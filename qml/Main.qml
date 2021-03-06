import QtQuick 2.8
import QtQuick.Window 2.2
import QtQuick.Dialogs 1.2
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.1

import "components/"

ApplicationWindow {
    id: window
    width: 340; height: 520; visible: true

    property QtObject menu
    property var menuPages: []
    property var userProfileData: Emile.readObject("user_profile_data")
    property bool isUserLoggedIn: Emile.readBool("is_user_logged_in")
    property bool isIOS: Qt.platform.os === "ios"
    property alias currentPage: pageStack.currentItem

    signal pageChanged()
    signal endSession()
    signal starSession(var userData)

    onIsUserLoggedInChanged: {
        Emile.saveData("is_user_logged_in", isUserLoggedIn);
    }
    onUserProfileDataChanged: {
        var userProfileDataTemp = Emile.readObject("user_profile_data");
        for (var prop in userProfileData) {
            if (userProfileData[prop] !== userProfileDataTemp[prop])
                Emile.saveObject("user_profile_data", userProfileData);
        }
        sendToken(Emile.readString("push_notification_token"));
    }
    onEndSession: {
        pageStack.clear();
        isUserLoggedIn = false;
        setIndexPage();
        var objectTemp = {};
        userProfileData = objectTemp;
    }
    onStarSession: {
        userProfileData = userData;
        isUserLoggedIn = true;
        setIndexPage();
    }

    function sortArrayByObjectKey(key) {
        var sortOrder = 1;
        if (key[0] === "-") {
            sortOrder = -1;
            key = key.substr(1);
        }
        return function (a,b) {
            var result = (a[key] < b[key]) ? -1 : (a[key] > b[key]) ? 1 : 0;
            return result * sortOrder;
        }
    }

    // slot connected with pushNotificationTokenListener in main.cpp
    function sendToken(token) {
        if (!token || !userProfileData || !userProfileData.id)
            return;
        var params = JSON.stringify({
            "post_message": {"push_notification_token": token}
        });
        // to solve first page request conflit
        var args = ({"source": appSettings.restService.baseUrl});
        var requestHttpTemp = Qt.createComponent(Qt.resolvedUrl("components/RequestHttp.qml")).createObject(window,args);
        requestHttpTemp.load("token_register/" + userProfileData.id, callbackTokenRegister, "POST", "application/json", params);
    }

    function pushNotificationUpdated(messageData) {
        //console.log("messageData receive in Main.qml: ");
        //console.log(messageData);
    }

    function callbackTokenRegister(status, response) {
        if (status === 200 && response && response.user) {
            Emile.saveObject("user_profile_data", response.user);
            Emile.saveData("push_notification_token", "");
        }
    }

    function alert(title, message, positiveButtonText, acceptedCallback, negativeButtonText, rejectedCallback) {
        messageDialog.title = title;
        messageDialog.informativeText = message;
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
        var menuPagesTemp = Emile.readObject("menuPages");
        // if the app pages is already saved, load from local as json
        if (menuPagesTemp && menuPagesTemp.menuPages) {
            menuPagesTemp = menuPagesTemp["menuPages"];
            menuPages = menuPagesTemp;
            return;
        }
        menuPagesTemp = [];
        var pageObject = {};
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
        menuPagesTemp.sort(sortArrayByObjectKey("order_priority"));
        menuPagesTemp.reverse();
        menuPages = menuPagesTemp;
        Emile.saveObject("menuPages", {"menuPages": menuPages});
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
        if (pageStack.depth >= 1)
            pageStack.replace(Qt.resolvedUrl(pageUrl), pageArgs);
        else
            pageStack.push(Qt.resolvedUrl(pageUrl), pageArgs);
    }

    function profileImageConfigure() {
        if (isIOS)
            iOSImagesGalleryComponent.createObject(window, {}).open();
        else
            androidGallery.open();
    }

    Component.onCompleted: setIndexPage();

    onClosing: {
        if (!isIOS) {
            close.accepted = false;
            if (pageStack.depth > 1)
                pageStack.pop();
            else if (pageStack.depth == 1)
                return;
            else
                Emile.minimizeApp();
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

    Connections {
        target: PostFile
        onFinished: {
            if (parseInt(statusCode) === 200 && response) {
                try {
                    // if the response is not a valid json string
                    // a exception will be throw by js
                    var objc = JSON.parse(response);
                    if (objc && typeof objc.user !== "undefined") {
                        Emile.saveObject("user_profile_data", objc.user);
                        userProfileData = objc.user;
                    }
                } catch(e) { }
            }
        }
    }

    Loader {
        id: menuLoader
        asynchronous: false
        active: isUserLoggedIn; source: "components/Menu.qml"
        onLoaded: {
            item.menuItemTextColor = appSettings.theme.colorAccent;
            item.menuBackgroundColor = appSettings.theme.colorPrimary;
            window.menu = item;
            toolBarLoader.active = true;
        }
    }

    Loader {
        id: toolBarLoader
        asynchronous: false
        active: false; source: "components/ToolBar/CustomToolBar.qml"
        onLoaded: window.header = toolBarLoader.item;
    }

    Component {
        id: iOSImagesGalleryComponent

        FileDialog {
            id: fileDialog
            folder: shortcuts.pictures
            onAccepted: {
                menu.userImageProfile = fileUrl;
                PostFile.postFile(appSettings.restService.baseUrl + "update_user_image/" + userProfileData.id, [fileUrl]);
                fileDialog.destroy();
            }
        }
    }

    Loader {
        active: !isIOS; asynchronous: active
        sourceComponent: Connections {
            target: androidGallery
            onImagePathSelected: {
                menu.userImageProfile = "file://"+imagePath;
                var url = appSettings.restService.baseUrl + "update_user_image/" + userProfileData.id;
                PostFile.postFile(url, [imagePath]);
            }
        }
    }

    RequestHttp {
        id: requestHttp
        source: appSettings.restService.baseUrl
    }

    Snackbar {
        id: snackbar
        z: pageStack.z + 100
    }

    Toast {
        id: toast
    }

    MessageDialog {
        id: messageDialog
        standardButtons: StandardButton.Ok|StandardButton.Cancel
    }

    StackView {
        id: pageStack
        focus: true; anchors.fill: parent
        Keys.onBackPressed: {
            if (messageDialog.visible)
                messageDialog.close();
            else if (pageStack.depth > 1)
                pageStack.pop();
            event.accepted = false;
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
