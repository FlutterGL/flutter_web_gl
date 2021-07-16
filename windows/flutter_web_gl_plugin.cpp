#include "include/flutter_web_gl/flutter_web_gl_plugin.h"
#include "include/gl32.h"
#include "include/egl.h"

// This must be included before many other Windows headers.
#include <windows.h>

// For getPlatformVersion; remove unless needed for your plugin implementation.
#include <VersionHelpers.h>

#include <flutter/method_channel.h>
#include <flutter/plugin_registrar_windows.h>
#include <flutter/standard_method_codec.h>

#include <map>
#include <memory>
#include <sstream>
#include <thread>
#include <iostream>

namespace {
using flutter::EncodableMap;
using flutter::EncodableValue;

  class OpenGLException
  {
  public:
      OpenGLException(char* message, int error);
      GLint error = 0;
      char* message ="";
  };

  OpenGLException::OpenGLException(char* message, int error)
  {
      this->error = error;
      message = message;
  }

  class FlutterGLTexture;

  typedef  std::map<int64_t, std::unique_ptr<FlutterGLTexture>> TextureMap;

  class FlutterWebGlPlugin : public flutter::Plugin {
  public:
      static void RegisterWithRegistrar(flutter::PluginRegistrarWindows* registrar);

      FlutterWebGlPlugin(flutter::TextureRegistrar* textures);

      virtual ~FlutterWebGlPlugin();

      static flutter::TextureRegistrar* textureRegistrar;


  private:
      // Called when a method is called on this plugin's channel from Dart.
      void HandleMethodCall(
          const flutter::MethodCall<flutter::EncodableValue>& method_call,
          std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result);

      TextureMap flutterGLTextures; // stores all created Textures
  };

  flutter::TextureRegistrar* FlutterWebGlPlugin::textureRegistrar;


  class FlutterGLTexture
  {
  public:
    FlutterGLTexture(GLsizei width, GLsizei height);
    virtual ~FlutterGLTexture();
    const FlutterDesktopPixelBuffer *CopyPixelBuffer(size_t width, size_t height);

   std::unique_ptr<FlutterDesktopPixelBuffer> buffer;
    GLuint fbo;
    GLuint rbo;
    int64_t flutterTextureId;
    std::unique_ptr<flutter::TextureVariant> flutterTexture;
  private:
    std::unique_ptr<uint8_t> pixels;
    size_t request_count_ = 0;


  }; 


  
  FlutterGLTexture::FlutterGLTexture(GLsizei width, GLsizei height)
  {
    int64_t size = width * height * 4;

    pixels.reset(new uint8_t[size]);

    buffer = std::make_unique<FlutterDesktopPixelBuffer>();
    buffer->buffer = pixels.get();
    buffer->width = width;
    buffer->height = height;
    memset(pixels.get(), 0x00, size);


    glGenFramebuffers(1, &fbo);
    glBindFramebuffer(GL_FRAMEBUFFER, fbo);

    glGenRenderbuffers(1, &rbo);
    glBindRenderbuffer(GL_RENDERBUFFER, rbo);  

    glRenderbufferStorage(GL_RENDERBUFFER, GL_RGBA8, width, height);
    auto error = glGetError();
    if (error != GL_NO_ERROR)
    {
        std::cerr << "GlError while allocating Renderbuffer" << error << std::endl;
        throw new OpenGLException("GlError while allocating Renderbuffer", error);
    }
    glFramebufferRenderbuffer(GL_FRAMEBUFFER, GL_COLOR_ATTACHMENT0, GL_RENDERBUFFER,rbo);
    auto frameBufferCheck = glCheckFramebufferStatus(GL_FRAMEBUFFER);
    if (frameBufferCheck != GL_FRAMEBUFFER_COMPLETE)
    {
        std::cerr << "Framebuffer error" << frameBufferCheck << std::endl;
        throw new OpenGLException("Framebuffer Error while creating Texture", frameBufferCheck);
    }

    error = glGetError() ;
    if( error != GL_NO_ERROR)
    {
      std::cerr << "GlError" << error << std::endl;
    }

    flutterTexture = std::make_unique<flutter::TextureVariant>(flutter::PixelBufferTexture(
        [this](size_t width, size_t height) -> const FlutterDesktopPixelBuffer* {
        return CopyPixelBuffer(width, height);
    }));

    flutterTextureId = FlutterWebGlPlugin::textureRegistrar->RegisterTexture(flutterTexture.get());

  }

