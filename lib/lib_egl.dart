import 'dart:ffi';
import 'dart:io';

import 'package:dylib/dylib.dart';
import 'package:ffi/ffi.dart';
import 'package:opengl_es_bindings/opengl_es_bindings.dart';

LibEGL? _libEGL;
//
// Public APIs
//

EglError eglGetError() => _libEGL!.eglGetError().toEglError();

Pointer<Void> eglGetCurrentContext() => _libEGL!.eglGetCurrentContext();

Pointer<Void> eglGetDisplay([Pointer<Void>? displayId]) {
  final nativeCallResult = _libEGL!.eglGetDisplay(displayId ?? nullptr);

  if (nativeCallResult == nullptr) {
    throw EglException(
        'No display matching display ID [$displayId] was found.');
  }

  return nativeCallResult;
}

void loadEGL() {
  if (_libEGL == null) {
    if (Platform.isMacOS || Platform.isIOS) {
      _libEGL = LibEGL(DynamicLibrary.process());
    } else {
      _libEGL = LibEGL(DynamicLibrary.open(resolveDylibPath('libEGL')));
    }
  }
}

EglInitializeResult eglInitialize(Pointer<Void> display) {
  final major = calloc<Int32>();
  final minor = calloc<Int32>();
  final nativeCallSucceeded =
      _libEGL!.eglInitialize(display, major, minor) == 1;
  EglInitializeResult result;

  if (nativeCallSucceeded) {
    result = EglInitializeResult(
      majorVersion: major.value,
      minorVersion: minor.value,
    );
  } else {
    throw EglException('Failed to initialize with display [$display]');
  }

  calloc.free(major);
  calloc.free(minor);

  return result;
}

/// https://www.khronos.org/registry/EGL/sdk/docs/man/html/eglChooseConfig.xhtml
List<Pointer<Void>> eglChooseConfig(
  Pointer<Void> display, {
  Map<EglConfigAttribute, int>? attributes,
  int maxConfigs = 1,
}) {
  final attributeCount = attributes == null ? 1 : attributes.length * 2 + 1;
  final attributeList = calloc<Int32>(attributeCount);

  if (attributes != null) {
    final attributeEntries = attributes.entries.toList(growable: false);

    for (var i = 0; i < attributeEntries.length; ++i) {
      attributeList[i * 2] = attributeEntries[i].key.toIntValue();
      attributeList[i * 2 + 1] = attributeEntries[i].value;
    }
  }

  // The list must be terminated with EGL_NONE.
  attributeList[attributeCount - 1] = EglValue.none.toIntValue();

  final configs = calloc<IntPtr>(maxConfigs);
  final numConfigs = calloc<Int32>();
  final nativeCallSucceeded = _libEGL!.eglChooseConfig(
        display,
        attributeList,
        configs.cast<Pointer<Void>>(),
        maxConfigs,
        numConfigs,
      ) ==
      1;
  List<Pointer<Void>> result = <Pointer<Void>>[];

  if (nativeCallSucceeded) {
    for (var i = 0; i < numConfigs.value; ++i) {
      result.add(Pointer.fromAddress(configs[i]));
    }
  }

  calloc.free(attributeList);
  calloc.free(configs);
  calloc.free(numConfigs);

  if (!nativeCallSucceeded) {
    throw EglException(
        'Failed to choose config for display [$display], attributes $attributes, max configs $maxConfigs.');
  }

  return result;
}

List<Pointer<Void>> eglGetConfigs(Pointer<Void> display,
    {int maxConfigs = 10}) {
  final configs = calloc<IntPtr>(maxConfigs);
  final numConfigs = calloc<Int32>();
  final nativeCallSucceeded = _libEGL!.eglGetConfigs(
        display,
        configs.cast<Pointer<Void>>(),
        maxConfigs,
        numConfigs,
      ) ==
      1;
  List<Pointer<Void>> result = <Pointer<Void>>[];

  if (nativeCallSucceeded) {
    for (var i = 0; i < numConfigs.value; ++i) {
      result.add(Pointer.fromAddress(configs[i]));
    }
  }

  calloc.free(configs);
  calloc.free(numConfigs);

  if (!nativeCallSucceeded) {
    throw EglException(
        'Failed to get configs for display [$display], max configs $maxConfigs.');
  }

  return result;
}

int eglGetConfigAttrib(
    Pointer<Void> display, Pointer<Void> config, EglConfigAttribute attribute) {
  final value = calloc<Int32>();
  final nativeCallSucceeded = _libEGL!.eglGetConfigAttrib(
        display,
        config,
        attribute.toIntValue(),
        value.cast(),
      ) ==
      1;
  int result = -1;
  if (nativeCallSucceeded) {
    result = value.value;
  }

  calloc.free(value);

  if (!nativeCallSucceeded) {
    throw EglException(
        'Failed to get configs attribute for display [$display], attribute:  ${attribute.toString()}.');
  }

  return result;
}

