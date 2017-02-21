import QtQuick 2.7
import QtQuick.Controls 2.0
import QtQuick.Controls.Material 2.0

import "../../qml/components/"
import "Functions.js" as LoginFunctions

BasePage {
    id: page
    objectName: qsTr("Login")
    hasListView: false
    hasRemoteRequest: true
    centralizeBusyIndicator: false

    Component.onCompleted: if (window.menu) window.menu.enabled = false;

    property int hideToolbar: 1

    Timer {
        id: lockerButtons
        repeat: false; running: false; interval: 100
    }

    Timer {
        id: loginPopShutdown
        repeat: false; running: false; interval: 2000
        onTriggered: setIndexPage(true, true); // setIndexPage() is a function from Main.qml
    }

    Flickable {
        id: pageFlickable
        anchors.fill: parent
        contentHeight: Math.max(content.implicitHeight, height)
        boundsBehavior: Flickable.StopAtBounds

        Column {
            id: content
            spacing: 25
            width: parent.width * 0.90; height: parent.height
            anchors.horizontalCenter: parent.horizontalCenter

            Rectangle {
                color: "transparent"
                width: parent.width; height: parent.height * 0.40
                anchors.horizontalCenter: parent.horizontalCenter

                Label {
                    id: brand
                    anchors.centerIn: parent
                    text: appSettings.applicationName; color: appSettings.theme.defaultTextColor
                    font { pointSize: appSettings.theme.bigFontSize; weight: Font.Bold }
                }
            }

            TextField {
                id: email
                text: "Email"
                color: appSettings.theme.colorPrimary
                width: window.width - (window.width*0.15)
                selectByMouse: true
                inputMethodHints: Qt.ImhEmailCharactersOnly | Qt.ImhLowercaseOnly
                anchors.horizontalCenter: parent.horizontalCenter
                background: Rectangle {
                    color: appSettings.theme.colorPrimary
                    y: (email.height-height) - (email.bottomPadding / 2)
                    width: email.width; height: email.activeFocus ? 2 : 1
                    border { width: 1; color: appSettings.theme.colorPrimary }
                }
                onFocusChanged: {
                    if (email.focus)
                        email.text = email.text === "Email" ? "" : email.text
                    else
                        email.text = email.text.length == 0 ? "Email" : email.text
                }
            }

            TextField {
                id: password
                text: "Password"
                color: appSettings.theme.colorPrimary
                width: window.width - (window.width*0.15)
                echoMode: TextInput.Normal; font.letterSpacing: 1
                anchors.horizontalCenter: parent.horizontalCenter
                selectByMouse: true
                inputMethodHints: Qt.ImhNoPredictiveText
                background: Rectangle {
                    color: appSettings.theme.colorPrimary
                    y: (password.height-height) - (password.bottomPadding / 2)
                    width: password.width; height: password.activeFocus ? 2 : 1
                    border { width: 1; color: appSettings.theme.colorPrimary }
                }
                onFocusChanged: {
                    if (password.focus && password.text == "Password") {
                        password.text = ""
                        password.echoMode = TextInput.Password
                    } else if (password.focus && password.text !== "Password") {
                        password.text = password.text
                        password.echoMode = TextInput.Password
                    } else if (!password.focus && !password.text) {
                        password.text = "Password"
                        password.echoMode = TextInput.Normal
                    } else {
                        password.echoMode = TextInput.Password
                    }
                }
            }

            CustomButton {
                id: loginButton
                enabled: !lockerButtons.running && jsonListModel.state !== "loading"
                text: qsTr("LOG IN");
                textColor: appSettings.theme.colorAccent
                backgroundColor: appSettings.theme.colorPrimary
                onClicked: {
                    lockerButtons.running = true
                    LoginFunctions.requestLogin();
                }
            }

//            CustomButton {
//                id: lostPasswordButton
//                enabled: !lockerButtons.running || !loginPopShutdown.running
//                text: qsTr("LOST PASSWORD")
//                textColor: appSettings.theme.colorPrimary
//                backgroundColor: appSettings.theme.colorAccent
//                onClicked: {
//                    lockerButtons.start();
//                    // pushPage() is a function from Main.qml
//                    pushPage("qrc:/plugins/Session/LostPassword.qml");
//                }
//            }
        }
    }
}
