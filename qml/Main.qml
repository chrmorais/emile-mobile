import QtQuick 2.7
import QtQuick.Window 2.0
import QtQuick.Dialogs 1.2
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.0
import QtQuick.Dialogs 1.2 as QuickDialogs

import "components/"
import "js/Utils.js" as Util

ApplicationWindow {
    id: window
    width: 340; height: 520; visible: true

    property QtObject menu
    property QtObject iOSImagesGallery
    property var menuPages: []
    property var userProfileData: Emile.readObject("user_profile_data")
    property bool isUserLoggedIn: Emile.readBool("is_user_logged_in")
    property bool isIOS: Qt.platform.os === "ios"
    property alias currentPage: pageStack.currentItem

    signal pageChanged()
    signal endSession()
    signal starSession(var userData)

    onUserProfileDataChanged: {
        var userProfileDataTemp = Emile.readObject("user_profile_data");
        for (var prop in userProfileData) {
            if (userProfileData[prop] !== userProfileDataTemp[prop])
                Emile.saveObject("user_profile_data", userProfileData);
        }
        submitTokenToServer();
    }

    onIsUserLoggedInChanged: {
        Emile.saveData("is_user_logged_in", isUserLoggedIn);
    }

    onEndSession: {
        isUserLoggedIn = false;
        var objectTemp = {};
        userProfileData = objectTemp;
        setIndexPage();
    }

    onStarSession: {
        isUserLoggedIn = true;
        userProfileData = userData;
        setIndexPage();
    }

    // slot connected with pushNotificationTokenListener in main.cpp
    function sendToken(token) {
        submitTokenToServer(token);
    }

    function submitTokenToServer(token) {
        var savedToken = Emile.readData("push_notification_token");

        if (savedToken && !token || savedToken !== token)
            token = savedToken;

        if (!token || !userProfileData || !userProfileData.id || token === userProfileData.push_notification_token)
            return;

        var params = {
            "post_message": { "push_notification_token": token }
        };

        jsonListModel.requestMethod = "POST";
        jsonListModel.contentType = "application/json";
        jsonListModel.source += "/token_register/"+userProfileData.id;
        jsonListModel.requestParams = JSON.stringify(params);
        jsonListModel.load(function(result, status) {
            Emile.saveObject("user_profile_data", result.user);
        });
    }

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

    function setIndexPage() {
        var pageArgs = {};
        var pageUrl = "/plugins/Session/Login.qml";
        if (isUserLoggedIn) {
            loadMenuPages();
            if (window.menu) window.menu.enabled = true;
            pageArgs = menuPages.length > 0 ? menuPages[0] : {};
            pageUrl = "/plugins/WallMessage/Wall.qml";
        }
        while (pageStack.depth > 1)
            pageStack.pop();
        if (pageStack.depth >= 1)
            pageStack.replace(Qt.resolvedUrl(pageUrl), pageArgs);
        else
            pageStack.push(Qt.resolvedUrl(pageUrl), pageArgs);
    }

    function profileImageConfigure() {
        if (isIOS)
            iOSImagesGallery.open();
        else
            androidGallery.open();
    }

    Component.onCompleted: setIndexPage();

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

    Connections {
        target: PostFile
        onFinished: {
            if (parseInt(statusCode) === 200 && result) {
                var response = JSON.parse(result);
                userProfileData.image_path = response.image_path;
                Emile.saveObject("user_profile_data", response.user);
                userProfileData = response.user;
            }
        }
    }

    Loader {
        id: menuLoader
        asynchronous: false
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
        asynchronous: false
        onLoaded: iOSImagesGallery = item
        sourceComponent: QuickDialogs.FileDialog {
            folder: shortcuts.pictures
            sidebarVisible: false
            onAccepted: {
                menu.userImageProfile = "file://"+fileUrl;
                var url = appSettings.rest_service.baseUrl + "/update_user_image/" + userProfileData.id;
                PostFile.postFile(url, [fileUrl]);
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
                var url = appSettings.rest_service.baseUrl + "/update_user_image/" + userProfileData.id;
                PostFile.postFile(url, [imagePath]);
            }
        }
    }

    JSONListModel {
        id: jsonListModel
        source: appSettings.rest_service.baseUrl
        onStateChanged: if (state === "ready" || state === "error") jsonListModel.source = appSettings.rest_service.baseUrl;
    }

    Snackbar {
        id: snackbar
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

        Keys.onReleased: {
            if (event.key === Qt.Key_Back) {
                if (pageStack.depth > 1) {
                    popPage();
                    event.accepted = false;
                } else {
                    if (!isIOS)
                        Emile.minimizeApp();
                    event.accepted = true;
                }
            }
        }

        pushEnter: Transition {
            PropertyAnimation {
                property: "opacity"
                from: 0; to: 1; duration: 450
            }
        }

        popExit: Transition {
            PropertyAnimation {
                property: "opacity"
                from: 1; to: 0; duration: 450
            }
        }
    }
}
