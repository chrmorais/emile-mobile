import QtQuick 2.7
import QtQuick.Controls 2.0

import "../../qml/components/" as AppComponents

Page {
    id: page
    title: qsTr("Write the message ")

    property int messageCharsLimit: 140
    property int messageCharsCount: messageCharsLimit - textarea.text.length
    onMessageCharsCountChanged: textMessageCharsLength.text = messageCharsCount + qsTr(" chars left")
    property string toolBarState: "goback"

    Component.onCompleted: textarea.forceActiveFocus();

    Rectangle {
        id: rectangleTextarea
        color: "transparent"
        width: parent.width * 0.90; height: parent.height * 0.50
        anchors { top: parent.top; topMargin: 50; horizontalCenter: parent.horizontalCenter }

        Flickable {
            id: flickable
            width: parent.width; height: textarea.implicitHeight > parent.height ? parent.height : textarea.implicitHeight

            TextArea.flickable: TextArea {
                id: textarea
                text: ""
                mouseSelectionMode: TextEdit.SelectWords
                persistentSelection: true
                wrapMode: TextArea.Wrap
                focus: true; width: parent.width
                onTextChanged: {
                    if (textarea.text.length > 139) {
                        textarea.remove(140, textarea.text.length);
                        textarea.cursorPosition = 139;
                    }
                }
            }

            ScrollBar.vertical: ScrollBar { }
        }
    }

    Text {
        id: textMessageCharsLength
        text: messageCharsCount + qsTr(" chars left")
        anchors { bottom: rectangleTextarea.top; topMargin: 15; horizontalCenter: parent.horizontalCenter }
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
