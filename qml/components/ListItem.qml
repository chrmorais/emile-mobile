import QtQuick 2.7
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.0

import "AwesomeIcon/"

Item {
    id: listItem
    antialiasing: true; opacity: enabled ? 1 : 0.6
    width: parent.width; height: 50; implicitHeight: height
    anchors { left: parent ? parent.left : undefined; right: parent ? parent.right : undefined }
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
    property color primaryLabelColor: appSettings.theme.textColorPrimary

    property alias secondaryLabel: __secondaryLabelItem
    property alias secondaryLabelText: __secondaryLabelItem.text

    property alias primaryIconName: primaryActionIcon.name
    property alias primaryIconColor: primaryActionIcon.color
    property alias primaryImageSource: primaryActionImage.source

    property alias secondaryIconName: secondaryActionIcon.name
    property alias secondaryIconColor: secondaryActionIcon.color
    property alias secondaryImageSource: secondaryActionImage.source

    property bool selected: false
    property bool interactive: true
    property bool showSeparator: false

    property color backgroundColor: appSettings.theme.colorWindowForeground
    property color selectedTextColor: primaryLabelColor
    property color selectedBackgroundColor: Qt.rgba(0,0,0,0.1)

    property int badgeRadius: 9999
    property int badgeBorderWidth: 0
    property color badgeTextColor: appSettings.theme.textColorPrimary
    property color badgeBorderColor: "transparent"
    property color badgeBackgroundColor: "transparent"
    property string badgeText
    property bool badgeInRightSide: false
    property real badgeWidth: 50

    signal clicked()
    signal pressAndHold()
    signal secondaryActionClicked()
    signal secondaryActionPressAndHold()

    Rectangle {
        id: rect
        clip: true; anchors.fill: parent
        color: selected ? selectedBackgroundColor : backgroundColor
        antialiasing: radius > 0
        Behavior on color {
            ColorAnimation { duration: 200 }
        }
    }

    Component {
        id: badgeComponent

        Rectangle {
            radius: badgeRadius; color: badgeBackgroundColor
            width: badgeWidth
            border { width: badgeBorderWidth; color: badgeBorderColor }
            anchors { verticalCenter: parent.verticalCenter; horizontalCenter: parent.horizontalCenter }

            Text {
                anchors.centerIn: parent
                text: badgeText; color: badgeTextColor
                font { weight: Font.DemiBold; pointSize: 12 }
            }
        }
    }

    RowLayout {
        id: row
        spacing: 12
        anchors { fill: listItem; leftMargin: listItem.margins; rightMargin: listItem.margins }

        Item {
            id: primaryAction
            width: 40; height: parent.height
            visible: primaryActionLoader.active || children.length > 3 || primaryActionImage.source != "" || primaryActionIcon.name.length > 0

            Loader {
                id: primaryActionLoader
                anchors.centerIn: parent
                sourceComponent: badgeComponent
                asynchronous: true; active: badgeText.length > 0 && !primaryActionImage.visible && !primaryActionIcon.visible
                onLoaded: {
                    item.parent = primaryAction
                    if(badgeRadius != 0) {
                        item.width = primaryAction.width * 0.75; item.height = width
                    }
                    else {
                        item.width = primaryAction.width; item.height = width / 2
                    }
                }
            }

            Image {
                id: primaryActionImage
                asynchronous: true; cache: true; clip: true
                width: parent.width * 0.75; height: width
                visible: source.length > 0
            }

            AwesomeIcon {
                id: primaryActionIcon
                color: __primaryLabelItem.color
                width: parent.width * 0.75; height: width
                visible: (!primaryActionLoader.active || !primaryActionImage.visible) && name.length > 0
                anchors { verticalCenter: parent.verticalCenter; horizontalCenter: parent.horizontalCenter }
            }

            MouseArea { onClicked: listItem.clicked(); onPressAndHold: listItem.pressAndHold(); anchors.fill: parent }
        }

        ColumnLayout {
            id: textContent
            spacing: 0
            Layout.alignment: Qt.AlignVCenter
            Layout.preferredHeight: parent.height
            Layout.preferredWidth: parent.width - (primaryAction.width + secondaryAction.width + 20)
            anchors.verticalCenter: parent.verticalCenter

            Text {
                id: __primaryLabelItem
                Layout.fillWidth: true
                elide: Text.ElideRight
                Layout.alignment: Qt.AlignVCenter
                color: selected ? selectedTextColor : primaryLabelColor; fontSizeMode: Text.Fit
                visible: text != ""; textFormat: Text.RichText
                font { weight: Font.DemiBold; pointSize: 14 }
                anchors {
                    top: __secondaryLabelItem.visible ? parent.top : undefined
                    topMargin: __secondaryLabelItem.visible ? 10 : 0
                    verticalCenter: __secondaryLabelItem.visible ? undefined : parent.verticalCenter
                }
            }

            Text {
                id: __secondaryLabelItem
                Layout.alignment: Qt.AlignVCenter
                color: __primaryLabelItem.color; font.pointSize: 12
                opacity: 0.7
                visible: text != "" && __primaryLabelItem.text
                elide: Text.ElideRight; wrapMode: Text.WrapAtWordBoundaryOrAnywhere
                Component.onCompleted: text = text.length > 32 ? text.substring(0, 30) + "..." : text
                anchors {
                    bottom: __primaryLabelItem.visible ? parent.bottom : undefined
                    bottomMargin: __primaryLabelItem.visible ? 10 : 0
                    verticalCenter: __primaryLabelItem.visible ? undefined : parent.verticalCenter
                }
            }

            MouseArea { onClicked: listItem.clicked(); onPressAndHold: listItem.pressAndHold(); anchors.fill: parent }
        }

        Item {
            id: secondaryAction
            width: 40; height: parent.height; anchors.right: parent.right
            visible: secondaryActionLoader.active || secondaryActionImage.visible || secondaryActionIcon.visible

            Loader {
                id: secondaryActionLoader
                anchors.centerIn: parent
                sourceComponent: badgeComponent
                asynchronous: true; active: badgeText.length > 0 && badgeInRightSide && !secondaryActionImage.visible && !secondaryActionIcon.visible
                onLoaded: {
                    item.parent = secondaryAction
                    item.width = secondaryAction.width * 0.75; item.height = width
                }
            }

            Image {
                id: secondaryActionImage
                asynchronous: true; cache: true; clip: true
                width: parent.width * 0.75; height: width
                visible: source.length > 0
            }

            AwesomeIcon {
                id: secondaryActionIcon
                color: __primaryLabelItem.color
                width: parent.width * 0.75; height: width
                visible: !secondaryActionImage.visible && name.length > 0
                anchors { verticalCenter: parent.verticalCenter; horizontalCenter: parent.horizontalCenter }
            }

            MouseArea { anchors.fill: parent; enabled: secondaryAction.visible; onClicked: secondaryActionClicked(); onPressAndHold: secondaryActionPressAndHold() }
        }
    }

    Rectangle {
        id: divider
        width: parent.width; height: 1
        antialiasing: true; visible: showSeparator
        color: Qt.rgba(0,0,0,0.1)
        anchors { bottom: parent.bottom; leftMargin: separatorInset }
    }
}