void printConfigAttributes(Pointer<Void> display, Pointer<Void> config) {
  print(
      '${EglConfigAttribute.alphaMaskSize.toString()}: ${eglGetConfigAttrib(display, config, EglConfigAttribute.alphaMaskSize)}');
  print(
      '${EglConfigAttribute.alphaSize.toString()}: ${eglGetConfigAttrib(display, config, EglConfigAttribute.alphaSize)}');
  print(
      '${EglConfigAttribute.bindToTextureRgb.toString()}: ${eglGetConfigAttrib(display, config, EglConfigAttribute.bindToTextureRgb)}');
  print(
      '${EglConfigAttribute.bindToTextureRgba.toString()}: ${eglGetConfigAttrib(display, config, EglConfigAttribute.bindToTextureRgba)}');
  print(
      '${EglConfigAttribute.blueSize.toString()}: ${eglGetConfigAttrib(display, config, EglConfigAttribute.blueSize)}');
  print(
      '${EglConfigAttribute.bufferSize.toString()}: ${eglGetConfigAttrib(display, config, EglConfigAttribute.bufferSize)}');
  print(
      '${EglConfigAttribute.colorBufferType.toString()}: ${eglGetConfigAttrib(display, config, EglConfigAttribute.colorBufferType)}');
  print(
      '${EglConfigAttribute.configCaveat.toString()}: ${eglGetConfigAttrib(display, config, EglConfigAttribute.configCaveat)}');
  print(
      '${EglConfigAttribute.configId.toString()}: ${eglGetConfigAttrib(display, config, EglConfigAttribute.configId)}');
  print(
      '${EglConfigAttribute.conformant.toString()}: ${eglGetConfigAttrib(display, config, EglConfigAttribute.conformant)}');
  print(
      '${EglConfigAttribute.depthSize.toString()}: ${eglGetConfigAttrib(display, config, EglConfigAttribute.depthSize)}');
  print(
      '${EglConfigAttribute.greenSize.toString()}: ${eglGetConfigAttrib(display, config, EglConfigAttribute.greenSize)}');
  print(
      '${EglConfigAttribute.level.toString()}: ${eglGetConfigAttrib(display, config, EglConfigAttribute.level)}');
  print(
      '${EglConfigAttribute.luminanceSize.toString()}: ${eglGetConfigAttrib(display, config, EglConfigAttribute.luminanceSize)}');
  print(
      '${EglConfigAttribute.matchNativePixmap.toString()}: ${eglGetConfigAttrib(display, config, EglConfigAttribute.matchNativePixmap)}');
  print(
      '${EglConfigAttribute.nativeRenderable.toString()}: ${eglGetConfigAttrib(display, config, EglConfigAttribute.nativeRenderable)}');
  print(
      '${EglConfigAttribute.maxSwapInterval.toString()}: ${eglGetConfigAttrib(display, config, EglConfigAttribute.maxSwapInterval)}');
  print(
      '${EglConfigAttribute.minSwapInterval.toString()}: ${eglGetConfigAttrib(display, config, EglConfigAttribute.minSwapInterval)}');
  print(
      '${EglConfigAttribute.redSize.toString()}: ${eglGetConfigAttrib(display, config, EglConfigAttribute.redSize)}');
  print(
      '${EglConfigAttribute.sampleBuffers.toString()}: ${eglGetConfigAttrib(display, config, EglConfigAttribute.sampleBuffers)}');
  print(
      '${EglConfigAttribute.samples.toString()}: ${eglGetConfigAttrib(display, config, EglConfigAttribute.samples)}');
  print(
      '${EglConfigAttribute.stencilSize.toString()}: ${eglGetConfigAttrib(display, config, EglConfigAttribute.stencilSize)}');
  print(
      '${EglConfigAttribute.renderableType.toString()}: ${eglGetConfigAttrib(display, config, EglConfigAttribute.renderableType)}');

  final surfaceType =
      eglGetConfigAttrib(display, config, EglConfigAttribute.surfaceType);

  print(
      'SurfaceType: ${(surfaceType & EGL_MULTISAMPLE_RESOLVE_BOX_BIT) != 0 ? 'EGL_MULTISAMPLE_RESOLVE_BOX_BIT, ' : ''}'
      '${(surfaceType & EGL_PBUFFER_BIT) != 0 ? 'EGL_PBUFFER_BIT, ' : ''}'
      '${(surfaceType & EGL_PIXMAP_BIT) != 0 ? 'EGL_PIXMAP_BIT, ' : ''}'
      '${(surfaceType & EGL_SWAP_BEHAVIOR_PRESERVED_BIT) != 0 ? 'EGL_SWAP_BEHAVIOR_PRESERVED_BIT, ' : ''}'
      '${(surfaceType & EGL_VG_ALPHA_FORMAT_PRE_BIT) != 0 ? 'EGL_VG_ALPHA_FORMAT_PRE_BIT, ' : ''}'
      '${(surfaceType & EGL_VG_COLORSPACE_LINEAR_BIT) != 0 ? 'EGL_VG_COLORSPACE_LINEAR_BIT, ' : ''}'
      '${(surfaceType & EGL_WINDOW_BIT) != 0 ? 'EGL_WINDOW_BIT, ' : ''}');
  print(
      '${EglConfigAttribute.transparentType.toString()}: ${eglGetConfigAttrib(display, config, EglConfigAttribute.transparentType)}');
  print(
      '${EglConfigAttribute.transparentRedValue.toString()}: ${eglGetConfigAttrib(display, config, EglConfigAttribute.transparentRedValue)}');
  print(
      '${EglConfigAttribute.transparentGreenValue.toString()}: ${eglGetConfigAttrib(display, config, EglConfigAttribute.transparentGreenValue)}');
  print(
      '${EglConfigAttribute.transparentBlueValue.toString()}: ${eglGetConfigAttrib(display, config, EglConfigAttribute.transparentBlueValue)}');
}

