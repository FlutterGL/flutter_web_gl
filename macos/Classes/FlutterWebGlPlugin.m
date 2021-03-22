#import "FlutterWebGlPlugin.h"
#import "MetalANGLE/EGL/egl.h"
#define EGL_EGLEXT_PROTOTYPES
#import "MetalANGLE/EGL/eglext.h"
#import "MetalANGLE/EGL/eglext_angle.h"
#import "MetalANGLE/angle_gl.h"

// Get metal device used by MetalANGLE.
// This can return nil if the MetalANGLE is not currently using Metal back-end. For example, the
// target device is running iOS version < 11.0 or macOS version < 13.0
static id<MTLDevice> GetANGLEMtlDevice(EGLDisplay display)
{
    EGLAttrib angleDevice = 0;
    EGLAttrib device      = 0;
    if (eglQueryDisplayAttribEXT(display, EGL_DEVICE_EXT, &angleDevice) != EGL_TRUE)
        return nil;

    if (eglQueryDeviceAttribEXT((EGLDeviceEXT)(angleDevice), EGL_MTL_DEVICE_ANGLE, &device) != EGL_TRUE)
        return nil;

    return (__bridge id<MTLDevice>)(void *)(device);
}

@implementation OpenGLException

- (instancetype) initWithMessage: (NSString*) message andError: (int) error
{
    self = [super init];
    if (self){
    _message = message;
    _errorCode = error;
    }
    return self;
}

@end

@interface FlutterGlTexture() {
    CVMetalTextureCacheRef _metalTextureCache;
    CVMetalTextureRef _metalTextureCVRef;
    id<MTLTexture> _metalTexture;
    EGLImageKHR _metalAsEGLImage;
}
@end

@implementation FlutterGlTexture
- (instancetype)initWithWidth:(int) width andHeight:(int)height registerWidth:(NSObject<FlutterTextureRegistry>*) registry{
    self = [super init];
    if (self){
        _width = width;
        _height = height;
        NSDictionary* options = @{
          // This key is required to generate SKPicture with CVPixelBufferRef in metal.
          (NSString*)kCVPixelBufferMetalCompatibilityKey : @YES
        };

        CVReturn status = CVPixelBufferCreate(kCFAllocatorDefault, width, height,
                                              kCVPixelFormatType_32BGRA, (__bridge CFDictionaryRef)options, &_pixelData);
        if (status != 0)
        {
            NSLog(@"CVPixelBufferCreate error %d", (int)status);
        }
        
        CVPixelBufferLockBaseAddress(_pixelData, 0);
        // UInt32* buffer = (UInt32*)CVPixelBufferGetBaseAddress(_pixelData);
        // for ( unsigned long i = 0; i < width * height; i++ )
        // {
        //     buffer[i] = CFSwapInt32HostToBig(0x00ff00ff);
        // }
        // CVPixelBufferUnlockBaseAddress(_pixelData, 0);

        [self createMtlTextureFromCVPixBufferWithWidth:width andHeight:height];
        glGenFramebuffers(1, &_fbo);
        glBindFramebuffer(GL_FRAMEBUFFER, _fbo);

        int error;
        if (_metalAsGLTexture) {
            glFramebufferTexture2D(GL_FRAMEBUFFER, GL_COLOR_ATTACHMENT0, GL_TEXTURE_2D, _metalAsGLTexture, 0);
        }
        else {
            // use offscreen renderbuffer as fallback if Metal back-end is not available
            glGenRenderbuffers(1, &_rbo);
            glBindRenderbuffer(GL_RENDERBUFFER, _rbo);

            glRenderbufferStorage(GL_RENDERBUFFER, GL_RGBA8, width, height);
            error = glGetError();
            if (error != GL_NO_ERROR)
            {
                NSLog(@"GlError while allocating Renderbuffer %d\n", error);
                @throw [[OpenGLException alloc] initWithMessage: @"GlError while allocating Renderbuffer"   andError: error];
            }
            glFramebufferRenderbuffer(GL_FRAMEBUFFER, GL_COLOR_ATTACHMENT0, GL_RENDERBUFFER,_rbo);
        }
        int frameBufferCheck = glCheckFramebufferStatus(GL_FRAMEBUFFER);
        if (frameBufferCheck != GL_FRAMEBUFFER_COMPLETE)
        {
            NSLog(@"GFramebuffer error %d\n", frameBufferCheck);
            @throw [[OpenGLException alloc] initWithMessage: @"Framebuffer error"   andError: frameBufferCheck];
        }
        error = glGetError() ;
        if( error != GL_NO_ERROR)
        {
            NSLog(@"GlError while allocating Renderbuffer %d\n", error);
        }

        _flutterTextureId = [registry registerTexture:self];

    }
    
    return self;
}

