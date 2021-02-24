part of 'flutter_web_gl.dart';

class OpenGLException implements Exception {
  OpenGLException(this.message, this.error);

  final String message;
  final int error;

  @override
  String toString() => '$message GLES error $error ';
}
// // The web wrapper uses this as base class everywhere

// // laong as we don't know if we need it, we use this dummy class
// class Interceptor {}

// class ActiveInfo extends Interceptor {
//   // To suppress missing implicit constructor warnings.
//   factory ActiveInfo._() {
//     throw new UnsupportedError("Not supported");
//   }

//   String get name;

//   int get size;

//   int get type;
// }

// class AngleInstancedArrays extends Interceptor {
//   // To suppress missing implicit constructor warnings.
//   factory AngleInstancedArrays._() {
//     throw new UnsupportedError("Not supported");
//   }

//   static const int VERTEX_ATTRIB_ARRAY_DIVISOR_ANGLE = 0x88FE;

//   void drawArraysInstancedAngle(int mode, int first, int count, int primcount);

//   void drawElementsInstancedAngle(int mode, int count, int type, int offset, int primcount);

//   void vertexAttribDivisorAngle(int index, int divisor);
// }

class Buffer {
  final int bufferId;
  Buffer._create(this.bufferId);
}

// class Canvas extends Interceptor {
//   // To suppress missing implicit constructor warnings.
//   factory Canvas._() {
//     throw new UnsupportedError("Not supported");
//   }

//   CanvasElement get canvas;

//   OffscreenCanvas? get offscreenCanvas;
// }

// class ColorBufferFloat extends Interceptor {
//   // To suppress missing implicit constructor warnings.
//   factory ColorBufferFloat._() {
//     throw new UnsupportedError("Not supported");
//   }
// }

// class CompressedTextureAstc extends Interceptor {
//   // To suppress missing implicit constructor warnings.
//   factory CompressedTextureAstc._() {
//     throw new UnsupportedError("Not supported");
//   }

//   static const int COMPRESSED_RGBA_ASTC_10x10_KHR = 0x93BB;

//   static const int COMPRESSED_RGBA_ASTC_10x5_KHR = 0x93B8;

//   static const int COMPRESSED_RGBA_ASTC_10x6_KHR = 0x93B9;

//   static const int COMPRESSED_RGBA_ASTC_10x8_KHR = 0x93BA;

//   static const int COMPRESSED_RGBA_ASTC_12x10_KHR = 0x93BC;

//   static const int COMPRESSED_RGBA_ASTC_12x12_KHR = 0x93BD;

//   static const int COMPRESSED_RGBA_ASTC_4x4_KHR = 0x93B0;

//   static const int COMPRESSED_RGBA_ASTC_5x4_KHR = 0x93B1;

//   static const int COMPRESSED_RGBA_ASTC_5x5_KHR = 0x93B2;

//   static const int COMPRESSED_RGBA_ASTC_6x5_KHR = 0x93B3;

//   static const int COMPRESSED_RGBA_ASTC_6x6_KHR = 0x93B4;

//   static const int COMPRESSED_RGBA_ASTC_8x5_KHR = 0x93B5;

//   static const int COMPRESSED_RGBA_ASTC_8x6_KHR = 0x93B6;

//   static const int COMPRESSED_RGBA_ASTC_8x8_KHR = 0x93B7;

//   static const int COMPRESSED_SRGB8_ALPHA8_ASTC_10x10_KHR = 0x93DB;

//   static const int COMPRESSED_SRGB8_ALPHA8_ASTC_10x5_KHR = 0x93D8;

//   static const int COMPRESSED_SRGB8_ALPHA8_ASTC_10x6_KHR = 0x93D9;

//   static const int COMPRESSED_SRGB8_ALPHA8_ASTC_10x8_KHR = 0x93DA;

//   static const int COMPRESSED_SRGB8_ALPHA8_ASTC_12x10_KHR = 0x93DC;

//   static const int COMPRESSED_SRGB8_ALPHA8_ASTC_12x12_KHR = 0x93DD;

//   static const int COMPRESSED_SRGB8_ALPHA8_ASTC_4x4_KHR = 0x93D0;

//   static const int COMPRESSED_SRGB8_ALPHA8_ASTC_5x4_KHR = 0x93D1;

//   static const int COMPRESSED_SRGB8_ALPHA8_ASTC_5x5_KHR = 0x93D2;

//   static const int COMPRESSED_SRGB8_ALPHA8_ASTC_6x5_KHR = 0x93D3;

//   static const int COMPRESSED_SRGB8_ALPHA8_ASTC_6x6_KHR = 0x93D4;

//   static const int COMPRESSED_SRGB8_ALPHA8_ASTC_8x5_KHR = 0x93D5;

//   static const int COMPRESSED_SRGB8_ALPHA8_ASTC_8x6_KHR = 0x93D6;

//   static const int COMPRESSED_SRGB8_ALPHA8_ASTC_8x8_KHR = 0x93D7;
// }

// // JS "WebGLCompressedTextureATC,WEBGL_compressed_texture_atc")
// class CompressedTextureAtc extends Interceptor {
//   // To suppress missing implicit constructor warnings.
//   factory CompressedTextureAtc._() {
//     throw new UnsupportedError("Not supported");
//   }

//   static const int COMPRESSED_RGBA_ATC_EXPLICIT_ALPHA_WEBGL = 0x8C93;

//   static const int COMPRESSED_RGBA_ATC_INTERPOLATED_ALPHA_WEBGL = 0x87EE;

//   static const int COMPRESSED_RGB_ATC_WEBGL = 0x8C92;
// }

// // JS "WebGLCompressedTextureETC1,WEBGL_compressed_texture_etc1")
// class CompressedTextureETC1 extends Interceptor {
//   // To suppress missing implicit constructor warnings.
//   factory CompressedTextureETC1._() {
//     throw new UnsupportedError("Not supported");
//   }

//   static const int COMPRESSED_RGB_ETC1_WEBGL = 0x8D64;
// }

// // JS "WebGLCompressedTextureETC")
// class CompressedTextureEtc extends Interceptor {
//   // To suppress missing implicit constructor warnings.
//   factory CompressedTextureEtc._() {
//     throw new UnsupportedError("Not supported");
//   }

//   static const int COMPRESSED_R11_EAC = 0x9270;

//   static const int COMPRESSED_RG11_EAC = 0x9272;

//   static const int COMPRESSED_RGB8_ETC2 = 0x9274;

//   static const int COMPRESSED_RGB8_PUNCHTHROUGH_ALPHA1_ETC2 = 0x9276;

//   static const int COMPRESSED_RGBA8_ETC2_EAC = 0x9278;

//   static const int COMPRESSED_SIGNED_R11_EAC = 0x9271;

//   static const int COMPRESSED_SIGNED_RG11_EAC = 0x9273;

//   static const int COMPRESSED_SRGB8_ALPHA8_ETC2_EAC = 0x9279;

//   static const int COMPRESSED_SRGB8_ETC2 = 0x9275;

//   static const int COMPRESSED_SRGB8_PUNCHTHROUGH_ALPHA1_ETC2 = 0x9277;
// }

// // JS "WebGLCompressedTexturePVRTC,WEBGL_compressed_texture_pvrtc")
// class CompressedTexturePvrtc extends Interceptor {
//   // To suppress missing implicit constructor warnings.
//   factory CompressedTexturePvrtc._() {
//     throw new UnsupportedError("Not supported");
//   }

//   static const int COMPRESSED_RGBA_PVRTC_2BPPV1_IMG = 0x8C03;

//   static const int COMPRESSED_RGBA_PVRTC_4BPPV1_IMG = 0x8C02;

//   static const int COMPRESSED_RGB_PVRTC_2BPPV1_IMG = 0x8C01;

//   static const int COMPRESSED_RGB_PVRTC_4BPPV1_IMG = 0x8C00;
// }

// // JS "WebGLCompressedTextureS3TC,WEBGL_compressed_texture_s3tc")
// class CompressedTextureS3TC extends Interceptor {
//   // To suppress missing implicit constructor warnings.
//   factory CompressedTextureS3TC._() {
//     throw new UnsupportedError("Not supported");
//   }

//   static const int COMPRESSED_RGBA_S3TC_DXT1_EXT = 0x83F1;

//   static const int COMPRESSED_RGBA_S3TC_DXT3_EXT = 0x83F2;

//   static const int COMPRESSED_RGBA_S3TC_DXT5_EXT = 0x83F3;

//   static const int COMPRESSED_RGB_S3TC_DXT1_EXT = 0x83F0;
// }

// // JS "WebGLCompressedTextureS3TCsRGB")
// class CompressedTextureS3TCsRgb extends Interceptor {
//   // To suppress missing implicit constructor warnings.
//   factory CompressedTextureS3TCsRgb._() {
//     throw new UnsupportedError("Not supported");
//   }

//   static const int COMPRESSED_SRGB_ALPHA_S3TC_DXT1_EXT = 0x8C4D;

//   static const int COMPRESSED_SRGB_ALPHA_S3TC_DXT3_EXT = 0x8C4E;

//   static const int COMPRESSED_SRGB_ALPHA_S3TC_DXT5_EXT = 0x8C4F;

//   static const int COMPRESSED_SRGB_S3TC_DXT1_EXT = 0x8C4C;
// }

// // JS "WebGLContextEvent")
// class ContextEvent extends Event {
//   // To suppress missing implicit constructor warnings.
//   factory ContextEvent._() {
//     throw new UnsupportedError("Not supported");
//   }

//   factory ContextEvent(String type, [Map? eventInit]) {
//     if (eventInit != null) {
//       var eventInit_1 = convertDartToNative_Dictionary(eventInit);
//       return ContextEvent._create_1(type, eventInit_1);
//     }
//     return ContextEvent._create_2(type);
//   }
//   static ContextEvent _create_1(type, eventInit) => JS('ContextEvent', 'new WebGLContextEvent(#,#)', type, eventInit);
//   static ContextEvent _create_2(type) => JS('ContextEvent', 'new WebGLContextEvent(#)', type);

//   String get statusMessage;
// }

// // JS "WebGLDebugRendererInfo,WEBGL_debug_renderer_info")
// class DebugRendererInfo extends Interceptor {
//   // To suppress missing implicit constructor warnings.
//   factory DebugRendererInfo._() {
//     throw new UnsupportedError("Not supported");
//   }

//   static const int UNMASKED_RENDERER_WEBGL = 0x9246;

//   static const int UNMASKED_VENDOR_WEBGL = 0x9245;
// }

// // JS "WebGLDebugShaders,WEBGL_debug_shaders")
// class DebugShaders extends Interceptor {
//   // To suppress missing implicit constructor warnings.
//   factory DebugShaders._() {
//     throw new UnsupportedError("Not supported");
//   }

//   String? getTranslatedShaderSource(Shader shader);
// }

// // JS "WebGLDepthTexture,WEBGL_depth_texture")
// class DepthTexture extends Interceptor {
//   // To suppress missing implicit constructor warnings.
//   factory DepthTexture._() {
//     throw new UnsupportedError("Not supported");
//   }

//   static const int UNSIGNED_INT_24_8_WEBGL = 0x84FA;
// }

// // JS "WebGLDrawBuffers,WEBGL_draw_buffers")
// class DrawBuffers extends Interceptor {
//   // To suppress missing implicit constructor warnings.
//   factory DrawBuffers._() {
//     throw new UnsupportedError("Not supported");
//   }

//   //JS ('drawBuffersWEBGL')
//   void drawBuffersWebgl(List<int> buffers);
// }

// // JS "EXTsRGB,EXT_sRGB")
// class EXTsRgb extends Interceptor {
//   // To suppress missing implicit constructor warnings.
//   factory EXTsRgb._() {
//     throw new UnsupportedError("Not supported");
//   }

//   static const int FRAMEBUFFER_ATTACHMENT_COLOR_ENCODING_EXT = 0x8210;

//   static const int SRGB8_ALPHA8_EXT = 0x8C43;

//   static const int SRGB_ALPHA_EXT = 0x8C42;

//   static const int SRGB_EXT = 0x8C40;
// }

// // JS "EXTBlendMinMax,EXT_blend_minmax")
// class ExtBlendMinMax extends Interceptor {
//   // To suppress missing implicit constructor warnings.
//   factory ExtBlendMinMax._() {
//     throw new UnsupportedError("Not supported");
//   }

//   static const int MAX_EXT = 0x8008;

//   static const int MIN_EXT = 0x8007;
// }

// // JS "EXTColorBufferFloat")
// class ExtColorBufferFloat extends Interceptor {
//   // To suppress missing implicit constructor warnings.
//   factory ExtColorBufferFloat._() {
//     throw new UnsupportedError("Not supported");
//   }
// }

// // JS "EXTColorBufferHalfFloat")
// class ExtColorBufferHalfFloat extends Interceptor {
//   // To suppress missing implicit constructor warnings.
//   factory ExtColorBufferHalfFloat._() {
//     throw new UnsupportedError("Not supported");
//   }
// }

// // JS "EXTDisjointTimerQuery")
// class ExtDisjointTimerQuery extends Interceptor {
//   // To suppress missing implicit constructor warnings.
//   factory ExtDisjointTimerQuery._() {
//     throw new UnsupportedError("Not supported");
//   }

//   static const int CURRENT_QUERY_EXT = 0x8865;

//   static const int GPU_DISJOINT_EXT = 0x8FBB;

//   static const int QUERY_COUNTER_BITS_EXT = 0x8864;

//   static const int QUERY_RESULT_AVAILABLE_EXT = 0x8867;

//   static const int QUERY_RESULT_EXT = 0x8866;

//   static const int TIMESTAMP_EXT = 0x8E28;

//   static const int TIME_ELAPSED_EXT = 0x88BF;

//   //JS ('beginQueryEXT')
//   void beginQueryExt(int target, TimerQueryExt query);

//   //JS ('createQueryEXT')
//   TimerQueryExt createQueryExt();

//   //JS ('deleteQueryEXT')
//   void deleteQueryExt(TimerQueryExt? query);

//   //JS ('endQueryEXT')
//   void endQueryExt(int target);

//   //JS ('getQueryEXT')
//   Object? getQueryExt(int target, int pname);

