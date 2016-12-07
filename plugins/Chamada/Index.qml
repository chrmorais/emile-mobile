import QtQuick 2.7
import QtQuick.Controls 2.0

Page {
    id: page

    property var json: {}
    property var configJson: {}

    Component.onCompleted: {
        jsonListModel.source += "/disciplina_em_andamento/" + user_profile_data.id
        jsonListModel.load()
        json = Qt.binding(function() { return jsonListModel.model.get(0) })
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
                text: json.turma.disciplina_id.codigo + " - " + json.turma.disciplina_id.nome
            }
        }

        Row {
            spacing: 5
            anchors.horizontalCenter: parent.horizontalCenter

            Label {
                text: json.data_inicio_aula + " - " + json.data_fim_aula
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
            onClicked: pushPage(configJson.root_folder+"/RealizarChamada.qml", {"turmaId": json.turma.id})
        }
    }

    Button {
        id: actionCancelButton
        text: "Ignorar"
        anchors { horizontalCenter: parent.horizontalCenter; bottom: parent.bottom; bottomMargin: 15 }
        onClicked: {
            // listar as disciplinas lecionadas pelo professor para o dia corrente
            // será implementado em um review posterior
        }
    }
}