- (void)dealloc {
    // TODO: deallocate GL resources
    _metalTexture = nil;
    if (_metalTextureCVRef) {
        CFRelease(_metalTextureCVRef);
        _metalTextureCVRef = nil;
    }
    if (_metalTextureCache) {
        CFRelease(_metalTextureCache);
        _metalTextureCache = nil;
    }
    CVPixelBufferRelease(_pixelData);
}

- (void)createMtlTextureFromCVPixBufferWithWidth:(int) width andHeight:(int)height {
    EGLDisplay display = eglGetDisplay(EGL_DEFAULT_DISPLAY);
    // Create Metal texture backed by CVPixelBuffer
    id<MTLDevice> mtlDevice = GetANGLEMtlDevice(display);
    // if mtlDevice is nil, fall-back to CPU readback via glReadPixels
    if (!mtlDevice)
        return;

    CVReturn status = CVMetalTextureCacheCreate(kCFAllocatorDefault,
                                                nil,
                                                mtlDevice,
                                                nil,
                                                &_metalTextureCache);
    if (status != 0)
    {
        NSLog(@"CVMetalTextureCacheCreate error %d", (int)status);
    }

    status = CVMetalTextureCacheCreateTextureFromImage(kCFAllocatorDefault,
                                                       _metalTextureCache,
                                                       _pixelData, nil,
                                                       MTLPixelFormatBGRA8Unorm,
                                                       width, height,
                                                       0,
                                                       &_metalTextureCVRef);
    if (status != 0)
    {
        NSLog(@"CVMetalTextureCacheCreateTextureFromImage error %d", (int)status);
    }
    _metalTexture = CVMetalTextureGetTexture(_metalTextureCVRef);

    // Create EGL image backed by Metal texture
    EGLint attribs[] = {
        EGL_NONE,
    };
    _metalAsEGLImage =
        eglCreateImageKHR(display, EGL_NO_CONTEXT, EGL_MTL_TEXTURE_MGL,
                          (__bridge EGLClientBuffer)(_metalTexture), attribs);

    // Create a texture target to bind the egl image
    glGenTextures(1, &_metalAsGLTexture);
    glBindTexture(GL_TEXTURE_2D, _metalAsGLTexture);

    PFNGLEGLIMAGETARGETTEXTURE2DOESPROC glEGLImageTargetTexture2DOES =
        (PFNGLEGLIMAGETARGETTEXTURE2DOESPROC)eglGetProcAddress("glEGLImageTargetTexture2DOES");
    glEGLImageTargetTexture2DOES(GL_TEXTURE_2D, _metalAsEGLImage);
}

#pragma mark - FlutterTexture

- (CVPixelBufferRef)copyPixelBuffer {
    CVBufferRetain(_pixelData);
    return _pixelData;
}

@end


@interface FlutterWebGlPlugin()
@property (nonatomic, strong) NSObject<FlutterTextureRegistry> *textureRegistry;
@property (nonatomic,strong) FlutterGlTexture* flutterGLTexture;

@end

@implementation FlutterWebGlPlugin

- (instancetype)initWithTextures:(NSObject<FlutterTextureRegistry> *)textures {
    self = [super init];
    if (self) {
        _textureRegistry = textures;
    }
    return self;
}


+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
    FlutterMethodChannel* channel =
          [FlutterMethodChannel methodChannelWithName:@"flutter_web_gl"
                                      binaryMessenger:[registrar messenger]];
    FlutterWebGlPlugin* instance = [[FlutterWebGlPlugin alloc] initWithTextures:[registrar textures]];
    [registrar addMethodCallDelegate:instance channel:channel];
    
}

- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
    if ([call.method isEqualToString:@"initOpenGL"]) {
        static EGLContext context;
        static EGLSurface dummySurfaceForDartSide;
        
        if (context != NULL)
        {
          // this means initOpenGL() was already called, which makes sense if you want to acess a Texture not only
          // from the main thread but also from an isolate. On the plugin layer here that doesn't bother because all
          // by `initOpenGL``in Dart created contexts will be linked to the one we got from the very first call to `initOpenGL`
          // we return this information so that the Dart side can dispose of one context.

            result(@{@"context" : [NSNumber numberWithLong: (long)context],
                     @"dummySurface" : [NSNumber numberWithLong: (long)dummySurfaceForDartSide]
                   });
          return;
          
        }
        // Obtain the OpenGL context that was created on the Dart side
        // it is linked to the context that is used by the Dart side for all further OpenGL operations over FFI
        // Because of that they are shared (linked) they have both access to the same RenderbufferObjects (RBO) which allows
        // The Dart main thread to render into an Texture RBO which can then accessed from this thread and passed to the Flutter Engine
        if (call.arguments) {
            NSNumber* contextAsNSNumber = call.arguments[@"openGLContext"];
            context = (EGLContext) contextAsNSNumber.longValue;
        }
        else
        {
          result([FlutterError errorWithCode: @"No OpenGL context" message: @"No OpenGL context received by the native part of FlutterGL.iniOpenGL"  details:NULL]);
          return;
        }

        EGLDisplay display = eglGetDisplay(EGL_DEFAULT_DISPLAY);
        EGLint major;
        EGLint minor;
        int initializeResult = eglInitialize(display,&major,&minor);
        if (initializeResult != 1)
        {
            result([FlutterError errorWithCode: @"No OpenGL context" message: @"eglInit failed"  details:NULL]);
            return;
        }
        
        const EGLint attribute_list[] = {
          EGL_RED_SIZE, 8,
          EGL_GREEN_SIZE, 8,
          EGL_BLUE_SIZE, 8,
          EGL_ALPHA_SIZE, 8,
          EGL_DEPTH_SIZE, 16,
          EGL_NONE};

        EGLint num_config;
        EGLConfig config;
        EGLBoolean chooseConfigResult = eglChooseConfig(display,attribute_list,&config,1,&num_config);
        if (chooseConfigResult != 1)
        {
            result([FlutterError errorWithCode: @"EGL InitError" message: @"Failed to call eglCreateWindowSurface()"  details:NULL]);
            return;
        }


        // This is just a dummy surface that it needed to make an OpenGL context current (bind it to this thread)
        CALayer* dummyLayer       = [[CALayer alloc] init];
        dummyLayer.frame = CGRectMake(0, 0, 1, 1);
        CALayer* dummyLayer2       = [[CALayer alloc] init];
        dummyLayer2.frame = CGRectMake(0, 0, 1, 1);

        dummySurfaceForDartSide = eglCreateWindowSurface(display, config,(__bridge EGLNativeWindowType)dummyLayer, NULL);
        EGLSurface dummySurface = eglCreateWindowSurface(display,
            config,(__bridge EGLNativeWindowType)dummyLayer2, NULL);
        
        if ((dummySurfaceForDartSide == EGL_NO_SURFACE) || (dummySurface == EGL_NO_SURFACE))
        {
            result([FlutterError errorWithCode: @"EGL InitError" message: @"Dummy Surface creation failed"  details:NULL]);
            return;

        }
        if (eglMakeCurrent(display, dummySurface, dummySurface, context)!=1)
        {
            NSLog(@"MakeCurrent failed: %d",eglGetError());
        }

        char* v = (char*) glGetString(GL_VENDOR);
        int error = glGetError();
        if (error != GL_NO_ERROR)
        {
            NSLog(@"GLError: %d",error);
        }
        char* r = (char*) glGetString(GL_RENDERER);
        char* v2 = (char*) glGetString(GL_VERSION);

        if (v==NULL)
        {
            NSLog(@"GetString: GL_VENDOR returned NULL");
        }
        if (r==NULL)
        {
            NSLog(@"GetString: GL_RENDERER returned NULL");
        }
        if (v2==NULL)
        {
            NSLog(@"GetString: GL_VERSION returned NULL");
        }
       NSLog(@"%@\n%@\n%@\n",[[NSString alloc] initWithUTF8String: v],[[NSString alloc] initWithUTF8String: r],[[NSString alloc] initWithUTF8String: v2]);
        /// we send back the context. This might look a bit strange, but is necessary to allow this function to be called
        /// from Dart Isolates.
        result(@{@"context" : [NSNumber numberWithLong: (long)context],
                 @"dummySurface" : [NSNumber numberWithLong: (long)dummySurfaceForDartSide]
               });
        return;

    }
    if ([call.method isEqualToString:@"createTexture"]) {
        static NSMutableDictionary *textureCache = nil;

        NSNumber* width;
        NSNumber* height;
        NSString* id;
        if (call.arguments) {
            id = call.arguments[@"id"];

            if ([textureCache objectForKey:id]) {
                NSDictionary* createTextureResult = textureCache[id];
                return result(createTextureResult);
            }

            width = call.arguments[@"width"];
            if (width == NULL)
            {
                result([FlutterError errorWithCode: @"CreateTexture Error" message: @"No width received by the native part of FlutterGL.createTexture"  details:NULL]);
                return;

            }
            height = call.arguments[@"height"];
            if (height == NULL)
            {
                result([FlutterError errorWithCode: @"CreateTexture Error" message: @"No height received by the native part of FlutterGL.createTexture"  details:NULL]);
                return;

            }
        }
        else
        {
          result([FlutterError errorWithCode: @"No arguments" message: @"No arguments received by the native part of FlutterGL.createTexture"  details:NULL]);
          return;
        }

        @try
        {
            _flutterGLTexture = [[FlutterGlTexture alloc] initWithWidth:width.intValue andHeight:height.intValue registerWidth:_textureRegistry];
        }
        @catch (OpenGLException* ex)
        {
            result([FlutterError errorWithCode: [@( [ex errorCode]) stringValue]
                                       message: [@"Error creating FlutterGLTextureObjec: " stringByAppendingString:[ex message]] details:NULL]);
            return;
        }

//        flutterGLTextures.insert(TextureMap::value_type(flutterGLTexture->flutterTextureId, std::move(flutterGLTexture)));

        NSDictionary* createTextureResult = @{
            @"textureId" : [NSNumber numberWithLongLong: [_flutterGLTexture flutterTextureId]],
            @"rbo": [NSNumber numberWithLongLong: [_flutterGLTexture  rbo]],
            @"metalAsGLTexture": [NSNumber numberWithLongLong: [_flutterGLTexture metalAsGLTexture]],
            @"cached": [NSNumber numberWithInt: 0],
        };

        result(createTextureResult);

        NSMutableDictionary *cachedVal = [NSMutableDictionary dictionaryWithDictionary:createTextureResult];
        [cachedVal setObject:[NSNumber numberWithInt:1] forKey:@"cached"];

        if (textureCache == nil) {
            textureCache = [NSMutableDictionary dictionaryWithDictionary:@{ id: cachedVal }];
        } else {
            [textureCache setValue:cachedVal forKey:id];
        }

        return;
    }
        if ([call.method isEqualToString:@"updateTexture"]) {
            NSNumber* textureId;
            if (call.arguments) {
                textureId = call.arguments[@"textureId"];
                if (textureId == NULL)
                {
                    result([FlutterError errorWithCode: @"updateTexture Error" message: @"no texture id received by the native part of FlutterGL.updateTexture"  details:NULL]);
                    return;

                }
            }
            else
            {
              result([FlutterError errorWithCode: @"No arguments" message: @"No arguments received by the native part of FlutterGL.updateTexture"  details:NULL]);
              return;
            }

                // Check if the received ID is registered
/*                if (flutterGLTextures.find(textureId) == flutterGLTextures.end())
                {
                    result->Error("Invalid texture ID", "Invalid Texture ID: " + std::to_string(textureId));
                    return;
                }

                auto currentTexture = flutterGLTextures[textureId].get();
                
*/
                FlutterGlTexture* currentTexture = _flutterGLTexture;

            if (currentTexture.metalAsGLTexture) {
                // DO NOTHING, metal texture is automatically updated
            }
            else {
                glBindFramebuffer(GL_FRAMEBUFFER, currentTexture.fbo);

                CVPixelBufferLockBaseAddress([currentTexture pixelData], 0);
                void* buffer = (void*)CVPixelBufferGetBaseAddress([currentTexture pixelData]);

                 glReadPixels(0, 0, (GLsizei)[currentTexture width], (GLsizei)currentTexture.height, GL_RGBA, GL_UNSIGNED_BYTE, (void*)buffer);

                // TODO: swap red & blue channels byte by byte

                CVPixelBufferUnlockBaseAddress([currentTexture pixelData],0);
            }

                [_textureRegistry textureFrameAvailable:[currentTexture flutterTextureId]];
                
                result(nil);
            return;
            }
        
        if ([call.method isEqualToString:@"getAll"]) {
        result(@{
          @"appName" : [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleDisplayName"]
              ?: [NSNull null],
          @"packageName" : [[NSBundle mainBundle] bundleIdentifier] ?: [NSNull null],
          @"version" : [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"]
              ?: [NSNull null],
          @"buildNumber" : [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleVersion"]
              ?: [NSNull null],
        });
} else {
    result(FlutterMethodNotImplemented);
  }
}
@end

