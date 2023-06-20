#cmake_minimum_required(VERSION 3.10)
cmake_minimum_required(VERSION 3.15)

project(Tutorial VERSION 1.0)

set(CMAKE_DEBUG_POSTFIX d)

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

set_target_properties(Tutorial PROPERTIES DEBUG_POSTFIX ${CMAKE_DEBUG_POSTFIX})

target_link_libraries(Tutorial PUBLIC MathFunctions tutorial_compiler_flags)

target_include_directories(Tutorial PUBLIC 
                           "${PROJECT_BINARY_DIR}"
                           #${EXTRA_INCLUDES}
                          )

#list(APPEND EXTRA_INCLUDES "${PROJECT_SOURCE_DIR}/MathFunctions")

install(TARGETS Tutorial DESTINATION bin)
install(FILES "${PROJECT_BINARY_DIR}/TutorialConfig.h" DESTINATION include)


#cmake build后会在同级"step$n_build"目录中生成CTestTestfile.cmake
#使用ctest命令后会生成Testing目录
#enable_testing()
include(CTest)

add_test(NAME Runs COMMAND Tutorial 25)


#首先，我们调用 add_test() 命令来定义一个名为 Usage 的测试。在这个命令中，我们使用 NAME 参数
#来指定测试名称，使用 COMMAND 参数来指定要执行的命令。在这个例子中，我们要测试的是名为 Tutorial 的
#可执行文件，因此我们将其作为 COMMAND 参数的值。

#接着，我们使用 set_tests_properties() 命令为 Usage 测试设置属性。在这个命令中，
#我们使用 PROPERTIES 参数来指定要设置的属性，其中 PASS_REGULAR_EXPRESSION 表示
#用于匹配测试输出内容的正则表达式。具体来说，我们使用该表达式来验证 Tutorial 执行时是否输出了
#特定格式的帮助信息，以便判断程序的使用方法是否正确。

#需要注意的是，当执行 ctest 命令时，所有通过 add_test() 定义的测试都会被自动运行，
#并检查测试的执行结果是否符合预期。在本例中，如果 Tutorial 输出的内容不符合正则表达式所描述的格式，
#那么该测试就会失败，使得整个项目构建失败。
add_test(NAME Usage COMMAND Tutorial)
set_tests_properties(Usage PROPERTIES PASS_REGULAR_EXPRESSION "Usage:.*number")

add_test(NAME StandardUse COMMAND Tutorial 4)
set_tests_properties(StandardUse PROPERTIES PASS_REGULAR_EXPRESSION "4 is 2")

function(do_test target arg result)
  add_test(NAME Comp${arg} COMMAND ${target} ${arg})
  set_tests_properties(Comp${arg}
    PROPERTIES PASS_REGULAR_EXPRESSION ${result}
    )
endfunction()

# do a bunch of result based tests
do_test(Tutorial 4 "4 is 2")
do_test(Tutorial 9 "9 is 3")
do_test(Tutorial 5 "5 is 2.236")
do_test(Tutorial 7 "7 is 2.645")
do_test(Tutorial 25 "25 is 5")
do_test(Tutorial -25 "-25 is (-nan|nan|0)")
do_test(Tutorial 0.0001 "0.0001 is 0.01")

include(InstallRequiredSystemLibraries)
set(CPACK_RESOURCE_FILE_LICENSE "${CMAKE_CURRENT_SOURCE_DIR}/License.txt")
set(CPACK_PACKAGE_VERSION_MAJOR "${Tutorial_VERSION_MAJOR}")
set(CPACK_PACKAGE_VERSION_MINOR "${Tutorial_VERSION_MINOR}")
set(CPACK_SOURCE_GENERATOR "TGZ")
include(CPack)


#首先，我们使用 set() 命令设置了 CMAKE_ARCHIVE_OUTPUT_DIRECTORY 变量，该变量指定了静态库输出路径为 
#${PROJECT_BINARY_DIR}，${PROJECT_BINARY_DIR} 表示保存项目构建结果的二进制目录，通常位于项目根目录下的 build/ 目录中。

#接着，我们使用 CMAKE_LIBRARY_OUTPUT_DIRECTORY 变量设置了动态库输出路径为 ${PROJECT_BINARY_DIR}，即与静态库相同的路径。

#最后，我们使用 CMAKE_RUNTIME_OUTPUT_DIRECTORY 变量设置了可执行文件输出路径为 ${PROJECT_BINARY_DIR}，
#也就是将可执行文件生成到与库文件相同的目录中。

#通过以上配置，我们可以将所有生成的编译结果统一存放在项目的 build/ 目录下，方便管理和部署。此外，该配置还可以
#保证不同类型的目标（如静态库、动态库和可执行文件）的生成路径相同，避免了路径错误导致的链接错误等问题。
set(CMAKE_ARCHIVE_OUTPUT_DIRECTORY "${PROJECT_BINARY_DIR}")
set(CMAKE_LIBRARY_OUTPUT_DIRECTORY "${PROJECT_BINARY_DIR}")
set(CMAKE_RUNTIME_OUTPUT_DIRECTORY "${PROJECT_BINARY_DIR}")

option(BUILD_SHARED_LIBS "Build using shared libraries" ON)

install(EXPORT MathFunctionsTargets 
  FILE MathFunctionsTargets.cmake 
  DESTINATION lib/cmake/MathFunctions
  )

include(CMakePackageConfigHelpers)
configure_package_config_file(${CMAKE_CURRENT_SOURCE_DIR}/Config.cmake.in
  "${CMAKE_CURRENT_BINARY_DIR}/MathFunctionsConfig.cmake"
  INSTALL_DESTINATION "lib/cmake/example"
  NO_SET_AND_CHECK_MACRO
  NO_CHECK_REQUIRED_COMPONENTS_MACRO
  )

write_basic_package_version_file(
  "${CMAKE_CURRENT_BINARY_DIR}/MathFunctionsConfigVersion.cmake"
  VERSION "${Tutorial_VERSION_MAJOR}.${Tutorial_VERSION_MINOR}"
  COMPATIBILITY AnyNewerVersion
  )

install(FILES
  ${CMAKE_CURRENT_BINARY_DIR}/MathFunctionsConfig.cmake
  ${CMAKE_CURRENT_BINARY_DIR}/MathFunctionsConfigVersion.cmake
  DESTINATION lib/cmake/MathFunctions
  )

export(EXPORT MathFunctionsTargets
  FILE "${CMAKE_CURRENT_BINARY_DIR}/MathFunctionsTargets.cmake"
  )