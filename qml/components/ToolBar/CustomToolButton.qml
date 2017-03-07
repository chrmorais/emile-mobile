import QtQuick 2.8
import QtQuick.Controls 2.1

import "../AwesomeIcon/" as Awesome

ToolButton {
    id: toolButton
    onClicked: actionExec(action); z: 100
    width: visible ? toolButton.width : 0; height: parent.height
    contentItem: Awesome.AwesomeIcon {
        id: toolButtonIcon
        clickEnabled: false; z: -1; size: 22
        anchors { horizontalCenter: parent.horizontalCenter; verticalCenter: parent.verticalCenter }
    }

    property string action
    property alias iconName: toolButtonIcon.name
    property alias iconColor: toolButtonIcon.color
}