//   //JS ('getQueryObjectEXT')
//   Object? getQueryObjectExt(TimerQueryExt query, int pname);

//   //JS ('isQueryEXT')
//   bool isQueryExt(TimerQueryExt? query);

//   //JS ('queryCounterEXT')
//   void queryCounterExt(TimerQueryExt query, int target);
// }

// // JS "EXTDisjointTimerQueryWebGL2")
// class ExtDisjointTimerQueryWebGL2 extends Interceptor {
//   // To suppress missing implicit constructor warnings.
//   factory ExtDisjointTimerQueryWebGL2._() {
//     throw new UnsupportedError("Not supported");
//   }

//   static const int GPU_DISJOINT_EXT = 0x8FBB;

//   static const int QUERY_COUNTER_BITS_EXT = 0x8864;

//   static const int TIMESTAMP_EXT = 0x8E28;

//   static const int TIME_ELAPSED_EXT = 0x88BF;

//   //JS ('queryCounterEXT')
//   void queryCounterExt(Query query, int target);
// }

// // JS "EXTFragDepth,EXT_frag_depth")
// class ExtFragDepth extends Interceptor {
//   // To suppress missing implicit constructor warnings.
//   factory ExtFragDepth._() {
//     throw new UnsupportedError("Not supported");
//   }
// }

// // JS "EXTShaderTextureLOD,EXT_shader_texture_lod")
// class ExtShaderTextureLod extends Interceptor {
//   // To suppress missing implicit constructor warnings.
//   factory ExtShaderTextureLod._() {
//     throw new UnsupportedError("Not supported");
//   }
// }

// // JS "EXTTextureFilterAnisotropic,EXT_texture_filter_anisotropic")
// class ExtTextureFilterAnisotropic extends Interceptor {
//   // To suppress missing implicit constructor warnings.
//   factory ExtTextureFilterAnisotropic._() {
//     throw new UnsupportedError("Not supported");
//   }

//   static const int MAX_TEXTURE_MAX_ANISOTROPY_EXT = 0x84FF;

//   static const int TEXTURE_MAX_ANISOTROPY_EXT = 0x84FE;
// }

// // JS "WebGLFramebuffer")
// class Framebuffer extends Interceptor {
//   // To suppress missing implicit constructor warnings.
//   factory Framebuffer._() {
//     throw new UnsupportedError("Not supported");
//   }
// }

// // JS "WebGLGetBufferSubDataAsync")
// class GetBufferSubDataAsync extends Interceptor {
//   // To suppress missing implicit constructor warnings.
//   factory GetBufferSubDataAsync._() {
//     throw new UnsupportedError("Not supported");
//   }

//   Future getBufferSubDataAsync(int target, int srcByteOffset, TypedData dstData, [int? dstOffset, int? length]) =>
//       promiseToFuture(
//           JS("", "#.getBufferSubDataAsync(#, #, #, #, #)", this, target, srcByteOffset, dstData, dstOffset, length));
// }

// // JS "WebGLLoseContext,WebGLExtensionLoseContext,WEBGL_lose_context")
// class LoseContext extends Interceptor {
//   // To suppress missing implicit constructor warnings.
//   factory LoseContext._() {
//     throw new UnsupportedError("Not supported");
//   }

//   void loseContext();

//   void restoreContext();
// }

// // JS "OESElementIndexUint,OES_element_index_uint")
// class OesElementIndexUint extends Interceptor {
//   // To suppress missing implicit constructor warnings.
//   factory OesElementIndexUint._() {
//     throw new UnsupportedError("Not supported");
//   }
// }

// // JS "OESStandardDerivatives,OES_standard_derivatives")
// class OesStandardDerivatives extends Interceptor {
//   // To suppress missing implicit constructor warnings.
//   factory OesStandardDerivatives._() {
//     throw new UnsupportedError("Not supported");
//   }

//   static const int FRAGMENT_SHADER_DERIVATIVE_HINT_OES = 0x8B8B;
// }

// // JS "OESTextureFloat,OES_texture_float")
// class OesTextureFloat extends Interceptor {
//   // To suppress missing implicit constructor warnings.
//   factory OesTextureFloat._() {
//     throw new UnsupportedError("Not supported");
//   }
// }

// // JS "OESTextureFloatLinear,OES_texture_float_linear")
// class OesTextureFloatLinear extends Interceptor {
//   // To suppress missing implicit constructor warnings.
//   factory OesTextureFloatLinear._() {
//     throw new UnsupportedError("Not supported");
//   }
// }

// // JS "OESTextureHalfFloat,OES_texture_half_float")
// class OesTextureHalfFloat extends Interceptor {
//   // To suppress missing implicit constructor warnings.
//   factory OesTextureHalfFloat._() {
//     throw new UnsupportedError("Not supported");
//   }

//   static const int HALF_FLOAT_OES = 0x8D61;
// }

// // JS "OESTextureHalfFloatLinear,OES_texture_half_float_linear")
// class OesTextureHalfFloatLinear extends Interceptor {
//   // To suppress missing implicit constructor warnings.
//   factory OesTextureHalfFloatLinear._() {
//     throw new UnsupportedError("Not supported");
//   }
// }

// // JS "OESVertexArrayObject,OES_vertex_array_object")
// class OesVertexArrayObject extends Interceptor {
//   // To suppress missing implicit constructor warnings.
//   factory OesVertexArrayObject._() {
//     throw new UnsupportedError("Not supported");
//   }

//   static const int VERTEX_ARRAY_BINDING_OES = 0x85B5;

//   //JS ('bindVertexArrayOES')
//   void bindVertexArray(VertexArrayObjectOes? arrayObject);

//   //JS ('createVertexArrayOES')
//   VertexArrayObjectOes createVertexArray();

//   //JS ('deleteVertexArrayOES')
//   void deleteVertexArray(VertexArrayObjectOes? arrayObject);

//   //JS ('isVertexArrayOES')
//   bool isVertexArray(VertexArrayObjectOes? arrayObject);
// }

// JS "WebGLProgram")

class Program {
  final int programID;
  Program._create(this.programID);
}

// // JS "WebGLQuery")
// class Query extends Interceptor {
//   // To suppress missing implicit constructor warnings.
//   factory Query._() {
//     throw new UnsupportedError("Not supported");
//   }
// }

// // JS "WebGLRenderbuffer")
// class Renderbuffer extends Interceptor {
//   // To suppress missing implicit constructor warnings.
//   factory Renderbuffer._() {
//     throw new UnsupportedError("Not supported");
//   }
// }

// JS "WebGL2RenderingContext")
class RenderingContext {
  final int contextId;
  final LibOpenGLES gl;
  RenderingContext._create(this.gl, this.contextId);

  /// As allocating and freeing native memory is expensive and we need regularly
  /// buffers to receive values from FFI function we create a small set here that will
  /// be reused constantly
  final tempInt32s = [allocate<Int32>(), allocate<Int32>(), allocate<Int32>()];
  final tempUint32s = [allocate<Uint32>(), allocate<Uint32>(), allocate<Uint32>()];
  final tempInt8 = allocate<Int8>();

  void dispose() {
    for (final p in tempInt32s) {
      free(p);
    }
    for (final p in tempUint32s) {
      free(p);
    }
    free(tempInt8);
  }

  void checkError([String message = '']) {
    final glError = gl.glGetError();
    if (glError != WebGL.NO_ERROR) {
      final openGLException = OpenGLException('RenderingContext.$message', glError);
      assert(() {
        print(openGLException.toString());
        return true;
      }());
      throw openGLException;
    }
  }

  // From WebGL2RenderingContextBase

  // void beginQuery(int target, Query query);

  // void beginTransformFeedback(int primitiveMode);

  // void bindBufferBase(int target, int index, Buffer? buffer);

  // void bindBufferRange(int target, int index, Buffer? buffer, int offset, int size);

  // void bindSampler(int unit, Sampler? sampler);

  // void bindTransformFeedback(int target, TransformFeedback? feedback);

  // void bindVertexArray(VertexArrayObject? vertexArray);

  // void blitFramebuffer(
  //     int srcX0, int srcY0, int srcX1, int srcY1, int dstX0, int dstY0, int dstX1, int dstY1, int mask, int filter);

  // //JS ('bufferData')
  // void bufferData2(int target, TypedData srcData, int usage, int srcOffset, [int? length]);

  // //JS ('bufferSubData')
  // void bufferSubData2(int target, int dstByteOffset, TypedData srcData, int srcOffset, [int? length]);

  // void clearBufferfi(int buffer, int drawbuffer, num depth, int stencil);

  // void clearBufferfv(int buffer, int drawbuffer, value, [int? srcOffset]);

  // void clearBufferiv(int buffer, int drawbuffer, value, [int? srcOffset]);

  // void clearBufferuiv(int buffer, int drawbuffer, value, [int? srcOffset]);

  // int clientWaitSync(Sync sync, int flags, int timeout);

  // //JS ('compressedTexImage2D')
  // void compressedTexImage2D2(
  //     int target, int level, int internalformat, int width, int height, int border, TypedData data, int srcOffset,
  //     [int? srcLengthOverride]);

  // //JS ('compressedTexImage2D')
  // void compressedTexImage2D3(
  //     int target, int level, int internalformat, int width, int height, int border, int imageSize, int offset);

  // void compressedTexImage3D(
  //     int target, int level, int internalformat, int width, int height, int depth, int border, TypedData data,
  //     [int? srcOffset, int? srcLengthOverride]);

  // //JS ('compressedTexImage3D')
  // void compressedTexImage3D2(int target, int level, int internalformat, int width, int height, int depth, int border,
  //     int imageSize, int offset);

  // //JS ('compressedTexSubImage2D')
  // void compressedTexSubImage2D2(
  //     int target, int level, int xoffset, int yoffset, int width, int height, int format, TypedData data, int srcOffset,
  //     [int? srcLengthOverride]);

  // //JS ('compressedTexSubImage2D')
  // void compressedTexSubImage2D3(
  //     int target, int level, int xoffset, int yoffset, int width, int height, int format, int imageSize, int offset);

  // void compressedTexSubImage3D(int target, int level, int xoffset, int yoffset, int zoffset, int width, int height,
  //     int depth, int format, TypedData data,
  //     [int? srcOffset, int? srcLengthOverride]);

  // //JS ('compressedTexSubImage3D')
  // void compressedTexSubImage3D2(int target, int level, int xoffset, int yoffset, int zoffset, int width, int height,
  //     int depth, int format, int imageSize, int offset);

  // void copyBufferSubData(int readTarget, int writeTarget, int readOffset, int writeOffset, int size);

  // void copyTexSubImage3D(
  //     int target, int level, int xoffset, int yoffset, int zoffset, int x, int y, int width, int height);

  // Query? createQuery();

  // Sampler? createSampler();

  // TransformFeedback? createTransformFeedback();

  // VertexArrayObject? createVertexArray();

  // void deleteQuery(Query? query);

  // void deleteSampler(Sampler? sampler);

  // void deleteSync(Sync? sync);

  // void deleteTransformFeedback(TransformFeedback? feedback);

  // void deleteVertexArray(VertexArrayObject? vertexArray);

  // void drawArraysInstanced(int mode, int first, int count, int instanceCount);

  // void drawBuffers(List<int> buffers);

  // void drawElementsInstanced(int mode, int count, int type, int offset, int instanceCount);

  // void drawRangeElements(int mode, int start, int end, int count, int type, int offset);

  // void endQuery(int target);

  // void endTransformFeedback();

  // Sync? fenceSync(int condition, int flags);

  // void framebufferTextureLayer(int target, int attachment, WebGLTexture? texture, int level, int layer);

  // String? getActiveUniformBlockName(Program program, int uniformBlockIndex);

  // Object? getActiveUniformBlockParameter(Program program, int uniformBlockIndex, int pname);

  // Object? getActiveUniforms(Program program, List<int> uniformIndices, int pname);

  // void getBufferSubData(int target, int srcByteOffset, TypedData dstData, [int? dstOffset, int? length]);

  // int getFragDataLocation(Program program, String name);

  // Object? getIndexedParameter(int target, int index);

  // Object? getInternalformatParameter(int target, int internalformat, int pname);

  // Object? getQuery(int target, int pname);

  // Object? getQueryParameter(Query query, int pname);

  // Object? getSamplerParameter(Sampler sampler, int pname);

  // Object? getSyncParameter(Sync sync, int pname);

  // ActiveInfo? getTransformFeedbackVarying(Program program, int index);

  // int getUniformBlockIndex(Program program, String uniformBlockName);

  // List<int>? getUniformIndices(Program program, List<String> uniformNames) {
  //   List uniformNames_1 = convertDartToNative_StringArray(uniformNames);
  //   return _getUniformIndices_1(program, uniformNames_1);
  // }

  // //JS ('getUniformIndices')
  // List<int>? _getUniformIndices_1(Program program, List uniformNames);

  // void invalidateFramebuffer(int target, List<int> attachments);

  // void invalidateSubFramebuffer(int target, List<int> attachments, int x, int y, int width, int height);

  // bool isQuery(Query? query);

  // bool isSampler(Sampler? sampler);

  // bool isSync(Sync? sync);

  // bool isTransformFeedback(TransformFeedback? feedback);

  // bool isVertexArray(VertexArrayObject? vertexArray);

  // void pauseTransformFeedback();

  // void readBuffer(int mode);

  // //JS ('readPixels')
  // void readPixels2(int x, int y, int width, int height, int format, int type, dstData_OR_offset, [int? offset]);

  // void renderbufferStorageMultisample(int target, int samples, int internalformat, int width, int height);

  // void resumeTransformFeedback();

  // void samplerParameterf(Sampler sampler, int pname, num param);

  // void samplerParameteri(Sampler sampler, int pname, int param);

