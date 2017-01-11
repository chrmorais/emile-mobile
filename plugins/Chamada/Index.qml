import QtQuick 2.7
import QtQuick.Controls 2.0

import "../../qml/components/"

Page {
    id: page
    title: "Disciplina em andamento"

    property var json: {}
    property var configJson: {}

    Component.onCompleted: {
        jsonListModel.source += "lesson_in_progress/" + userProfileData.id
        jsonListModel.load()
    }

    Connections {
        target: jsonListModel
        onStateChanged: {
            if (jsonListModel.state === "ready" && currentPage.title === page.title) {
                var jsonTemp = jsonListModel.model.get(0);
                json = jsonTemp;
            }
        }
    }

    BusyIndicator {
        id: busyIndicator
        anchors.centerIn: parent
        visible: jsonListModel.state === "loading"
    }

    Column {
        visible: !busyIndicator.visible
        spacing: 25
        anchors { top: parent.top; topMargin: 15; horizontalCenter: parent.horizontalCenter }

        Label {
            text: "Disciplina em andamento:"
            anchors.horizontalCenter: parent.horizontalCenter
            font { pointSize: 18; weight: Font.Bold }
        }

        Column {
            spacing: 5
            anchors.horizontalCenter: parent.horizontalCenter

            Label {
                font { pointSize: 14; weight: Font.DemiBold }
                text: json.classes.subject_id.code + " - " + json.classes.subject_id.name
                anchors.horizontalCenter: parent.horizontalCenter
            }

            Label {
                font { pointSize: 12; weight: Font.DemiBold }
                text: json.lesson_start_time + " - " + json.lesson_finish_time
                anchors.horizontalCenter: parent.horizontalCenter
            }
        }

        Column {
            spacing: 5

            Label {
                text: "Deseja fazer a chamada?"
                anchors.horizontalCenter: parent.horizontalCenter
                font { pointSize: 16; weight: Font.Bold }
            }

            CustomButton {
                id: loginButton
                enabled: !lockerButtons.running && jsonListModel.state !== "running"
                text: qsTr("Realizar a chamada")
                textColor: appSettings.theme.colorAccent
                backgroundColor: appSettings.theme.colorPrimary
                anchors.horizontalCenter: parent.horizontalCenter
                onClicked: pushPage(configJson.root_folder+"/RealizarChamada.qml", {"lesson_id": json.id, "classes_id": json.classes.id})
            }
        }
    }

    CustomButton {
        id: loginButton
        enabled: !lockerButtons.running && jsonListModel.state !== "running"
        text: qsTr("Ignorar")
        textColor: appSettings.theme.colorAccent
        backgroundColor: appSettings.theme.colorPrimary
        anchors { horizontalCenter: parent.horizontalCenter; bottom: parent.bottom; bottomMargin: 15 }
        onClicked: pushPage(configJson.root_folder+"/TurmasDoProfessor.qml", {})
    }
}
