import QtQuick 2.8
import QtQuick.Controls 2.1

Item {
    width: parent.width * 0.55; height: parent.height

    property alias searchText: __searchInput.text

    TextField {
        id: __searchInput
        focus: visible
        width: parent.width
        color: defaultTextColor
        placeholderText: qsTr("Search")
        inputMethodHints: Qt.ImhNoPredictiveText
        anchors.verticalCenter: parent.verticalCenter
        onVisibleChanged: {
            var strTemp = "";
            __searchInput.text = strTemp;
            if (__searchInput.visible)
                __searchInput.forceActiveFocus();
        }
        background: Rectangle {
            color: defaultTextColor
            border { width: 1; color: defaultTextColor }
            y: (__searchInput.height-height) - (__searchInput.bottomPadding / 2)
            width: __searchInput.width; height: __searchInput.activeFocus ? 2 : 1
        }
    }
}
