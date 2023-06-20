add_library(MathFunctions MathFunctions.cxx)

target_include_directories(MathFunctions INTERFACE ${CMAKE_CURRENT_SOURCE_DIR})

option(USE_MYMATH "Use tutorial provided math implementation" ON)
if(USE_MYMATH)

  #MathFunctions 是要添加预定义宏的目标，PRIVATE 则表示这个预定义宏只会影响当前目标本身
  #而不会传递给依赖它的其他目标。USE_MYMATH 则是要添加的预定义宏的名称。
  target_compile_definitions(MathFunctions PRIVATE "USE_MYMATH")
  add_library(SqrtLibrary STATIC mysqrt.cxx)

  #target_link_libraries() 命令的顺序很重要我们先将 SqrtLibrary 与 
  #tutorial_compiler_flags 进行链接，再将 MathFunctions 与 SqrtLibrary 进行链接
  #这样一来，当其他目标依赖于 MathFunctions 时，它们会自动继承 SqrtLibrary 中
  #定义的函数和 tutorial_compiler_flags 提供的编译特性或标准。
  target_link_libraries(SqrtLibrary PUBLIC tutorial_compiler_flags)
  #第三章是PUBLIC，一直到第七章才在TODO里面明确改成PRIVATE，但是官方源码在第五章时改为了PRIVATE
  #target_link_libraries(MathFunctions PUBLIC SqrtLibrary)

  include(CheckCXXSourceCompiles)

  check_cxx_source_compiles("
    #include <cmath>
    int main(){
      std::log(1.0)
      return 0;
    }
  " HAVE_LOG)

  check_cxx_source_compiles("
    #inlcude <cmath>
    int main(){
      std::exp(1.0)
      return 0;
    }
  " HAVE_EXP)

  if(HAVE_LOG AND HAVE_EXP)
    target_compile_definitions(SqrtLibrary PRIVATE "HAVE_LOG" "HAVE_EXP")
  endif()

  target_link_libraries(MathFunctions PRIVATE SqrtLibrary)
endif()
#target_link_libraries(MathFunctions PUBLIC tutorial_compiler_flags)


#首先，我们定义了一个名为 installable_libs 的变量，该变量包含了要安装的目标列表。
#在这个例子中，我们将 MathFunctions 和 tutorial_compiler_flags 两个目标添加到了列表中，
#并使用了 if() 条件语句判断是否存在 SqrtLibrary 目标。如果存在，则将 SqrtLibrary 
#目标也添加到了 installable_libs 列表中。

#接着，我们使用 install() 命令将 installable_libs 中的所有目标安装到指定位置。
#在这个命令中，我们使用了 CMake 的变量展开（variable expansion）功能 ${...} 
#来表示要安装的目标列表，并使用 DESTINATION 关键字来指定安装目录。

#需要注意的是，install() 命令只有在执行 make install 命令时才会真正执行。
#在 CMakeLists.txt 文件中，它通常被用于定义安装规则，以便在项目构建完成后
#可以方便地将生成的文件复制到系统的标准目录或自定义目录中去。

set(installable_libs MathFunctions tutorial_compiler_flags)
if(TARGET SqrtLibrary)
  list(APPEND installable_libs SqrtLibrary)
endif()
install(TARGETS ${installable_libs} DESTINATION lib)
install(FILES MathFunctions.h DESTINATION include)


