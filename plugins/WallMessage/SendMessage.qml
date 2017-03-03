import QtQuick 2.7
import QtQuick.Controls 2.0

import "../../qml/components/"

BasePage {
    id: page
    title: qsTr("Write the message ")
    objectName: qsTr("Send message")
    hasListView: false
    hasRemoteRequest: true
    toolBarState: "goback"
    centralizeBusyIndicator: false

    property int parameter
    property int userTypeDestinationId
    property int messageCharsLimit: 140
    property int messageCharsCount: messageCharsLimit - textarea.text.length

    property var post_message: {"post_message": {}};

    onMessageCharsCountChanged: textMessageCharsLength.text = messageCharsCount + qsTr(" chars left")

    Component.onCompleted: textarea.forceActiveFocus();

    function send() {
        var post_messageTemp = post_message["post_message"];
        post_messageTemp.user_type_destination_id = userTypeDestinationId;
        post_messageTemp.parameter = parameter;
        post_messageTemp.message = textarea.text
        post_messageTemp.sender = window.userProfileData.id
        post_message["post_message"] = post_messageTemp;
        requestToSave();
        page.forceActiveFocus();
    }

    function requestCallback(result, status) {
        if (status === 200) {
            textarea.enabled = false;
            alert(qsTr("Success!"), qsTr("The message was successfully sended"), "OK", function() { popPage(); }, qsTr("CANCEL"), function() { });
        } else if (status === 404) {
            alert(qsTr("Warning!"), qsTr("The message was not sent!"), "OK", function() { }, qsTr("CANCEL"), function() { });
        }
    }

    function requestToSave() {
        jsonListModel.requestMethod = "POST";
        jsonListModel.contentType = "application/json";
        jsonListModel.source += "wall_push_notification";
        jsonListModel.requestParams = JSON.stringify(post_message);
        jsonListModel.load(requestCallback);
        toast.show(qsTr("Sending message..."), true);
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
                z: parent.z + 1; text: ""
                enabled: !busyIndicator.visible
                focus: enabled; width: parent.width
                opacity: busyIndicator.visible ? 0.8 : 1.0
                overwriteMode: true; wrapMode: TextArea.Wrap
                selectByMouse: true; persistentSelection: true
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
        color: appSettings.theme.defaultTextColor
        anchors { bottom: rectangleTextarea.top; topMargin: 15; horizontalCenter: parent.horizontalCenter }
    }

    CustomButton {
        text: qsTr("Send message")
        anchors { bottom: parent.bottom; bottomMargin: 15 }
        enabled: !busyIndicator.visible
        textColor: appSettings.theme.colorAccent
        backgroundColor: appSettings.theme.colorPrimary
        onClicked: send();
    }
}
