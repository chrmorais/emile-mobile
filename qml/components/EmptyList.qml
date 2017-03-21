import QtQuick 2.8
import QtQuick.Layouts 1.3
import QtQuick.Controls.Material 2.1
import QtQuick.Controls.Material.impl 2.1

import "AwesomeIcon/" as Awesome

Rectangle {
    id: noItemRec
    anchors.centerIn: parent
    color: backgroundColor; border.color: borderColor; radius: 5
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

    property int iconSize: 75
    property bool stateVisible: noItemRec.visible
    property color borderColor: "transparent"
    property color backgroundColor: "transparent"
    property string textColor: "#888"
    property string iconColor: textColor
    property string iconName: "warning"
    property string firstText: qsTr("Ops!")
    property string secondText: qsTr("No itens found. Touch to reload!")

    signal clicked()
    signal pressAndHold()
    signal visibleTrue()
    signal visibleFalse()

    onVisibleChanged: {
        if (visible)
            visibleTrue();
        else
            visibleFalse();
    }

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
                size: iconSize; color: textColor; name: iconName
                anchors.horizontalCenter: parent.horizontalCenter; clickEnabled: false
            }
        }

        Text {
            color: textColor; text: firstText
            renderType: Text.NativeRendering
            fontSizeMode: isIOS ? Text.FixedSize : Text.Fit
            anchors.horizontalCenter: parent.horizontalCenter
            font { weight: Font.DemiBold; pointSize: appSettings.theme.middleFontSize }
        }

        Text {
            renderType: Text.NativeRendering
            fontSizeMode: isIOS ? Text.FixedSize : Text.Fit
            color: textColor; text: secondText; font.pointSize: appSettings.theme.smallFontSize
            anchors.horizontalCenter: parent.horizontalCenter
        }
    }
}
