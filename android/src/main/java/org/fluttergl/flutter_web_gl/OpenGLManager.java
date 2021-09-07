package org.fluttergl.flutter_web_gl;

import android.graphics.SurfaceTexture;
import android.opengl.EGL14;
import android.opengl.GLES30;
import android.opengl.GLUtils;
import android.util.Log;

import javax.microedition.khronos.egl.EGL10;
import javax.microedition.khronos.egl.EGLConfig;
import javax.microedition.khronos.egl.EGLContext;
import javax.microedition.khronos.egl.EGLDisplay;
import javax.microedition.khronos.egl.EGLSurface;

import static android.opengl.EGL14.EGL_CONTEXT_CLIENT_VERSION;
import static android.opengl.EGLExt.EGL_OPENGL_ES3_BIT_KHR;
import static android.opengl.GLES20.GL_NO_ERROR;
import static android.opengl.GLES20.GL_RENDERER;
import static android.opengl.GLES20.GL_VENDOR;
import static android.opengl.GLES20.GL_VERSION;
import static android.opengl.GLES20.glGetError;
import static javax.microedition.khronos.egl.EGL10.EGL_HEIGHT;
import static javax.microedition.khronos.egl.EGL10.EGL_NONE;
import static javax.microedition.khronos.egl.EGL10.EGL_SURFACE_TYPE;
import static javax.microedition.khronos.egl.EGL10.EGL_WIDTH;
import static javax.microedition.khronos.egl.EGL10.EGL_WINDOW_BIT;

public final class OpenGLManager  {
    private static final String LOG_TAG = "OpenGLManager";
    private EGL10 egl;
    private EGLDisplay eglDisplay;
    private EGLContext eglContext;
    private EGLSurface eglSurface;
    private volatile String error;

    EGLConfig eglConfig;
    private int configId;
    /// This here are only used so that we can create surfaces for new textures and access the native
    // handle which is opaque in the Kronos implementation
    private android.opengl.EGLDisplay eglDisplayAndroid;
    private android.opengl.EGLConfig eglConfigAndroid;

    public android.opengl.EGLContext getEGLContext() {
        if (eglContext == null)
        {
            return null;
        }
        android.opengl.EGLContext contextAndroid = EGL14.eglGetCurrentContext();
        return  contextAndroid;
    }

    android.opengl.EGLSurface createSurfaceFromTexture(SurfaceTexture texture) {
        int [] attributes = new int[]{EGL_NONE};
        return EGL14.eglCreateWindowSurface(eglDisplayAndroid, eglConfigAndroid, texture, attributes,0);
    }

    android.opengl.EGLSurface createDummySurface() {
        int[] surfaceAttributes = new int[]{

                EGL_WIDTH, 16,
                EGL_HEIGHT, 16,
                EGL_NONE
        };
        return EGL14.eglCreatePbufferSurface(eglDisplayAndroid, eglConfigAndroid, surfaceAttributes,0);
    }

