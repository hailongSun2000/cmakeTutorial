#cmake_minimum_required(VERSION 3.10)
cmake_minimum_required(VERSION 3.15)

project(Tutorial VERSION 1.0)

add_library(tutorial_compiler_flags INTERFACE)

#tutorial_compiler_flags 是一个 INTERFACE 类型的目标，表示该目标只会影响依赖于它的其他目标
#而不会对自身产生影响。cxx_std_11 则是要添加的一个编译特性，表示使用 C++11 标准进行编译。
target_compile_features(tutorial_compiler_flags INTERFACE cxx_std_11)

#set(CMAKE_CXX_STANDARD 11)
#set(CMAKE_CXX_STANDARD_REQUIRED True)

#首先，我们定义了一个名为 gcc_like_cxx 的变量，该变量使用了 CMake 的 COMPILE_LANG_AND_ID 
#生成器表达式来指定编译语言为 CXX，并且编译器类型可以是 ARMClang、AppleClang、Clang、GNU 
#或 LCC 中的任意一种。这里使用 <...> 括起来的是一种逻辑运算符，表示只有当条件成立时才会执行后面的表达式
#其中 BUILD_INTERFACE 表示目标需要被本项目或其依赖项重新编译时应采用的选项。

#接着，我们定义了一个名为 msvc_cxx 的变量，该变量使用了与上述类似的表达式来指定编译器类型为 MSVC
#这里我们使用了 MSVC 特有的编译器选项 -W3，它与 GCC 中的 -Wall 类似，表示启用所有的警告信息。

#最后，我们使用 target_compile_options() 命令将编译选项添加到 tutorial_compiler_flags 目标中
#在这个命令中，我们使用了 CMake 的逻辑运算符 $<...> 来根据不同的编译器类型指定不同的编译选项
#具体来说，如果编译器类型是 gcc_like_cxx 中定义的一种，则使用 -Wall、-Wextra、-Wshadow、
#-Wformat=2 和 -Wunused 这些选项；否则，如果编译器类型为 msvc_cxx 中定义的 MSVC，
#则使用 -W3 这个选项。
set(gcc_like_cxx "$<COMPILE_LANG_AND_ID:CXX,ARMClang,AppleClang,Clang,GNU,LCC>")
set(msvc_cxx "$<COMPILE_LANG_AND_ID:CXX,MSVC>")
target_compile_options(tutorial_compiler_flags INTERFACE
  "$<${gcc_like_cxx}:$<BUILD_INTERFACE:-Wall;-Wextra;-Wshadow;-Wformat=2;-Wunused>>"
  "$<${msvc_cxx}:$<BUILD_INTERFACE:-W3>>"
)

configure_file(TutorialConfig.h.in TutorialConfig.h)

add_subdirectory(MathFunctions)

add_executable(Tutorial tutorial.cxx)

target_link_libraries(Tutorial PUBLIC MathFunctions tutorial_compiler_flags)

target_include_directories(Tutorial PUBLIC 
                           "${PROJECT_BINARY_DIR}"
                           #${EXTRA_INCLUDES}
                          )

#list(APPEND EXTRA_INCLUDES "${PROJECT_SOURCE_DIR}/MathFunctions")


