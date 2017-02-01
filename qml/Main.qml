import QtQuick 2.7
import QtQuick.Window 2.0
import QtQuick.Dialogs 1.2
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.0
import Qt.labs.settings 1.0
import QtQuick.Dialogs 1.2 as QuickDialogs

import "components/"
import "js/Utils.js" as Util

ApplicationWindow {
    id: window
    width: 340; height: 520; visible: true

    property QtObject menu
    property QtObject iOSImagesGallery
    property var menuPages: []
    property var userProfileData: {}
    property bool isUserLoggedIn: false
    property bool isIOS: Qt.platform.os === "ios"
    property alias currentPage: pageStack.currentItem

    signal pageChanged()

    function alert(title, message, positiveButtonText, acceptedCallback, negativeButtonText, rejectedCallback) {
        messageDialog.title = title
        messageDialog.informativeText = message

        if (acceptedCallback) {
            messageDialog.accepted.connect(function() {
                acceptedCallback();
            });
        }
        if (negativeButtonText && rejectedCallback) {
            messageDialog.rejected.connect(function() {
                rejectedCallback();
            });
        }

        messageDialog.open();
    }

    function pushPage(pageUrl, args) {
        pageStack.push(Qt.resolvedUrl(pageUrl), args);
        pageChanged();
    }

    function popPage() {
        pageStack.pop();
        pageChanged();
    }

    function loadMenuPages() {
        if (menuPages.length > 0)
            return;
        var pageObject = {};
        var menuPagesTemp = [];
        for (var i = 0; i < crudModel.length; i++) {
            for (var j = 0; j < crudModel[i].pages.length; j++) {
                pageObject = crudModel[i].pages[j];
                if (!pageObject.menu_name)
                    continue;
                if (!pageObject.order_priority)
                    pageObject.order_priority = 0;
                // append the plugin config json
                pageObject.configJson = crudModel[i];
                menuPagesTemp.push(pageObject);
            }
        }
        menuPagesTemp.sort(Util.sortArrayByObjectKey("order_priority"));
        menuPagesTemp.reverse();
        menuPages = menuPagesTemp;
    }

    function setIndexPage(clearPageStack) {
        var pageUrl = "/plugins/Session/Login.qml";
        if (isUserLoggedIn) {
            loadMenuPages();
            if (window.menu) window.menu.enabled = true;
            pageUrl = "/plugins/WallMessage/Wall.qml";
        }
        if (clearPageStack) {
            while (pageStack.depth > 1)
                pageStack.pop();
        }
        pageStack.replace(Qt.resolvedUrl(pageUrl), {});
    }

    function profileImageConfigure() {
        if (isIOS)
            iOSImagesGallery.open();
        else
            androidGallery.open();
    }

    Component.onCompleted: {
        setIndexPage();
        if (!isIOS && Qt.platform.os !== "android") {
            setX(Screen.width / 2 - width / 2);
            setY(Screen.height / 2 - height / 2);
        }
    }

    Connections {
        target: header
        onActionExec: {
            switch (actionName) {
            case "goback":
                popPage();
                break;
            case "openMenu":
                menu.open();
                break;
            }
        }
    }

    Loader {
        id: menuLoader
        asynchronous: true
        active: isUserLoggedIn; source: "components/Menu.qml"
        onLoaded: {
            window.menu = item
            window.menu.userInfoTextColor = appSettings.theme.colorPrimary
            window.menu.menuItemTextColor = appSettings.theme.colorPrimary
            window.menu.menuBackgroundColor = appSettings.theme.colorWindowBackground
            toolBarLoader.active = true
        }
    }

    Loader {
        id: toolBarLoader
        asynchronous: false
        active: false; source: "components/ToolBar/CustomToolBar.qml"
        onLoaded: {
            window.header = toolBarLoader.item
            window.header.toolBarColor = appSettings.theme.colorPrimary
            window.header.defaultTextColor = appSettings.theme.colorHintText
        }
    }

    Loader {
        active: isIOS
        asynchronous: active
        onLoaded: iOSImagesGallery = item
        sourceComponent: QuickDialogs.FileDialog {
            folder: shortcuts.pictures
            sidebarVisible: false
            onAccepted: {
                menu.userImageProfile = "file://"+iOSImagesGallery.fileUrl;
                // implementar upload para o serviço rest
            }
        }
    }

    Loader {
        active: !isIOS && Qt.platform.os === "android"
        asynchronous: active
        sourceComponent: Connections {
            target: androidGallery
            onImagePathSelected: {
                menu.userImageProfile = "file://"+imagePath;
                // implementar upload para o serviço rest
            }
        }
    }

    Settings {
        id: settings
        property alias isUserLoggedIn: window.isUserLoggedIn
        property alias userProfileData: window.userProfileData
    }

    JSONListModel {
        id: jsonListModel
        source: appSettings.rest_service.baseUrl
        onStateChanged: if (state === "ready" || state === "error") jsonListModel.source = appSettings.rest_service.baseUrl;
    }

    Toast {
        id: toast
    }

    MessageDialog {
        id: messageDialog
        standardButtons: StandardButton.Ok|StandardButton.Cancel
        property color green: "green"
        property color darkGreen: "#c5e1a5"
    }

    StackView {
        id: pageStack
        focus: true; anchors.fill: parent

        Keys.onBackPressed: {
            if (pageStack.depth > 1)
                popPage();
            else
                event.accepted = false;
        }

        pushEnter: Transition {
            PropertyAnimation {
                property: "opacity"
                from: 0; to: 1; duration: 350
            }
        }

        popExit: Transition {
            PropertyAnimation {
                property: "opacity"
                from: 1; to: 0; duration: 350
            }
        }
    }
}
