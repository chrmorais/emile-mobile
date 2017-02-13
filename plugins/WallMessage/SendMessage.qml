import QtQuick 2.7
import QtQuick.Controls 2.0

import "../../qml/components/" as AppComponents

Page {
    id: page
    title: qsTr("Write the message ")
    background: Rectangle {
        anchors.fill: parent
        color: appSettings.theme.colorWindowBackground
    }

    property int messageCharsLimit: 140
    property int messageCharsCount: messageCharsLimit - textarea.text.length
    property string toolBarState: "goback"
    property var post_message: {"post_message": {}};
    property int parameter
    property int userTypeDestinationId

    onMessageCharsCountChanged: textMessageCharsLength.text = messageCharsCount + qsTr(" chars left")

    Component.onCompleted: textarea.forceActiveFocus();

    function requestToSave() {
        jsonListModel.debug = true
        jsonListModel.requestMethod = "POST";
        jsonListModel.contentType = "application/json";
        jsonListModel.requestParams = JSON.stringify(post_message);
        jsonListModel.source += "wall_push_notification";
        jsonListModel.load();
        jsonListModel.stateChanged.connect(savePost_messageValidateStatus);
        toast.show("Sending message...");
    }

    function savePost_messageValidateStatus() {
        // after get server response, close the current page
        if (["ready", "error"].indexOf(jsonListModel.state) !== -1) {
            if (jsonListModel.httpStatus === 200) {
                jsonListModel.stateChanged.disconnect(savePost_messageValidateStatus);
                alert("Success!", "The message was successfully sended", "OK", function() { popPage() }, "CANCEL", function() { });
            } else if (jsonListModel.httpStatus === 404) {
                jsonListModel.stateChanged.disconnect(savePost_messageValidateStatus);
                alert("Warning!", "The message was not sent!", "OK", function() { }, "CANCEL", function() { });
            }
        }
    }

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
        text: messageCharsCount + " " + qsTr("chars left")
        color: appSettings.theme.defaultTextColor
        anchors { bottom: rectangleTextarea.top; topMargin: 15; horizontalCenter: parent.horizontalCenter }
    }

    AppComponents.CustomButton {
        text: qsTr("Send message")
        anchors { bottom: parent.bottom; bottomMargin: 15 }
        enabled: jsonListModel.state !== "running"
        textColor: appSettings.theme.colorAccent
        backgroundColor: appSettings.theme.colorPrimary
        onClicked: {
            var post_messageTemp = post_message["post_message"];
            post_messageTemp.user_type_destination_id = userTypeDestinationId;
            post_messageTemp.parameter = parameter;
            post_messageTemp.message = textarea.text
            post_messageTemp.sender = window.userProfileData.id
            post_message["post_message"] = post_messageTemp;
            requestToSave();
        }
    }
}
