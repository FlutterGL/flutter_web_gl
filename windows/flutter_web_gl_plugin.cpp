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

void draw();

GLuint LoadShader ( GLenum type, const char *shaderSrc )
{
   GLuint shader;
   GLint compiled;

   // Create the shader object
   shader = glCreateShader ( type );

   if ( shader == 0 )
   {
      return 0;
   }

   // Load the shader source
   glShaderSource ( shader, 1, &shaderSrc, NULL );

   // Compile the shader
   glCompileShader ( shader );

   // Check the compile status
   glGetShaderiv ( shader, GL_COMPILE_STATUS, &compiled );

   if ( !compiled )
   {
      GLint infoLen = 0;

      glGetShaderiv ( shader, GL_INFO_LOG_LENGTH, &infoLen );

      if ( infoLen > 1 )
      {
         char *infoLog =(char*) malloc ( sizeof ( char ) * infoLen );

         glGetShaderInfoLog ( shader, infoLen, NULL, infoLog );
         std::cerr<< "Error compiling shader:\n%s\n" << infoLog << std::endl;

         free ( infoLog );
      }

      glDeleteShader ( shader );
      return 0;
   }

   return shader;

}  

  class OpenGLTexture
  {
  public:
    OpenGLTexture(size_t width, size_t height);
    virtual ~OpenGLTexture();
    const FlutterDesktopPixelBuffer *CopyPixelBuffer(size_t width, size_t height);

    std::unique_ptr<FlutterDesktopPixelBuffer> buffer;
  private:
    std::unique_ptr<uint8_t> pixels;
    size_t request_count_ = 0;
  }; 
  
  
  OpenGLTexture::OpenGLTexture(size_t width, size_t height)
  {
    size_t size = width * height * 4;

    pixels.reset(new uint8_t[size]);

    buffer = std::make_unique<FlutterDesktopPixelBuffer>();
    buffer->buffer = pixels.get();
    buffer->width = width;
    buffer->height = height;
    memset(pixels.get(), 0xff, size);

  }

  const FlutterDesktopPixelBuffer *OpenGLTexture::CopyPixelBuffer(size_t width, size_t height)
  {
    return buffer.get();
  }

    OpenGLTexture::~OpenGLTexture() {}

class FlutterWebGlPlugin : public flutter::Plugin {
 public:
  static void RegisterWithRegistrar(flutter::PluginRegistrarWindows *registrar);

  FlutterWebGlPlugin(flutter::TextureRegistrar *textures);

  virtual ~FlutterWebGlPlugin();

 private:
  // Called when a method is called on this plugin's channel from Dart.
  void HandleMethodCall(
      const flutter::MethodCall<flutter::EncodableValue> &method_call,
      std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result);

  flutter::TextureRegistrar *textures_;
  std::unique_ptr<flutter::TextureVariant> texture_;
  std::unique_ptr<OpenGLTexture> _texture;   
};

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

FlutterWebGlPlugin::FlutterWebGlPlugin(flutter::TextureRegistrar *textures) : textures_(textures) {}

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
  else if (method_call.method_name().compare("initOpenGL") == 0) {
      
      static EGLContext  context;
      if (context)
      {
        result->Success();
      }

      if (arguments) {
          auto texture_id = arguments->find(EncodableValue("openGLContext"));
          if (texture_id != arguments->end()) {
              context = (EGLContext) std::get<std::int64_t>(texture_id->second);
          }
      }
      else
      {
        result->Error("no texture id","no texture id");
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

      // auto context = eglCreateContext(
      //     display,
      //     config,
      //     EGL_NO_CONTEXT,
      //     nullptr
      //     );

      const EGLint surfaceAttributes[] = {
        EGL_WIDTH, 16,
        EGL_HEIGHT, 16,
        EGL_NONE
      };

      auto surface = eglCreatePbufferSurface(display, config, surfaceAttributes);
      
      eglMakeCurrent(display, surface, surface, context);

      auto v = glGetString(GL_VENDOR);
      int error = glGetError();
      if (error != GL_NO_ERROR)
      {
          std::cerr << "GlError" << error << std::endl;
      }     auto r = glGetString(GL_RENDERER);
      auto v2 = glGetString(GL_VERSION);

      std::cerr << v << std::endl << r << std::endl << v2 << std::endl;

      result->Success();
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

      std::cerr << width << "x" << height << std::endl;
      _texture = std::make_unique<OpenGLTexture>(width, height);
      unsigned int fbo;
      glGenFramebuffers(1, &fbo);
      glBindFramebuffer(GL_FRAMEBUFFER, fbo);

      unsigned int rbo;
      glGenRenderbuffers(1, &rbo);
      glBindRenderbuffer(GL_RENDERBUFFER, rbo);  

      glRenderbufferStorage(GL_RENDERBUFFER, GL_RGBA8, width, height);
      auto error = glGetError();
      if (error != GL_NO_ERROR)
      {
          std::cerr << "GlError" << error << std::endl;
      }
      glFramebufferRenderbuffer(GL_FRAMEBUFFER, GL_COLOR_ATTACHMENT0, GL_RENDERBUFFER,rbo);
      auto frameBufferCheck = glCheckFramebufferStatus(GL_FRAMEBUFFER);
      if (frameBufferCheck != GL_FRAMEBUFFER_COMPLETE)
      {
          std::cerr << "Framebuffer error" << frameBufferCheck << std::endl;
      }

      error = glGetError() ;
      if( error != GL_NO_ERROR)
      {
        std::cerr << "GlError" << error << std::endl;
      }

      texture_ = std::make_unique<flutter::TextureVariant>(flutter::PixelBufferTexture(
        [this](size_t width, size_t height) -> const FlutterDesktopPixelBuffer * {
          return _texture->CopyPixelBuffer(width, height);
        }));
      

      GLint widthRbo;
      glGetRenderbufferParameteriv(GL_RENDERBUFFER, GL_RENDERBUFFER_WIDTH, &widthRbo);
      error = glGetError();
      if (error != GL_NO_ERROR)
      {
          std::cerr << "GlError" << error << std::endl;
      }
    GLint heightRbo ;
    glGetRenderbufferParameteriv(GL_RENDERBUFFER, GL_RENDERBUFFER_HEIGHT, &heightRbo);

    GLint internalFormat ;
    glGetRenderbufferParameteriv(GL_RENDERBUFFER, GL_RENDERBUFFER_INTERNAL_FORMAT, &internalFormat);

    std::cerr << "rboID: " << rbo << "with: " << widthRbo << "height: " << heightRbo << "internalFormat: " << internalFormat << std::endl;

      int64_t texture_id = textures_->RegisterTexture(texture_.get());
      auto response = flutter::EncodableValue(flutter::EncodableMap{
          {flutter::EncodableValue("textureId"),
           flutter::EncodableValue(texture_id)},
          {flutter::EncodableValue("rbo"),
           flutter::EncodableValue((int64_t) rbo) }
         }
      );

      result->Success(response);
      std::cerr << "Created a new texture " << width << "x" << height << std::endl;
  }
  else if (method_call.method_name().compare("updateTexture") == 0) {
    // TODO: check if id is valid
      int64_t id =0;
      if (arguments) {
          auto texture_id = arguments->find(EncodableValue("textureId"));
          if (texture_id != arguments->end()) {
              id = std::get<std::int64_t>(texture_id->second);
          }
      }
      else
      {
        result->Error("no texture id","no texture id");
        return;
      }
      //draw();

       glReadPixels(0, 0, (GLsizei)_texture->buffer->width, (GLsizei)_texture->buffer->height, GL_RGBA, GL_UNSIGNED_BYTE, (void*)_texture->buffer->buffer);
       textures_->MarkTextureFrameAvailable(id);

       result->Success();
  }
   else {
    result->NotImplemented();
  }
}


