import QtQuick 2.8
import QtQuick.Layouts 1.3
import QtQuick.Controls.Material 2.1
import QtQuick.Controls.Material.impl 2.1

import "AwesomeIcon/" as Awesome

Item {
    id: noItemRec
    anchors.centerIn: parent
    width: parent.width * 0.65; height: parent.width > parent.height ? parent.width * 0.30 : parent.height * 0.30
    transitions: Transition {
        NumberAnimation { property: "opacity"; duration: 500 }
    }
    states: [
        State {
            when: stateVisible
            PropertyChanges { target: noItemRec; opacity: 1.0 }
        },
        State {
            when: !stateVisible
            PropertyChanges { target: noItemRec; opacity: 0.0 }
        }
    ]

    property alias iconSize: awesomeIcon.size
    property alias textColor: primaryText.color
    property alias iconName: awesomeIcon.name
    property alias firstText: primaryText.text
    property alias secondText: secondaryText.text

    signal clicked()
    signal pressAndHold()

    MouseArea {
        hoverEnabled: true
        anchors.fill: parent
        onEntered: noItemRec.opacity = 0.7
        onExited: noItemRec.opacity = 1.0
        onClicked: noItemRec.clicked();
        onPressAndHold: noItemRec.pressAndHold();

        Ripple {
            z: 0; anchor: parent
            x: (parent.width - width) / 2
            y: (parent.height - height) / 2
            width: parent.width; height: width
            pressed: parent.pressed
            active: parent.pressed
            color: parent.pressed ? Material.highlightedRippleColor : Material.rippleColor
        }
    }

    Column {
        spacing: 10
        anchors.centerIn: parent
        visible: noItemRec.visible

        Rectangle {
            color: "transparent"
            width: awesomeIcon.size; height: width
            anchors.horizontalCenter: parent.horizontalCenter

            Awesome.AwesomeIcon {
                id: awesomeIcon
                size: 75; color: primaryText.color; name: "warning"
                anchors.horizontalCenter: parent.horizontalCenter; clickEnabled: false
            }
        }

        Text {
            id: primaryText
            color: appSettings.theme.textColorPrimary
            renderType: Text.NativeRendering; text: qsTr("No itens found!")
            fontSizeMode: isIOS ? Text.FixedSize : Text.Fit
            anchors.horizontalCenter: parent.horizontalCenter
            font { weight: Font.DemiBold; pointSize: appSettings.theme.middleFontSize }
        }

        Text {
            id: secondaryText
            renderType: Text.NativeRendering
            fontSizeMode: isIOS ? Text.FixedSize : Text.Fit; opacity: 0.7
            color: primaryText.color; text: qsTr("Touch to reload!")
            font.pointSize: appSettings.theme.smallFontSize
            anchors.horizontalCenter: parent.horizontalCenter
        }
    }
}
