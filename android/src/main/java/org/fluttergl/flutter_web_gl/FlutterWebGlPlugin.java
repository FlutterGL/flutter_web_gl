
package org.fluttergl.flutter_web_gl;

import androidx.annotation.NonNull;
import androidx.annotation.RequiresApi;

import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;


import io.flutter.plugin.common.PluginRegistry.Registrar;
import io.flutter.view.TextureRegistry;

import android.graphics.SurfaceTexture;
import android.opengl.EGL14;
import android.opengl.EGL15;
import android.opengl.EGLConfig;
import android.opengl.EGLContext;
import android.opengl.EGLDisplay;
import android.opengl.EGLObjectHandle;
import android.opengl.EGLSurface;
import android.opengl.GLES30;
import android.os.Build;
import android.util.Log;

import java.util.HashMap;
import java.util.Map;

import static android.opengl.EGL14.EGL_ALPHA_SIZE;
import static android.opengl.EGL14.EGL_BLUE_SIZE;
import static android.opengl.EGL14.EGL_CONTEXT_CLIENT_VERSION;
import static android.opengl.EGL14.EGL_DEFAULT_DISPLAY;
import static android.opengl.EGL14.EGL_DEPTH_SIZE;
import static android.opengl.EGL14.EGL_GREEN_SIZE;
import static android.opengl.EGL14.EGL_HEIGHT;
import static android.opengl.EGL14.EGL_NONE;
import static android.opengl.EGL14.EGL_NO_CONTEXT;
import static android.opengl.EGL14.EGL_NO_SURFACE;
import static android.opengl.EGL14.EGL_RED_SIZE;
import static android.opengl.EGL14.EGL_RENDERABLE_TYPE;
import static android.opengl.EGL14.EGL_WIDTH;
import static android.opengl.EGL14.eglCreateWindowSurface;
import static android.opengl.EGL14.eglMakeCurrent;
import static android.opengl.EGL15.EGL_OPENGL_ES3_BIT;
import static android.opengl.EGL15.EGL_PLATFORM_ANDROID_KHR;
import static android.opengl.EGLExt.EGL_OPENGL_ES3_BIT_KHR;
import static android.opengl.GLES20.GL_NO_ERROR;
import static android.opengl.GLES20.GL_RENDERER;
import static android.opengl.GLES20.GL_VENDOR;
import static android.opengl.GLES20.GL_VERSION;
import static android.opengl.GLES20.glGetError;

class OpenGLException extends Throwable {

  OpenGLException(String message, int error)
  {
    this.error = error;
    this.message = message;
  }
  int error;
  String message;
};

@RequiresApi(api = Build.VERSION_CODES.JELLY_BEAN_MR1)
class MyEGLContext extends EGLObjectHandle {
  @RequiresApi(api = Build.VERSION_CODES.LOLLIPOP)
  MyEGLContext(long handle)
  {
    super(handle);
  }
}


class FlutterGLTexture
{
  public
  FlutterGLTexture(TextureRegistry.SurfaceTextureEntry textureEntry,   int width, int  height)
  {
    this.with=width;
    this.height=height;
    this.surfaceTextureEntry=textureEntry;
    surfaceTextureEntry.surfaceTexture().setDefaultBufferSize(width,height);



  }

  protected void finalize()
  {

  }

  int with;
  int height;
  int fbo;
  int rbo;
  TextureRegistry.SurfaceTextureEntry surfaceTextureEntry;
};


class GLThread extends Thread
{

  @Override
  public void run() {
    super.run();
    EGLDisplay display = EGL14.eglGetDisplay(EGL_DEFAULT_DISPLAY);

    int[] version = new int[2];
    boolean initializeResult = EGL14.eglInitialize(display, version, 0, version, 1);
    if (!initializeResult) {
      Log.i("EGL InitError", "eglInit failed", null);
      return;
    }

    Log.i("FlutterWegGL", "EGL version in native plugin " + version[0] + "." + version[1]);

  }
}


