import QtQuick 2.7
import QtQuick.Controls 2.0
import QtQuick.Controls.Material 2.0

import "../../qml/js/Utils.js" as Util
import "../../qml/components/"
import "../../qml/components/AwesomeIcon/"

BasePage {
    id: page

    function isValidLostPasswordForm() {
        if (!email.text && !cpf.text) {
            warning("Erro!", "Informe o seu email e CPF!", "Revisar");
            return false;
        } else if (!Util.isValidEmail(email.text)) {
            warning("Erro!", "Informe um email válido!", "Revisar");
            return false;
        }
        return true;
    }

    function lostPasswordsubmit() {
        if (isValidLostPasswordForm()) {
            // implementar requisição para recuperação de senha: url, parametros etc
        }
    }

    Flickable {
        anchors.fill: parent
        contentHeight: Math.max(content.implicitHeight, height)
        boundsBehavior: Flickable.StopAtBounds

        Row {
            spacing: 20
            width: parent.width * 0.90; height: 25
            anchors { top: parent.top; topMargin: 12; left: parent.left; leftMargin: 20 }

            Item {
                width: 16; height: width
                anchors.verticalCenter: parent.verticalCenter

                AwesomeIcon {
                    size: parent.height; color: brand.color
                    name: "arrow_left"; anchors.centerIn: parent
                }

                MouseArea { anchors.fill: parent; onClicked: popPage() }
            }

            Text { text: qsTr("Back to login"); anchors.verticalCenter: parent.verticalCenter; color: brand.color; font.pointSize: 12 }
        }

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

            CustomButton {
                enabled: requestHttp.state !== "running"
                text: qsTr("Submit")
                radius: 25; textColor: appSettings.theme.colorAccent
                backgroundColor: appSettings.theme.colorPrimary
                onClicked: lostPasswordsubmit();
            }
        }
    }
}
