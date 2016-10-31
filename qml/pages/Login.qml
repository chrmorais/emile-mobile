import QtQuick 2.6
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.3
import QtQuick.Controls.Material 2.0

import "../components/"
import "../js/Utils.js" as Util

Page {
    id: loginPage
    objectName: "Login"
    background: Rectangle {
        anchors.fill: parent
        color: colorWindowBackground
    }

    property int hideToolbar: 1
    property var requestResult: ({})

    signal loginSubmit()
    signal successLogin()

    function requestLogin() {
        jsonHttpRequest.requestType   = "POST"
        jsonHttpRequest.requestParams = "email=" + email.text + "&password=" + password.text
        jsonHttpRequest.requestSource = "login"
     }

    function isValidLoginForm() {
        if (email.text === "Email" || email.text.length === 0) {
            alert("Error!", "Enter your Email!")
            return false
        } else if (!Util.isValidEmail(email.text)) {
            alert("Error!", "Invalid Email!")
            return false
        } else if (password.text === "Password" || password.text.length === 0) {
            alert("Error!", "Enter your password!")
            return false
        }
        return true
    }

    Timer {
        id: lockerButtons
        repeat: false
        running: false
        interval: 100
    }

    Timer {
        id: loginSuccessCountdown
        repeat: false
        running: false
        interval: 1000
        onTriggered: setPage()
    }

    Connections {
        target: jsonHttpRequest
        onCountChanged: {
            switch (jsonHttpRequest.resultCode) {
                case 404:
                    alert("Error!", "Email or password is invalid. Try again!");
                    break;
                case 200:
                    requestResult = jsonHttpRequest.model
                    successLogin()
                    break;
                default:
                    alert("Error!", "Failed to connect to the server!")
            }
        }
    }

    Connections {
        target: loginPage
        onLoginSubmit: {
            if (isValidLoginForm())
                requestLogin() //signal
        }
        onSuccessLogin: {
            window.user_logged_in = 1
            window.user_profile_data = JSON.stringify(requestResult)
            requestResult = null
            loginSuccessCountdown.start()
        }
    }

    BusyIndicator {
        id: busyIndicator
        antialiasing: true
        visible: jsonHttpRequest.state === "running"
        anchors {
            top: parent.top
            topMargin: !isIOS ? 25 : 10
            horizontalCenter: parent.horizontalCenter
        }
    }

    Flickable {
        id: pageFlickable
        anchors.fill: parent
        contentHeight: Math.max(content.implicitHeight, height)
        boundsBehavior: Flickable.StopAtBounds

        Column {
            id: content
            width: parent.width * 0.90
            height: parent.height
            spacing: 25
            anchors.horizontalCenter: parent.horizontalCenter

            Rectangle {
                width: parent.width
                height: parent.height * 0.40
                color: "transparent"
                anchors.horizontalCenter: parent.horizontalCenter

                Label {
                    id: brand
                    text: "Émile Mobile"
                    color: "#607D8B"
                    anchors.centerIn: parent
                    font {
                        pointSize: 30
                        weight: Font.Bold
                    }
                }
            }

            TextField {
                id: email
                width: window.width - (window.width*0.15)
                color: "#607D8B"
                inputMethodHints: Qt.ImhEmailCharactersOnly | Qt.ImhLowercaseOnly
                text: "Email"
                anchors.horizontalCenter: parent.horizontalCenter
                background: Rectangle {
                    y: (email.height-height) - (email.bottomPadding / 2)
                    width: email.width
                    height: email.activeFocus ? 2 : 1
                    color: "#607D8B"
                    border {
                        width: 1
                        color: "#607D8B"
                    }
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
                width: window.width - (window.width*0.15)
                color: "#607D8B"
                echoMode: TextInput.Normal
                text: "Password"
                font.letterSpacing: 1
                anchors.horizontalCenter: parent.horizontalCenter
                inputMethodHints: Qt.ImhNoPredictiveText
                background: Rectangle {
                    y: (password.height-height) - (password.bottomPadding / 2)
                    width: password.width
                    height: password.activeFocus ? 2 : 1
                    color: "#607D8B"
                    border {
                        width: 1
                        color: "#607D8B"
                    }
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
                enabled: !lockerButtons.running && jsonHttpRequest.state !== "running"
                text: "LOG IN"
                textColor: colorAccent
                backgroundColor: colorPrimary
                radius: 25
                onClicked: {
                    lockerButtons.running = true
                    loginSubmit() //signal
                }
            }

            CustomButton {
                id: lostPasswordButton
                enabled: !lockerButtons.running || !loginSuccessCountdown.running
                text: "LOST PASSWORD"
                textColor: colorPrimary
                backgroundColor: colorAccent
                radius: 25
                onClicked: {
                    lockerButtons.start()
                    pageStack.push(Qt.resolvedUrl("LostPassword.qml"))
                }
            }
        }
    }
}
