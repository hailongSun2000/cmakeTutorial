cmake_minimum_required(VERSION 3.10)
project(Tutorial VERSION 1.0)
add_executable(Tutorial tutorial.cxx)

#set(CMAKE_CXX_STANDARD 11)
#set(CMAKE_CXX_STANDARD_REQUIRED True)

configure_file(TutorialConfig.h.in TutorialConfig.h)
target_include_directories(Tutorial PUBLIC 
                           "${PROJECT_BINARY_DIR}"
                           #${EXTRA_INCLUDES}
                          )

add_subdirectory(MathFunctions)
target_link_libraries(Tutorial PUBLIC MathFunctions tutorial_compiler_flags)

#list(APPEND EXTRA_INCLUDES "${PROJECT_SOURCE_DIR}/MathFunctions")

add_library(tutorial_compiler_flags INTERFACE)

#tutorial_compiler_flags 是一个 INTERFACE 类型的目标，表示该目标只会影响依赖于它的其他目标
#而不会对自身产生影响。cxx_std_11 则是要添加的一个编译特性，表示使用 C++11 标准进行编译。
target_compile_features(tutorial_compiler_flags INTERFACE cxx_std_11)