  // void texImage2D2(int target, int level, int internalformat, int width, int height, int border, int format, int type,
  //     bitmap_OR_canvas_OR_data_OR_image_OR_offset_OR_srcData_OR_video,
  //     [int? srcOffset]) {
  //   if ((bitmap_OR_canvas_OR_data_OR_image_OR_offset_OR_srcData_OR_video is int) && srcOffset == null) {
  //     _texImage2D2_1(target, level, internalformat, width, height, border, format, type,
  //         bitmap_OR_canvas_OR_data_OR_image_OR_offset_OR_srcData_OR_video);
  //     return;
  //   }
  //   if ((bitmap_OR_canvas_OR_data_OR_image_OR_offset_OR_srcData_OR_video is ImageData) && srcOffset == null) {
  //     var data_1 = convertDartToNative_ImageData(bitmap_OR_canvas_OR_data_OR_image_OR_offset_OR_srcData_OR_video);
  //     _texImage2D2_2(target, level, internalformat, width, height, border, format, type, data_1);
  //     return;
  //   }
  //   if ((bitmap_OR_canvas_OR_data_OR_image_OR_offset_OR_srcData_OR_video is ImageElement) && srcOffset == null) {
  //     _texImage2D2_3(target, level, internalformat, width, height, border, format, type,
  //         bitmap_OR_canvas_OR_data_OR_image_OR_offset_OR_srcData_OR_video);
  //     return;
  //   }
  //   if ((bitmap_OR_canvas_OR_data_OR_image_OR_offset_OR_srcData_OR_video is CanvasElement) && srcOffset == null) {
  //     _texImage2D2_4(target, level, internalformat, width, height, border, format, type,
  //         bitmap_OR_canvas_OR_data_OR_image_OR_offset_OR_srcData_OR_video);
  //     return;
  //   }
  //   if ((bitmap_OR_canvas_OR_data_OR_image_OR_offset_OR_srcData_OR_video is VideoElement) && srcOffset == null) {
  //     _texImage2D2_5(target, level, internalformat, width, height, border, format, type,
  //         bitmap_OR_canvas_OR_data_OR_image_OR_offset_OR_srcData_OR_video);
  //     return;
  //   }
  //   if ((bitmap_OR_canvas_OR_data_OR_image_OR_offset_OR_srcData_OR_video is ImageBitmap) && srcOffset == null) {
  //     _texImage2D2_6(target, level, internalformat, width, height, border, format, type,
  //         bitmap_OR_canvas_OR_data_OR_image_OR_offset_OR_srcData_OR_video);
  //     return;
  //   }
  //   if (srcOffset != null && (bitmap_OR_canvas_OR_data_OR_image_OR_offset_OR_srcData_OR_video is TypedData)) {
  //     _texImage2D2_7(target, level, internalformat, width, height, border, format, type,
  //         bitmap_OR_canvas_OR_data_OR_image_OR_offset_OR_srcData_OR_video, srcOffset);
  //     return;
  //   }
  //   throw new ArgumentError("Incorrect number or type of arguments");
  // }

  // //JS ('texImage2D')
  // void _texImage2D2_1(target, level, internalformat, width, height, border, format, type, int offset);
  // //JS ('texImage2D')
  // void _texImage2D2_2(target, level, internalformat, width, height, border, format, type, data);
  // //JS ('texImage2D')
  // void _texImage2D2_3(target, level, internalformat, width, height, border, format, type, ImageElement image);
  // //JS ('texImage2D')
  // void _texImage2D2_4(target, level, internalformat, width, height, border, format, type, CanvasElement canvas);
  // //JS ('texImage2D')
  // void _texImage2D2_5(target, level, internalformat, width, height, border, format, type, VideoElement video);
  // //JS ('texImage2D')
  // void _texImage2D2_6(target, level, internalformat, width, height, border, format, type, ImageBitmap bitmap);
  // //JS ('texImage2D')
  // void _texImage2D2_7(target, level, internalformat, width, height, border, format, type, TypedData srcData, srcOffset);

  // void texImage3D(int target, int level, int internalformat, int width, int height, int depth, int border, int format,
  //     int type, bitmap_OR_canvas_OR_data_OR_image_OR_offset_OR_pixels_OR_video,
  //     [int? srcOffset]) {
  //   if ((bitmap_OR_canvas_OR_data_OR_image_OR_offset_OR_pixels_OR_video is int) && srcOffset == null) {
  //     _texImage3D_1(target, level, internalformat, width, height, depth, border, format, type,
  //         bitmap_OR_canvas_OR_data_OR_image_OR_offset_OR_pixels_OR_video);
  //     return;
  //   }
  //   if ((bitmap_OR_canvas_OR_data_OR_image_OR_offset_OR_pixels_OR_video is ImageData) && srcOffset == null) {
  //     var data_1 = convertDartToNative_ImageData(bitmap_OR_canvas_OR_data_OR_image_OR_offset_OR_pixels_OR_video);
  //     _texImage3D_2(target, level, internalformat, width, height, depth, border, format, type, data_1);
  //     return;
  //   }
  //   if ((bitmap_OR_canvas_OR_data_OR_image_OR_offset_OR_pixels_OR_video is ImageElement) && srcOffset == null) {
  //     _texImage3D_3(target, level, internalformat, width, height, depth, border, format, type,
  //         bitmap_OR_canvas_OR_data_OR_image_OR_offset_OR_pixels_OR_video);
  //     return;
  //   }
  //   if ((bitmap_OR_canvas_OR_data_OR_image_OR_offset_OR_pixels_OR_video is CanvasElement) && srcOffset == null) {
  //     _texImage3D_4(target, level, internalformat, width, height, depth, border, format, type,
  //         bitmap_OR_canvas_OR_data_OR_image_OR_offset_OR_pixels_OR_video);
  //     return;
  //   }
  //   if ((bitmap_OR_canvas_OR_data_OR_image_OR_offset_OR_pixels_OR_video is VideoElement) && srcOffset == null) {
  //     _texImage3D_5(target, level, internalformat, width, height, depth, border, format, type,
  //         bitmap_OR_canvas_OR_data_OR_image_OR_offset_OR_pixels_OR_video);
  //     return;
  //   }
  //   if ((bitmap_OR_canvas_OR_data_OR_image_OR_offset_OR_pixels_OR_video is ImageBitmap) && srcOffset == null) {
  //     _texImage3D_6(target, level, internalformat, width, height, depth, border, format, type,
  //         bitmap_OR_canvas_OR_data_OR_image_OR_offset_OR_pixels_OR_video);
  //     return;
  //   }
  //   if ((bitmap_OR_canvas_OR_data_OR_image_OR_offset_OR_pixels_OR_video is TypedData ||
  //           bitmap_OR_canvas_OR_data_OR_image_OR_offset_OR_pixels_OR_video == null) &&
  //       srcOffset == null) {
  //     _texImage3D_7(target, level, internalformat, width, height, depth, border, format, type,
  //         bitmap_OR_canvas_OR_data_OR_image_OR_offset_OR_pixels_OR_video);
  //     return;
  //   }
  //   if (srcOffset != null && (bitmap_OR_canvas_OR_data_OR_image_OR_offset_OR_pixels_OR_video is TypedData)) {
  //     _texImage3D_8(target, level, internalformat, width, height, depth, border, format, type,
  //         bitmap_OR_canvas_OR_data_OR_image_OR_offset_OR_pixels_OR_video, srcOffset);
  //     return;
  //   }
  //   throw new ArgumentError("Incorrect number or type of arguments");
  // }

  // //JS ('texImage3D')
  // void _texImage3D_1(target, level, internalformat, width, height, depth, border, format, type, int offset);
  // //JS ('texImage3D')
  // void _texImage3D_2(target, level, internalformat, width, height, depth, border, format, type, data);
  // //JS ('texImage3D')
  // void _texImage3D_3(target, level, internalformat, width, height, depth, border, format, type, ImageElement image);
  // //JS ('texImage3D')
  // void _texImage3D_4(target, level, internalformat, width, height, depth, border, format, type, CanvasElement canvas);
  // //JS ('texImage3D')
  // void _texImage3D_5(target, level, internalformat, width, height, depth, border, format, type, VideoElement video);
  // //JS ('texImage3D')
  // void _texImage3D_6(target, level, internalformat, width, height, depth, border, format, type, ImageBitmap bitmap);
  // //JS ('texImage3D')
  // void _texImage3D_7(target, level, internalformat, width, height, depth, border, format, type, TypedData? pixels);
  // //JS ('texImage3D')
  // void _texImage3D_8(
  //     target, level, internalformat, width, height, depth, border, format, type, TypedData pixels, srcOffset);

  // void texStorage2D(int target, int levels, int internalformat, int width, int height);

  // void texStorage3D(int target, int levels, int internalformat, int width, int height, int depth);

  // void texSubImage2D2(int target, int level, int xoffset, int yoffset, int width, int height, int format, int type,
  //     bitmap_OR_canvas_OR_data_OR_image_OR_offset_OR_srcData_OR_video,
  //     [int? srcOffset]) {
  //   if ((bitmap_OR_canvas_OR_data_OR_image_OR_offset_OR_srcData_OR_video is int) && srcOffset == null) {
  //     _texSubImage2D2_1(target, level, xoffset, yoffset, width, height, format, type,
  //         bitmap_OR_canvas_OR_data_OR_image_OR_offset_OR_srcData_OR_video);
  //     return;
  //   }
  //   if ((bitmap_OR_canvas_OR_data_OR_image_OR_offset_OR_srcData_OR_video is ImageData) && srcOffset == null) {
  //     var data_1 = convertDartToNative_ImageData(bitmap_OR_canvas_OR_data_OR_image_OR_offset_OR_srcData_OR_video);
  //     _texSubImage2D2_2(target, level, xoffset, yoffset, width, height, format, type, data_1);
  //     return;
  //   }
  //   if ((bitmap_OR_canvas_OR_data_OR_image_OR_offset_OR_srcData_OR_video is ImageElement) && srcOffset == null) {
  //     _texSubImage2D2_3(target, level, xoffset, yoffset, width, height, format, type,
  //         bitmap_OR_canvas_OR_data_OR_image_OR_offset_OR_srcData_OR_video);
  //     return;
  //   }
  //   if ((bitmap_OR_canvas_OR_data_OR_image_OR_offset_OR_srcData_OR_video is CanvasElement) && srcOffset == null) {
  //     _texSubImage2D2_4(target, level, xoffset, yoffset, width, height, format, type,
  //         bitmap_OR_canvas_OR_data_OR_image_OR_offset_OR_srcData_OR_video);
  //     return;
  //   }
  //   if ((bitmap_OR_canvas_OR_data_OR_image_OR_offset_OR_srcData_OR_video is VideoElement) && srcOffset == null) {
  //     _texSubImage2D2_5(target, level, xoffset, yoffset, width, height, format, type,
  //         bitmap_OR_canvas_OR_data_OR_image_OR_offset_OR_srcData_OR_video);
  //     return;
  //   }
  //   if ((bitmap_OR_canvas_OR_data_OR_image_OR_offset_OR_srcData_OR_video is ImageBitmap) && srcOffset == null) {
  //     _texSubImage2D2_6(target, level, xoffset, yoffset, width, height, format, type,
  //         bitmap_OR_canvas_OR_data_OR_image_OR_offset_OR_srcData_OR_video);
  //     return;
  //   }
  //   if (srcOffset != null && (bitmap_OR_canvas_OR_data_OR_image_OR_offset_OR_srcData_OR_video is TypedData)) {
  //     _texSubImage2D2_7(target, level, xoffset, yoffset, width, height, format, type,
  //         bitmap_OR_canvas_OR_data_OR_image_OR_offset_OR_srcData_OR_video, srcOffset);
  //     return;
  //   }
  //   throw new ArgumentError("Incorrect number or type of arguments");
  // }

  // //JS ('texSubImage2D')
  // void _texSubImage2D2_1(target, level, xoffset, yoffset, width, height, format, type, int offset);
  // //JS ('texSubImage2D')
  // void _texSubImage2D2_2(target, level, xoffset, yoffset, width, height, format, type, data);
  // //JS ('texSubImage2D')
  // void _texSubImage2D2_3(target, level, xoffset, yoffset, width, height, format, type, ImageElement image);
  // //JS ('texSubImage2D')
  // void _texSubImage2D2_4(target, level, xoffset, yoffset, width, height, format, type, CanvasElement canvas);
  // //JS ('texSubImage2D')
  // void _texSubImage2D2_5(target, level, xoffset, yoffset, width, height, format, type, VideoElement video);
  // //JS ('texSubImage2D')
  // void _texSubImage2D2_6(target, level, xoffset, yoffset, width, height, format, type, ImageBitmap bitmap);
  // //JS ('texSubImage2D')
  // void _texSubImage2D2_7(target, level, xoffset, yoffset, width, height, format, type, TypedData srcData, srcOffset);

