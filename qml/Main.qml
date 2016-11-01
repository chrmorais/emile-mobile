import QtQuick 2.7
import QtQuick.Window 2.0
import QtQuick.Dialogs 1.2
import QtQuick.Layouts 1.0
import QtQuick.Controls 2.0
import Qt.labs.settings 1.0

import "components/"
import "js/Utils.js" as Util

ApplicationWindow {
    id: window
    width: 380
    height: 620
    visible: true

    property bool isIOS: Qt.platform.os === "ios"

    property QtObject menu
    property int user_logged_in: 0
    property var user_profile_data: ({})

    // a array to store the app pages loaded after user loggin or startup
    property var menuPages: []

    // a reference to the current page in the application
    property alias currentPage: pageStack.currentItem

    signal pageChanged()

    function alert(title, message, positiveButtonText, acceptedCallback, negativeButtonText, rejectedCallback) {
        messageDialog.title = title
        messageDialog.informativeText = message

        if (acceptedCallback) {
            messageDialog.accepted.connect(function() {
                acceptedCallback()
            })
        }
        if (negativeButtonText && rejectedCallback) {
            messageDialog.rejected.connect(function() {
                rejectedCallback()
            })
        }

        messageDialog.open()
    }

    function isUserLoggedIn() {
        return true //parseInt(settings.user_logged_in) === 1
    }

    function pushPage(pageUrl, args) {
        pageStack.push(Qt.resolvedUrl(pageUrl), args)
        pageChanged()
    }

    function popPage() {
        pageStack.pop()
        pageChanged()
    }

    /**
      * iterate the plugins from crudModel to load all plugin pages.
      * Each plugin can define more of one page, so each page will be put into array
      * that will be available for menu on navigation drawer to display the app pages for the user
      */
    function loadMenuPages() {
        // pages already loaded ? return
        if (menuPages.length > 0)
            return
        var pageObject = {}
        for (var i = 0; i < crudModel.length; i++) { // from each plugin
            for (var j = 0; j < crudModel[i].pages.length; j++) { // iterate the pages from current plugin
                pageObject = crudModel[i].pages[j]
                // append the plugin config json - to turn available for the object page
                pageObject.configJson = crudModel[i]
                menuPages.push(pageObject)
            }
        }
    }

    /**
      * create a string with the qml page url to push in pagestack.
      * @param string pageUrl the url from qml page to push in pagestack
      * @param object args a object with property values to pass to page
      * @param bool clearPageStack a flag to define if clear pageStack
      */
    function setPage(pageUrl, args, clearPageStack) {
        var pageTemp = pageUrl || "pages/Login.qml"
        if (isUserLoggedIn()) {
            loadMenuPages()
            pageTemp = pageUrl || "pages/Index.qml"
            menuLoader.active = toolBarLoader.active = true
        }
        if (clearPageStack) {
            while (pageStack.depth > 1)
                pageStack.pop()
        }
        pageStack.replace(Qt.resolvedUrl(pageTemp), args || {})
    }

    Component.onCompleted: {
        setPage()

        // if is desktop, open window centralized
        if (!isIOS && Qt.platform.os !== "android") {
            setX(Screen.width / 2 - width / 2)
            setY(Screen.height / 2 - height / 2)
        }
    }

    Connections {
        target: header
        onActionExec: {
            switch (actionName) {
            case "goback":
                pageStack.pop()
                break
            case "openMenu":
                menu.open()
                break
            }
        }
    }

    Loader {
        id: menuLoader
        active: false
        source: "components/Menu.qml"
    }

    Loader {
        id: toolBarLoader
        active: false
        source: "components/ToolBar/CustomToolBar.qml"
        onLoaded: window.header = item
    }

    Settings {
        id: settings

        property alias user_profile_data: window.user_profile_data
        property alias user_logged_in: window.user_logged_in
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
        focus: true
        anchors.fill: parent

        Keys.onBackPressed: {
            if (pageStack.depth > 1)
                pageStack.pop()
            else
                event.accepted = false
        }

        pushEnter: Transition {
            PropertyAnimation {
                property: "opacity"
                from: 0
                to: 1
                duration: 450
            }
        }

        popExit: Transition {
            PropertyAnimation {
                property: "opacity"
                from: 1
                to: 0
                duration: 550
            }
        }
    }
}
