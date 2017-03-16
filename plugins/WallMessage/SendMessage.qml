import QtQuick 2.8
import QtQuick.Controls 2.1

import "../../qml/components/"

BasePage {
    id: page
    title: qsTr("Write the message ")
    objectName: qsTr("Send message")
    hasListView: false
    hasRemoteRequest: true
    toolBarState: "goback"
    centralizeBusyIndicator: false
    toolBarActions: ({"toolButton4": {"action":"send", "icon":"send"}})

    property int parameter
    property int userTypeDestinationId
    property int messageCharsLimit: 140
    property int messageCharsCount: messageCharsLimit - textarea.text.length

    onMessageCharsCountChanged: textMessageCharsLength.text = messageCharsCount + qsTr(" chars left")

    Component.onCompleted: textarea.forceActiveFocus();

    function send() {
        if (isPageBusy || !textarea.text || !userTypeDestinationId) return;
        var postMessage = ({});
        postMessage.user_type_destination_id = userTypeDestinationId;
        postMessage.parameter = parameter;
        postMessage.message = textarea.text;
        postMessage.sender = window.userProfileData.id;
        textarea.focus = false;
        page.forceActiveFocus();
        var sendParams = ({"post_message": postMessage});
        requestToSave(sendParams);
    }

    function requestCallback(status, response) {
        if (status === 200) {
            textarea.text = "";
            textarea.forceActiveFocus();
            alert(qsTr("Success!"), qsTr("The message was successfully sended"));
        } else if (status === 404) {
            alert(qsTr("Warning!"), qsTr("The message was not sent!"));
        }
    }

    function requestToSave(postMessage) {
        toast.show(qsTr("Sending message..."), true);
        requestHttp.requestParams = JSON.stringify(postMessage);
        requestHttp.load("wall_push_notification", requestCallback, "POST");
    }

    Connections {
        target: window.header
        onActionExec: if (actionName === "send") send();
    }

    Rectangle {
        id: rectangleTextarea
        color: "transparent"
        width: parent.width * 0.90; height: parent.height * 0.50
        anchors { top: parent.top; topMargin: 50; horizontalCenter: parent.horizontalCenter }

        Flickable {
            id: flickable
            width: parent.width
            height: textarea.implicitHeight > parent.height ? parent.height : textarea.implicitHeight + 12

            TextArea.flickable: TextArea {
                id: textarea
                z: parent.z + 1; text: ""
                enabled: !isPageBusy; readOnly: isPageBusy
                focus: enabled; width: parent.width * 0.98
                opacity: isPageBusy ? 0.8 : 1.0
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
}