  // void texSubImage3D(int target, int level, int xoffset, int yoffset, int zoffset, int width, int height, int depth,
  //     int format, int type, bitmap_OR_canvas_OR_data_OR_image_OR_offset_OR_pixels_OR_video,
  //     [int? srcOffset]) {
  //   if ((bitmap_OR_canvas_OR_data_OR_image_OR_offset_OR_pixels_OR_video is int) && srcOffset == null) {
  //     _texSubImage3D_1(target, level, xoffset, yoffset, zoffset, width, height, depth, format, type,
  //         bitmap_OR_canvas_OR_data_OR_image_OR_offset_OR_pixels_OR_video);
  //     return;
  //   }
  //   if ((bitmap_OR_canvas_OR_data_OR_image_OR_offset_OR_pixels_OR_video is ImageData) && srcOffset == null) {
  //     var data_1 = convertDartToNative_ImageData(bitmap_OR_canvas_OR_data_OR_image_OR_offset_OR_pixels_OR_video);
  //     _texSubImage3D_2(target, level, xoffset, yoffset, zoffset, width, height, depth, format, type, data_1);
  //     return;
  //   }
  //   if ((bitmap_OR_canvas_OR_data_OR_image_OR_offset_OR_pixels_OR_video is ImageElement) && srcOffset == null) {
  //     _texSubImage3D_3(target, level, xoffset, yoffset, zoffset, width, height, depth, format, type,
  //         bitmap_OR_canvas_OR_data_OR_image_OR_offset_OR_pixels_OR_video);
  //     return;
  //   }
  //   if ((bitmap_OR_canvas_OR_data_OR_image_OR_offset_OR_pixels_OR_video is CanvasElement) && srcOffset == null) {
  //     _texSubImage3D_4(target, level, xoffset, yoffset, zoffset, width, height, depth, format, type,
  //         bitmap_OR_canvas_OR_data_OR_image_OR_offset_OR_pixels_OR_video);
  //     return;
  //   }
  //   if ((bitmap_OR_canvas_OR_data_OR_image_OR_offset_OR_pixels_OR_video is VideoElement) && srcOffset == null) {
  //     _texSubImage3D_5(target, level, xoffset, yoffset, zoffset, width, height, depth, format, type,
  //         bitmap_OR_canvas_OR_data_OR_image_OR_offset_OR_pixels_OR_video);
  //     return;
  //   }
  //   if ((bitmap_OR_canvas_OR_data_OR_image_OR_offset_OR_pixels_OR_video is ImageBitmap) && srcOffset == null) {
  //     _texSubImage3D_6(target, level, xoffset, yoffset, zoffset, width, height, depth, format, type,
  //         bitmap_OR_canvas_OR_data_OR_image_OR_offset_OR_pixels_OR_video);
  //     return;
  //   }
  //   if ((bitmap_OR_canvas_OR_data_OR_image_OR_offset_OR_pixels_OR_video is TypedData) && srcOffset == null) {
  //     _texSubImage3D_7(target, level, xoffset, yoffset, zoffset, width, height, depth, format, type,
  //         bitmap_OR_canvas_OR_data_OR_image_OR_offset_OR_pixels_OR_video);
  //     return;
  //   }
  //   if (srcOffset != null && (bitmap_OR_canvas_OR_data_OR_image_OR_offset_OR_pixels_OR_video is TypedData)) {
  //     _texSubImage3D_8(target, level, xoffset, yoffset, zoffset, width, height, depth, format, type,
  //         bitmap_OR_canvas_OR_data_OR_image_OR_offset_OR_pixels_OR_video, srcOffset);
  //     return;
  //   }
  //   throw new ArgumentError("Incorrect number or type of arguments");
  // }

  // //JS ('texSubImage3D')
  // void _texSubImage3D_1(target, level, xoffset, yoffset, zoffset, width, height, depth, format, type, int offset);
  // //JS ('texSubImage3D')
  // void _texSubImage3D_2(target, level, xoffset, yoffset, zoffset, width, height, depth, format, type, data);
  // //JS ('texSubImage3D')
  // void _texSubImage3D_3(
  //     target, level, xoffset, yoffset, zoffset, width, height, depth, format, type, ImageElement image);
  // //JS ('texSubImage3D')
  // void _texSubImage3D_4(
  //     target, level, xoffset, yoffset, zoffset, width, height, depth, format, type, CanvasElement canvas);
  // //JS ('texSubImage3D')
  // void _texSubImage3D_5(
  //     target, level, xoffset, yoffset, zoffset, width, height, depth, format, type, VideoElement video);
  // //JS ('texSubImage3D')
  // void _texSubImage3D_6(
  //     target, level, xoffset, yoffset, zoffset, width, height, depth, format, type, ImageBitmap bitmap);
  // //JS ('texSubImage3D')
  // void _texSubImage3D_7(target, level, xoffset, yoffset, zoffset, width, height, depth, format, type, TypedData pixels);
  // //JS ('texSubImage3D')
  // void _texSubImage3D_8(
  //     target, level, xoffset, yoffset, zoffset, width, height, depth, format, type, TypedData pixels, srcOffset);

  // void transformFeedbackVaryings(Program program, List<String> varyings, int bufferMode) {
  //   List varyings_1 = convertDartToNative_StringArray(varyings);
  //   _transformFeedbackVaryings_1(program, varyings_1, bufferMode);
  //   return;
  // }

  // //JS ('transformFeedbackVaryings')
  // void _transformFeedbackVaryings_1(Program program, List varyings, bufferMode);

  // //JS ('uniform1fv')
  // void uniform1fv2(UniformLocation? location, v, int srcOffset, [int? srcLength]);

  // //JS ('uniform1iv')
  // void uniform1iv2(UniformLocation? location, v, int srcOffset, [int? srcLength]);

  // void uniform1ui(UniformLocation? location, int v0);

  // void uniform1uiv(UniformLocation? location, v, [int? srcOffset, int? srcLength]);

  // //JS ('uniform2fv')
  // void uniform2fv2(UniformLocation? location, v, int srcOffset, [int? srcLength]);

  // //JS ('uniform2iv')
  // void uniform2iv2(UniformLocation? location, v, int srcOffset, [int? srcLength]);

  // void uniform2ui(UniformLocation? location, int v0, int v1);

  // void uniform2uiv(UniformLocation? location, v, [int? srcOffset, int? srcLength]);

  // //JS ('uniform3fv')
  // void uniform3fv2(UniformLocation? location, v, int srcOffset, [int? srcLength]);

  // //JS ('uniform3iv')
  // void uniform3iv2(UniformLocation? location, v, int srcOffset, [int? srcLength]);

  // void uniform3ui(UniformLocation? location, int v0, int v1, int v2);

  // void uniform3uiv(UniformLocation? location, v, [int? srcOffset, int? srcLength]);

  // //JS ('uniform4fv')
  // void uniform4fv2(UniformLocation? location, v, int srcOffset, [int? srcLength]);

  // //JS ('uniform4iv')
  // void uniform4iv2(UniformLocation? location, v, int srcOffset, [int? srcLength]);

  // void uniform4ui(UniformLocation? location, int v0, int v1, int v2, int v3);

  // void uniform4uiv(UniformLocation? location, v, [int? srcOffset, int? srcLength]);

  // void uniformBlockBinding(Program program, int uniformBlockIndex, int uniformBlockBinding);

  // //JS ('uniformMatrix2fv')
  // void uniformMatrix2fv2(UniformLocation? location, bool transpose, array, int srcOffset, [int? srcLength]);

  // void uniformMatrix2x3fv(UniformLocation? location, bool transpose, value, [int? srcOffset, int? srcLength]);

  // void uniformMatrix2x4fv(UniformLocation? location, bool transpose, value, [int? srcOffset, int? srcLength]);

  // //JS ('uniformMatrix3fv')
  // void uniformMatrix3fv2(UniformLocation? location, bool transpose, array, int srcOffset, [int? srcLength]);

  // void uniformMatrix3x2fv(UniformLocation? location, bool transpose, value, [int? srcOffset, int? srcLength]);

  // void uniformMatrix3x4fv(UniformLocation? location, bool transpose, value, [int? srcOffset, int? srcLength]);

  // //JS ('uniformMatrix4fv')
  // void uniformMatrix4fv2(UniformLocation? location, bool transpose, array, int srcOffset, [int? srcLength]);

  // void uniformMatrix4x2fv(UniformLocation? location, bool transpose, value, [int? srcOffset, int? srcLength]);

  // void uniformMatrix4x3fv(UniformLocation? location, bool transpose, value, [int? srcOffset, int? srcLength]);

  // void vertexAttribDivisor(int index, int divisor);

  // void vertexAttribI4i(int index, int x, int y, int z, int w);

  // void vertexAttribI4iv(int index, v);

  // void vertexAttribI4ui(int index, int x, int y, int z, int w);

  // void vertexAttribI4uiv(int index, v);

  // void vertexAttribIPointer(int index, int size, int type, int stride, int offset);

  // void waitSync(Sync sync, int flags, int timeout);

  // // From WebGLRenderingContextBase

  // int? get drawingBufferHeight;

  // int? get drawingBufferWidth;

  void activeTexture(int texture) {
    gl.glActiveTexture(texture);
    checkError('activeTexture');
  }

  void attachShader(Program program, Shader shader) {
    gl.glAttachShader(program.programID, shader.shaderId);
    checkError('attachShader');
  }

  // void bindAttribLocation(Program program, int index, String name);

  void bindBuffer(int target, Buffer buffer) {
    gl.glBindBuffer(target, buffer.bufferId);
    checkError('bindBuffer');
  }

  // void bindFramebuffer(int target, Framebuffer? framebuffer);

  // void bindRenderbuffer(int target, Renderbuffer? renderbuffer);

  void bindTexture(int target, WebGLTexture? texture) {
    gl.glBindTexture(target, texture?.textureId ?? 0);
    checkError('bindTexture');
  }

  // void blendColor(num red, num green, num blue, num alpha);

  // void blendEquation(int mode);

  // void blendEquationSeparate(int modeRGB, int modeAlpha);

  // void blendFunc(int sfactor, int dfactor);

  // void blendFuncSeparate(int srcRGB, int dstRGB, int srcAlpha, int dstAlpha);

  /// Be careful which type of integer you really pass here. Unfortunately an UInt16List
  /// is viewed by the Dart type system just as List<int>, so we jave to specify the native type
  /// here in [nativeType]
  void bufferData<T extends Object>(int target, T data, int usage) {
    late Pointer<Void> nativeData;
    late int size;
    if (data is List<double> || data is Float32List) {
      nativeData = floatListToArrayPointer(data as List<double>).cast();
      size = data.length * sizeOf<Float>();
    } else if (data is Int32List) {
      nativeData = int32ListToArrayPointer(data).cast();
      size = data.length * sizeOf<Int32>();
    } else if (data is Uint16List) {
      nativeData = uInt16ListToArrayPointer(data).cast();
      size = data.length * sizeOf<Uint16>();
    } else {
      throw (OpenGLException('bufferData: unsupported native type $T', -1));
    }
    gl.glBufferData(target, size, nativeData, usage);
    free(nativeData);
    checkError('bufferData');
  }

  Pointer<Float> floatListToArrayPointer(List<double> list) {
    final ptr = allocate<Float>(count: list.length);
    for (var i = 0; i < list.length; i++) {
      ptr.elementAt(i).value = list[i];
    }
    return ptr;
  }

  Pointer<Int32> int32ListToArrayPointer(List<int> list) {
    final ptr = allocate<Int32>(count: list.length);
    for (var i = 0; i < list.length; i++) {
      ptr.elementAt(i).value = list[i];
    }
    return ptr;
  }

  Pointer<Uint16> uInt16ListToArrayPointer(List<int> list) {
    final ptr = allocate<Uint16>(count: list.length);
    for (var i = 0; i < list.length; i++) {
      ptr.elementAt(i).value = list[i];
    }
    return ptr;
  }
  // void bufferSubData(int target, int offset, data);

  // int checkFramebufferStatus(int target);

  void clear(int mask) => gl.glClear(mask);

  void clearColor(double red, double green, double blue, double alpha) {
    gl.glClearColor(red, green, blue, alpha);
    checkError('clearColor');
  }

  // void clearDepth(num depth);

  // void clearStencil(int s);

  // void colorMask(bool red, bool green, bool blue, bool alpha);

  // Future commit() => promiseToFuture(JS("", "#.commit()", this));

  void compileShader(Shader shader, [bool checkForErrors = true]) {
    gl.glCompileShader(shader.shaderId);

    if (checkForErrors) {
      final compiled = tempInt32s[0];
      gl.glGetShaderiv(shader.shaderId, GL_COMPILE_STATUS, compiled);
      if (compiled.value == 0) {
        final infoLen = tempInt32s[1];

        gl.glGetShaderiv(shader.shaderId, GL_INFO_LOG_LENGTH, infoLen);

        String message = '';
        if (infoLen.value > 1) {
          final infoLog = allocate<Int8>(count: infoLen.value);

          gl.glGetShaderInfoLog(shader.shaderId, infoLen.value, nullptr, infoLog);
          message = "\nError compiling shader:\n${Utf8.fromUtf8(infoLog.cast())}";

          free(infoLog);
        }
        throw OpenGLException(message, 0);
      }
    }
  }

  // void compressedTexImage2D(
  //     int target, int level, int internalformat, int width, int height, int border, TypedData data);

  // void compressedTexSubImage2D(
  //     int target, int level, int xoffset, int yoffset, int width, int height, int format, TypedData data);

  // void copyTexImage2D(int target, int level, int internalformat, int x, int y, int width, int height, int border);

  // void copyTexSubImage2D(int target, int level, int xoffset, int yoffset, int x, int y, int width, int height);

  Buffer createBuffer() {
    Pointer<Uint32> bufferId = tempUint32s[0];
    gl.glGenBuffers(1, bufferId);
    checkError('createBuffer');
    return Buffer._create(bufferId.value);
  }

  // Framebuffer createFramebuffer();

  Program createProgram() {
    final program = Program._create(gl.glCreateProgram());
    checkError('createProgram');
    return program;
  }

  // Renderbuffer createRenderbuffer();

  Shader createShader(int type) {
    final shader = Shader._create(gl.glCreateShader(type));
    checkError('createShader');
    return shader;
  }

  WebGLTexture createTexture() {
    Pointer<Uint32> textureId = tempUint32s[0];
    gl.glGenTextures(1, textureId);
    checkError('createBuffer');
    return WebGLTexture._create(textureId.value);
  }

  // void cullFace(int mode);

  // void deleteBuffer(Buffer? buffer);

  // void deleteFramebuffer(Framebuffer? framebuffer);

  // void deleteProgram(Program? program);

  // void deleteRenderbuffer(Renderbuffer? renderbuffer);

  // void deleteShader(Shader? shader);

  // void deleteTexture(WebGLTexture? texture);

  // void depthFunc(int func);

  // void depthMask(bool flag);

  // void depthRange(num zNear, num zFar);

  // void detachShader(Program program, Shader shader);

  void disable(int cap) {
    gl.glDisable(cap);
    checkError('disable');
  }

  // void disableVertexAttribArray(int index);

  void drawArrays(int mode, int first, int count) {
    gl.glDrawArrays(mode, first, count);
    checkError('drawArrays');
  }

  void drawElements(int mode, int count, int type, int offset) {
    var offSetPointer = Pointer<Void>.fromAddress(offset);
    gl.glDrawElements(mode, count, type, offSetPointer.cast());
    checkError('drawElements');
    free(offSetPointer);
  }

  void enable(int cap) {
    gl.glEnable(cap);
    checkError('enable');
  }

  void enableVertexAttribArray(int index) {
    gl.glEnableVertexAttribArray(index);
    checkError('enableVertexAttribArray');
  }

  // void finish();

  // void flush();

  // void framebufferRenderbuffer(int target, int attachment, int renderbuffertarget, Renderbuffer? renderbuffer);

