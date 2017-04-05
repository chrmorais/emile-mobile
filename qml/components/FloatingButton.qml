import QtQuick 2.8
import QtQuick.Controls 2.1
import QtGraphicalEffects 1.0

import "AwesomeIcon/"

CustomButton {
    id: button
    radius: 200; width: 50; height: width
    maximumWidth: width; maximumHeigth: width
    anchors { horizontalCenter: undefined; bottom: parent.bottom; bottomMargin: 16; right: parent.right; rightMargin: 16 }
    layer.enabled: true
    layer.effect: DropShadow {
        samples: 17; radius: 12
        verticalOffset: 1; horizontalOffset: 0
        color: "#66000000"; spread: 0
    }

    contentItem: AwesomeIcon {
        id: contentIcon; clickEnabled: false
        name: "plus"; anchors.centerIn: parent; color: appSettings.theme.colorAccent
    }

    property alias iconName: contentIcon.name
    property alias iconColor: contentIcon.color
}