    boolean initGL() {
        egl = (EGL10) EGLContext.getEGL();
        eglDisplay = egl.eglGetDisplay(EGL10.EGL_DEFAULT_DISPLAY);

        if (eglDisplay == EGL10.EGL_NO_DISPLAY) {
            error = "eglGetDisplay failed";
            return false;
        }

        int[] version = new int[2];
        if (!egl.eglInitialize(eglDisplay, version)) {
            error = "eglInitialize failed";
            return false;
        }

         eglConfig = chooseEglConfig();

         if (eglConfig == null) {
            return false;
        }

        eglContext = createContext(egl, eglDisplay, eglConfig);

         int[] surfaceAttributes = new int[]{

                 EGL_WIDTH, 16,
                 EGL_HEIGHT, 16,
                 EGL_NONE
         };
          eglSurface = egl.eglCreatePbufferSurface(eglDisplay, eglConfig, surfaceAttributes);

        if (eglSurface == null || eglSurface == EGL10.EGL_NO_SURFACE) {
            error = "GL error: " + GLUtils.getEGLErrorString(egl.eglGetError());
            return false;
        }

        if (!egl.eglMakeCurrent(eglDisplay, eglSurface, eglSurface, eglContext)) {
            error = "GL make current error: " + GLUtils.getEGLErrorString(egl.eglGetError());
            return false;
        }

         // make config and display accessible for EGL14 API because javax.microedition.khronos.egl
         // classes don't allow to access the native handles
         int valA[] = new int[1];
         egl.eglGetConfigAttrib(eglDisplay, eglConfig, EGL10.EGL_CONFIG_ID, valA);
         configId = valA[0];

         eglDisplayAndroid = EGL14.eglGetCurrentDisplay();
         int[] attribA = {EGL14.EGL_CONFIG_ID, configId, EGL14.EGL_NONE};
         android.opengl.EGLConfig[] configA = new android.opengl.EGLConfig[1];
         int[] nConfigA = new int[1];
         EGL14.eglChooseConfig(eglDisplayAndroid, attribA, 0, configA, 0, 1, nConfigA, 0);
         eglConfigAndroid = configA[0];

        String v = GLES30.glGetString(GL_VENDOR);
        int error = glGetError();
        if (error != GL_NO_ERROR)
        {

            Log.i("FlutterWegGL", "GLError: " + error);
        }
        String r = GLES30.glGetString(GL_RENDERER);
        String v2 = GLES30.glGetString(GL_VERSION);

        Log.i("FlutterWegGL", "OpenGL initialized: Vendor:" + v + " renderer: " + r + " Version: " + v2);
        Log.d(LOG_TAG, "Successfully initialized GL in plugin");

        return true;
    }

    private void deinitGL() {
        egl.eglMakeCurrent(eglDisplay, EGL10.EGL_NO_SURFACE, EGL10.EGL_NO_SURFACE, EGL10.EGL_NO_CONTEXT);
        egl.eglDestroySurface(eglDisplay, eglSurface);
        egl.eglDestroyContext(eglDisplay, eglContext);
        egl.eglTerminate(eglDisplay);
        Log.d(LOG_TAG, "OpenGL deinit OK.");
    }

    private EGLContext createContext(EGL10 egl, EGLDisplay eglDisplay, EGLConfig eglConfig) {
        int[] attribList = {EGL_CONTEXT_CLIENT_VERSION, 3, EGL10.EGL_NONE};
        return egl.eglCreateContext(eglDisplay, eglConfig, EGL10.EGL_NO_CONTEXT, attribList);
    }

    private EGLConfig chooseEglConfig() {
        int[] configsCount = new int[1];
        EGLConfig[] configs = new EGLConfig[1];
        int[] configSpec = getConfigAttributes();

        if (!egl.eglChooseConfig(eglDisplay, configSpec, configs, 1, configsCount)) {
            error = "Failed to choose config: " + GLUtils.getEGLErrorString(egl.eglGetError());
            return null;
        } else if (configsCount[0] > 0) {
            int valA[] = new int[1];
            egl.eglGetConfigAttrib(eglDisplay, configs[0], EGL10.EGL_CONFIG_ID, valA);
            configId = valA[0];
            return configs[0];
        }

        return null;
    }

    private int[] getConfigAttributes() {
        return new int[]{
                EGL10.EGL_RENDERABLE_TYPE,
                EGL_OPENGL_ES3_BIT_KHR,
                EGL_SURFACE_TYPE,    EGL_WINDOW_BIT,
                EGL10.EGL_RED_SIZE, 8,
                EGL10.EGL_GREEN_SIZE, 8,
                EGL10.EGL_BLUE_SIZE, 8,
                EGL10.EGL_ALPHA_SIZE, 8,
                EGL10.EGL_DEPTH_SIZE, 16,
                EGL10.EGL_NONE
        };
    }


    public String getError() {
        return error;
    }

    public int getConfigId() {
        return configId;
    }

    public android.opengl.EGLDisplay getEglDisplayAndroid() {
        return eglDisplayAndroid;
    }
}
