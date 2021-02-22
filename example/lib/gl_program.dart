part of 'learn_gl.dart';
// Copyright (c) 2013, John Thomas McDole.
/*
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

/// Create a WebGL [Program], compiling [Shader]s from passed in sources and
/// cache [UniformLocation]s and AttribLocations.
class GlProgram {
  Map<String, int> attributes = new Map<String, int>();
  Map<String, UniformLocation> uniforms = new Map<String, UniformLocation>();
  late Program program;

  late Shader fragShader, vertShader;

  GlProgram(String fragSrc, String vertSrc, List<String> attributeNames, List<String> uniformNames) {
    fragShader = gl.createShader(WebGL.FRAGMENT_SHADER);
    gl.shaderSource(fragShader, fragSrc);
    gl.compileShader(fragShader);

    vertShader = gl.createShader(WebGL.VERTEX_SHADER);
    gl.shaderSource(vertShader, vertSrc);
    gl.compileShader(vertShader);

    program = gl.createProgram();
    gl.attachShader(program, vertShader);
    gl.attachShader(program, fragShader);
    gl.linkProgram(program);

    for (String attrib in attributeNames) {
      int attributeLocation = gl.getAttribLocation(program, attrib);
      gl.enableVertexAttribArray(attributeLocation);
      gl.checkError(attrib);
      attributes[attrib] = attributeLocation;
    }
    for (String uniform in uniformNames) {
      var uniformLocation = gl.getUniformLocation(program, uniform);
      gl.checkError(uniform);
      uniforms[uniform] = uniformLocation;
    }
  }
}
