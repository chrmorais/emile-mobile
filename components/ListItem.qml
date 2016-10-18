import QtQuick 2.6
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.0
import QtGraphicalEffects 1.0
import QtQuick.Controls.Material 2.0

Item {
    id: listItem
    width: 100
    height: 50
    antialiasing: true
    opacity: enabled ? 1 : 0.6
    implicitHeight: height
    anchors {
        left: parent ? parent.left : undefined
        right: parent ? parent.right : undefined
    }
    implicitWidth: {
        var width = listItem.margins * 2

        if (primaryAction.visible)
            width += primaryAction.width + row.spacing

        if (__primaryLabelItem.visible)
            width += __primaryLabelItem.implicitWidth + row.spacing
        else
            width += __primaryLabelItem.implicitWidth + row.spacing

        if (__secondaryLabelItem.visible)
            width += secondaryLabel.width + row.spacing

        if (secondaryAction.visible)
            width += secondaryAction.width + row.spacing

        return width
    }

    property int margins: 16
    property alias radius: rect.radius
    property int separatorInset: primaryAction.visible ? listItem.height : 0

    property alias separatorColor: divider.color
    property alias separatorWidth: divider.width
    property alias separatorHeight: divider.height

    property alias primaryLabel: __primaryLabelItem
    property alias primaryLabelText: __primaryLabelItem.text
    property color primaryLabelColor: __primaryLabelItem.color

    property alias secondaryLabel: __secondaryLabelItem
    property alias secondaryLabelText: __secondaryLabelItem.text
    property alias secondaryLabelColor: __secondaryLabelItem.color

    property alias primaryAction: primaryAction
    property QtObject primaryImageIcon: primaryImageIconAction
    property alias primaryImageIconSource: primaryImageIconAction.source

    property alias secondaryAction: secondaryAction
    property QtObject secondaryImageIcon: secondaryImageIconAction
    property alias secondaryImageIconSource: secondaryImageIconAction.source

    property bool selected: false
    property bool interactive: true
    property bool showSeparator: false
    property bool darkBackground: false

    property color selectedColor: "#f0ffff"
    property color backgroundColor: selected ? Qt.rgba(0,0,0,0.03) : touchFx.containsMouse ? Qt.rgba(0,0,0,0.03) : Qt.rgba(0,0,0,0)

    signal clicked()
    signal pressAndHold()

    signal secondaryActionClicked()
    signal secondaryActionPressAndHold()

    MouseArea {
        id: touchFx
        z: 10
        anchors.fill: parent
        enabled: listItem.interactive && listItem.enabled
        onClicked: listItem.clicked()
        onPressAndHold: listItem.pressAndHold()
    }

    Rectangle {
        id: rect
        clip: true
        anchors.fill: parent
        color: backgroundColor
        antialiasing: radius > 0

        Behavior on color {
            ColorAnimation { duration: 200 }
        }
    }

    RowLayout {
        id: row
        spacing: 0
        anchors {
            fill: listItem
            leftMargin: listItem.margins
            rightMargin: listItem.margins
        }

        Item {
            id: primaryAction
            Layout.preferredWidth: 40
            Layout.preferredHeight: width
            Layout.alignment: Qt.AlignCenter
            visible: !primaryAction.children ? false : primaryAction.children.length > 1
            anchors {
                left: parent.left
                verticalCenter: parent.verticalCenter
            }

            Image {
                id: primaryImageIconAction
                width: parent.width
                height: parent.height
                anchors {
                    left: parent.left
                    verticalCenter: parent.verticalCenter
                }
            }

            TouchFx {
                onClicked: listItem.clicked()
                onPressAndHold: listItem.pressAndHold()
            }
        }

        ColumnLayout {
            id: textContent
            spacing: 0
            Layout.alignment: Qt.AlignVCenter
            Layout.preferredHeight: parent.height
            Layout.preferredWidth: parent.width - (primaryAction.width + secondaryAction.width)
            anchors {
                verticalCenter: parent.verticalCenter
                left: primaryAction.right
                right: secondaryAction.left
            }

            Label {
                id: __primaryLabelItem
                Layout.alignment: Qt.AlignVCenter
                Layout.fillWidth: true
                elide: Text.ElideRight
                visible: text != ""
                color: "#000"
                anchors {
                    top: __secondaryLabelItem.visible ? parent.top : undefined
                    topMargin: __secondaryLabelItem.visible ? 10 : 0
                    verticalCenter: __secondaryLabelItem.visible ? undefined : parent.verticalCenter
                }
                font {
                    weight: Font.DemiBold
                    pointSize: 9
                }
            }

            Label {
                id: __secondaryLabelItem
                visible: text != "" && __primaryLabelItem.text
                Layout.alignment: Qt.AlignVCenter
                elide: Text.ElideRight
                wrapMode: Text.WrapAtWordBoundaryOrAnywhere
                color: "#777"
                font.pointSize: 7
                Component.onCompleted: text = text.length > 32 ? text.substring(0, 30) + "..." : text
                anchors {
                    bottom: __primaryLabelItem.visible ? parent.bottom : undefined
                    bottomMargin: __primaryLabelItem.visible ? 10 : 0
                    verticalCenter: __primaryLabelItem.visible ? undefined : parent.verticalCenter
                }
            }

            TouchFx {
                onClicked: listItem.clicked()
                onPressAndHold: listItem.pressAndHold()
            }
        }

        Item {
            id: secondaryAction
            Layout.preferredWidth: 40
            Layout.preferredHeight: width
            Layout.alignment: Qt.AlignCenter
            visible: (secondaryImageIcon.name || secondaryImageIcon.source !== null && secondaryImageIconAction.source.length !== undefined)
            anchors {
                right: parent.right
                rightMargin: -(margins*2)
                verticalCenter: parent.verticalCenter
            }

            Image {
                id: secondaryImageIconAction
                width: parent.width
                height: parent.height
                anchors {
                    right: parent.right
                    rightMargin: 0
                    verticalCenter: parent.verticalCenter
                }
            }
        }

        TouchFx {
            enabled: secondaryAction.visible
            onClicked: secondaryActionClicked()
            onPressAndHold: secondaryActionPressAndHold()
        }
    }

    Rectangle {
        id: divider
        antialiasing: true
        visible: showSeparator
        color: Qt.rgba(0,0,0,0.1)
        width: parent.width
        height: 1
        anchors {
            bottom: parent.bottom
            leftMargin: separatorInset
        }
    }
}