Pointer<Void> eglCreateContext(
  Pointer<Void> display,
  Pointer<Void> config, {
  int contextClientVersion = 3,
  Pointer<Void>? shareContext,
  bool isDebugContext = false,
}) {
  final attributeList = calloc<Int32>(5);
  attributeList[0] = EGL_CONTEXT_CLIENT_VERSION;
  attributeList[1] = contextClientVersion;
  if (!isDebugContext) {
    attributeList[2] = EglValue.none.toIntValue();
  } else {
    attributeList[2] = EGL_CONTEXT_OPENGL_DEBUG;
    attributeList[3] = EGL_TRUE;
    attributeList[4] = EglValue.none.toIntValue();
  }

  final nativeCallResult = _libEGL!.eglCreateContext(
      display, config, shareContext ?? nullptr, attributeList);
  late Pointer<Void> result;

  if (nativeCallResult != nullptr) {
    result = nativeCallResult;
  }

  calloc.free(attributeList);

  if (nativeCallResult == nullptr) {
    throw EglException(
        'Failed to create context for display [$display], config [$config], context client version $contextClientVersion, share context [$shareContext].');
  }

  return result;
}

Pointer<Void> eglCreateWindowSurface(
  Pointer<Void> display,
  Pointer<Void> config,
  Pointer<Void> nativeWindow,
) {
  final nativeCallResult =
      _libEGL!.eglCreateWindowSurface(display, config, nativeWindow, nullptr);

  if (nativeCallResult == nullptr) {
    throw EglException(
        'Failed to create window surface for display [$display], config [$config], native window [$nativeWindow].');
  }

  return nativeCallResult;
}

Pointer<Void> eglCreatePbufferSurface(
  Pointer<Void> display,
  Pointer<Void> config, {
  Map<EglSurfaceAttributes, int>? attributes,
}) {
  final attributeCount = attributes == null ? 1 : attributes.length * 2 + 1;
  final attributeList = calloc<Int32>(attributeCount);

  if (attributes != null) {
    final attributeEntries = attributes.entries.toList(growable: false);

    for (var i = 0; i < attributeEntries.length; ++i) {
      attributeList[i * 2] = attributeEntries[i].key.toIntValue();
      attributeList[i * 2 + 1] = attributeEntries[i].value;
    }
  }

  // The list must be terminated with EGL_NONE.
  attributeList[attributeCount - 1] = EglValue.none.toIntValue();

  final nativeCallResult =
      _libEGL!.eglCreatePbufferSurface(display, config, attributeList);

  calloc.free(attributeList);
  if (nativeCallResult == nullptr) {
    throw EglException(
        'Failed to create Pbuffer surface for display [$display], config [$config], attributes [$attributeList].');
  }

  return nativeCallResult;
}

void eglMakeCurrent(
  Pointer<Void> display,
  Pointer<Void> draw,
  Pointer<Void> read,
  Pointer<Void> context,
) {
  final nativeCallResult =
      _libEGL!.eglMakeCurrent(display, draw, read, context) == 1;

  if (nativeCallResult) {
    return;
  }

  throw EglException(
      'Failed to make current using display [$display], draw [$draw], read [$read], context [$context].');
}

void eglSwapBuffers(
  Pointer<Void> display,
  Pointer<Void> surface,
) {
  final nativeCallResult = _libEGL!.eglSwapBuffers(display, surface) == 1;

  if (nativeCallResult) {
    return;
  }

  throw EglException(
      'Failed to swap buffers using display [$display], surface [$surface].');
}

void eglDestroyContext(
  Pointer<Void> display,
  Pointer<Void> context,
) {
  final nativeCallResult = _libEGL!.eglDestroyContext(display, context) == 1;

  if (nativeCallResult) {
    return;
  }

  throw EglException(
      'Failed to destroy context [$display], surface [$context].');
}

//
// Supporting types
//

class EglException implements Exception {
  EglException(this.message) : eglError = eglGetError();

  final String message;
  final EglError eglError;

  bool get hasEglError => eglError != EglError.success;

  @override
  String toString() =>
      '$message${hasEglError ? ' EGL error $eglError (${eglError.toIntValue()})' : ''}';
}

class EglInitializeResult {
  EglInitializeResult({
    required this.majorVersion,
    required this.minorVersion,
  });

  final int majorVersion;
  final int minorVersion;

  @override
  String toString() => '$majorVersion.$minorVersion';
}

// AUTO GENERATED FILE, DO NOT EDIT.
//
// Generated by supporting F# code.

enum EglError {
  /// EGL_SUCCESS
  success,

  /// EGL_NOT_INITIALIZED
  notInitialized,

  /// EGL_BAD_ACCESS
  badAccess,

  /// EGL_BAD_ALLOC
  badAlloc,

  /// EGL_BAD_ATTRIBUTE
  badAttribute,

