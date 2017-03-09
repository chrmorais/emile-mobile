import QtQuick 2.8
import QtQuick.Controls 2.1
import QtGraphicalEffects 1.0

import "AwesomeIcon/"

Rectangle {
    id: button
    anchors { bottom: parent.bottom; bottomMargin: 10; right: parent.right; rightMargin: 10 }
    color: appSettings.theme.colorPrimary
    opacity: enabled ? 0.75 : 1.0
    radius: width; implicitWidth: 48; implicitHeight: 48
    layer.enabled: true
    layer.effect: DropShadow {
        samples: 17
        verticalOffset: 1; horizontalOffset: 0
        color: Qt.rgba(0,0,0,0.5); spread: 0.1
    }

    AwesomeIcon {
        id: contentIcon; clickEnabled: false
        name: "plus"; anchors.centerIn: parent
    }

    MouseArea {
        id: mouseArea
        anchors.fill: parent
        onClicked: {
            if (button.enabled)
                button.clicked();
        }
        onPressAndHold: {
            if (button.enabled)
                button.pressAndHold();
        }
    }

    property bool showShadow: true
    property color shadowColor: appSettings.theme.colorPrimary
    property alias iconName: contentIcon.name
    property alias iconColor: contentIcon.color
    property alias backgroundColor: button.color

    signal clicked()
    signal pressAndHold()
}
