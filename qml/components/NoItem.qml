import QtQuick 2.7
import QtQuick.Layouts 1.3

import "AwesomeIcon/" as Awesome

Rectangle {
    id: noItemRec
    width: parent.width * 0.65
    height: parent.width > parent.height ? parent.width * 0.30 : parent.height * 0.30
    anchors.centerIn: parent
    color: backgroundColor
    border.color: borderColor
    radius: 5
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
    transitions: Transition {
        NumberAnimation { property: "opacity"; duration: 500 }
    }

    property int iconSize: 75
    property bool stateVisible: noItemRec.visible

    property color borderColor: "transparent"
    property color backgroundColor: "transparent"

    property string textColor: "#888"
    property string iconColor: textColor
    property string iconName: "warning"
    property string firstText: qsTr("Warning! No itens found")
    property string secondText: qsTr("Touch to try again!")

    signal clicked()
    signal pressAndHold()
    signal visibleTrue()
    signal visibleFalse()

    onVisibleChanged: {
        if (visible)
            visibleTrue()
        else
            visibleFalse()
    }

    MouseArea {
        anchors.fill: parent
        onClicked: noItemRec.clicked()
        onPressAndHold: noItemRec.pressAndHold()
    }

    ColumnLayout {
        spacing: 10
        anchors.centerIn: parent
        visible: noItemRec.visible

        Awesome.AwesomeIcon {
            size: iconSize
            color: textColor
            name: iconName
            anchors.horizontalCenter: parent.horizontalCenter
        }

        Text {
            color: textColor
            text: firstText
            anchors.horizontalCenter: parent.horizontalCenter
            font {
                weight: Font.DemiBold
                pointSize: 12
            }
        }

        Text {
            color: textColor
            text: secondText
            font.pointSize: 10
            anchors.horizontalCenter: parent.horizontalCenter
        }
    }
}
