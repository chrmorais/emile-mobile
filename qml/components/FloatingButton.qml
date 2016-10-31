import QtQuick 2.0
import QtQuick.Controls 2.0
import QtGraphicalEffects 1.0

import "AwesomeIcon/" as Awesome

Button {
    id: button
    anchors {
        bottom: parent.bottom
        bottomMargin: 10
        right: parent.right
        rightMargin: 10
    }
    contentItem: Item {
        implicitWidth: contentIcon.size
        implicitHeight: contentIcon.size
        Awesome.AwesomeIcon {
            id: contentIcon
            anchors.centerIn: parent
            name: "plus"
        }
    }
    background: Rectangle {
        id: buttonBackground
        implicitWidth: 48
        implicitHeight: 48
        color: appSettings.theme.colorPrimary
        radius: width
        opacity: button.pressed ? 0.75 : 1.0
        layer.enabled: button.showShadow
        layer.effect: DropShadow {
            verticalOffset: 1
            horizontalOffset: 0
            color: "#ddd"
            samples: button.pressed ? 20 : 10
            spread: 0.7
        }
    }

    property bool showShadow: true
    property alias iconName: contentIcon.name
    property alias backgroundColor: buttonBackground.color
}
