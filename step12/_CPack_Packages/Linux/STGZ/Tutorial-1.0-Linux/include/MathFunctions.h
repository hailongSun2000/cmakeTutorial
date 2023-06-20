#pragma once


// 定义了一个命名空间 mathfunctions，其中包含了一个声明为 DECLSPEC 的函数 sqrt(double x)。
// 同时，它还针对不同操作系统平台和编译模式，使用条件编译技术分别设置了 DECLSPEC 宏的值。

// 首先通过 #if defined(_WIN32) 判断当前是否在 Windows 平台下编译代码。如果是，则进入第二层 
// #if defined(EXPORTING_MYMATH) 判断，该判断检查是否定义了 EXPORTING_MYMATH 宏。
// 如果有，则将 DECLSPEC 宏的值设为 __declspec(dllexport)；否则将其设为 __declspec(dllimport)。

// 需要注意的是，Windows 系统中的 DLL 库文件需要区分导出符号（export）和导入符号（import）。
// 在编写 DLL 库时，我们需要指定需要对外导出的函数或数据，以便其他程序可以调用；
// 而在使用 DLL 库的程序中，则需要声明这些函数或数据的导入方式，并且使用宏等手段处理导入符号与导出符号的差异。

// 在非 Windows 平台下，由于没有 DLL 库的概念，因此无需使用 __declspec(dllexport) 或 
// __declspec(dllimport) 修饰符。因此，在 else 分支中，直接将 DECLSPEC 宏的值设为空即可。

// 最后，通过 namespace mathfunctions 将函数 sqrt 放在该命名空间下，以避免与其他函数或变量产生冲突。

// 这段代码主要用于实现跨平台的库文件编译和链接。通过使用条件编译技术，我们可以在 Windows 和
// 非 Windows 平台下分别定义相应的导出和导入方式，并保证在不同环境中生成正确的 DLL 库文件。
#if defined(_WIN32)
#  if defined(EXPORTING_MYMATH)
#    define DECLSPEC __declspec(dllexport)
#  else
#    define DECLSPEC __declspec(dllimport)
#  endif
#else // non windows
#  define DECLSPEC
#endif

namespace mathfunctions {
double DECLSPEC sqrt(double x);
}

//namespace mathfunctions {
//double sqrt(double x);
//}