  /// EGL_BAD_CONTEXT
  badContext,

  /// EGL_BAD_CONFIG
  badConfig,

  /// EGL_BAD_CURRENT_SURFACE
  badCurrentSurface,

  /// EGL_BAD_DISPLAY
  badDisplay,

  /// EGL_BAD_SURFACE
  badSurface,

  /// EGL_BAD_MATCH
  badMatch,

  /// EGL_BAD_PARAMETER
  badParameter,

  /// EGL_BAD_NATIVE_PIXMAP
  badNativePixmap,

  /// EGL_BAD_NATIVE_WINDOW
  badNativeWindow,

  /// EGL_CONTEXT_LOST
  contextLost,
}

extension EglErrorExtension on EglError {
  int toIntValue() {
    switch (this) {
      case EglError.success:
        return EGL_SUCCESS;
      case EglError.notInitialized:
        return EGL_NOT_INITIALIZED;
      case EglError.badAccess:
        return EGL_BAD_ACCESS;
      case EglError.badAlloc:
        return EGL_BAD_ALLOC;
      case EglError.badAttribute:
        return EGL_BAD_ATTRIBUTE;
      case EglError.badContext:
        return EGL_BAD_CONTEXT;
      case EglError.badConfig:
        return EGL_BAD_CONFIG;
      case EglError.badCurrentSurface:
        return EGL_BAD_CURRENT_SURFACE;
      case EglError.badDisplay:
        return EGL_BAD_DISPLAY;
      case EglError.badSurface:
        return EGL_BAD_SURFACE;
      case EglError.badMatch:
        return EGL_BAD_MATCH;
      case EglError.badParameter:
        return EGL_BAD_PARAMETER;
      case EglError.badNativePixmap:
        return EGL_BAD_NATIVE_PIXMAP;
      case EglError.badNativeWindow:
        return EGL_BAD_NATIVE_WINDOW;
      case EglError.contextLost:
        return EGL_CONTEXT_LOST;
      default:
        throw UnsupportedError('Unsupported value: $this');
    }
  }
}

extension EglErrorIntExtension on int {
  EglError toEglError() {
    switch (this) {
      case EGL_SUCCESS:
        return EglError.success;
      case EGL_NOT_INITIALIZED:
        return EglError.notInitialized;
      case EGL_BAD_ACCESS:
        return EglError.badAccess;
      case EGL_BAD_ALLOC:
        return EglError.badAlloc;
      case EGL_BAD_ATTRIBUTE:
        return EglError.badAttribute;
      case EGL_BAD_CONTEXT:
        return EglError.badContext;
      case EGL_BAD_CONFIG:
        return EglError.badConfig;
      case EGL_BAD_CURRENT_SURFACE:
        return EglError.badCurrentSurface;
      case EGL_BAD_DISPLAY:
        return EglError.badDisplay;
      case EGL_BAD_SURFACE:
        return EglError.badSurface;
      case EGL_BAD_MATCH:
        return EglError.badMatch;
      case EGL_BAD_PARAMETER:
        return EglError.badParameter;
      case EGL_BAD_NATIVE_PIXMAP:
        return EglError.badNativePixmap;
      case EGL_BAD_NATIVE_WINDOW:
        return EglError.badNativeWindow;
      case EGL_CONTEXT_LOST:
        return EglError.contextLost;
      default:
        throw UnsupportedError('Unsupported value: $this');
    }
  }
}

enum EglConfigAttribute {
  /// EGL_ALPHA_MASK_SIZE
  ///Must be followed by a nonnegative integer that indicates the desired alpha
  ///mask buffer size, in bits. The smallest alpha mask buffers of at least the
  ///specified size are preferred. The default value is zero.
  ////The alpha mask buffer is used only by OpenVG.
  alphaMaskSize,

  /// EGL_ALPHA_SIZE
  ///  Must be followed by a nonnegative integer that indicates the desired size
  /// of the alpha component of the color buffer, in bits. If this value is zero,
  /// color buffers with the smallest alpha component size are preferred. Otherwise,
  /// color buffers with the largest alpha component of at least the specified
  /// size are preferred. The default value is zero.
  alphaSize,

  /// EGL_BIND_TO_TEXTURE_RGB
  ///   Must be followed by EGL_DONT_CARE, EGL_TRUE, or EGL_FALSE. If EGL_TRUE is
  /// specified, then only frame buffer configurations that support binding of color
  /// buffers to an OpenGL ES RGB texture will be considered. Currently only frame
  /// buffer configurations that support pbuffers allow this.
  /// The default value is EGL_DONT_CARE.
  bindToTextureRgb,

  /// EGL_BIND_TO_TEXTURE_RGBA
  /// Must be followed by one of EGL_DONT_CARE, EGL_TRUE, or EGL_FALSE. If EGL_TRUE
  /// is specified, then only frame buffer configurations that support binding of
  /// color buffers to an OpenGL ES RGBA texture will be considered. Currently
  /// only frame buffer configurations that support pbuffers allow this.
  /// The default value is EGL_DONT_CARE.
  bindToTextureRgba,

