import QtQuick 2.7

ListView {
    id: listViewAlunos

    // the plugin config.json as object
    property var configJson: ({})
    property string fieldVisible: ""

    onConfigJsonChanged: {
        fieldVisible = configJson.index_fields[0]
    }

    Component.onCompleted: {
        jsonListModel.source = "https://emile-server.herokuapp.com/users"
        jsonListModel.requestMethod = "GET"
        jsonListModel.load()
    }

    model: jsonListModel.model

    delegate: Rectangle {
        width: parent.width
        height: columnData.height
        anchors.horizontalCenter: parent.horizontalCenter

        Column {
            id: columnData
            width: parent.width

            Rectangle {
                width: parent.width
                height: data.height
                color: "transparent"

                Text {
                    id: data
                    text: "Nome do usuário"
                    font.pointSize: 25
                    width: parent.width
                    wrapMode: Text.WordWrap
                    anchors.horizontalCenter: parent.horizontalCenter
                }
            }

            Text {
                text: model[fieldVisible]
                font.pointSize: 20
                width: parent.width
                wrapMode: Text.WordWrap
            }
        }
    }
}
