import QtQuick 2.7
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.0
import QtQuick.Controls.Material 2.1

import "../../qml/components/"
import "../../qml/components/AwesomeIcon/" as AwesomeIcon

BasePage {
    id: page
    title: qsTr("Message wall")
    objectName: qsTr("Message wall")
    listViewSpacing: 10
    listViewTopMargin: 10
    listViewBottomMargin: 10
    listViewDelegate: pageDelegate
    onUpdatePage: request();

    function apendObject(o) {
        listViewModel.append(o);
        listViewModel.move(listViewModel.count - 1, 0, 1);
    }

    function request() {
        jsonListModel.source += "wall_messages/" + userProfileData.id;
        jsonListModel.load(function(response, status) {
            if (status !== 200)
                return;
            var i = 0;
            if (listViewModel.count > 0)
                listViewModel.clear();
            for (var prop in response) {
                while (i < response[prop].length)
                    apendObject(response[prop][i++]);
            }
        });
    }

    Component.onCompleted: request();

    Component {
        id: pageDelegate

        Rectangle {
            id: delegate
            color: "#fff799"; radius: 4
            anchors.horizontalCenter: parent.horizontalCenter
            width: parent.width * 0.95; height: columnLayoutDelegate.height

            Pane {
                z: parent.z-10
                width: parent.width; height: parent.height
                Material.elevation: 3
            }

            ColumnLayout {
                id: columnLayoutDelegate
                spacing: 15
                width: parent.width

                Row {
                    spacing: 4
                    anchors { top: parent.top; topMargin: 5; left: parent.left; leftMargin: 10 }

                    AwesomeIcon.AwesomeIcon {
                        size: 12; name: "commenting"; color: authorLabel.color
                    }

                    Label {
                        id: authorLabel
                        text: sender ? sender.name || "" : ""; color: "#444"
                    }
                }

                Item {
                    Layout.fillWidth: true
                    height: labelMessage.implicitHeight; implicitHeight: height

                    Label {
                        id: labelMessage
                        text: message || ""
                        width: parent.width * 0.95
                        wrapMode: Text.Wrap
                        font.wordSpacing: 1
                        color: appSettings.theme.defaultTextColor
                        anchors { right: parent.right; left: parent.left; margins: 10 }
                    }
                }

                Row {
                    spacing: 4
                    anchors { bottom: parent.bottom; bottomMargin: 5; left: parent.left; leftMargin: 10 }

                    AwesomeIcon.AwesomeIcon {
                        size: 12; name: "clock_o"; color: dateLabel.color
                    }

                    Label {
                        id: dateLabel
                        color: appSettings.theme.defaultTextColor
                        text: date || ""
                    }
                }
            }
        }
    }

    FloatingButton {
        visible: window.userProfileData.type.name !== "student"
        iconName: "pencil"; iconColor: appSettings.theme.colorAccent
        onClicked: pushPage(configJson.root_folder+"/DestinationGroupSelect.qml", {});
    }
}