  /// EGL_BLUE_SIZE
  /// Must be followed by a nonnegative integer that indicates the desired size
  /// of the blue component of the color buffer, in bits. If this value is zero,
  /// color buffers with the smallest blue component size are preferred.
  /// Otherwise, color buffers with the largest blue component of at least the
  /// specified size are preferred. The default value is zero.
  blueSize,

  /// EGL_BUFFER_SIZE
  /// Must be followed by a nonnegative integer that indicates the desired color
  /// buffer size, in bits. The smallest color buffers of at least the specified
  /// size are preferred. The default value is zero. The color buffer size is the
  /// sum of EGL_RED_SIZE, EGL_GREEN_SIZE, EGL_BLUE_SIZE, and EGL_ALPHA_SIZE,
  /// and does not include any padding bits which may be present in the pixel
  /// format. It is usually preferable to specify desired sizes for these color
  /// components individually.
  bufferSize,

  /// EGL_COLOR_BUFFER_TYPE
  /// Must be followed by one of EGL_RGB_BUFFER or EGL_LUMINANCE_BUFFER.
  /// EGL_RGB_BUFFER indicates an RGB color buffer; in this case, attributes
  /// EGL_RED_SIZE, EGL_GREEN_SIZE and EGL_BLUE_SIZE must be non-zero, and
  /// EGL_LUMINANCE_SIZE must be zero. EGL_LUMINANCE_BUFFER indicates a
  /// luminance color buffer. In this case EGL_RED_SIZE, EGL_GREEN_SIZE,
  /// EGL_BLUE_SIZE must be zero, and EGL_LUMINANCE_SIZE must be non-zero.
  /// For both RGB and luminance color buffers, EGL_ALPHA_SIZE may be zero or
  /// non-zero.
  colorBufferType,

  /// EGL_CONFIG_CAVEAT
  /// Must be followed by EGL_DONT_CARE, EGL_NONE, EGL_SLOW_CONFIG, or
  /// EGL_NON_CONFORMANT_CONFIG. If EGL_DONT_CARE is specified, then configs are
  /// not matched for this attribute. The default value is EGL_DONT_CARE.
  /// If EGL_NONE is specified, then configs are matched for this attribute, but
  /// only configs with no caveats (neither EGL_SLOW_CONFIG or EGL_NON_CONFORMANT_CONFIG)
  ///  will be considered. If EGL_SLOW_CONFIG is specified, then only slow configs
  /// configurations will be considered. The meaning of``slow'' is
  /// implementation-dependent, but typically indicates a non-hardware-accelerated
  /// (software) implementation. If EGL_NON_CONFORMANT_CONFIG is specified, then
  /// only configs supporting non-conformant OpenGL ES contexts will be considered.
  /// If the EGL version is 1.3 or later, caveat EGL_NON_CONFORMANT_CONFIG is obsolete,
  /// since the same information can be specified via the EGL_CONFORMANT attribute
  /// on a per-client-API basis, not just for OpenGL ES.
  configCaveat,

  /// EGL_CONFIG_ID
  /// Must be followed by a valid integer ID that indicates the desired EGL frame
  /// buffer configuration. When a EGL_CONFIG_ID is specified, all other attributes
  /// are ignored. The default value is EGL_DONT_CARE. The meaning of config IDs
  /// is implementation-dependent. They are used only to uniquely identify different
  /// frame buffer configurations.
  configId,

  /// EGL_CONFORMANT
  /// Must be followed by a bitmask indicating which types of client API contexts
  /// created with respect to the frame buffer configuration config must pass the
  /// required conformance tests for that API. Mask bits include:
  ///
  /// EGL_OPENGL_BIT
  ///
  ///     Config supports creating OpenGL contexts.
  /// EGL_OPENGL_ES_BIT
  ///
  ///     Config supports creating OpenGL ES 1.0 and/or 1.1 contexts.
  /// EGL_OPENGL_ES2_BIT
  ///
  ///     Config supports creating OpenGL ES 2.0 contexts.
  /// EGL_OPENVG_BIT
  ///
  ///     Config supports creating OpenVG contexts.
  ///
  /// For example, if the bitmask is set to EGL_OPENGL_ES_BIT, only frame buffer
  /// configurations that support creating conformant OpenGL ES contexts will
  /// match. The default value is zero.
  ///
  /// Most EGLConfigs should be conformant for all supported client APIs, and it
  /// is rarely desirable to select a nonconformant config. Conformance requirements
  /// limit the number of non-conformant configs that an implementation can define.
  conformant,

  /// EGL_DEPTH_SIZE
  ///  Must be followed by a nonnegative integer that indicates the desired depth
  /// buffer size, in bits. The smallest depth buffers of at least the specified
  /// size is preferred. If the desired size is zero, frame buffer configurations
  /// with no depth buffer are preferred. The default value is zero.
  ///  The depth buffer is used only by OpenGL and OpenGL ES client APIs.
  depthSize,

  /// EGL_GREEN_SIZE
  /// Must be followed by a nonnegative integer that indicates the desired size
  /// of the green component of the color buffer, in bits. If this value is zero,
  /// color buffers with the smallest green component size are preferred. Otherwise,
  /// color buffers with the largest green component of at least the specified size
  /// are preferred. The default value is zero.
  greenSize,

