import QtQuick 2.7
import QtQuick.Controls 2.0

Page {
    id: page
    title: qsTr("My courses")

    property var json: {}

    Component.onCompleted: {
        jsonListModel.source += "classes_teacher/" + userProfileData.id
        jsonListModel.load()
    }

    Connections {
        target: jsonListModel
        onStateChanged: {
            if (jsonListModel.state === "ready") {
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

        Repeater {
            model: json

            Label {
                text: modelData.name
                anchors.horizontalCenter: parent.horizontalCenter
                font { pointSize: 14; weight: Font.DemiBold }
            }

            Label {
                text: modelData.subject_id.code
                anchors.horizontalCenter: parent.horizontalCenter
                font { pointSize: 9; weight: Font.DemiBold }
            }

            Label {
                text: modelData.subject_id.name
                anchors.horizontalCenter: parent.horizontalCenter
                font { pointSize: 9; weight: Font.DemiBold }
            }
        }
    }
}
