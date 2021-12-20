# CMake项目例子
从公司项目中扒了一点CMake的关键语句，主要包含了源码管理、编译、打包、安装等步骤；
具体内容在CMakeLists.txt都有注释

## 源码
源码都放在了`src`目录下，当然，结构可以自己随便调整，在CMakeLists.txt里修改即可

## 构建
`build_vs2017.bat`包含了简单了构建命令，即创建build目录，然后cmake当前目录下的CMakeLists.txt，目前使用的是vs2017

## 编译
构建后生成vs2017的解决方案文件（即sln），基本上编码、编译、调试和打包的操作都是在vs里进行

##  打包
https://doc.qt.io/qtinstallerframework/
使用了QtIFW工具，自由度比较高，安装过程任何步骤都可以自定义