  // void framebufferTexture2D(int target, int attachment, int textarget, WebGLTexture? texture, int level);

  // void frontFace(int mode);

  void generateMipmap(int target) {
    gl.glGenerateMipmap(target);
    checkError('generateMipmap');
  }

  // ActiveInfo getActiveAttrib(Program program, int index);

  // ActiveInfo getActiveUniform(Program program, int index);

  // List<Shader>? getAttachedShaders(Program program);

  int getAttribLocation(Program program, String name) {
    final locationName = Utf8.toUtf8(name);
    final location = gl.glGetAttribLocation(program.programID, locationName.cast());
    checkError('getAttribLocation');
    free(locationName);
    return location;
  }
  // Object? getBufferParameter(int target, int pname);

  // Map? getContextAttributes() {
  //   return convertNativeToDart_Dictionary(_getContextAttributes_1());
  // }

  // //JS ('getContextAttributes')
  // _getContextAttributes_1();

  // int getError();

  // Object? getExtension(String name);

  // Object? getFramebufferAttachmentParameter(int target, int attachment, int pname);

  // Object? getParameter(int pname);

  // String? getProgramInfoLog(Program program);

  int getProgramParameter(Program program, int pname) {
    final status = tempInt32s[0];
    gl.glGetProgramiv(program.programID, pname, status);
    checkError('getProgramParameter');
    return status.value;
  }

  // Object? getRenderbufferParameter(int target, int pname);

  // String? getShaderInfoLog(Shader shader);

  // Object? getShaderParameter(Shader shader, int pname);

  // ShaderPrecisionFormat getShaderPrecisionFormat(int shadertype, int precisiontype);

  // String? getShaderSource(Shader shader);

  // List<String>? getSupportedExtensions();

  // Object? getTexParameter(int target, int pname);

  // Object? getUniform(Program program, UniformLocation location);

  UniformLocation getUniformLocation(Program program, String name) {
    final locationName = Utf8.toUtf8(name);
    final location = gl.glGetUniformLocation(program.programID, locationName.cast());
    checkError('getProgramParameter');
    free(locationName);
    return UniformLocation._create(location);
  }

  // Object? getVertexAttrib(int index, int pname);

  // int getVertexAttribOffset(int index, int pname);

  // void hint(int target, int mode);

  // bool isBuffer(Buffer? buffer);

  // bool isContextLost();

  // bool isEnabled(int cap);

  // bool isFramebuffer(Framebuffer? framebuffer);

  // bool isProgram(Program? program);

  // bool isRenderbuffer(Renderbuffer? renderbuffer);

  // bool isShader(Shader? shader);

  // bool isTexture(WebGLTexture? texture);

  // void lineWidth(num width);

  void linkProgram(Program program, [bool checkForErrors = true]) {
    gl.glLinkProgram(program.programID);
    if (checkForErrors) {
      final linked = tempInt32s[0];
      gl.glGetProgramiv(program.programID, GL_LINK_STATUS, linked);
      if (linked.value == 0) {
        final infoLen = tempInt32s[1];

        gl.glGetProgramiv(program.programID, GL_INFO_LOG_LENGTH, infoLen);

        String message = '';
        if (infoLen.value > 1) {
          final infoLog = allocate<Int8>(count: infoLen.value);

          gl.glGetProgramInfoLog(program.programID, infoLen.value, nullptr, infoLog);
          message = "\nError linking program:\n${Utf8.fromUtf8(infoLog.cast())}";

          free(infoLog);
        }
        throw OpenGLException(message, 0);
      }
    }
  }

  void pixelStorei(int pname, int param) {
    gl.glPixelStorei(pname, param);
    checkError('pixelStorei');
  }

  // void polygonOffset(num factor, num units);

  // //JS ('readPixels')
  // void _readPixels(int x, int y, int width, int height, int format, int type, TypedData? pixels);

  // void renderbufferStorage(int target, int internalformat, int width, int height);

  // void sampleCoverage(num value, bool invert);

  // void scissor(int x, int y, int width, int height);

  void shaderSource(Shader shader, String shaderSource) {
    var sourceString = Utf8.toUtf8(shaderSource);
    var arrayPointer = allocate<Pointer<Int8>>();
    arrayPointer.value = Pointer.fromAddress(sourceString.address);
    gl.glShaderSource(shader.shaderId, 1, arrayPointer, nullptr);
    free(arrayPointer);
    free(sourceString);
    checkError('shaderSource');
  }

  // void stencilFunc(int func, int ref, int mask);

  // void stencilFuncSeparate(int face, int func, int ref, int mask);

  // void stencilMask(int mask);

  // void stencilMaskSeparate(int face, int mask);

  // void stencilOp(int fail, int zfail, int zpass);

  // void stencilOpSeparate(int face, int fail, int zfail, int zpass);

  // //JS ('texImage2D')
  /// passing null for pixels is perfectly fine, in that case an empty Texture is allocated
  void texImage2D(target, level, internalformat, width, height, int border, format, type, TypedData? pixels) {
    /// TODO this can probably optimized depending on if the length can be devided by 4 or 2
    Pointer<Int8>? nativeBuffer;
    if (pixels != null) {
      nativeBuffer = allocate<Int8>(count: pixels.lengthInBytes);
      final dartData = pixels.buffer.asUint8List();
      for (int i = 0; i < dartData.lengthInBytes; i++) {
        nativeBuffer.elementAt(i).value = dartData[i];
      }
    }
    gl.glTexImage2D(target, level, internalformat, width, height, border, format, type,
        nativeBuffer != null ? nativeBuffer.cast() : nullptr);

    if (nativeBuffer != null) {
      free(nativeBuffer);
    }
    checkError('texImage2D');
  }

  Future<void> texImage2DfromImage(
    target,
    Image image, {
    level = 0,
    internalformat = WebGL.RGBA,
    format = WebGL.RGBA,
    type = WebGL.UNSIGNED_BYTE,
  }) async {
    texImage2D(target, level, internalformat, image.width, image.height, 0, format, type, (await image.toByteData())!);
  }

  Future<void> texImage2DfromAsset(
    target,
    String assetPath, {
    level = 0,
    internalformat = WebGL.RGBA32UI,
    format = WebGL.RGBA,
    type = WebGL.UNSIGNED_INT,
  }) async {
    final image = await loadImageFromAsset(assetPath);
    texImage2D(target, level, internalformat, image.width, image.height, 0, format, type, (await image.toByteData())!);
  }

  Future<Image> loadImageFromAsset(String assetPath) async {
    final bytes = await rootBundle.load(assetPath);
    final loadingCompleter = Completer<Image>();
    decodeImageFromList(bytes.buffer.asUint8List(), (image) {
      loadingCompleter.complete(image);
    });
    return loadingCompleter.future;
  }

  void texParameterf(int target, int pname, double param) {
    gl.glTexParameterf(target, pname, param);
    checkError('texParameterf');
  }

  void texParameteri(int target, int pname, int param) {
    gl.glTexParameteri(target, pname, param);
    checkError('texParameteri');
  }

  // void texSubImage2D(int target, int level, int xoffset, int yoffset, int format_OR_width, int height_OR_type,
  //     bitmap_OR_canvas_OR_format_OR_image_OR_pixels_OR_video,
  //     [int? type, TypedData? pixels]) {
  //   if (type != null && (bitmap_OR_canvas_OR_format_OR_image_OR_pixels_OR_video is int)) {
  //     _texSubImage2D_1(target, level, xoffset, yoffset, format_OR_width, height_OR_type,
  //         bitmap_OR_canvas_OR_format_OR_image_OR_pixels_OR_video, type, pixels);
  //     return;
  //   }
  //   if ((bitmap_OR_canvas_OR_format_OR_image_OR_pixels_OR_video is ImageData) && type == null && pixels == null) {
  //     var pixels_1 = convertDartToNative_ImageData(bitmap_OR_canvas_OR_format_OR_image_OR_pixels_OR_video);
  //     _texSubImage2D_2(target, level, xoffset, yoffset, format_OR_width, height_OR_type, pixels_1);
  //     return;
  //   }
  //   if ((bitmap_OR_canvas_OR_format_OR_image_OR_pixels_OR_video is ImageElement) && type == null && pixels == null) {
  //     _texSubImage2D_3(target, level, xoffset, yoffset, format_OR_width, height_OR_type,
  //         bitmap_OR_canvas_OR_format_OR_image_OR_pixels_OR_video);
  //     return;
  //   }
  //   if ((bitmap_OR_canvas_OR_format_OR_image_OR_pixels_OR_video is CanvasElement) && type == null && pixels == null) {
  //     _texSubImage2D_4(target, level, xoffset, yoffset, format_OR_width, height_OR_type,
  //         bitmap_OR_canvas_OR_format_OR_image_OR_pixels_OR_video);
  //     return;
  //   }
  //   if ((bitmap_OR_canvas_OR_format_OR_image_OR_pixels_OR_video is VideoElement) && type == null && pixels == null) {
  //     _texSubImage2D_5(target, level, xoffset, yoffset, format_OR_width, height_OR_type,
  //         bitmap_OR_canvas_OR_format_OR_image_OR_pixels_OR_video);
  //     return;
  //   }
  //   if ((bitmap_OR_canvas_OR_format_OR_image_OR_pixels_OR_video is ImageBitmap) && type == null && pixels == null) {
  //     _texSubImage2D_6(target, level, xoffset, yoffset, format_OR_width, height_OR_type,
  //         bitmap_OR_canvas_OR_format_OR_image_OR_pixels_OR_video);
  //     return;
  //   }
  //   throw new ArgumentError("Incorrect number or type of arguments");
  // }

  // //JS ('texSubImage2D')
  // void _texSubImage2D_1(target, level, xoffset, yoffset, width, height, int format, type, TypedData? pixels);
  // //JS ('texSubImage2D')
  // void _texSubImage2D_2(target, level, xoffset, yoffset, format, type, pixels);
  // //JS ('texSubImage2D')
  // void _texSubImage2D_3(target, level, xoffset, yoffset, format, type, ImageElement image);
  // //JS ('texSubImage2D')
  // void _texSubImage2D_4(target, level, xoffset, yoffset, format, type, CanvasElement canvas);
  // //JS ('texSubImage2D')
  // void _texSubImage2D_5(target, level, xoffset, yoffset, format, type, VideoElement video);
  // //JS ('texSubImage2D')
  // void _texSubImage2D_6(target, level, xoffset, yoffset, format, type, ImageBitmap bitmap);

  // void uniform1f(UniformLocation? location, num x);

  // void uniform1fv(UniformLocation? location, v);

  void uniform1i(UniformLocation location, int x) {
    gl.glUniform1i(location.locationId, x);
    checkError('uniform1i');
  }

  // void uniform1iv(UniformLocation? location, v);

  // void uniform2f(UniformLocation? location, num x, num y);

  // void uniform2fv(UniformLocation? location, v);

  // void uniform2i(UniformLocation? location, int x, int y);

  // void uniform2iv(UniformLocation? location, v);

  void uniform3f(UniformLocation location, double x, double y, double z) {
    gl.glUniform3f(location.locationId, x, y, z);
    checkError('uniform3f');
  }

  void uniform3fv(UniformLocation location, List<double> vectors) {
    var arrayPointer = floatListToArrayPointer(vectors);
    gl.glUniform3fv(location.locationId, vectors.length ~/ 3, arrayPointer);
    checkError('uniform3fv');
    free(arrayPointer);
  }

  // void uniform3i(UniformLocation? location, int x, int y, int z);

  // void uniform3iv(UniformLocation? location, v);

  // void uniform4f(UniformLocation? location, num x, num y, num z, num w);

  // void uniform4fv(UniformLocation? location, v);

  // void uniform4i(UniformLocation? location, int x, int y, int z, int w);

  // void uniform4iv(UniformLocation? location, v);

  // void uniformMatrix2fv(UniformLocation? location, bool transpose, array);

  void uniformMatrix3fv(UniformLocation location, bool transpose, List<double> values) {
    var arrayPointer = floatListToArrayPointer(values);
    gl.glUniformMatrix3fv(location.locationId, values.length ~/ 9, transpose ? 1 : 0, arrayPointer);
    checkError('uniformMatrix4fv');
    free(arrayPointer);
  }

  /// be careful, data always has a length that is a multiple of 16
  void uniformMatrix4fv(UniformLocation location, bool transpose, List<double> values) {
    var arrayPointer = floatListToArrayPointer(values);
    gl.glUniformMatrix4fv(location.locationId, values.length ~/ 16, transpose ? 1 : 0, arrayPointer);
    checkError('uniformMatrix4fv');
    free(arrayPointer);
  }

  void useProgram(Program program) {
    gl.glUseProgram(program.programID);
    checkError('useProgram');
  }

  // void validateProgram(Program program);

  // void vertexAttrib1f(int indx, num x);

  // void vertexAttrib1fv(int indx, values);

  // void vertexAttrib2f(int indx, num x, num y);

  // void vertexAttrib2fv(int indx, values);

  // void vertexAttrib3f(int indx, num x, num y, num z);

  // void vertexAttrib3fv(int indx, values);

  // void vertexAttrib4f(int indx, num x, num y, num z, num w);

  // void vertexAttrib4fv(int indx, values);

  void vertexAttribPointer(int index, int size, int type, bool normalized, int stride, int offset) {
    var offsetPointer = Pointer<Void>.fromAddress(offset);
    gl.glVertexAttribPointer(index, size, type, normalized ? 1 : 0, stride, offsetPointer.cast());
    checkError('vertexAttribPointer');
    free(offsetPointer);
  }

  void viewport(int x, int y, int width, int height) {
    gl.glViewport(x, y, width, height);
    checkError('viewPort');
  }

  // void readPixels(int x, int y, int width, int height, int format, int type, TypedData pixels) {
  //   _readPixels(x, y, width, height, format, type, pixels);
  // }
}

// // JS "WebGLSampler")
// class Sampler extends Interceptor {
//   // To suppress missing implicit constructor warnings.
//   factory Sampler._() {
//     throw new UnsupportedError("Not supported");
//   }
// }

// JS "WebGLShader")
class Shader {
  final int shaderId;
  Shader._create(this.shaderId);
}

