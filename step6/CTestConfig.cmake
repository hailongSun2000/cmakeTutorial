#注意这个文件需要自己手动添加，并且需要使用"cmake --build ."，用于生成DartConfiguration.tcl

#首先，我们使用 set() 命令设置了 CTEST_PROJECT_NAME 变量，该变量表示当前所配置的 CTest 项目名称
#为 "CMakeTutorial"。随后，我们使用 CTEST_NIGHTLY_START_TIME 变量设置了测试执行时间为 
#EST 时间的午夜时刻（即 0 点）。

#接着，我们使用 CTEST_DROP_METHOD、CTEST_DROP_SITE 和 CTEST_DROP_LOCATION 
#变量配置了测试结果上传到 CDash 的方法和目标。具体来说，CTEST_DROP_METHOD 所设置的值为
#"http"，表示使用 HTTP 协议进行数据传输；CTEST_DROP_SITE 所设置的值为 "my.cdash.org"，
#表示将测试结果上传到指定的服务器地址；CTEST_DROP_LOCATION 所设置的值为 
#"/submit.php?project=CMakeTutorial"，表示上传数据的位置和所属项目名称。

#最后，我们使用 CTEST_DROP_SITE_CDASH 变量设置了是否将测试结果链接到 CDash 网站上。
#如果该变量的值为 TRUE，则测试结果链接会自动发送到所有订阅了当前项目的用户。
#如果该变量的值为 FALSE，则不会发送链接信息，但仍然可以在 CDash 网站上查看测试结果。
set(CTEST_PROJECT_NAME "CMakeTutorial")
set(CTEST_NIGHTLY_START_TIME "00:00:00 EST")

set(CTEST_DROP_METHOD "http")
set(CTEST_DROP_SITE "my.cdash.org")    #其实就是一个网址,还可看到其他用户的提交
set(CTEST_DROP_LOCATION "/submit.php?project=CMakeTutorial")
set(CTEST_DROP_SITE_CDASH TRUE)