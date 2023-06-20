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
  target_link_libraries(MathFunctions PUBLIC SqrtLibrary)
endif()
#target_link_libraries(MathFunctions PUBLIC tutorial_compiler_flags)

