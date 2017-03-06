import QtQuick 2.8
import QtQuick.Controls 2.1
import QtGraphicalEffects 1.0

import "AwesomeIcon/" as Awesome

Button {
    id: button
    anchors { bottom: parent.bottom; bottomMargin: 10; right: parent.right; rightMargin: 10 }
    contentItem: Item {
        implicitWidth: contentIcon.size; implicitHeight: contentIcon.size
        Awesome.AwesomeIcon {
            id: contentIcon; clickEnabled: false
            name: "plus"; anchors.centerIn: parent
        }
    }
    background: Rectangle {
        id: buttonBackground
        color: appSettings.theme.colorPrimary
        opacity: button.pressed ? 0.75 : 1.0
        layer.enabled: button.showShadow
        radius: width; implicitWidth: 48; implicitHeight: 48
        layer.effect: DropShadow {
            verticalOffset: 1; horizontalOffset: 0
            color: Qt.rgba(0,0,0,0.5); spread: 0.1
            samples: button.pressed ? 35 : 25
        }
    }

    property bool showShadow: true
    property color shadowColor: appSettings.theme.colorPrimary
    property alias iconName: contentIcon.name
    property alias iconColor: contentIcon.color
    property alias backgroundColor: buttonBackground.color
}
