import QtQuick 2.7
import QtQuick.Controls 2.0

import "../AwesomeIcon/" as Awesome

ToolButton {
    id: toolButton
    width: visible ? toolButton.width : 0; height: parent.height
    onClicked: actionExec(action)
    contentItem: Awesome.AwesomeIcon {
        id: toolButtonIcon
        anchors { horizontalCenter: parent.horizontalCenter; verticalCenter: parent.verticalCenter }
    }

    property string action
    property alias iconName: toolButtonIcon.name
    property alias iconColor: toolButtonIcon.color
}