/** FlutterWebGlPlugin */
public class FlutterWebGlPlugin implements FlutterPlugin, MethodCallHandler {
  /// The MethodChannel that will the communication between Flutter and native Android
  ///
  /// This local reference serves to register the plugin with the Flutter Engine and unregister it
  /// when the Flutter Engine is detached from the Activity
  private MethodChannel channel;
  private EGLContext context=null;
  private TextureRegistry textureRegistry;
  private OpenGLManager openGLManager;
  private TextureRegistry.SurfaceTextureEntry surfaceTextureEntry;

  @Override
  public void onAttachedToEngine(@NonNull FlutterPluginBinding flutterPluginBinding) {
    channel = new MethodChannel(flutterPluginBinding.getBinaryMessenger(), "flutter_web_gl");
    channel.setMethodCallHandler(this);
    textureRegistry = flutterPluginBinding.getTextureRegistry();
  }

  @RequiresApi(api = Build.VERSION_CODES.LOLLIPOP)
  @Override
  public void onMethodCall(@NonNull MethodCall call, @NonNull Result result) {
    Map<String, Object> arguments = (Map<String, Object>) call.arguments;
    if (call.method.equals("getPlatformVersion")) {
      result.success("Android " + android.os.Build.VERSION.RELEASE);

    }
      else if (call.method.equals("initOpenGL")) {
      if (context != null) {
        // TODO this isn't fully handled on the dart side yet
        // this means initOpenGL() was already called, which makes sense if you want to access a Texture not only
        // from the main thread but also from an isolate. On the plugin layer here that doesn't bother because all
        // by `initOpenGL``in Dart created contexts will be linked to the one we got from the very first call to `initOpenGL`
        // we return this information so that the Dart side can dispose of one context.
        long handle = context.getNativeHandle();
                result.success(handle);

        return;
      }
      openGLManager = new OpenGLManager();

      surfaceTextureEntry = textureRegistry.createSurfaceTexture();
      SurfaceTexture surfaceTexture = surfaceTextureEntry.surfaceTexture();

      surfaceTexture.setDefaultBufferSize(640,320);

      int[] attribute_list = new int[]{
              EGL_RENDERABLE_TYPE,
              EGL_OPENGL_ES3_BIT_KHR,
              EGL_RED_SIZE, 8,
              EGL_GREEN_SIZE, 8,
              EGL_BLUE_SIZE, 8,
              EGL_ALPHA_SIZE, 8,
              EGL_DEPTH_SIZE, 16,
              EGL_NONE};

      if(!openGLManager.initGL())
      {
        result.error("OpenGL Init Error",openGLManager.getError(),null);
        return;
      }
      context = openGLManager.getEGLContext();
      long surface = openGLManager.createSurfaceFromTexture(surfaceTexture);


      long display = EGL14.eglGetCurrentDisplay().getNativeHandle();
      Map<String, Object> response = new HashMap<>();
      response.put("context", context.getNativeHandle());
      response.put("dummySurface",surface );
      response.put("eglConfigId",openGLManager.getConfigId());
      result.success(response);
    }
      else if (call.method.equals("createTexture")){

      int width = (int) arguments.get("width");
      int height = (int) arguments.get("height");
        if (width == 0) {
          result.error("no texture width","no texture width",0);
          return;
        }
        if (height==0) {
          result.error("no texture height","no texture height",null);
          return;
        }
/*
      FlutterGLTexture flutterGLTexture;

      flutterGLTexture = new FlutterGLTexture(textureRegistry.createSurfaceTexture(), width, height);
      try
      {
        flutterGLTexture = new FlutterGLTexture(textureRegistry.createSurfaceTexture(), width, height);
      }
      catch (OpenGLException ex)
      {
        result.error(ex.message + " : " + ex.error,null,null);
        return;
      }
      //flutterGLTextures.insert(TextureMap::value_type(flutterGLTexture->flutterTextureId, std::move(flutterGLTexture)));


*/
      Map<String, Object> response = new HashMap<>();
      response.put("textureId", surfaceTextureEntry.id());
      response.put("rbo", 0);
//      response.put("textureId", flutterGLTexture.surfaceTextureEntry.id());
//      response.put("rbo", flutterGLTexture.rbo);
      result.success(response);

      Log.i("FlutterWebGL","Created a new texture " + width + "x" + height);
    } else {
      result.notImplemented();
    }
  }

  @Override
  public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {
    channel.setMethodCallHandler(null);
  }
}
