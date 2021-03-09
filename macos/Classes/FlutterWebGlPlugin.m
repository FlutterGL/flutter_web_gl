#import "FlutterWebGlPlugin.h"
#import "MetalANGLE/EGL/egl.h"
#import "MetalANGLE/angle_gl.h"


@implementation FlutterWebGlPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
    FlutterMethodChannel* channel =
          [FlutterMethodChannel methodChannelWithName:@"flutter_web_gl"
                                      binaryMessenger:[registrar messenger]];
    FlutterWebGlPlugin* instance = [[FlutterWebGlPlugin alloc] init];
    [registrar addMethodCallDelegate:instance channel:channel];
    
}

- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
    if ([call.method isEqualToString:@"initOpenGL"]) {
        static EGLContext  context;
        if (context != NULL)
        {
          // this means initOpenGL() was already called, which makes sense if you want to acess a Texture not only
          // from the main thread but also from an isolate. On the plugin layer here that doesn't bother because all
          // by `initOpenGL``in Dart created contexts will be linked to the one we got from the very first call to `initOpenGL`
          // we return this information so that the Dart side can dispose of one context.

            result([NSNumber numberWithLong: (long)context]);
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
            result([FlutterError errorWithCode: @"EGL InitError" message: @"eglChooseConfig failed"  details:NULL]);
            return;
        }

        const EGLint surfaceAttributes[] = {
          EGL_WIDTH, 16,
          EGL_HEIGHT, 16,
          EGL_NONE
        };

        // This is just a dummy surface that it needed to make an OpenGL context current (bind it to this thread)
        EGLSurface surface = eglCreatePbufferSurface(display, config, surfaceAttributes);
        
        eglMakeCurrent(display, surface, surface, context);

        char* v = (char*) glGetString(GL_VENDOR);
        int error = glGetError();
        if (error != GL_NO_ERROR)
        {
            NSLog(@"GLError: %d",error);
        }
        char* r = (char*) glGetString(GL_RENDERER);
        char* v2 = (char*) glGetString(GL_VERSION);

        // NSLog(@"%@\n%@\n%@\n",[[NSString alloc] initWithUTF8String: v],[[NSString alloc] initWithUTF8String: r],[[NSString alloc] initWithUTF8String: v2]);
        /// we send back the context. This might look a bit strange, but is necessary to allow this function to be called
        /// from Dart Isolates.
        result([NSNumber numberWithLong: (long)context]);
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
