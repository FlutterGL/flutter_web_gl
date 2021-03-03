# FlutterWebGL [![Pub Version](https://img.shields.io/pub/v/flutter_web_gl)][Pub]

So far there is no way to render 3D objects efficiently in Flutter. Also directly accessing and programming the GPU from Dart isn't supported yet. This plugin shall close this gap. 

Originally @kentcb and I were working on a wrapper for OpenGL for a project for the company Aaronia. Although we got pretty far with that one looking at the fact the Apple deprecated OpenGL I wondered if this still is the right approach. 

Luckily Simon made me aware that there is the *Angle* project from Google that implements an OpenGL ES API for all platforms that don't support them

This project will solve two goals:

* Offer a low-level Dart FFI layer to render into a Flutter Texture Widget with the OpenGL ES 3.0 API
* Realise a Dart Version of the WebGL interface which covers most of the functionality of OpenGL ES, but without the hassle to deal with FFI NativeTypes and proper error handling.

On top of that other packages can build easier to use 3D APIs, e.g. there is a Dart port of the JS 3D framework *three.js*

## How does this work:

Flutter has a `Texture` widget which is a placeholder for graphic content that is rendered onto a native Texture object. This works by creating a Texture object in the native part of this plugin and registering this texture with the Flutter Engine. The Engine returns an id which can then be used in Texture widgets in Flutter.
Flutter will then display the current content of that texture. If the content of this texture was changed by native code we have to inform the Flutter Engine, so that it can update the linked Texture Widgets.

This plugin uses OpenGL ES to render to that native textures. Because of the way OpenGL works we can access the OpenGL "render buffer object" (RBO) from the native part of the plugin as well over the Dart-FFI bindings to the OpenGL ES API so that we can write all rendering code (with the exception of Shaders) in Dart.

To use this you have to do:

1. Call `FlutterWebGL.initOpenGL()` which will setup all the needed infrastructure on the Dart and native side of the plugin
2. Create a Texture with `FlutterWebGL.createTexture` which will return you the textureID to use it in the TextureWidget
3. Activate the Texture to access it with OpenGL commands (this part isn't done yet, so far only one texture is supported).
4. Render to this texture with OpenGL ES low level or WebGL commands
5. Inform the Flutter Engine that new content is available on that texture by calling `FlutterWebGL.updateTexture`.

Check out the example to see how it works.

So far the handling of rendering is intentionally not connected to any special widget, but kept separate. This will make it possible to update the texture content even from a separate Isolate which opens a lot of possibilities.

## Roadmap

Luckily [Aaronia](https://aaronia.de) supports this project by that I can work part of the time I do for them on this project. 

As there is a lot to do, and it needs knowledge of the tool chains for the different platforms it would be amazing if you could join this project.

Currently, I see the following tasks that need to be solved.

- [ ] Build the Angle Framework for 
    - [x] Windows 
    - [ ] Linux,(not necessary until the Flutter Engine supports native Textures on Linux, see [this stale PR](https://github.com/flutter/engine/pull/20714) )
    - [ ] MacOS 
    - [ ] iOS (it seems that the main Angle project hasn't caught up with its fork [metalangle](https://github.com/kakashidinho/metalangle) so we probably should use this one)
- [x] Create a Dart-FFI layer for OpenGL ES 3.0 API and EGL 1.5
- [ ] Implement native plugin parts that register and update the textures
    - [x] Windows 
    - [ ] Android
    - [ ] iOS
    - [ ] macOS
    - [ ] Linux (see above)
    - [ ] Web??? I have no idea how, but maybe someone else does :-)
- [ ] Implement WebGL in Dart
- [ ] add a way to render text. My current idea would be to render text using Flutter onto a canvas and pass that down to OpenGL so that it can be used as a texture on Polygons.

- [ ] design widgets that let you use WebGL without needing to care about Texture allocation and notifying 
- [ ] write examples and documentation


## resources
https://chromium.googlesource.com/angle/angle
https://github.com/kakashidinho/metalangle
https://www.khronos.org/registry/OpenGL/specs/es/3.2/es_spec_3.2.pdf
https://www.khronos.org/registry/EGL/specs/eglspec.1.5.pdf

https://learnopengl.com/Getting-started/Hello-Triangle

[Pub]: pub.dev/packages/flutter_web_gl
