import QtQuick 2.6
import QtQuick.Controls 2.0

import "AwesomeIcon/" as Awesome

Item {
    width: parent.width * 0.45
    anchors.verticalCenter: parent.verticalCenter

    property alias searchText: __searchInput.text
    property alias searchSection: __searchSection
    property alias currentPageTitle: __title.text

    Label {
        id: __title
        width: parent.width
        visible: !__searchSection.visible
        elide: "ElideRight"
        color: appSettings.theme.textColorPrimary
        anchors.verticalCenter: parent.verticalCenter
        font {
            weight: Font.DemiBold
            pointSize: 10
        }
    }

    Row {
        id: __searchSection
        visible: false
        spacing: 5
        width: parent.width
        anchors {
            left: parent.left
            right: parent.right
            verticalCenter: parent.verticalCenter
        }

        onVisibleChanged: {
            var strTemp = ""
            __searchInput.text = strTemp
            __searchInput.text.length = 0
            if (__searchSection.visible)
                __searchInput.forceActiveFocus()
        }

        TextField {
            id: __searchInput
            width: parent.width * 0.60
            maximumLength: 30
            focus: __searchSection.visible
            color: appSettings.theme.textColorPrimary
            placeholderText: "Search"
            inputMethodHints: Qt.ImhNoPredictiveText
            background: Rectangle {
                y: (__searchInput.height-height) - ((__searchInput.bottomPadding / 2) + 2)
                width: __searchInput.width
                implicitWidth: __searchInput.width
                height: 1
                color: appSettings.theme.textColorPrimary
                border {
                    width: 1
                    color: appSettings.theme.textColorPrimary
                }
            }
        }
    }
}