// // JS "WebGLShaderPrecisionFormat")
// class ShaderPrecisionFormat extends Interceptor {
//   // To suppress missing implicit constructor warnings.
//   factory ShaderPrecisionFormat._() {
//     throw new UnsupportedError("Not supported");
//   }

//   int get precision;

//   int get rangeMax;

//   int get rangeMin;
// }

// // JS "WebGLSync")
// class Sync extends Interceptor {
//   // To suppress missing implicit constructor warnings.
//   factory Sync._() {
//     throw new UnsupportedError("Not supported");
//   }
// }

/// JS "WebGLTexture") We have to stay with the Original Name to avoid name clashing
/// with the Flutter WebGLTexture widget
class WebGLTexture {
  // To suppress missing implicit constructor warnings.
  final int textureId;
  WebGLTexture._create(this.textureId);

  /// These function were defined in the Dart version of the WebGL interface
  /// What is strange is that they are not defined in the WebGL standard
  // bool? get lastUploadedVideoFrameWasSkipped;

  // int? get lastUploadedVideoHeight;

  // num? get lastUploadedVideoTimestamp;

  // int? get lastUploadedVideoWidth;
}

// // JS "WebGLTimerQueryEXT")
// class TimerQueryExt extends Interceptor {
//   // To suppress missing implicit constructor warnings.
//   factory TimerQueryExt._() {
//     throw new UnsupportedError("Not supported");
//   }
// }

// // JS "WebGLTransformFeedback")
// class TransformFeedback extends Interceptor {
//   // To suppress missing implicit constructor warnings.
//   factory TransformFeedback._() {
//     throw new UnsupportedError("Not supported");
//   }
// }

// JS "WebGLUniformLocation")
class UniformLocation {
  final int locationId;
  UniformLocation._create(this.locationId);
}

// // JS "WebGLVertexArrayObject")
// class VertexArrayObject extends Interceptor {
//   // To suppress missing implicit constructor warnings.
//   factory VertexArrayObject._() {
//     throw new UnsupportedError("Not supported");
//   }
// }

// // JS "WebGLVertexArrayObjectOES")
// class VertexArrayObjectOes extends Interceptor {
//   // To suppress missing implicit constructor warnings.
//   factory VertexArrayObjectOes._() {
//     throw new UnsupportedError("Not supported");
//   }
// }
// // Copyright (c) 2018, the Dart project authors.  Please see the AUTHORS file
// // for details. All rights reserved. Use of this source code is governed by a
// // BSD-style license that can be found in the LICENSE file.

/// Amalgamation of the WebGL constants from the IDL interfaces in
/// WebGLRenderingContextBase, WebGL2RenderingContextBase, & WebGLDrawBuffers.
/// Because the RenderingContextBase interfaces are hidden they would be
/// replicated in more than one class (e.g., RenderingContext and
/// RenderingContext2) to prevent that duplication these 600+ constants are
/// defined in one abstract class (WebGL).
// JS "WebGL")
abstract class WebGL {
  // To suppress missing implicit constructor warnings.
  factory WebGL._() {
    throw new UnsupportedError("Not supported");
  }

  static const int ACTIVE_ATTRIBUTES = 0x8B89;

  static const int ACTIVE_TEXTURE = 0x84E0;

  static const int ACTIVE_UNIFORMS = 0x8B86;

  static const int ACTIVE_UNIFORM_BLOCKS = 0x8A36;

  static const int ALIASED_LINE_WIDTH_RANGE = 0x846E;

  static const int ALIASED_POINT_SIZE_RANGE = 0x846D;

  static const int ALPHA = 0x1906;

  static const int ALPHA_BITS = 0x0D55;

  static const int ALREADY_SIGNALED = 0x911A;

  static const int ALWAYS = 0x0207;

  static const int ANY_SAMPLES_PASSED = 0x8C2F;

  static const int ANY_SAMPLES_PASSED_CONSERVATIVE = 0x8D6A;

  static const int ARRAY_BUFFER = 0x8892;

  static const int ARRAY_BUFFER_BINDING = 0x8894;

  static const int ATTACHED_SHADERS = 0x8B85;

  static const int BACK = 0x0405;

  static const int BLEND = 0x0BE2;

  static const int BLEND_COLOR = 0x8005;

  static const int BLEND_DST_ALPHA = 0x80CA;

  static const int BLEND_DST_RGB = 0x80C8;

  static const int BLEND_EQUATION = 0x8009;

  static const int BLEND_EQUATION_ALPHA = 0x883D;

  static const int BLEND_EQUATION_RGB = 0x8009;

  static const int BLEND_SRC_ALPHA = 0x80CB;

  static const int BLEND_SRC_RGB = 0x80C9;

  static const int BLUE_BITS = 0x0D54;

  static const int BOOL = 0x8B56;

  static const int BOOL_VEC2 = 0x8B57;

  static const int BOOL_VEC3 = 0x8B58;

  static const int BOOL_VEC4 = 0x8B59;

  static const int BROWSER_DEFAULT_WEBGL = 0x9244;

  static const int BUFFER_SIZE = 0x8764;

  static const int BUFFER_USAGE = 0x8765;

  static const int BYTE = 0x1400;

  static const int CCW = 0x0901;

  static const int CLAMP_TO_EDGE = 0x812F;

  static const int COLOR = 0x1800;

  static const int COLOR_ATTACHMENT0 = 0x8CE0;

  static const int COLOR_ATTACHMENT0_WEBGL = 0x8CE0;

  static const int COLOR_ATTACHMENT1 = 0x8CE1;

  static const int COLOR_ATTACHMENT10 = 0x8CEA;

  static const int COLOR_ATTACHMENT10_WEBGL = 0x8CEA;

  static const int COLOR_ATTACHMENT11 = 0x8CEB;

  static const int COLOR_ATTACHMENT11_WEBGL = 0x8CEB;

  static const int COLOR_ATTACHMENT12 = 0x8CEC;

  static const int COLOR_ATTACHMENT12_WEBGL = 0x8CEC;

  static const int COLOR_ATTACHMENT13 = 0x8CED;

  static const int COLOR_ATTACHMENT13_WEBGL = 0x8CED;

  static const int COLOR_ATTACHMENT14 = 0x8CEE;

  static const int COLOR_ATTACHMENT14_WEBGL = 0x8CEE;

  static const int COLOR_ATTACHMENT15 = 0x8CEF;

  static const int COLOR_ATTACHMENT15_WEBGL = 0x8CEF;

  static const int COLOR_ATTACHMENT1_WEBGL = 0x8CE1;

  static const int COLOR_ATTACHMENT2 = 0x8CE2;

  static const int COLOR_ATTACHMENT2_WEBGL = 0x8CE2;

  static const int COLOR_ATTACHMENT3 = 0x8CE3;

  static const int COLOR_ATTACHMENT3_WEBGL = 0x8CE3;

  static const int COLOR_ATTACHMENT4 = 0x8CE4;

  static const int COLOR_ATTACHMENT4_WEBGL = 0x8CE4;

  static const int COLOR_ATTACHMENT5 = 0x8CE5;

  static const int COLOR_ATTACHMENT5_WEBGL = 0x8CE5;

  static const int COLOR_ATTACHMENT6 = 0x8CE6;

  static const int COLOR_ATTACHMENT6_WEBGL = 0x8CE6;

  static const int COLOR_ATTACHMENT7 = 0x8CE7;

  static const int COLOR_ATTACHMENT7_WEBGL = 0x8CE7;

  static const int COLOR_ATTACHMENT8 = 0x8CE8;

  static const int COLOR_ATTACHMENT8_WEBGL = 0x8CE8;

  static const int COLOR_ATTACHMENT9 = 0x8CE9;

  static const int COLOR_ATTACHMENT9_WEBGL = 0x8CE9;

  static const int COLOR_BUFFER_BIT = 0x00004000;

  static const int COLOR_CLEAR_VALUE = 0x0C22;

  static const int COLOR_WRITEMASK = 0x0C23;

  static const int COMPARE_REF_TO_TEXTURE = 0x884E;

  static const int COMPILE_STATUS = 0x8B81;

  static const int COMPRESSED_TEXTURE_FORMATS = 0x86A3;

  static const int CONDITION_SATISFIED = 0x911C;

  static const int CONSTANT_ALPHA = 0x8003;

  static const int CONSTANT_COLOR = 0x8001;

  static const int CONTEXT_LOST_WEBGL = 0x9242;

  static const int COPY_READ_BUFFER = 0x8F36;

  static const int COPY_READ_BUFFER_BINDING = 0x8F36;

  static const int COPY_WRITE_BUFFER = 0x8F37;

  static const int COPY_WRITE_BUFFER_BINDING = 0x8F37;

  static const int CULL_FACE = 0x0B44;

  static const int CULL_FACE_MODE = 0x0B45;

  static const int CURRENT_PROGRAM = 0x8B8D;

  static const int CURRENT_QUERY = 0x8865;

  static const int CURRENT_VERTEX_ATTRIB = 0x8626;

  static const int CW = 0x0900;

  static const int DECR = 0x1E03;

  static const int DECR_WRAP = 0x8508;

  static const int DELETE_STATUS = 0x8B80;

  static const int DEPTH = 0x1801;

  static const int DEPTH24_STENCIL8 = 0x88F0;

  static const int DEPTH32F_STENCIL8 = 0x8CAD;

  static const int DEPTH_ATTACHMENT = 0x8D00;

  static const int DEPTH_BITS = 0x0D56;

  static const int DEPTH_BUFFER_BIT = 0x00000100;

  static const int DEPTH_CLEAR_VALUE = 0x0B73;

  static const int DEPTH_COMPONENT = 0x1902;

  static const int DEPTH_COMPONENT16 = 0x81A5;

  static const int DEPTH_COMPONENT24 = 0x81A6;

  static const int DEPTH_COMPONENT32F = 0x8CAC;

  static const int DEPTH_FUNC = 0x0B74;

  static const int DEPTH_RANGE = 0x0B70;

  static const int DEPTH_STENCIL = 0x84F9;

  static const int DEPTH_STENCIL_ATTACHMENT = 0x821A;

  static const int DEPTH_TEST = 0x0B71;

  static const int DEPTH_WRITEMASK = 0x0B72;

  static const int DITHER = 0x0BD0;

  static const int DONT_CARE = 0x1100;

  static const int DRAW_BUFFER0 = 0x8825;

  static const int DRAW_BUFFER0_WEBGL = 0x8825;

  static const int DRAW_BUFFER1 = 0x8826;

  static const int DRAW_BUFFER10 = 0x882F;

  static const int DRAW_BUFFER10_WEBGL = 0x882F;

  static const int DRAW_BUFFER11 = 0x8830;

  static const int DRAW_BUFFER11_WEBGL = 0x8830;

  static const int DRAW_BUFFER12 = 0x8831;

  static const int DRAW_BUFFER12_WEBGL = 0x8831;

  static const int DRAW_BUFFER13 = 0x8832;

  static const int DRAW_BUFFER13_WEBGL = 0x8832;

  static const int DRAW_BUFFER14 = 0x8833;

  static const int DRAW_BUFFER14_WEBGL = 0x8833;

  static const int DRAW_BUFFER15 = 0x8834;

  static const int DRAW_BUFFER15_WEBGL = 0x8834;

  static const int DRAW_BUFFER1_WEBGL = 0x8826;

  static const int DRAW_BUFFER2 = 0x8827;

  static const int DRAW_BUFFER2_WEBGL = 0x8827;

  static const int DRAW_BUFFER3 = 0x8828;

  static const int DRAW_BUFFER3_WEBGL = 0x8828;

  static const int DRAW_BUFFER4 = 0x8829;

  static const int DRAW_BUFFER4_WEBGL = 0x8829;

  static const int DRAW_BUFFER5 = 0x882A;

  static const int DRAW_BUFFER5_WEBGL = 0x882A;

  static const int DRAW_BUFFER6 = 0x882B;

  static const int DRAW_BUFFER6_WEBGL = 0x882B;

  static const int DRAW_BUFFER7 = 0x882C;

  static const int DRAW_BUFFER7_WEBGL = 0x882C;

  static const int DRAW_BUFFER8 = 0x882D;

  static const int DRAW_BUFFER8_WEBGL = 0x882D;

  static const int DRAW_BUFFER9 = 0x882E;

  static const int DRAW_BUFFER9_WEBGL = 0x882E;

  static const int DRAW_FRAMEBUFFER = 0x8CA9;

  static const int DRAW_FRAMEBUFFER_BINDING = 0x8CA6;

  static const int DST_ALPHA = 0x0304;

  static const int DST_COLOR = 0x0306;

  static const int DYNAMIC_COPY = 0x88EA;

  static const int DYNAMIC_DRAW = 0x88E8;

  static const int DYNAMIC_READ = 0x88E9;

  static const int ELEMENT_ARRAY_BUFFER = 0x8893;

  static const int ELEMENT_ARRAY_BUFFER_BINDING = 0x8895;

  static const int EQUAL = 0x0202;

  static const int FASTEST = 0x1101;

  static const int FLOAT = 0x1406;

  static const int FLOAT_32_UNSIGNED_INT_24_8_REV = 0x8DAD;

  static const int FLOAT_MAT2 = 0x8B5A;

  static const int FLOAT_MAT2x3 = 0x8B65;

  static const int FLOAT_MAT2x4 = 0x8B66;

  static const int FLOAT_MAT3 = 0x8B5B;

  static const int FLOAT_MAT3x2 = 0x8B67;

  static const int FLOAT_MAT3x4 = 0x8B68;

  static const int FLOAT_MAT4 = 0x8B5C;

  static const int FLOAT_MAT4x2 = 0x8B69;

  static const int FLOAT_MAT4x3 = 0x8B6A;

  static const int FLOAT_VEC2 = 0x8B50;

  static const int FLOAT_VEC3 = 0x8B51;

  static const int FLOAT_VEC4 = 0x8B52;

  static const int FRAGMENT_SHADER = 0x8B30;

  static const int FRAGMENT_SHADER_DERIVATIVE_HINT = 0x8B8B;

  static const int FRAMEBUFFER = 0x8D40;

  static const int FRAMEBUFFER_ATTACHMENT_ALPHA_SIZE = 0x8215;

