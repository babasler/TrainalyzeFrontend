cmake_minimum_required(VERSION 3.14)
project(trainalyze_flutter)

# The name of the executable created for the application.
set(BINARY_NAME "trainalyze_flutter")

# The unique application identifier for this application.
set(APPLICATION_ID "com.trainalyze.trainalyze_flutter")

# Explicitly opt in to modern CMake behaviors to avoid warnings.
cmake_policy(SET CMP0063 NEW)

# Define build configuration options.
get_property(IS_MULTICONFIG GLOBAL PROPERTY GENERATOR_IS_MULTI_CONFIG)
if(IS_MULTICONFIG)
  set(CMAKE_CONFIGURATION_TYPES "Debug;Profile;Release"
    CACHE STRING "" FORCE)
else()
  if(NOT CMAKE_BUILD_TYPE AND NOT CMAKE_CONFIGURATION_TYPES)
    set(CMAKE_BUILD_TYPE "Debug" CACHE
      STRING "Flutter build mode" FORCE)
    set_property(CACHE CMAKE_BUILD_TYPE PROPERTY STRINGS
      "Debug" "Profile" "Release")
  endif()
endif()

# Use Unicode for all projects.
add_definitions(-DUNICODE -D_UNICODE)

# Flutter library and tool build rules.
set(FLUTTER_MANAGED_DIR "${CMAKE_CURRENT_SOURCE_DIR}/flutter")

# Application build
add_executable(${BINARY_NAME}
  WIN32
  "runner/main.cpp"
  "runner/resource.h"
  "runner/runner.exe.manifest"
  "runner/Runner.rc"
  "runner/utils.cpp"
  "runner/utils.h"
  "runner/win32_window.cpp"
  "runner/win32_window.h"
)

# Apply the standard set of build settings.
target_compile_features(${BINARY_NAME} PUBLIC cxx_std_17)
target_compile_options(${BINARY_NAME} PRIVATE /W4 /WX /wd"4100")
target_compile_options(${BINARY_NAME} PRIVATE /EHsc)
target_compile_definitions(${BINARY_NAME} PRIVATE "_HAS_EXCEPTIONS=0")
target_compile_definitions(${BINARY_NAME} PRIVATE "$<$<CONFIG:Debug>:_DEBUG>")
target_compile_definitions(${BINARY_NAME} PRIVATE "UNICODE" "_UNICODE")

# Flutter bundle build
add_subdirectory(flutter)