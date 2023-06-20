#cmake 文件是一组 CMake 命令和函数的集合，通常用于封装可重用的代码或变量，并将其打包为模块(Module)。
#这些模块可以在其他 CMake 构建脚本中通过 include() 命令引入并调用，以便在不同的项目中重复使用。

#CMakeLists.txt 文件则是一个顶层的 CMake 配置文件，用于定义一个项目的整体结构、编译选项和目标等信息。
#它通常包含一系列 CMake 命令和参数，例如 project()、add_executable() 和 target_link_libraries()
#等，用于生成 Makefile 或其他构建系统所需要的代码。

add_executable(MakeTable MakeTable.cxx)
target_link_libraries(MakeTable PRIVATE tutorial_compiler_flags)
add_custom_command(
    OUTPUT ${CMAKE_CURRENT_BINARY_DIR}/Table.h
    COMMAND MakeTable ${CMAKE_CURRENT_BINARY_DIR}/Table.h
    DEPENDS MakeTable
)