  /// EGL_LEVEL
  /// Must be followed by an integer buffer level specification. This specification
  /// is honored exactly. Buffer level zero corresponds to the default frame buffer
  /// of the display. Buffer level one is the first overlay frame buffer, level two
  /// the second overlay frame buffer, and so on. Negative buffer levels correspond
  /// to underlay frame buffers. The default value is zero.
  /// Most platforms do not support buffer levels other than zero. The behavior of
  /// windows placed in overlay and underlay planes depends on the underlying platform.
  level,

  /// EGL_LUMINANCE_SIZE
  /// Must be followed by a nonnegative integer that indicates the desired size
  /// of the luminance component of the color buffer, in bits. If this value is
  /// zero, color buffers with the smallest luminance component size are preferred.
  /// Otherwise, color buffers with the largest luminance component of at least the
  /// specified size are preferred. The default value is zero.
  luminanceSize,

  /// EGL_MATCH_NATIVE_PIXMAP
  /// Must be followed by the handle of a valid native pixmap, cast to EGLint, or
  /// EGL_NONE. If the value is not EGL_NONE, only configs which support creating
  /// pixmap surfaces with this pixmap using eglCreatePixmapSurface will match this
  /// attribute. If the value is EGL_NONE, then configs are not matched for this
  /// attribute. The default value is EGL_NONE.
  /// EGL_MATCH_NATIVE_PIXMAP was introduced due to the difficulty of determining
  /// an EGLConfig compatibile with a native pixmap using only color component sizes.
  matchNativePixmap,

  /// EGL_NATIVE_RENDERABLE
  /// Must be followed by EGL_DONT_CARE, EGL_TRUE, or EGL_FALSE. If EGL_TRUE is
  /// specified, then only frame buffer configurations that allow native rendering
  /// into the surface will be considered. The default value is EGL_DONT_CARE.
  nativeRenderable,

  /// EGL_MAX_SWAP_INTERVAL
  ///  Must be followed by a integer that indicates the maximum value that can be
  /// passed to eglSwapInterval. The default value is EGL_DONT_CARE.
  maxSwapInterval,

  /// EGL_MIN_SWAP_INTERVAL
  /// Must be followed by a integer that indicates the minimum value that can be
  /// passed to eglSwapInterval. The default value is EGL_DONT_CARE.
  minSwapInterval,

  /// EGL_RED_SIZE
  /// Must be followed by a nonnegative integer that indicates the desired size
  /// of the red component of the color buffer, in bits. If this value is zero,
  /// color buffers with the smallest red component size are preferred. Otherwise,
  /// color buffers with the largest red component of at least the specified size
  /// are preferred. The default value is zero.
  redSize,

  /// EGL_SAMPLE_BUFFERS
  /// Must be followed by the minimum acceptable number of multisample buffers.
  /// Configurations with the smallest number of multisample buffers that meet or
  /// exceed this minimum number are preferred. Currently operation with more
  /// than one multisample buffer is undefined, so only values of zero or one
  /// will produce a match. The default value is zero.
  sampleBuffers,

  /// EGL_SAMPLES
  /// Must be followed by the minimum number of samples required in multisample
  /// buffers. Configurations with the smallest number of samples that meet or
  /// exceed the specified minimum number are preferred. Note that it is possible
  /// for color samples in the multisample buffer to have fewer bits than colors
  /// in the main color buffers. However, multisampled colors maintain at least
  /// as much color resolution in aggregate as the main color buffers.
  samples,

  /// EGL_STENCIL_SIZE
  /// Must be followed by a nonnegative integer that indicates the desired stencil
  /// buffer size, in bits. The smallest stencil buffers of at least the specified
  /// size are preferred. If the desired size is zero, frame buffer configurations
  /// with no stencil buffer are preferred. The default value is zero.
  /// The stencil buffer is used only by OpenGL and OpenGL ES client APIs.
  stencilSize,

  /// EGL_RENDERABLE_TYPE
  /// Must be followed by a bitmask indicating which types of client API contexts
  /// the frame buffer configuration must support creating with eglCreateContext).
  /// Mask bits are the same as for attribute EGL_CONFORMANT. The default
  /// value is EGL_OPENGL_ES_BIT.
  renderableType,

  /// EGL_SURFACE_TYPE
  ///   Must be followed by a bitmask indicating which EGL surface types and
  /// capabilities the frame buffer configuration must support. Mask bits include:
  ///
  ///   EGL_MULTISAMPLE_RESOLVE_BOX_BIT
  ///       Config allows specifying box filtered multisample resolve behavior
  ///       with eglSurfaceAttrib.
  ///   EGL_PBUFFER_BIT
  ///       Config supports creating pixel buffer surfaces.
  ///   EGL_PIXMAP_BIT
  ///       Config supports creating pixmap surfaces.
  ///   EGL_SWAP_BEHAVIOR_PRESERVED_BIT
  ///       Config allows setting swap behavior for color buffers with eglSurfaceAttrib.
  ///   EGL_VG_ALPHA_FORMAT_PRE_BIT
  ///       Config allows specifying OpenVG rendering with premultiplied alpha values at
  ///       surface creation time (see eglCreatePbufferSurface, eglCreatePixmapSurface,
  ///       and eglCreateWindowSurface).
  ///   EGL_VG_COLORSPACE_LINEAR_BIT
  ///       Config allows specifying OpenVG rendering in a linear colorspace at surface
  ///       creation time (see eglCreatePbufferSurface, eglCreatePixmapSurface, and
  ///       eglCreateWindowSurface).
  ///   EGL_WINDOW_BIT
  ///       Config supports creating window surfaces.
  ///   For example, if the bitmask is set to EGL_WINDOW_BIT | EGL_PIXMAP_BIT, only frame
  ///   buffer configurations that support both windows and pixmaps will be considered. The default
  ///   value is EGL_WINDOW_BIT.
  surfaceType,

