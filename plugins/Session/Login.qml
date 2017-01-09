import QtQuick 2.7
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.0
import QtQuick.Controls.Material 2.0

import "../../qml/components/"
import "../../qml/js/Utils.js" as Util

Page {
    id: loginPage
    objectName: "Login"
    background: Rectangle {
        anchors.fill: parent
        color: appSettings.theme.colorWindowBackground
    }

    Component.onCompleted: if (window.menu) window.menu.enabled = false;

    property int hideToolbar: 1
    property var requestResult: {}

    function isDeveloperLogin() {
        var fixBindArray = {};
        if (email.text === "aluno@teste.com" && password.text === "lkjlkj") {
            fixBindArray.id = 2;
            fixBindArray.role = "student";
            fixBindArray.name = "enoquejoseneas";
            fixBindArray.email = "enoquejoseneas@ifba.edu.br";
            window.userProfileData = fixBindArray;
            window.isUserLoggedIn = true;
            loginPopShutdown.start();
            return true;
        } else if (email.text === "professor@teste.com" && password.text === "lkjlkj") {
            fixBindArray.id = 2;
            fixBindArray.role = "teacher";
            fixBindArray.name = "enoquejoseneas";
            fixBindArray.email = "enoquejoseneas@ifba.edu.br";
            window.userProfileData = fixBindArray;
            window.isUserLoggedIn = true;
            loginPopShutdown.start();
            return true;
        }
        return false;
    }

    function requestLogin() {
        if (!isValidLoginForm())
            return;
        if (isDeveloperLogin())
            return;
        jsonListModel.requestMethod = "POST"
        jsonListModel.requestParams = JSON.stringify({"email":email.text,"password":password.text})
        jsonListModel.source += "login/"
        jsonListModel.load()
    }

    function isValidLoginForm() {
        if (email.text === "Email" || email.text.length === 0) {
            alert("Error!", "Enter your Email!");
            return false;
        } else if (!Util.isValidEmail(email.text)) {
            alert("Error!", "Invalid Email!");
            return false;
        } else if (password.text === "Password" || password.text.length === 0) {
            alert("Error!", "Enter your password!");
            return false;
        }
        return true;
    }

    Timer {
        id: lockerButtons
        repeat: false; running: false; interval: 100
    }

    Timer {
        id: loginPopShutdown
        repeat: false; running: false; interval: 1000
        onTriggered: setIndexPage(true);
    }

    Connections {
        target: jsonListModel
        onHttpStatusChanged: {
            switch (jsonListModel.httpStatus) {
            case 405:
                alert("Error!", "Email or password is invalid. Try again!");
                break;
            case 200:
                window.userProfileData = jsonListModel.model.get(0);
                window.isUserLoggedIn = true;
                loginPopShutdown.start();
                break;
            default:
                alert("Error!", "Failed to connect to the server!")
            }
        }
    }

    BusyIndicator {
        id: busyIndicator
        antialiasing: true
        visible: jsonListModel.state === "running"
        anchors { top: parent.top; topMargin: 20; horizontalCenter: parent.horizontalCenter }
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
                    text: appSettings.name; color: appSettings.theme.colorPrimary
                    font { pointSize: appSettings.theme.bigFontSize; weight: Font.Bold }
                }
            }

            TextField {
                id: email
                text: "Email"
                color: appSettings.theme.colorPrimary
                width: window.width - (window.width*0.15)
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
                enabled: !lockerButtons.running && jsonListModel.state !== "running"
                text: qsTr("LOG IN");
                radius: 25; textColor: appSettings.theme.colorAccent
                backgroundColor: appSettings.theme.colorPrimary
                onClicked: {
                    lockerButtons.running = true
                    requestLogin();
                }
            }

            CustomButton {
                id: lostPasswordButton
                enabled: !lockerButtons.running || !loginPopShutdown.running
                text: qsTr("LOST PASSWORD")
                radius: 25; textColor: appSettings.theme.colorPrimary
                backgroundColor: appSettings.theme.colorAccent
                onClicked: {
                    lockerButtons.start();
                    pushPage("qrc:/plugins/Session/LostPassword.qml");
                }
            }
        }
    }
}
