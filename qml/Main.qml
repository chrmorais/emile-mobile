import QtQuick 2.7
import QtQuick.Window 2.0
import QtQuick.Dialogs 1.2
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.0
import Qt.labs.settings 1.0

import "components/"
import "js/Utils.js" as Util

ApplicationWindow {
    id: window
    width: 380; height: 620; visible: true

    property QtObject menu
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

    function isUserLoggedIn() {
        return true //parseInt(settings.isUserLoggedIn) === 1
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
        var pageObject = {}
        for (var i = 0; i < crudModel.length; i++) {
            for (var j = 0; j < crudModel[i].pages.length; j++) {
                pageObject = crudModel[i].pages[j];
                if (!pageObject.menu_name)
                    continue;
                if (!pageObject.order_priority)
                    pageObject.order_priority = 0;
                // append the plugin config json
                pageObject.configJson = crudModel[i];
                menuPages.push(pageObject);
            }
        }
        menuPages.sort(Util.sortArrayByObjectKey("order_priority"));
        menuPages.reverse();
    }

    function setPage(pageUrl, args, clearPageStack) {
        var pageTemp = pageUrl || "/plugins/Session/Login.qml"
        if (isUserLoggedIn()) {
            loadMenuPages();
            pageTemp = pageUrl || "/plugins/Session/Index.qml";
            menuLoader.active = toolBarLoader.active = true;
        }
        if (clearPageStack) {
            while (pageStack.depth > 1)
                pageStack.pop();
        }
        pageStack.replace(Qt.resolvedUrl(pageTemp), args || {});
    }

    Component.onCompleted: {
        setPage();
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
        active: false; source: "components/Menu.qml"
        onLoaded: {
            item.menuItemLabelColor = appSettings.theme.textColorPrimary
            item.menuItemBackgroundColor = appSettings.theme.colorPrimary
        }
    }

    Loader {
        id: toolBarLoader
        active: false; source: "components/ToolBar/CustomToolBar.qml"
        onLoaded: window.header = item
    }

    Settings {
        id: settings
        property alias isUserLoggedIn: window.isUserLoggedIn
        property alias userProfileData: window.userProfileData
    }

    JSONListModel {
        id: jsonListModel
        source: appSettings.rest_service.baseUrl
    }

    MessageDialog {
        id: messageDialog
        standardButtons: StandardButton.Ok|StandardButton.Cancel
    }

    StackView {
        id: pageStack
        focus: true; anchors.fill: parent

        Keys.onBackPressed: {
            if (pageStack.depth > 1)
                pageStack.pop();
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