  /// EGL_TRANSPARENT_TYPE
  /// Must be followed by one of EGL_NONE or EGL_TRANSPARENT_RGB. If EGL_NONE is
  /// specified, then only opaque frame buffer configurations will be considered.
  /// If EGL_TRANSPARENT_RGB is specified, then only transparent frame buffer
  /// configurations will be considered. The default value is EGL_NONE.
  /// Most implementations support only opaque frame buffer configurations.
  transparentType,

  /// Must be followed by an integer value indicating the transparent red value.
  /// The value must be between zero and the maximum color buffer value for red.
  /// Only frame buffer configurations that use the specified transparent red value
  /// will be considered. The default value is EGL_DONT_CARE.
  /// This attribute is ignored unless EGL_TRANSPARENT_TYPE is included in
  /// attrib_list and specified as EGL_TRANSPARENT_RGB.
  transparentRedValue,

  /// EGL_TRANSPARENT_GREEN_VALUE
  /// Must be followed by an integer value indicating the transparent green value.
  /// The value must be between zero and the maximum color buffer value for green.
  /// Only frame buffer configurations that use the specified transparent green
  /// value will be considered. The default value is EGL_DONT_CARE.
  /// This attribute is ignored unless EGL_TRANSPARENT_TYPE is included in
  /// attrib_list and specified as EGL_TRANSPARENT_RGB.
  transparentGreenValue,

  /// EGL_TRANSPARENT_BLUE_VALUE
  /// Must be followed by an integer value indicating the transparent blue value.
  /// The value must be between zero and the maximum color buffer value for blue.
  /// Only frame buffer configurations that use the specified transparent blue
  /// value will be considered. The default value is EGL_DONT_CARE.
  /// This attribute is ignored unless EGL_TRANSPARENT_TYPE is included in attrib_list
  /// and specified as EGL_TRANSPARENT_RGB.
  transparentBlueValue,
}

extension EglConfigAttributeExtension on EglConfigAttribute {
  int toIntValue() {
    switch (this) {
      case EglConfigAttribute.alphaMaskSize:
        return EGL_ALPHA_MASK_SIZE;
      case EglConfigAttribute.alphaSize:
        return EGL_ALPHA_SIZE;
      case EglConfigAttribute.bindToTextureRgb:
        return EGL_BIND_TO_TEXTURE_RGB;
      case EglConfigAttribute.bindToTextureRgba:
        return EGL_BIND_TO_TEXTURE_RGBA;
      case EglConfigAttribute.blueSize:
        return EGL_BLUE_SIZE;
      case EglConfigAttribute.bufferSize:
        return EGL_BUFFER_SIZE;
      case EglConfigAttribute.colorBufferType:
        return EGL_COLOR_BUFFER_TYPE;
      case EglConfigAttribute.configCaveat:
        return EGL_CONFIG_CAVEAT;
      case EglConfigAttribute.configId:
        return EGL_CONFIG_ID;
      case EglConfigAttribute.conformant:
        return EGL_CONFORMANT;
      case EglConfigAttribute.depthSize:
        return EGL_DEPTH_SIZE;
      case EglConfigAttribute.greenSize:
        return EGL_GREEN_SIZE;
      case EglConfigAttribute.level:
        return EGL_LEVEL;
      case EglConfigAttribute.luminanceSize:
        return EGL_LUMINANCE_SIZE;
      case EglConfigAttribute.matchNativePixmap:
        return EGL_MATCH_NATIVE_PIXMAP;
      case EglConfigAttribute.nativeRenderable:
        return EGL_NATIVE_RENDERABLE;
      case EglConfigAttribute.maxSwapInterval:
        return EGL_MAX_SWAP_INTERVAL;
      case EglConfigAttribute.minSwapInterval:
        return EGL_MIN_SWAP_INTERVAL;
      case EglConfigAttribute.redSize:
        return EGL_RED_SIZE;
      case EglConfigAttribute.sampleBuffers:
        return EGL_SAMPLE_BUFFERS;
      case EglConfigAttribute.samples:
        return EGL_SAMPLES;
      case EglConfigAttribute.stencilSize:
        return EGL_STENCIL_SIZE;
      case EglConfigAttribute.renderableType:
        return EGL_RENDERABLE_TYPE;
      case EglConfigAttribute.surfaceType:
        return EGL_SURFACE_TYPE;
      case EglConfigAttribute.transparentType:
        return EGL_TRANSPARENT_TYPE;
      case EglConfigAttribute.transparentRedValue:
        return EGL_TRANSPARENT_RED_VALUE;
      case EglConfigAttribute.transparentGreenValue:
        return EGL_TRANSPARENT_GREEN_VALUE;
      case EglConfigAttribute.transparentBlueValue:
        return EGL_TRANSPARENT_BLUE_VALUE;
      default:
        throw UnsupportedError('Unsupported value: $this');
    }
  }
}

