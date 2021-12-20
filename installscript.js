function Controller() {
    // 隐藏创建开始菜单快捷方式的页面，因为创建不了，暂时不知道原因
    installer.setDefaultPageVisible(QInstaller.StartMenuSelection, false)
}

Controller.prototype.TargetDirectoryPageCallback = function () {
    // 指定默认的安装路径
    var widget = gui.currentPageWidget()
    if (widget) {
        widget.TargetDirectoryLineEdit.setText("C:\\Program Files\\cmake_example")
    }
}

function Component() {}

// 创建桌面快捷方式
Component.prototype.createOperations = function () {
    component.createOperations()
    component.addOperation("CreateShortcut", "@TargetDir@\\cmake_example.exe", "@DesktopDir@\\@Name@.lnk")
}

