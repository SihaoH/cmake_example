set(NAME_CN "CMake例子")

# 设置安装包的信息（通用）
set(CPACK_PACKAGE_NAME ${TARGET})
set(CPACK_PACKAGE_VERSION "1.0")
set(CPACK_PACKAGE_DESCRIPTION_SUMMARY "")
set(CPACK_PACKAGE_INSTALL_DIRECTORY ${TARGET})

# 设置IFW安装包所支持的信息，比如将维护工具更名为Uninstall.exe
# https://doc.qt.io/qtinstallerframework
set(CPACK_GENERATOR IFW)
set(CPACK_IFW_VERBOSE ON)
set(CPACK_IFW_PACKAGE_NAME ${NAME_CN})
set(CPACK_IFW_PACKAGE_TITLE ${NAME_CN})
set(CPACK_IFW_PACKAGE_VERSION "1.0")
set(CPACK_IFW_PACKAGE_WIZARD_STYLE "Modern")
set(CPACK_IFW_PACKAGE_MAINTENANCE_TOOL_NAME "Uninstall")
set(CPACK_IFW_PACKAGE_MAINTENANCE_TOOL_INI_FILE "Uninstall.ini")
# installscript.js包含了两个模块的东西，Controller和Component，本应分开两个js文件，这里为了省事就合成一个了
set(CPACK_IFW_PACKAGE_CONTROL_SCRIPT ${CMAKE_CURRENT_SOURCE_DIR}/installscript.js)
set(CMAKE_INSTALL_DEFAULT_COMPONENT_NAME ${TARGET})

# 从环境变量中取得Qt的安装路径，如果环境变量没有Wis_Qt的值，这里会为空
file(TO_CMAKE_PATH $ENV{Wis_Qt}/.. qt_install_dir)

# “部署”指的是打包行为，指定要打包的东西
# 部署可执行程序，以及依赖的dll
install(TARGETS ${TARGET} RUNTIME DESTINATION .)
install(FILES ${qt_install_dir}/bin/libEGL.dll DESTINATION .)
install(FILES ${qt_install_dir}/bin/libGLESv2.dll DESTINATION .)
install(FILES ${qt_install_dir}/plugins/platforms/qwindows.dll DESTINATION ./platforms)

# 手动部署qml所需的dll，并且排除pdb文件
install(DIRECTORY ${qt_install_dir}/qml/Qt DESTINATION . PATTERN "*.pdb" EXCLUDE)
install(DIRECTORY ${qt_install_dir}/qml/QtQml DESTINATION . PATTERN "*.pdb" EXCLUDE)
install(DIRECTORY ${qt_install_dir}/qml/QtQuick DESTINATION . PATTERN "*.pdb" EXCLUDE)
install(DIRECTORY ${qt_install_dir}/qml/QtQuick.2 DESTINATION . PATTERN "*.pdb" EXCLUDE)

# 为了使用cpack相关命令（函数），必须先include(CPack)
include(CPack)
# 打包工具使用QtIFW
include(CPackIFW)

# 指定安装组件，否则installscript.js不生效
# 不知道为啥，这句必须在install(TARGETS ……)的下面
cpack_add_component(${TARGET})
cpack_ifw_configure_component(${TARGET} FORCED_INSTALLATION
    SCRIPT "${CMAKE_CURRENT_SOURCE_DIR}/installscript.js")

set(APP "\$ENV{DESTDIR}\${CMAKE_INSTALL_PREFIX}/${TARGET}.exe")
set(DIRS "\${qt_install_dir}/bin" "\${qt_install_dir}/lib")
# 自动查找依赖的qll并打包，像qml那种都动态加载的不会被扫描到，所以上面手动部署了
install(CODE
    "include(BundleUtilities)
    set(BU_CHMOD_BUNDLE_ITEMS TRUE)
    fixup_bundle(\"${APP}\"   \"\"   \"${DIRS}\" IGNORE_ITEM \"\")")