  static const int FRAMEBUFFER_ATTACHMENT_BLUE_SIZE = 0x8214;

  static const int FRAMEBUFFER_ATTACHMENT_COLOR_ENCODING = 0x8210;

  static const int FRAMEBUFFER_ATTACHMENT_COMPONENT_TYPE = 0x8211;

  static const int FRAMEBUFFER_ATTACHMENT_DEPTH_SIZE = 0x8216;

  static const int FRAMEBUFFER_ATTACHMENT_GREEN_SIZE = 0x8213;

  static const int FRAMEBUFFER_ATTACHMENT_OBJECT_NAME = 0x8CD1;

  static const int FRAMEBUFFER_ATTACHMENT_OBJECT_TYPE = 0x8CD0;

  static const int FRAMEBUFFER_ATTACHMENT_RED_SIZE = 0x8212;

  static const int FRAMEBUFFER_ATTACHMENT_STENCIL_SIZE = 0x8217;

  static const int FRAMEBUFFER_ATTACHMENT_TEXTURE_CUBE_MAP_FACE = 0x8CD3;

  static const int FRAMEBUFFER_ATTACHMENT_TEXTURE_LAYER = 0x8CD4;

  static const int FRAMEBUFFER_ATTACHMENT_TEXTURE_LEVEL = 0x8CD2;

  static const int FRAMEBUFFER_BINDING = 0x8CA6;

  static const int FRAMEBUFFER_COMPLETE = 0x8CD5;

  static const int FRAMEBUFFER_DEFAULT = 0x8218;

  static const int FRAMEBUFFER_INCOMPLETE_ATTACHMENT = 0x8CD6;

  static const int FRAMEBUFFER_INCOMPLETE_DIMENSIONS = 0x8CD9;

  static const int FRAMEBUFFER_INCOMPLETE_MISSING_ATTACHMENT = 0x8CD7;

  static const int FRAMEBUFFER_INCOMPLETE_MULTISAMPLE = 0x8D56;

  static const int FRAMEBUFFER_UNSUPPORTED = 0x8CDD;

  static const int FRONT = 0x0404;

  static const int FRONT_AND_BACK = 0x0408;

  static const int FRONT_FACE = 0x0B46;

  static const int FUNC_ADD = 0x8006;

  static const int FUNC_REVERSE_SUBTRACT = 0x800B;

  static const int FUNC_SUBTRACT = 0x800A;

  static const int GENERATE_MIPMAP_HINT = 0x8192;

  static const int GEQUAL = 0x0206;

  static const int GREATER = 0x0204;

  static const int GREEN_BITS = 0x0D53;

  static const int HALF_FLOAT = 0x140B;

  static const int HIGH_FLOAT = 0x8DF2;

  static const int HIGH_INT = 0x8DF5;

  static const int IMPLEMENTATION_COLOR_READ_FORMAT = 0x8B9B;

  static const int IMPLEMENTATION_COLOR_READ_TYPE = 0x8B9A;

  static const int INCR = 0x1E02;

  static const int INCR_WRAP = 0x8507;

  static const int INT = 0x1404;

  static const int INTERLEAVED_ATTRIBS = 0x8C8C;

  static const int INT_2_10_10_10_REV = 0x8D9F;

  static const int INT_SAMPLER_2D = 0x8DCA;

  static const int INT_SAMPLER_2D_ARRAY = 0x8DCF;

  static const int INT_SAMPLER_3D = 0x8DCB;

  static const int INT_SAMPLER_CUBE = 0x8DCC;

  static const int INT_VEC2 = 0x8B53;

  static const int INT_VEC3 = 0x8B54;

  static const int INT_VEC4 = 0x8B55;

  static const int INVALID_ENUM = 0x0500;

  static const int INVALID_FRAMEBUFFER_OPERATION = 0x0506;

  static const int INVALID_INDEX = 0xFFFFFFFF;

  static const int INVALID_OPERATION = 0x0502;

  static const int INVALID_VALUE = 0x0501;

  static const int INVERT = 0x150A;

  static const int KEEP = 0x1E00;

  static const int LEQUAL = 0x0203;

  static const int LESS = 0x0201;

  static const int LINEAR = 0x2601;

  static const int LINEAR_MIPMAP_LINEAR = 0x2703;

  static const int LINEAR_MIPMAP_NEAREST = 0x2701;

  static const int LINES = 0x0001;

  static const int LINE_LOOP = 0x0002;

  static const int LINE_STRIP = 0x0003;

  static const int LINE_WIDTH = 0x0B21;

  static const int LINK_STATUS = 0x8B82;

  static const int LOW_FLOAT = 0x8DF0;

  static const int LOW_INT = 0x8DF3;

  static const int LUMINANCE = 0x1909;

  static const int LUMINANCE_ALPHA = 0x190A;

  static const int MAX = 0x8008;

  static const int MAX_3D_TEXTURE_SIZE = 0x8073;

  static const int MAX_ARRAY_TEXTURE_LAYERS = 0x88FF;

  static const int MAX_CLIENT_WAIT_TIMEOUT_WEBGL = 0x9247;

  static const int MAX_COLOR_ATTACHMENTS = 0x8CDF;

  static const int MAX_COLOR_ATTACHMENTS_WEBGL = 0x8CDF;

  static const int MAX_COMBINED_FRAGMENT_UNIFORM_COMPONENTS = 0x8A33;

  static const int MAX_COMBINED_TEXTURE_IMAGE_UNITS = 0x8B4D;

  static const int MAX_COMBINED_UNIFORM_BLOCKS = 0x8A2E;

  static const int MAX_COMBINED_VERTEX_UNIFORM_COMPONENTS = 0x8A31;

  static const int MAX_CUBE_MAP_TEXTURE_SIZE = 0x851C;

  static const int MAX_DRAW_BUFFERS = 0x8824;

  static const int MAX_DRAW_BUFFERS_WEBGL = 0x8824;

  static const int MAX_ELEMENTS_INDICES = 0x80E9;

  static const int MAX_ELEMENTS_VERTICES = 0x80E8;

  static const int MAX_ELEMENT_INDEX = 0x8D6B;

  static const int MAX_FRAGMENT_INPUT_COMPONENTS = 0x9125;

  static const int MAX_FRAGMENT_UNIFORM_BLOCKS = 0x8A2D;

  static const int MAX_FRAGMENT_UNIFORM_COMPONENTS = 0x8B49;

  static const int MAX_FRAGMENT_UNIFORM_VECTORS = 0x8DFD;

  static const int MAX_PROGRAM_TEXEL_OFFSET = 0x8905;

  static const int MAX_RENDERBUFFER_SIZE = 0x84E8;

  static const int MAX_SAMPLES = 0x8D57;

  static const int MAX_SERVER_WAIT_TIMEOUT = 0x9111;

  static const int MAX_TEXTURE_IMAGE_UNITS = 0x8872;

  static const int MAX_TEXTURE_LOD_BIAS = 0x84FD;

  static const int MAX_TEXTURE_SIZE = 0x0D33;

  static const int MAX_TRANSFORM_FEEDBACK_INTERLEAVED_COMPONENTS = 0x8C8A;

  static const int MAX_TRANSFORM_FEEDBACK_SEPARATE_ATTRIBS = 0x8C8B;

  static const int MAX_TRANSFORM_FEEDBACK_SEPARATE_COMPONENTS = 0x8C80;

  static const int MAX_UNIFORM_BLOCK_SIZE = 0x8A30;

  static const int MAX_UNIFORM_BUFFER_BINDINGS = 0x8A2F;

  static const int MAX_VARYING_COMPONENTS = 0x8B4B;

  static const int MAX_VARYING_VECTORS = 0x8DFC;

  static const int MAX_VERTEX_ATTRIBS = 0x8869;

  static const int MAX_VERTEX_OUTPUT_COMPONENTS = 0x9122;

  static const int MAX_VERTEX_TEXTURE_IMAGE_UNITS = 0x8B4C;

  static const int MAX_VERTEX_UNIFORM_BLOCKS = 0x8A2B;

  static const int MAX_VERTEX_UNIFORM_COMPONENTS = 0x8B4A;

  static const int MAX_VERTEX_UNIFORM_VECTORS = 0x8DFB;

  static const int MAX_VIEWPORT_DIMS = 0x0D3A;

  static const int MEDIUM_FLOAT = 0x8DF1;

  static const int MEDIUM_INT = 0x8DF4;

  static const int MIN = 0x8007;

  static const int MIN_PROGRAM_TEXEL_OFFSET = 0x8904;

  static const int MIRRORED_REPEAT = 0x8370;

  static const int NEAREST = 0x2600;

  static const int NEAREST_MIPMAP_LINEAR = 0x2702;

  static const int NEAREST_MIPMAP_NEAREST = 0x2700;

  static const int NEVER = 0x0200;

  static const int NICEST = 0x1102;

  static const int NONE = 0;

  static const int NOTEQUAL = 0x0205;

  static const int NO_ERROR = 0;

  static const int OBJECT_TYPE = 0x9112;

  static const int ONE = 1;

  static const int ONE_MINUS_CONSTANT_ALPHA = 0x8004;

  static const int ONE_MINUS_CONSTANT_COLOR = 0x8002;

  static const int ONE_MINUS_DST_ALPHA = 0x0305;

  static const int ONE_MINUS_DST_COLOR = 0x0307;

  static const int ONE_MINUS_SRC_ALPHA = 0x0303;

  static const int ONE_MINUS_SRC_COLOR = 0x0301;

  static const int OUT_OF_MEMORY = 0x0505;

  static const int PACK_ALIGNMENT = 0x0D05;

  static const int PACK_ROW_LENGTH = 0x0D02;

  static const int PACK_SKIP_PIXELS = 0x0D04;

  static const int PACK_SKIP_ROWS = 0x0D03;

  static const int PIXEL_PACK_BUFFER = 0x88EB;

  static const int PIXEL_PACK_BUFFER_BINDING = 0x88ED;

  static const int PIXEL_UNPACK_BUFFER = 0x88EC;

  static const int PIXEL_UNPACK_BUFFER_BINDING = 0x88EF;

  static const int POINTS = 0x0000;

  static const int POLYGON_OFFSET_FACTOR = 0x8038;

  static const int POLYGON_OFFSET_FILL = 0x8037;

  static const int POLYGON_OFFSET_UNITS = 0x2A00;

  static const int QUERY_RESULT = 0x8866;

  static const int QUERY_RESULT_AVAILABLE = 0x8867;

  static const int R11F_G11F_B10F = 0x8C3A;

  static const int R16F = 0x822D;

  static const int R16I = 0x8233;

  static const int R16UI = 0x8234;

  static const int R32F = 0x822E;

  static const int R32I = 0x8235;

  static const int R32UI = 0x8236;

  static const int R8 = 0x8229;

  static const int R8I = 0x8231;

  static const int R8UI = 0x8232;

  static const int R8_SNORM = 0x8F94;

  static const int RASTERIZER_DISCARD = 0x8C89;

  static const int READ_BUFFER = 0x0C02;

  static const int READ_FRAMEBUFFER = 0x8CA8;

  static const int READ_FRAMEBUFFER_BINDING = 0x8CAA;

  static const int RED = 0x1903;

  static const int RED_BITS = 0x0D52;

  static const int RED_INTEGER = 0x8D94;

  static const int RENDERBUFFER = 0x8D41;

  static const int RENDERBUFFER_ALPHA_SIZE = 0x8D53;

  static const int RENDERBUFFER_BINDING = 0x8CA7;

  static const int RENDERBUFFER_BLUE_SIZE = 0x8D52;

  static const int RENDERBUFFER_DEPTH_SIZE = 0x8D54;

  static const int RENDERBUFFER_GREEN_SIZE = 0x8D51;

  static const int RENDERBUFFER_HEIGHT = 0x8D43;

  static const int RENDERBUFFER_INTERNAL_FORMAT = 0x8D44;

  static const int RENDERBUFFER_RED_SIZE = 0x8D50;

  static const int RENDERBUFFER_SAMPLES = 0x8CAB;

  static const int RENDERBUFFER_STENCIL_SIZE = 0x8D55;

  static const int RENDERBUFFER_WIDTH = 0x8D42;

  static const int RENDERER = 0x1F01;

  static const int REPEAT = 0x2901;

  static const int REPLACE = 0x1E01;

  static const int RG = 0x8227;

  static const int RG16F = 0x822F;

  static const int RG16I = 0x8239;

  static const int RG16UI = 0x823A;

  static const int RG32F = 0x8230;

  static const int RG32I = 0x823B;

  static const int RG32UI = 0x823C;

  static const int RG8 = 0x822B;

  static const int RG8I = 0x8237;

  static const int RG8UI = 0x8238;

  static const int RG8_SNORM = 0x8F95;

  static const int RGB = 0x1907;

  static const int RGB10_A2 = 0x8059;

  static const int RGB10_A2UI = 0x906F;

  static const int RGB16F = 0x881B;

  static const int RGB16I = 0x8D89;

  static const int RGB16UI = 0x8D77;

  static const int RGB32F = 0x8815;

  static const int RGB32I = 0x8D83;

  static const int RGB32UI = 0x8D71;

  static const int RGB565 = 0x8D62;

  static const int RGB5_A1 = 0x8057;

  static const int RGB8 = 0x8051;

  static const int RGB8I = 0x8D8F;

  static const int RGB8UI = 0x8D7D;

  static const int RGB8_SNORM = 0x8F96;

  static const int RGB9_E5 = 0x8C3D;

  static const int RGBA = 0x1908;

  static const int RGBA16F = 0x881A;

  static const int RGBA16I = 0x8D88;

  static const int RGBA16UI = 0x8D76;

  static const int RGBA32F = 0x8814;

  static const int RGBA32I = 0x8D82;

  static const int RGBA32UI = 0x8D70;

  static const int RGBA4 = 0x8056;

  static const int RGBA8 = 0x8058;

  static const int RGBA8I = 0x8D8E;

  static const int RGBA8UI = 0x8D7C;

  static const int RGBA8_SNORM = 0x8F97;

  static const int RGBA_INTEGER = 0x8D99;

  static const int RGB_INTEGER = 0x8D98;

  static const int RG_INTEGER = 0x8228;