void draw()
{
   char vShaderStr[] =
      "#version 300 es                          \n"
      "layout(location = 0) in vec4 vPosition;  \n"
      "void main()                              \n"
      "{                                        \n"
      "   gl_Position = vPosition;              \n"
      "}                                        \n";

   char fShaderStr[] =
      "#version 300 es                              \n"
      "precision mediump float;                     \n"
      "out vec4 fragColor;                          \n"
      "void main()                                  \n"
      "{                                            \n"
      "   fragColor = vec4 ( 1.0, 0.0, 0.0, 1.0 );  \n"
      "}                                            \n";

   GLuint vertexShader;
   GLuint fragmentShader;
   GLuint programObject;
   GLint linked;

   // Load the vertex/fragment shaders
   vertexShader = LoadShader ( GL_VERTEX_SHADER, vShaderStr );
   fragmentShader = LoadShader ( GL_FRAGMENT_SHADER, fShaderStr );

   // Create the program object
   programObject = glCreateProgram ( );

   if ( programObject == 0 )
   {
      
      auto error = glGetError();
      if (error != GL_NO_ERROR)
      {
          std::cerr << "GlError" << error << std::endl;
      }
   }

   glAttachShader ( programObject, vertexShader );
   glAttachShader ( programObject, fragmentShader );

   // Link the program
   glLinkProgram ( programObject );

   // Check the link status
   glGetProgramiv ( programObject, GL_LINK_STATUS, &linked );

   if ( !linked )
   {
      GLint infoLen = 0;

      glGetProgramiv ( programObject, GL_INFO_LOG_LENGTH, &infoLen );

      if ( infoLen > 1 )
      {
         char *infoLog = (char*)malloc ( sizeof ( char ) * infoLen );

         glGetProgramInfoLog ( programObject, infoLen, NULL, infoLog );
         std::cerr << "Error linking program:\n%s\n" << infoLog << std::endl;

         free ( infoLog );
      }

      glDeleteProgram ( programObject );
      return ;
   }
   // Store the program object

   glClearColor ( 0.0f, 0.0f, 1.0f, 1.0f );
  
   GLfloat vVertices[] = {  0.0f,  0.5f, 0.0f,
                            -0.5f, -0.5f, 0.0f,
                            0.5f, -0.5f, 0.0f
                         };

   // Set the viewport
  glViewport ( 0, 0, 600, 400);

   // Clear the color buffer
   glClear ( GL_COLOR_BUFFER_BIT );

   // Use the program object
   glUseProgram ( programObject );

   // Load the vertex data
   glVertexAttribPointer ( 0, 3, GL_FLOAT, GL_FALSE, 0, vVertices );
   glEnableVertexAttribArray ( 0 );

  glDrawArrays ( GL_TRIANGLES, 0, 3 );

}




}  // namespace

void FlutterWebGlPluginRegisterWithRegistrar(
    FlutterDesktopPluginRegistrarRef registrar) {
  FlutterWebGlPlugin::RegisterWithRegistrar(
      flutter::PluginRegistrarManager::GetInstance()
          ->GetRegistrar<flutter::PluginRegistrarWindows>(registrar));
}

