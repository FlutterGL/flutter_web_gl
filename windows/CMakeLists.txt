cmake_minimum_required(VERSION 3.15)
set(PROJECT_NAME "flutter_web_gl")
project(${PROJECT_NAME} LANGUAGES CXX)

# This value is used when generating builds using this plugin, so it must
# not be changed
set(PLUGIN_NAME "flutter_web_gl_plugin")

add_library(${PLUGIN_NAME} SHARED
  "flutter_web_gl_plugin.cpp"
)
apply_standard_settings(${PLUGIN_NAME})
set_target_properties(${PLUGIN_NAME} PROPERTIES
  CXX_VISIBILITY_PRESET hidden)
target_compile_definitions(${PLUGIN_NAME} PRIVATE FLUTTER_PLUGIN_IMPL)
target_include_directories(${PLUGIN_NAME} INTERFACE
  "${CMAKE_CURRENT_SOURCE_DIR}/include")
  
  set(LIB_GLES_NAME "libGLESv2.dll")
  set(LIB_EGL_NAME "libEGL.dll")
  set(ZLIB_NAME "zlib.dll")
  set(ANGLE_DIR "${CMAKE_CURRENT_SOURCE_DIR}/angle")
  set(OPENGL_ARCH ${MSVC_CXX_ARCHITECTURE_ID})
  set(OPENGL_BUILD_TYPE "$<$<CONFIG:Debug>:debug>$<$<CONFIG:Release>:release>")
  set(OPENGL_LIB_DIR "${ANGLE_DIR}/${OPENGL_ARCH}/${OPENGL_BUILD_TYPE}")
  set(OPENGL_LIB "${OPENGL_LIB_DIR}/${LIB_GLES_NAME}")
  set(EGL_LIB "${OPENGL_LIB_DIR}/${LIB_EGL_NAME}")
  set(ZLIB_LIB "${OPENGL_LIB_DIR}/${ZLIB_NAME}")
  
  target_link_directories(${PLUGIN_NAME} PUBLIC ${OPENGL_LIB_DIR} )
  target_link_libraries(${PLUGIN_NAME} PRIVATE flutter flutter_wrapper_plugin ${LIB_GLES_NAME}.lib ${LIB_EGL_NAME}.lib)
# List of absolute paths to libraries that should be bundled with the plugin
set(flutter_web_gl_bundled_libraries
  "${OPENGL_LIB}"
  "${EGL_LIB}"
  "${ZLIB_LIB}"
  PARENT_SCOPE
)