enum EglSurfaceAttributes {
  ///  Specifies the color space used by OpenGL and OpenGL ES when rendering to
  /// the surface. If its value is EGL_GL_COLORSPACE_SRGB, then a non-linear,
  /// perceptually uniform color space is assumed, with a corresponding
  /// GL_FRAMEBUFFER_ATTACHMENT_COLOR_ENCODING value of GL_SRGB. If its value is
  /// EGL_GL_COLORSPACE_LINEAR, then a linear color space is assumed, with a
  /// corresponding GL_FRAMEBUFFER_ATTACHMENT_COLOR_ENCODING value of GL_LINEAR.
  /// The default value of  gl_colorspace is  gl_colorspace_srgb.
  /// Note that the EGL_GL_COLORSPACE attribute is used only by OpenGL and OpenGL
  /// ES contexts supporting sRGB framebuffers. EGL itself does not distinguish multiple colorspace models. Refer to the ``sRGB Conversion'' sections of the OpenGL 4.6 and OpenGL ES 3.2 Specifications for more information.
  glColorspace,

  /// Specifies the required height of the pixel buffer surface. The default value is 0.
  height,

  /// Requests the largest available pixel buffer surface when the allocation
  /// would otherwise fail. Use eglQuerySurface to retrieve the dimensions of the
  /// allocated pixel buffer. The default value is EGL_FALSE.
  largestPbuffer,

  /// Specifies whether storage for mipmaps should be allocated. Space for mipmaps
  ///  will be set aside if the attribute value is EGL_TRUE and EGL_TEXTURE_FORMAT
  ///  is not EGL_NO_TEXTURE. The default value is EGL_FALSE.
  mipmapTexture,

  /// Specifies the format of the texture that will be created when a pbuffer is
  ///  bound to a texture map. Possible values are EGL_NO_TEXTURE, EGL_TEXTURE_RGB,
  ///  and EGL_TEXTURE_RGBA. The default value is EGL_NO_TEXTURE.
  textureFormat,

  /// Specifies the target for the texture that will be created when the pbuffer
  /// is created with a texture format of EGL_TEXTURE_RGB or EGL_TEXTURE_RGBA.
  /// Possible values are EGL_NO_TEXTURE, or EGL_TEXTURE_2D. The default value is
  /// EGL_NO_TEXTURE.
  textureTarget,

  /// Specifies how alpha values are interpreted by OpenVG when rendering to the
  /// surface. If its value is EGL_VG_ALPHA_FORMAT_NONPRE, then alpha values are not premultipled. If its value is EGL_VG_ALPHA_FORMAT_PRE, then alpha values are premultiplied. The default value of EGL_VG_ALPHA_FORMAT is EGL_VG_ALPHA_FORMAT_NONPRE.
  vgAlphaFormat,

  /// Specifies the color space used by OpenVG when rendering to the surface.
  /// If its value is EGL_VG_COLORSPACE_sRGB, then a non-linear, perceptually
  /// uniform color space is assumed, with a corresponding VGImageFormat of form
  /// VG_s*. If its value is EGL_VG_COLORSPACE_LINEAR, then a linear color space is
  /// assumed, with a corresponding VGImageFormat of form VG_l*. The default value
  /// of EGL_VG_COLORSPACE is EGL_VG_COLORSPACE_sRGB.
  vgColorspace,

  /// Specifies the required width of the pixel buffer surface.
  /// The default value is 0.
  width,
}

const _EglSurfaceAttributesToInt = <EglSurfaceAttributes, int>{
  EglSurfaceAttributes.glColorspace: EGL_GL_COLORSPACE,
  EglSurfaceAttributes.height: EGL_HEIGHT,
  EglSurfaceAttributes.largestPbuffer: EGL_LARGEST_PBUFFER,
  EglSurfaceAttributes.mipmapTexture: EGL_MIPMAP_TEXTURE,
  EglSurfaceAttributes.textureFormat: EGL_TEXTURE_FORMAT,
  EglSurfaceAttributes.textureTarget: EGL_TEXTURE_TARGET,
  EglSurfaceAttributes.vgAlphaFormat: EGL_VG_ALPHA_FORMAT,
  EglSurfaceAttributes.vgColorspace: EGL_VG_COLORSPACE,
  EglSurfaceAttributes.width: EGL_WIDTH,
};

extension EglSurfaceAttributesExtension on EglSurfaceAttributes {
  int toIntValue() => _EglSurfaceAttributesToInt[this]!;
}

enum EglValue {
  /// EGL_NONE
  none,

  /// EGL_OPENGL_ES2_BIT
  openglEs2Bit,
  openglEs3Bit,
}

extension EglValueExtension on EglValue {
  int toIntValue() {
    switch (this) {
      case EglValue.none:
        return EGL_NONE;
      case EglValue.openglEs2Bit:
        return EGL_OPENGL_ES2_BIT;
      case EglValue.openglEs3Bit:
        return EGL_OPENGL_ES3_BIT;
      default:
        throw UnsupportedError('Unsupported value: $this');
    }
  }
}
