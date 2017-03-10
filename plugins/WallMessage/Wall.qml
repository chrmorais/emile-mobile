import QtQuick 2.8
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.1
import QtQuick.Controls.Material 2.1

import "../../qml/components/"
import "../../qml/components/AwesomeIcon/" as AwesomeIcon

BasePage {
    id: page
    title: qsTr("Message wall")
    objectName: qsTr("Message wall")
    listViewSpacing: 13
    listViewTopMargin: 10
    listViewBottomMargin: 10
    listViewDelegate: pageDelegate
    onUpdatePage: request();

    function apendObject(o, moveToTop) {
        listViewModel.append(o);
        if (moveToTop)
            listViewModel.move(listViewModel.count - 1, 0, 1);
    }

    function requestCallback(status, response) {
        if (status !== 200)
            return;
        for (var prop in response) {
            // se o usuário forçou a atualização e não há novidades
            if (listViewModel.count === response[prop].length)
                return;
            else
                listViewModel.clear();
            var i = 0;
            while (i < response[prop].length)
                apendObject(response[prop][i++]);
        }
    }

    function request() {
        if (!userProfileData.id)
            return;
        httpRequest.load("wall_messages/" + userProfileData.id, requestCallback);
    }

    Component.onCompleted: request();

    Connections {
        target: listView
        onContentYChanged: {
            busyIndicator.visible = false;
            if (listView.contentY < -65 && !isPageBusy && !lockMultipleRequests.running)
                lockMultipleRequests.running = true;
        }
    }

    Timer {
        id: loopRequestUpdate
        interval: 90000 // 1.5 min
        running: isActivePage
        onTriggered: {
            busyIndicator.visible = false;
            request();
        }
    }

    Timer {
        id: lockMultipleRequests
        interval: 2000
        onTriggered: {
            request();
            lockMultipleRequests.interval = 2000;
        }
    }

    Component {
        id: pageDelegate

        Rectangle {
            id: delegate
            color: "#fff799"; radius: 4
            anchors.horizontalCenter: parent.horizontalCenter
            width: page.width * 0.95; height: columnLayoutDelegate.height

            Pane {
                z: parent.z-10
                width: parent.width-1; height: parent.height-1
                Material.elevation: 2
            }

            ColumnLayout {
                id: columnLayoutDelegate
                spacing: 15
                width: parent.width

                Row {
                    spacing: 4
                    anchors { top: parent.top; topMargin: 5; left: parent.left; leftMargin: 10 }

                    AwesomeIcon.AwesomeIcon {
                        size: 12; name: "commenting"; color: authorLabel.color; clickEnabled: false
                    }

                    Label {
                        id: authorLabel
                        text: userProfileData.name === sender.name ? qsTr("You") : sender ? sender.name || "" : ""; color: "#444"
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
                        size: 12; name: "clock_o"; color: dateLabel.color; clickEnabled: false
                    }

                    Label {
                        id: dateLabel
                        text: date || ""
                        color: appSettings.theme.defaultTextColor
                    }
                }
            }
        }
    }

    FloatingButton {
        enabled: typeof userProfileData.type !== "undefined" && userProfileData.type.name !== "student" && httpRequest.state !== "loading"
        iconName: "pencil"; iconColor: appSettings.theme.colorAccent
        onClicked: {
            var url = Qt.resolvedUrl(configJson.root_folder+"/DestinationGroupSelect.qml");
            pageStack.push(url, {"configJson": configJson});
        }
    }
}
