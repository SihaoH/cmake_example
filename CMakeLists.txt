cmake_minimum_required(VERSION 3.15)

project(cmake_example LANGUAGES CXX)

set(CMAKE_INCLUDE_CURRENT_DIR ON)
set(CMAKE_AUTOMOC ON)
set(CMAKE_AUTORCC ON)

find_package(Qt5 COMPONENTS Core Widgets Quick REQUIRED)

# 添加头文件的搜索路径
include_directories(src)

set(TARGET ${PROJECT_NAME})
set(SOURCES src/main.cpp)

# 指定从源码编译输出为可执行程序
# 如果要编译输出dll，使用add_library命令
add_executable(
    ${TARGET}
    ${SOURCES}
    src/qml/qml.qrc)

target_link_libraries(${TARGET}
    Qt5::Core
    Qt5::Widgets
    Qt5::Quick)

# 设置VS项目的工作目录，即可执行程序的根路径（默认是.sln的目录）
set_target_properties(${TARGET} PROPERTIES VS_DEBUGGER_WORKING_DIRECTORY
    ${PROJECT_BINARY_DIR}/${CMAKE_CFG_INTDIR})

# 设置Release版本的程序不显示控制台
if(${CMAKE_CXX_COMPILER} MATCHES ".*/(g\\+\\+)(\\..*)")
    set_target_properties(${TARGET} PROPERTIES LINK_FLAGS_RELEASE "-mwindows")
elseif(${CMAKE_CXX_COMPILER} MATCHES ".*/(cl)(\\..*)")
    set_target_properties(${TARGET} PROPERTIES LINK_FLAGS_RELEASE "/SUBSYSTEM:WINDOWS /ENTRY:mainCRTStartup")
endif()

# 打包安装
include(Installer.cmake)
