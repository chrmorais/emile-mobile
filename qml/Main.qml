import QtQuick 2.7
import QtQuick.Dialogs 1.2
import QtQuick.Layouts 1.0
import QtQuick.Controls 2.0
import QtQuick.Controls.Material 2.0
import Qt.labs.settings 1.0

import "components/"
import "js/Utils.js" as Util

ApplicationWindow {
    id: window
    width: 360
    height: 520
    visible: true

    property bool debug: 0
    property bool isIOS: Qt.platform.os === "ios"

    property int user_logged_in: 0
    property var user_profile_data: ({})

    readonly property color colorAccent: "#c5e1a5"
    readonly property color colorPrimary: "#607d8b"
    readonly property color colorPrimaryDark: "#444444"
    readonly property color colorWindowBackground: "#eeeeee"
    readonly property color colorWindowForeground: "#607d8b"

    property alias currentPage: pageStack.currentItem

    function alert(title, message, positiveButtonText, acceptedCallback, negativeButtonText, rejectedCallback) {
        messageDialog.title = title
        messageDialog.detailedText = message
        messageDialog.accepted.connect(function() {
            if (acceptedCallback)
                acceptedCallback()
        })
        messageDialog.rejected.connect(function() {
            if (rejectedCallback)
                rejectedCallback()
        })
        messageDialog.open()
    }

    function isUserLoggedIn() {
        return parseInt(settings.user_logged_in) === 1
    }

    function setPage(pageName, pageArgs) {
        var pageTemp = {"url":"pages/Login.qml","name":"Login"}
        if (isUserLoggedIn()) {
            while (pageStack.depth > 1) pageStack.pop()
            pageTemp = {"url":"pages/Index.qml","name":"Início"}
        }
        pageStack.replace(Qt.resolvedUrl(pageTemp.url), pageArgs || {})
    }

    Component.onCompleted: setPage()

    Settings {
        id: settings

        property alias user_profile_data: window.user_profile_data
        property alias user_logged_in: window.user_logged_in
    }

    JSONListModel {
        id: jsonHttpRequest
        baseUrl: "https://emile-server.herokuapp.com/"
        baseImagesUrl: "https://emile-server.herokuapp.com/media/"
        onError: warning("Error!", jsonHttpRequest.message)
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