  static const int SAMPLER_2D = 0x8B5E;

  static const int SAMPLER_2D_ARRAY = 0x8DC1;

  static const int SAMPLER_2D_ARRAY_SHADOW = 0x8DC4;

  static const int SAMPLER_2D_SHADOW = 0x8B62;

  static const int SAMPLER_3D = 0x8B5F;

  static const int SAMPLER_BINDING = 0x8919;

  static const int SAMPLER_CUBE = 0x8B60;

  static const int SAMPLER_CUBE_SHADOW = 0x8DC5;

  static const int SAMPLES = 0x80A9;

  static const int SAMPLE_ALPHA_TO_COVERAGE = 0x809E;

  static const int SAMPLE_BUFFERS = 0x80A8;

  static const int SAMPLE_COVERAGE = 0x80A0;

  static const int SAMPLE_COVERAGE_INVERT = 0x80AB;

  static const int SAMPLE_COVERAGE_VALUE = 0x80AA;

  static const int SCISSOR_BOX = 0x0C10;

  static const int SCISSOR_TEST = 0x0C11;

  static const int SEPARATE_ATTRIBS = 0x8C8D;

  static const int SHADER_TYPE = 0x8B4F;

  static const int SHADING_LANGUAGE_VERSION = 0x8B8C;

  static const int SHORT = 0x1402;

  static const int SIGNALED = 0x9119;

  static const int SIGNED_NORMALIZED = 0x8F9C;

  static const int SRC_ALPHA = 0x0302;

  static const int SRC_ALPHA_SATURATE = 0x0308;

  static const int SRC_COLOR = 0x0300;

  static const int SRGB = 0x8C40;

  static const int SRGB8 = 0x8C41;

  static const int SRGB8_ALPHA8 = 0x8C43;

  static const int STATIC_COPY = 0x88E6;

  static const int STATIC_DRAW = 0x88E4;

  static const int STATIC_READ = 0x88E5;

  static const int STENCIL = 0x1802;

  static const int STENCIL_ATTACHMENT = 0x8D20;

  static const int STENCIL_BACK_FAIL = 0x8801;

  static const int STENCIL_BACK_FUNC = 0x8800;

  static const int STENCIL_BACK_PASS_DEPTH_FAIL = 0x8802;

  static const int STENCIL_BACK_PASS_DEPTH_PASS = 0x8803;

  static const int STENCIL_BACK_REF = 0x8CA3;

  static const int STENCIL_BACK_VALUE_MASK = 0x8CA4;

  static const int STENCIL_BACK_WRITEMASK = 0x8CA5;

  static const int STENCIL_BITS = 0x0D57;

  static const int STENCIL_BUFFER_BIT = 0x00000400;

  static const int STENCIL_CLEAR_VALUE = 0x0B91;

  static const int STENCIL_FAIL = 0x0B94;

  static const int STENCIL_FUNC = 0x0B92;

  static const int STENCIL_INDEX8 = 0x8D48;

  static const int STENCIL_PASS_DEPTH_FAIL = 0x0B95;

  static const int STENCIL_PASS_DEPTH_PASS = 0x0B96;

  static const int STENCIL_REF = 0x0B97;

  static const int STENCIL_TEST = 0x0B90;

  static const int STENCIL_VALUE_MASK = 0x0B93;

  static const int STENCIL_WRITEMASK = 0x0B98;

  static const int STREAM_COPY = 0x88E2;

  static const int STREAM_DRAW = 0x88E0;

  static const int STREAM_READ = 0x88E1;

  static const int SUBPIXEL_BITS = 0x0D50;

  static const int SYNC_CONDITION = 0x9113;

  static const int SYNC_FENCE = 0x9116;

  static const int SYNC_FLAGS = 0x9115;

  static const int SYNC_FLUSH_COMMANDS_BIT = 0x00000001;

  static const int SYNC_GPU_COMMANDS_COMPLETE = 0x9117;

  static const int SYNC_STATUS = 0x9114;

  static const int TEXTURE = 0x1702;

  static const int TEXTURE0 = 0x84C0;

  static const int TEXTURE1 = 0x84C1;

  static const int TEXTURE10 = 0x84CA;

  static const int TEXTURE11 = 0x84CB;

  static const int TEXTURE12 = 0x84CC;

  static const int TEXTURE13 = 0x84CD;

  static const int TEXTURE14 = 0x84CE;

  static const int TEXTURE15 = 0x84CF;

  static const int TEXTURE16 = 0x84D0;

  static const int TEXTURE17 = 0x84D1;

  static const int TEXTURE18 = 0x84D2;

  static const int TEXTURE19 = 0x84D3;

  static const int TEXTURE2 = 0x84C2;

  static const int TEXTURE20 = 0x84D4;

  static const int TEXTURE21 = 0x84D5;

  static const int TEXTURE22 = 0x84D6;

  static const int TEXTURE23 = 0x84D7;

  static const int TEXTURE24 = 0x84D8;

  static const int TEXTURE25 = 0x84D9;

  static const int TEXTURE26 = 0x84DA;

  static const int TEXTURE27 = 0x84DB;

  static const int TEXTURE28 = 0x84DC;

  static const int TEXTURE29 = 0x84DD;

  static const int TEXTURE3 = 0x84C3;

  static const int TEXTURE30 = 0x84DE;

  static const int TEXTURE31 = 0x84DF;

  static const int TEXTURE4 = 0x84C4;

  static const int TEXTURE5 = 0x84C5;

  static const int TEXTURE6 = 0x84C6;

  static const int TEXTURE7 = 0x84C7;

  static const int TEXTURE8 = 0x84C8;

  static const int TEXTURE9 = 0x84C9;

  static const int TEXTURE_2D = 0x0DE1;

  static const int TEXTURE_2D_ARRAY = 0x8C1A;

  static const int TEXTURE_3D = 0x806F;

  static const int TEXTURE_BASE_LEVEL = 0x813C;

  static const int TEXTURE_BINDING_2D = 0x8069;

  static const int TEXTURE_BINDING_2D_ARRAY = 0x8C1D;

  static const int TEXTURE_BINDING_3D = 0x806A;

  static const int TEXTURE_BINDING_CUBE_MAP = 0x8514;

  static const int TEXTURE_COMPARE_FUNC = 0x884D;

  static const int TEXTURE_COMPARE_MODE = 0x884C;

  static const int TEXTURE_CUBE_MAP = 0x8513;

  static const int TEXTURE_CUBE_MAP_NEGATIVE_X = 0x8516;

  static const int TEXTURE_CUBE_MAP_NEGATIVE_Y = 0x8518;

  static const int TEXTURE_CUBE_MAP_NEGATIVE_Z = 0x851A;

  static const int TEXTURE_CUBE_MAP_POSITIVE_X = 0x8515;

  static const int TEXTURE_CUBE_MAP_POSITIVE_Y = 0x8517;

  static const int TEXTURE_CUBE_MAP_POSITIVE_Z = 0x8519;

  static const int TEXTURE_IMMUTABLE_FORMAT = 0x912F;

  static const int TEXTURE_IMMUTABLE_LEVELS = 0x82DF;

  static const int TEXTURE_MAG_FILTER = 0x2800;

  static const int TEXTURE_MAX_LEVEL = 0x813D;

  static const int TEXTURE_MAX_LOD = 0x813B;

  static const int TEXTURE_MIN_FILTER = 0x2801;

  static const int TEXTURE_MIN_LOD = 0x813A;

  static const int TEXTURE_WRAP_R = 0x8072;

  static const int TEXTURE_WRAP_S = 0x2802;

  static const int TEXTURE_WRAP_T = 0x2803;

  static const int TIMEOUT_EXPIRED = 0x911B;

  static const int TIMEOUT_IGNORED = -1;

  static const int TRANSFORM_FEEDBACK = 0x8E22;

  static const int TRANSFORM_FEEDBACK_ACTIVE = 0x8E24;

  static const int TRANSFORM_FEEDBACK_BINDING = 0x8E25;

  static const int TRANSFORM_FEEDBACK_BUFFER = 0x8C8E;

  static const int TRANSFORM_FEEDBACK_BUFFER_BINDING = 0x8C8F;

  static const int TRANSFORM_FEEDBACK_BUFFER_MODE = 0x8C7F;

  static const int TRANSFORM_FEEDBACK_BUFFER_SIZE = 0x8C85;

  static const int TRANSFORM_FEEDBACK_BUFFER_START = 0x8C84;

  static const int TRANSFORM_FEEDBACK_PAUSED = 0x8E23;

  static const int TRANSFORM_FEEDBACK_PRIMITIVES_WRITTEN = 0x8C88;

  static const int TRANSFORM_FEEDBACK_VARYINGS = 0x8C83;

  static const int TRIANGLES = 0x0004;

  static const int TRIANGLE_FAN = 0x0006;

  static const int TRIANGLE_STRIP = 0x0005;

  static const int UNIFORM_ARRAY_STRIDE = 0x8A3C;

  static const int UNIFORM_BLOCK_ACTIVE_UNIFORMS = 0x8A42;

  static const int UNIFORM_BLOCK_ACTIVE_UNIFORM_INDICES = 0x8A43;

  static const int UNIFORM_BLOCK_BINDING = 0x8A3F;

  static const int UNIFORM_BLOCK_DATA_SIZE = 0x8A40;

  static const int UNIFORM_BLOCK_INDEX = 0x8A3A;

  static const int UNIFORM_BLOCK_REFERENCED_BY_FRAGMENT_SHADER = 0x8A46;

  static const int UNIFORM_BLOCK_REFERENCED_BY_VERTEX_SHADER = 0x8A44;

  static const int UNIFORM_BUFFER = 0x8A11;

  static const int UNIFORM_BUFFER_BINDING = 0x8A28;

  static const int UNIFORM_BUFFER_OFFSET_ALIGNMENT = 0x8A34;

  static const int UNIFORM_BUFFER_SIZE = 0x8A2A;

  static const int UNIFORM_BUFFER_START = 0x8A29;

  static const int UNIFORM_IS_ROW_MAJOR = 0x8A3E;

  static const int UNIFORM_MATRIX_STRIDE = 0x8A3D;

  static const int UNIFORM_OFFSET = 0x8A3B;

  static const int UNIFORM_SIZE = 0x8A38;

  static const int UNIFORM_TYPE = 0x8A37;

  static const int UNPACK_ALIGNMENT = 0x0CF5;

  static const int UNPACK_COLORSPACE_CONVERSION_WEBGL = 0x9243;

  static const int UNPACK_FLIP_Y_WEBGL = 0x9240;

  static const int UNPACK_IMAGE_HEIGHT = 0x806E;

  static const int UNPACK_PREMULTIPLY_ALPHA_WEBGL = 0x9241;

  static const int UNPACK_ROW_LENGTH = 0x0CF2;

  static const int UNPACK_SKIP_IMAGES = 0x806D;

  static const int UNPACK_SKIP_PIXELS = 0x0CF4;

  static const int UNPACK_SKIP_ROWS = 0x0CF3;

  static const int UNSIGNALED = 0x9118;

  static const int UNSIGNED_BYTE = 0x1401;

  static const int UNSIGNED_INT = 0x1405;

  static const int UNSIGNED_INT_10F_11F_11F_REV = 0x8C3B;

  static const int UNSIGNED_INT_24_8 = 0x84FA;

  static const int UNSIGNED_INT_2_10_10_10_REV = 0x8368;

  static const int UNSIGNED_INT_5_9_9_9_REV = 0x8C3E;

  static const int UNSIGNED_INT_SAMPLER_2D = 0x8DD2;

  static const int UNSIGNED_INT_SAMPLER_2D_ARRAY = 0x8DD7;

  static const int UNSIGNED_INT_SAMPLER_3D = 0x8DD3;

  static const int UNSIGNED_INT_SAMPLER_CUBE = 0x8DD4;

  static const int UNSIGNED_INT_VEC2 = 0x8DC6;

  static const int UNSIGNED_INT_VEC3 = 0x8DC7;

  static const int UNSIGNED_INT_VEC4 = 0x8DC8;

  static const int UNSIGNED_NORMALIZED = 0x8C17;

  static const int UNSIGNED_SHORT = 0x1403;

  static const int UNSIGNED_SHORT_4_4_4_4 = 0x8033;

  static const int UNSIGNED_SHORT_5_5_5_1 = 0x8034;

  static const int UNSIGNED_SHORT_5_6_5 = 0x8363;

  static const int VALIDATE_STATUS = 0x8B83;

  static const int VENDOR = 0x1F00;

  static const int VERSION = 0x1F02;

  static const int VERTEX_ARRAY_BINDING = 0x85B5;

  static const int VERTEX_ATTRIB_ARRAY_BUFFER_BINDING = 0x889F;

  static const int VERTEX_ATTRIB_ARRAY_DIVISOR = 0x88FE;

  static const int VERTEX_ATTRIB_ARRAY_ENABLED = 0x8622;

  static const int VERTEX_ATTRIB_ARRAY_INTEGER = 0x88FD;

  static const int VERTEX_ATTRIB_ARRAY_NORMALIZED = 0x886A;

  static const int VERTEX_ATTRIB_ARRAY_POINTER = 0x8645;

  static const int VERTEX_ATTRIB_ARRAY_SIZE = 0x8623;

  static const int VERTEX_ATTRIB_ARRAY_STRIDE = 0x8624;

  static const int VERTEX_ATTRIB_ARRAY_TYPE = 0x8625;

  static const int VERTEX_SHADER = 0x8B31;

  static const int VIEWPORT = 0x0BA2;

  static const int WAIT_FAILED = 0x911D;

  static const int ZERO = 0;
}

// // JS "WebGL2RenderingContextBase")
// abstract class _WebGL2RenderingContextBase extends Interceptor implements _WebGLRenderingContextBase {
//   // To suppress missing implicit constructor warnings.
//   factory _WebGL2RenderingContextBase._() {
//     throw new UnsupportedError("Not supported");
//   }

//   // From WebGLRenderingContextBase
// }

// abstract class _WebGLRenderingContextBase extends Interceptor {
//   // To suppress missing implicit constructor warnings.
//   factory _WebGLRenderingContextBase._() {
//     throw new UnsupportedError("Not supported");
//   }
// }
