import QtQuick 2.7
import QtQuick.Controls 2.0

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
        spacing: 15
        anchors { top: parent.top; topMargin: 15; horizontalCenter: parent.horizontalCenter }

        Label {
            text: "Disciplina em andamento:"
            anchors.horizontalCenter: parent.horizontalCenter
            font { pointSize: 14; weight: Font.DemiBold }
        }

        Row {
            spacing: 5
            anchors.horizontalCenter: parent.horizontalCenter

            Label {
                text: json.classes.subject_id.code + " - " + json.classes.subject_id.name
            }
        }

        Row {
            spacing: 5
            anchors.horizontalCenter: parent.horizontalCenter

            Label {
                text: json.lesson_start_date + " - " + json.lesson_finish_date
            }
        }

        Label {
            text: "Deseja fazer a chamada?"
            anchors.horizontalCenter: parent.horizontalCenter
            font { pointSize: 9; weight: Font.DemiBold }
        }

        Button {
            id: actionStartButton
            text: "Realizar a chamada"
            anchors.horizontalCenter: parent.horizontalCenter
            onClicked: pushPage(configJson.root_folder+"/RealizarChamada.qml", {"lesson_id": json.id, "classes_id": json.classes.id})
        }
    }

    Button {
        id: actionCancelButton
        text: "Ignorar"
        anchors { horizontalCenter: parent.horizontalCenter; bottom: parent.bottom; bottomMargin: 15 }
        onClicked: pushPage(configJson.root_folder+"/TurmasDoProfessor.qml", {})
    }
}
