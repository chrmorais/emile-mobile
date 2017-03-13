import QtQuick 2.8
import QtQuick.Controls 2.1
import QtQuick.Controls.Material 2.0

import "../../qml/components/"
import "../../qml/components/AwesomeIcon"
import "Functions.js" as LoginFunctions

BasePage {
    id: page
    objectName: qsTr("Login")
    hasListView: false
    centralizeBusyIndicator: false

    Component.onCompleted: if (window.menu) window.menu.enabled = false;

    property var requestResult

    Timer {
        id: lockerButtons
        repeat: false; running: false; interval: 100
    }

    Timer {
        id: loginPopShutdown
        repeat: false; running: false; interval: 2000
        onTriggered: window.starSession(requestResult); // is a signal on the main.qml
    }

    Flickable {
        id: pageFlickable
        anchors.fill: parent
        contentHeight: Math.max(content.implicitHeight, height)
        boundsBehavior: Flickable.DragOverBounds

        Column {
            id: content
            spacing: 25
            topPadding: 15
            width: parent.width * 0.90
            anchors.horizontalCenter: parent.horizontalCenter

            Rectangle {
                color: "transparent"
                width: parent.width; height: parent.height * 0.40
                anchors.horizontalCenter: parent.horizontalCenter

                Label {
                    id: brand
                    anchors.centerIn: parent
                    text: appSettings.applicationName; color: appSettings.theme.defaultTextColor
                    font { pointSize: appSettings.theme.extraLargeFontSize; weight: Font.Bold }
                }
            }

            TextField {
                id: email
                color: appSettings.theme.colorPrimary
                width: window.width - (window.width*0.15)
                echoMode: TextInput.Password
                selectByMouse: true
                inputMethodHints: Qt.ImhNoPredictiveText
                anchors.horizontalCenter: parent.horizontalCenter
                font.capitalization: Font.AllLowercase
                onAccepted: password.focus = true
                renderType: isIOS ? Text.NativeRendering : Text.QtRendering
                placeholderText: qsTr("Email")
                onFocusChanged: echoMode = TextInput.Normal
                onEditingFinished: text = text.toLocaleLowerCase().trim();
                background: Rectangle {
                    color: appSettings.theme.colorPrimary
                    y: (email.height-height) - (email.bottomPadding / 2)
                    width: email.width; height: email.activeFocus ? 2 : 1
                    border { width: 1; color: appSettings.theme.colorPrimary }
                }
            }

            TextField {
                id: password
                color: appSettings.theme.colorPrimary
                width: window.width - (window.width*0.15)
                echoMode: TextInput.Password
                anchors.horizontalCenter: parent.horizontalCenter
                selectByMouse: true; renderType: Text.NativeRendering
                onAccepted: loginButton.clicked()
                inputMethodHints: Qt.ImhNoPredictiveText
                placeholderText: qsTr("Password")
                background: Rectangle {
                    color: appSettings.theme.colorPrimary
                    y: (password.height-height) - (password.bottomPadding / 2)
                    width: password.width; height: password.activeFocus ? 2 : 1
                    border { width: 1; color: appSettings.theme.colorPrimary }
                }

                AwesomeIcon {
                    z: parent.z + 150; size: 20
                    name: password.echoMode == TextInput.Password ? "eye" : "eye_slash"
                    opacity: password.echoMode == TextInput.Password ? 0.7 : 1.0; color: parent.color
                    anchors { verticalCenter: parent.verticalCenter; right: parent.right; rightMargin: 0 }
                    onClicked: parent.echoMode = parent.echoMode == TextInput.Password ? TextInput.Normal : TextInput.Password
                }
            }

            CustomButton {
                id: loginButton
                enabled: !lockerButtons.running && !isPageBusy
                text: qsTr("LOG IN");
                textColor: appSettings.theme.colorAccent
                backgroundColor: appSettings.theme.colorPrimary
                onClicked: {
                    email.focus = false;
                    password.focus = false;
                    lockerButtons.running = true;
                    LoginFunctions.requestLogin();
                }
            }
        }
    }
}
