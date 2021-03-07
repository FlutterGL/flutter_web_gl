#import "FlutterWebGlPlugin.h"
// #import "MetalANGLE/EGL/egl.h"


@implementation FlutterWebGlPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
    FlutterMethodChannel* channel =
          [FlutterMethodChannel methodChannelWithName:@"flutter_web_gl"
                                      binaryMessenger:[registrar messenger]];
    FlutterWebGlPlugin* instance = [[FlutterWebGlPlugin alloc] init];
    [registrar addMethodCallDelegate:instance channel:channel];
    
    //EGLAttrib displayAttribs[] = {EGL_NONE};
    // void* _eglDisplay = eglGetPlatformDisplay(0x3202, NULL, displayAttribs);

    
    // int result = eglGetError();
    // void* display = eglGetDisplay(EGL_DEFAULT_DISPLAY);
    // EGLint major;
    // EGLint minor;
    // eglInitialize(display,&major,&minor);
    
}

- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
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
