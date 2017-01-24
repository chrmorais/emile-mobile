import QtQuick 2.7
import QtQuick.Controls 2.0

import "../../qml/components/" as AppComponents

Page {
    id: page
    title: qsTr("Write the message ")

    property int messageCharsLimit: 140 - textarea.text.length
    property string toolBarState: "goback"

    Component.onCompleted: textarea.forceActiveFocus();

    Rectangle {
        id: rectangleTextarea
        color: "transparent"
        width: parent.width * 0.90; height: parent.height * 0.50
        anchors { top: parent.top; topMargin: 50; horizontalCenter: parent.horizontalCenter }

        Flickable {
            id: flickable
            width: parent.width; height: textarea.contentHeight > parent.height ? parent.height : textarea.contentHeight

            TextArea.flickable: TextArea {
                id: textarea
                wrapMode: TextArea.Wrap
                focus: true; width: parent.width
                text: "TextArea\n...\n...\n...\n...\n...\n...\n"
            }

            ScrollBar.vertical: ScrollBar { }
        }
    }

    Text {
        text: messageCharsLimit + " chars left"
        anchors { top: rectangleTextarea.bottom; topMargin: 15; horizontalCenter: parent.horizontalCenter }
    }

    AppComponents.CustomButton {
        text: qsTr("Send message")
        anchors { bottom: parent.bottom; bottomMargin: 15 }
        enabled: jsonListModel.state !== "running"
        textColor: appSettings.theme.colorAccent
        backgroundColor: appSettings.theme.colorPrimary
        onClicked: console.log("send message!");
    }
}