  const FlutterDesktopPixelBuffer *FlutterGLTexture::CopyPixelBuffer(size_t width, size_t height)
  {
    return buffer.get();
  }

 FlutterGLTexture::~FlutterGLTexture() {
     FlutterWebGlPlugin::textureRegistrar->UnregisterTexture(flutterTextureId);
     glDeleteRenderbuffers(1, &rbo);
     glDeleteFramebuffers(1, &fbo);
     pixels.reset();
     buffer.reset();
 }




 

// static
void FlutterWebGlPlugin::RegisterWithRegistrar(
    flutter::PluginRegistrarWindows *registrar) {
  auto channel =
      std::make_unique<flutter::MethodChannel<flutter::EncodableValue>>(
          registrar->messenger(), "flutter_web_gl",
          &flutter::StandardMethodCodec::GetInstance());

  auto plugin = std::make_unique<FlutterWebGlPlugin>(registrar->texture_registrar());

  channel->SetMethodCallHandler(
      [plugin_pointer = plugin.get()](const auto& call, auto result) {
      plugin_pointer->HandleMethodCall(call, std::move(result));
  });
  registrar->AddPlugin(std::move(plugin));
}

FlutterWebGlPlugin::FlutterWebGlPlugin(flutter::TextureRegistrar *textures)  {
    textureRegistrar = textures;
}

FlutterWebGlPlugin::~FlutterWebGlPlugin() {}


void FlutterWebGlPlugin::HandleMethodCall(
    const flutter::MethodCall<flutter::EncodableValue> &method_call,
    std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result) {
  const auto* arguments = std::get_if<EncodableMap>(method_call.arguments());
  
  if (method_call.method_name().compare("getPlatformVersion") == 0) {
    std::ostringstream version_stream;
    version_stream << "Windows ";
    if (IsWindows10OrGreater()) {
      version_stream << "10+";
    } else if (IsWindows8OrGreater()) {
      version_stream << "8";
    } else if (IsWindows7OrGreater()) {
      version_stream << "7";
    }
    result->Success(flutter::EncodableValue(version_stream.str()));
  }
  else if (method_call.method_name().compare("initOpenGL") == 0) 
  {
      static EGLContext  context;
      if (context != nullptr)
      {
        // this means initOpenGL() was already called, which makes sense if you want to acess a Texture not only 
        // from the main thread but also from an isolate. On the plugin layer here that doesn't bother because all 
        // by `initOpenGL``in Dart created contexts will be linked to the one we got from the very first call to `initOpenGL`
        // we return this information so that the Dart side can dispose of one context.
        auto response = flutter::EncodableValue(context);
        result->Success(response);

        return;
      }

      auto display = eglGetDisplay(EGL_DEFAULT_DISPLAY);
      EGLint major;
      EGLint minor;
      auto initializeResult = eglInitialize(display,&major,&minor);
      if (initializeResult != 1)
      {
          result->Error("EGL InitError", "eglInit failed");
          return;
      }

      std::cerr << "EGL version in native plugin" << major << "." << minor << std::endl;
      
      const EGLint attribute_list[] = {
        EGL_RENDERABLE_TYPE,
        EGL_OPENGL_ES3_BIT,
        EGL_RED_SIZE, 8,
        EGL_GREEN_SIZE, 8,
        EGL_BLUE_SIZE, 8,
        EGL_ALPHA_SIZE, 8,
        EGL_DEPTH_SIZE, 16,
        EGL_NONE};

      EGLint num_config;
      EGLConfig config;
      auto chooseConfigResult = eglChooseConfig(display,attribute_list,&config,1,&num_config);
      if (chooseConfigResult != 1)
      {
          result->Error("EGL InitError", "eglChooseConfig failed");
          return;
      }

      EGLint configId;
      eglGetConfigAttrib(display,config,EGL_CONFIG_ID,&configId);

      const EGLint surfaceAttributes[] = {
        EGL_WIDTH, 16,
        EGL_HEIGHT, 16,
        EGL_NONE
      };

      const EGLint contextAttributes[] ={
        EGL_CONTEXT_CLIENT_VERSION,
        3,
        EGL_NONE
      };
      context = eglCreateContext(display,config,EGL_NO_CONTEXT,contextAttributes);


      // This is just a dummy surface that it needed to make an OpenGL context current (bind it to this thread)
      auto dummySurface = eglCreatePbufferSurface(display, config, surfaceAttributes);
      auto dummySurfaceForDartSide = eglCreatePbufferSurface(display, config, surfaceAttributes);
      
      eglMakeCurrent(display, dummySurface, dummySurface, context);

      auto v = glGetString(GL_VENDOR);
      int error = glGetError();
      if (error != GL_NO_ERROR)
      {
          std::cerr << "GlError" << error << std::endl;
      }     auto r = glGetString(GL_RENDERER);
      auto v2 = glGetString(GL_VERSION);

      std::cerr << v << std::endl << r << std::endl << v2 << std::endl;

      /// we send back the context so that the Dart side can create a linked context. 
      auto response = flutter::EncodableValue(flutter::EncodableMap{
          {flutter::EncodableValue("context"),
           flutter::EncodableValue((int64_t) context)},
          {flutter::EncodableValue("dummySurface"),
           flutter::EncodableValue((int64_t) dummySurfaceForDartSide)},
          {flutter::EncodableValue("eglConfigId"),
           flutter::EncodableValue((int64_t) configId)}
          });
      result->Success(response);
      return;
  }
  else if (method_call.method_name().compare("createTexture") == 0) {
      int width = 0;
      int height = 0;
      if (arguments) {
          auto texture_width = arguments->find(EncodableValue("width"));
          if (texture_width != arguments->end()) {
              width = std::get<std::int32_t>(texture_width->second);
          }
          else
          {
            result->Error("no texture width","no texture width");
            return;
          }
          auto texture_height = arguments->find(EncodableValue("height"));
          if (texture_height != arguments->end()) {
              height = std::get<std::int32_t>(texture_height->second);
          }
          else
          {
            result->Error("no texture height","no texture height");
            return;
          }
      }
      else
      {
        result->Error("no texture texture height and width","no texture width and height");
        return;
      }

      std::unique_ptr<FlutterGLTexture> flutterGLTexture;

      try
      {
          flutterGLTexture = std::make_unique<FlutterGLTexture>(width, height);
      }
      catch (OpenGLException ex)
      {
          result->Error(ex.message + ':' + std::to_string(ex.error));
      }
      auto rbo = (int64_t)flutterGLTexture->rbo;

      auto response = flutter::EncodableValue(flutter::EncodableMap{
          {flutter::EncodableValue("textureId"),
           flutter::EncodableValue(flutterGLTexture->flutterTextureId)},
          {flutter::EncodableValue("rbo"),
           flutter::EncodableValue( rbo)}
          }
      );

      flutterGLTextures.insert(TextureMap::value_type(flutterGLTexture->flutterTextureId, std::move(flutterGLTexture)));
          

      result->Success(response);
      std::cerr << "Created a new texture " << width << "x" << height << "openGL ID" << rbo << std::endl;
  }
  else if (method_call.method_name().compare("updateTexture") == 0) {
      int64_t textureId =0;
      if (arguments) {
          auto findResult = arguments->find(EncodableValue("textureId"));
          if (findResult != arguments->end()) {
              textureId = std::get<std::int64_t>(findResult->second);
          }
      }
      else
      {
        result->Error("no texture id","no texture id");
        return;
      }

      // Check if the received ID is registered
      if (flutterGLTextures.find(textureId) == flutterGLTextures.end())
      {
          result->Error("Invalid texture ID", "Invalid Texture ID: " + std::to_string(textureId));
          return;
      }

      auto currentTexture = flutterGLTextures[textureId].get();
      glBindFramebuffer(GL_FRAMEBUFFER, currentTexture->fbo);

       glReadPixels(0, 0, (GLsizei)currentTexture->buffer->width, (GLsizei)currentTexture->buffer->height, GL_RGBA, GL_UNSIGNED_BYTE, (void*)currentTexture->buffer->buffer);
       textureRegistrar->MarkTextureFrameAvailable(textureId);

       result->Success();
  }
  else if (method_call.method_name().compare("deleteTexture") == 0) {
  int64_t textureId = 0;
  if (arguments) {
      auto id_iterator = arguments->find(EncodableValue("textureId"));
      if (id_iterator != arguments->end()) {
          textureId = std::get<std::int64_t>(id_iterator->second);
      }
  }
  else
  {
      result->Error("no texture id", "no texture id");
      return;
  }

  auto findResult = flutterGLTextures.find(textureId);
  // Check if the received ID is registered
  if ( findResult == flutterGLTextures.end())
  {
      result->Error("Invalid texture ID", "Invalid Texture ID: " + std::to_string(textureId));
      return;
  }

  flutterGLTextures[textureId].release();
  flutterGLTextures.erase(textureId);

  result->Success();
  }
  else {
    result->NotImplemented();
  }
}


// void draw()
// {
//    char vShaderStr[] =
//       "#version 300 es                          \n"
//       "layout(location = 0) in vec4 vPosition;  \n"
//       "void main()                              \n"
//       "{                                        \n"
//       "   gl_Position = vPosition;              \n"
//       "}                                        \n";

//    char fShaderStr[] =
//       "#version 300 es                              \n"
//       "precision mediump float;                     \n"
//       "out vec4 fragColor;                          \n"
//       "void main()                                  \n"
//       "{                                            \n"
//       "   fragColor = vec4 ( 1.0, 0.0, 0.0, 1.0 );  \n"
//       "}                                            \n";

//    GLuint vertexShader;
//    GLuint fragmentShader;
//    GLuint programObject;
//    GLint linked;

//    // Load the vertex/fragment shaders
//    vertexShader = LoadShader ( GL_VERTEX_SHADER, vShaderStr );
//    fragmentShader = LoadShader ( GL_FRAGMENT_SHADER, fShaderStr );

//    // Create the program object
//    programObject = glCreateProgram ( );

//    if ( programObject == 0 )
//    {
      
//       auto error = glGetError();
//       if (error != GL_NO_ERROR)
//       {
//           std::cerr << "GlError" << error << std::endl;
//       }
//    }

//    glAttachShader ( programObject, vertexShader );
//    glAttachShader ( programObject, fragmentShader );

//    // Link the program
//    glLinkProgram ( programObject );

//    // Check the link status
//    glGetProgramiv ( programObject, GL_LINK_STATUS, &linked );

//    if ( !linked )
//    {
//       GLint infoLen = 0;

//       glGetProgramiv ( programObject, GL_INFO_LOG_LENGTH, &infoLen );

//       if ( infoLen > 1 )
//       {
//          char *infoLog = (char*)malloc ( sizeof ( char ) * infoLen );

//          glGetProgramInfoLog ( programObject, infoLen, NULL, infoLog );
//          std::cerr << "Error linking program:\n%s\n" << infoLog << std::endl;

//          free ( infoLog );
//       }

//       glDeleteProgram ( programObject );
//       return ;
//    }
//    // Store the program object

//    glClearColor ( 0.0f, 0.0f, 1.0f, 1.0f );
  
//    GLfloat vVertices[] = {  0.0f,  0.5f, 0.0f,
//                             -0.5f, -0.5f, 0.0f,
//                             0.5f, -0.5f, 0.0f
//                          };

//    // Set the viewport
//   glViewport ( 0, 0, 600, 400);

//    // Clear the color buffer
//    glClear ( GL_COLOR_BUFFER_BIT );

//    // Use the program object
//    glUseProgram ( programObject );

//    // Load the vertex data
//    glVertexAttribPointer ( 0, 3, GL_FLOAT, GL_FALSE, 0, vVertices );
//    glEnableVertexAttribArray ( 0 );

//   glDrawArrays ( GL_TRIANGLES, 0, 3 );

// }




}  // namespace

void FlutterWebGlPluginRegisterWithRegistrar(
    FlutterDesktopPluginRegistrarRef registrar) {
  FlutterWebGlPlugin::RegisterWithRegistrar(
      flutter::PluginRegistrarManager::GetInstance()
          ->GetRegistrar<flutter::PluginRegistrarWindows>(registrar));
}

