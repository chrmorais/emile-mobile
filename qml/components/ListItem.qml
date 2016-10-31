import QtQuick 2.6
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.0

Item {
    id: listItem
    width: parent.width
    height: 60
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

    property QtObject secondaryImageIcon: secondaryImageIconAction
    property alias secondaryAction: secondaryAction
    property alias secondaryImageIconSource: secondaryImageIconAction.source

    property bool selected: false
    property bool interactive: true
    property bool showSeparator: false
    property bool darkBackground: false

    property color selectedColor: "#f0ffff"
    property color backgroundColor: selected ? Qt.rgba(0,0,0,0.15) : "#fff"

    property int badgeRadius: 9999
    property int badgeborderWidth: 0
    property color badgeborderColor: "transparent"
    property color badgeBackgroundColor: "#" + Math.random().toString(16).slice(2,8)
    property string badgeText

    signal clicked()
    signal pressAndHold()

    signal secondaryActionClicked()
    signal secondaryActionPressAndHold()

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

    Component {
        id: badgeComponent

        Rectangle {
            radius: badgeRadius
            color: badgeBackgroundColor
            anchors {
                verticalCenter: parent.verticalCenter
                horizontalCenter: parent.horizontalCenter
            }
            border {
                width: badgeborderWidth
                color: badgeborderColor
            }

            Text {
                anchors.centerIn: parent
                text: badgeText
                color: "#fff"
                font {
                    weight: Font.DemiBold
                    pointSize: 10
                }
            }
        }
    }

    RowLayout {
        id: row
        spacing: 12
        anchors {
            fill: listItem
            leftMargin: listItem.margins
            rightMargin: listItem.margins
        }

        Item {
            id: primaryAction
            width: 40
            height: parent.height
            visible: primaryActionLoader.active || primaryAction.children.length > 3 || primaryImageIconAction.source != ""

            Loader {
                id: primaryActionLoader
                width: primaryAction.width * 0.75
                height: width
                anchors.centerIn: parent
                asynchronous: true
                active: badgeText.length > 0
                sourceComponent: badgeComponent
            }

            Image {
                id: primaryImageIconAction
                visible: !primaryActionLoader.active || source.length > 0
                width: primaryAction.width * 0.75
                height: width
                asynchronous: true
                antialiasing: true
                fillMode: Image.Stretch
                anchors {
                    verticalCenter: parent.verticalCenter
                    horizontalCenter: parent.horizontalCenter
                }
            }

            MouseArea {
                onClicked: listItem.clicked()
                onPressAndHold: listItem.pressAndHold()
                anchors.fill: parent
            }
        }

        ColumnLayout {
            id: textContent
            spacing: 0
            Layout.alignment: Qt.AlignVCenter
            Layout.preferredHeight: parent.height
            Layout.preferredWidth: parent.width - (primaryAction.width + secondaryAction.width + 20)
            anchors .verticalCenter: parent.verticalCenter

            Text {
                id: __primaryLabelItem
                Layout.alignment: Qt.AlignVCenter
                Layout.fillWidth: true
                elide: Text.ElideRight
                visible: text != ""
                textFormat: Text.RichText
                color: "#333"
                fontSizeMode: Text.Fit
                anchors {
                    top: __secondaryLabelItem.visible ? parent.top : undefined
                    topMargin: __secondaryLabelItem.visible ? 10 : 0
                    verticalCenter: __secondaryLabelItem.visible ? undefined : parent.verticalCenter
                }
                font {
                    weight: Font.DemiBold
                    pointSize: 14
                }
            }

            Label {
                id: __secondaryLabelItem
                visible: text != "" && __primaryLabelItem.text
                Layout.alignment: Qt.AlignVCenter
                elide: Text.ElideRight
                wrapMode: Text.WrapAtWordBoundaryOrAnywhere
                color: "#777"
                font.pointSize: 12
                Component.onCompleted: text = text.length > 32 ? text.substring(0, 30) + "..." : text
                anchors {
                    bottom: __primaryLabelItem.visible ? parent.bottom : undefined
                    bottomMargin: __primaryLabelItem.visible ? 10 : 0
                    verticalCenter: __primaryLabelItem.visible ? undefined : parent.verticalCenter
                }
            }

            MouseArea {
                onClicked: listItem.clicked()
                onPressAndHold: listItem.pressAndHold()
                anchors.fill: parent
            }
        }

        Item {
            id: secondaryAction
            width: 40
            height: parent.height
            visible: (secondaryAction.children > 2 || secondaryImageIconAction.source.length > 0 || secondaryImageIconAction.source.length !== undefined)

            Image {
                id: secondaryImageIconAction
            }

            MouseArea {
                anchors.fill: parent
                enabled: secondaryAction.visible
                onClicked: listItem.clicked()
                onPressAndHold: secondaryActionPressAndHold()
            }
        }
    }

    Rectangle {
        id: divider
        width: parent.width
        height: 1
        antialiasing: true
        visible: showSeparator
        color: Qt.rgba(0,0,0,0.1)
        anchors {
            bottom: parent.bottom
            leftMargin: separatorInset
        }
    }
}
