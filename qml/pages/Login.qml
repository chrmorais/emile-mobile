import QtQuick 2.6
import QtQuick.Controls 2.0
import QtQuick.Controls.Material 2.0

import "../components/"
import "../libs/Utils.js" as Util

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
        var params = JSON.stringify({"user":email.text,"password":password.text})

        httpRequest.post("testssl/", params, function(json, statusCode) {
            if (statusCode === 404) {
                warning("Erro!", "Email ou senha inválido. Tente novamente!", "Ok")
            } else if (statusCode === 200 && json !== null) {
                requestResult = result // server send response with user profile data
                successLogin() //signal
            } else {
                warning("Erro!", "Falha ao tentar conectar com o servidor!", "Ok")
            }
        })
    }

    function isValidLoginForm() {
        if (email.text.length === 0) {
            warning("Erro!", "Digite o seu Email!", "Revisar")
            return false
        } else if (!Util.isValidEmail(email.text)) {
            warning("Erro!", "O email é inválido!", "Revisar")
            return false
        } else if (password.text.length === 0) {
            warning("Erro!", "Digite a sua senha!", "Revisar")
            return false
        }
        return true
    }

    Timer {
        id: timerLogin
        repeat: false
        running: false
        interval: 100
    }

    Timer {
        id: loginSuccessCountdown
        repeat: false
        running: false
        interval: 3000
        onTriggered: setPage() // está no Main.qml
    }

    Connections {
        target: loginPage
        onLoginSubmit: {
            if (isValidLoginForm())
                requestLogin() //signal
        }
        onSuccessLogin: {
            // saveUserDataFromLoginResult() // à implementar
            loginSuccessCountdown.start()
        }
    }

    Connections {
        target: httpRequest
        onRequestRunning: {
            loginButton.enabled = false
            busyIndicator.visible = true
        }
        onRequestFinish: {
            loginButton.enabled = true
            busyIndicator.visible = false
        }
    }

    BusyIndicator {
        id: busyIndicator
        antialiasing: true
        visible: false
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

        Item { width: parent.width; height: 1 }

        Column {
            id: content
            width: parent.width * 0.90
            spacing: 10
            anchors.horizontalCenter: parent.horizontalCenter

            Item { width: parent.width; height: 100 }

            Label {
                id: brand
                text: "Émile Mobile"
                color: "#607D8B"
                anchors.horizontalCenter: parent.horizontalCenter
                font {
                    pointSize: 30
                    weight: Font.Bold
                }

                TouchFx {
                    width: parent.width * 2
                    height: parent.height * 2
                    onClicked: {
                        console.log("brand clicked!")
                    }
                }
            }

            Item { width: parent.width; height: 80 }

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

            Item { width: parent.width; height: 4 }

            TextField {
                id: password
                width: window.width - (window.width*0.15)
                color: "#607D8B"
                echoMode: TextInput.Normal
                text: "Senha"
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
                    if (password.focus && password.text == "Senha") {
                        password.text = ""
                        password.echoMode = TextInput.Password
                    } else if (password.focus && password.text !== "Senha") {
                        password.text = password.text
                        password.echoMode = TextInput.Password
                    } else if (!password.focus && !password.text) {
                        password.text = "Senha"
                        password.echoMode = TextInput.Normal
                    } else {
                        password.echoMode = TextInput.Password
                    }
                }
            }

            Item { width: parent.width; height: 15 }

            Button {
                id: loginButton
                text: "ENTRAR"
                width: 185
                anchors.horizontalCenter: parent.horizontalCenter
                background: Rectangle {
                    id: loginButtonBackground
                    width: loginButton.width
                    height: loginButton.height
                    opacity: enabled ? 1 : 0.3
                    color: colorPrimary
                    radius: 25
                }
                contentItem: Text {
                    id: loginButtonText
                    text: loginButton.text
                    opacity: enabled ? 1.0 : 0.3
                    color: colorAccent
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                    elide: Text.ElideRight
                    font {
                        weight: Font.DemiBold
                        pointSize: 14
                    }
                }

                TouchFx {
                    circular: true
                    anchors.fill: parent
                    onClicked: {
                        timerLogin.running = true
                        loginSubmit() //signal
                    }
                }
            }

            Item { width: parent.width; height: 35 }

            Button {
                id: lostPasswordButton
                width: 185
                enabled: !timerLogin.running || !loginSuccessCountdown.running
                anchors.horizontalCenter: parent.horizontalCenter
                contentItem: Text {
                    text: "RECUPERAR SENHA"
                    opacity: enabled ? 1.0 : 0.3
                    color: colorPrimary
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                    elide: Text.ElideRight
                    font {
                        weight: Font.DemiBold
                        pointSize: 14
                    }
                }
                background: Rectangle {
                    id: lostPasswordButtonBackground
                    width: lostPasswordButton.width
                    height: lostPasswordButton.height
                    opacity: enabled ? 1 : 0.3
                    color: colorAccent
                    radius: 25
                }

                TouchFx {
                    circular: true
                    anchors.fill: parent
                    onClicked: {
                        timerLogin.start()
                        pageStack.push(Qt.resolvedUrl("LostPassword.qml"))
                    }
                }
            }

            Item { width: parent.width; height: 5 }
        }
    }
}
