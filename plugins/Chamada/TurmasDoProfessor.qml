import QtQuick 2.7
import QtQuick.Controls 2.0

import "../../qml/components/" as AppComponents

Page {
    id: page
    title: qsTr("My courses")

    property var json: {}

    function request() {
        jsonListModel.source += "course_sections_teacher/" + userProfileData.id
        jsonListModel.load()
    }

    Component.onCompleted: request();

    Connections {
        target: jsonListModel
        onStateChanged: {
            if (jsonListModel.state === "ready" && currentPage.title === page.title) {
                var jsonTemp = jsonListModel.model;
                json = jsonTemp;
            }
        }
    }

    BusyIndicator {
        id: busyIndicator
        anchors.centerIn: parent
        visible: jsonListModel.state === "loading"
    }

    AppComponents.EmptyList {
        z: listView.z + 1
        visible: listView.count === 0 && !loading.visible
        onClicked: request();
    }

    Column {
        visible: !busyIndicator.visible
        spacing: 15
        anchors { top: parent.top; topMargin: 15; horizontalCenter: parent.horizontalCenter }

        Repeater {
            model: json

            Column {

                Label {
                    text: name
                    anchors.horizontalCenter: parent.horizontalCenter
                    font { pointSize: 14; weight: Font.DemiBold }
                }

                Label {
                    text: code
                    anchors.horizontalCenter: parent.horizontalCenter
                    font { pointSize: 9; weight: Font.DemiBold }
                }
            }
        }
    }
}
