import QtQuick 2.7
import QtQuick.Layouts 1.0
import QtQuick.Controls 2.0
import QtQuick.Controls.Material 2.0

import "components/"
import "libs/Utils.js" as Util

ApplicationWindow {
    id: window
    width: 720
    height: 1280
    visible: true

    property int debug: 0
    property int isIOS: Qt.platform.os === "ios" ? 1 : 0

    readonly property color colorAccent: "#c5e1a5"
    readonly property color colorPrimary: "#607d8b"
    readonly property color colorPrimaryDark: "#444444"
    readonly property color colorWindowBackground: "#eeeeee"
    readonly property color colorWindowForeground: "#607d8b"

    property alias currentPage: pageStack.currentItem

    function warning(title, message, okButtonText, okButtonCallback, cancelButtonText, cancelButtonCallback) {
        console.log("warning(...){...}")
        // Implementar o diálogo de aviso - passando os parâmetros acima!
    }

    function isUserLoggedIn() {
        // Implementar verificação da sessão - checando se o usuário está ou não logado!
        return false
    }

    function setPage(pageName, pageArgs) {
        var pageTemp = {"url":"pages/Login.qml","name":"Login"}
        if (isUserLoggedIn())
            pageTemp = {"url":"pages/Index.qml","name":"Início"}
        pageStack.push(Qt.resolvedUrl(pageTemp.url), pageArgs || {})
    }

    Component.onCompleted: setPage()

    HttpRequest {
        id: httpRequest
        onNoConection: {
            warning("Erro!", "Não foi possível conectar ao link remoto! Verifique sua conexão com a internet e tente novamente.")
        }
        onRequestTimeout: {
            warning("Erro!", "A requisição atingiu o tempo limite. Deseja tentar novamente?", "Sim", function() {
                request(requestType, requestPath, dataToSend || 0, callback)
            }, "Cancelar", function() {
                callback(null, 0)
            })
        }
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
