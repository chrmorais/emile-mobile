import QtQuick 2.7
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.0
import QtQuick.Controls.Material 2.0

import "../../qml/components/" as AppComponents
import "../../qml/components/AwesomeIcon/" as AwesomeIcon

Page {
    id: page
    title: qsTr("Wall messages")
    background: Rectangle {
        anchors.fill: parent
        color: appSettings.theme.colorWindowBackground
    }

    property var json: []

    function request() {
        jsonListModel.debug = false;
        jsonListModel.source += "wall_messages/" + userProfileData.id
        jsonListModel.load()
    }

    Component.onCompleted: request()

    Connections {
        target: window
        onPageChanged: {
            if (currentPage.title === page.title)
                request();
            else
                json = "";
        }
    }

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
        visible: listView.count === 0 && !busyIndicator.visible
        onClicked: request();
    }

    Component {
        id: listViewDelegate

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

    ListView {
        id: listView
        spacing: 7
        model: json
        focus: true; cacheBuffer: width
        topMargin: 10; bottomMargin: 10
        width: page.width; height: page.height
        delegate: listViewDelegate
        Keys.onUpPressed: scrollBar.decrease()
        Keys.onDownPressed: scrollBar.increase()
        ScrollBar.vertical: ScrollBar { id: scrollBar }
    }
}
