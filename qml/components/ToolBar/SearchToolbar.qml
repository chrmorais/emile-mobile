import QtQuick 2.8
import QtQuick.Controls 2.1

Item {
    width: visible ? parent.width * 0.55 : 0
    height: parent.height

    property alias searchText: __searchInput.text
    property alias defaultTextColor: __searchInput.color

    TextField {
        id: __searchInput
        focus: visible
        width: parent.width
        placeholderText: qsTr("Search")
        inputMethodHints: Qt.ImhNoPredictiveText
        anchors.verticalCenter: parent.verticalCenter
        onVisibleChanged: {
            var strTemp = "";
            __searchInput.text = strTemp;
            if (__searchInput.visible)
                __searchInput.forceActiveFocus();
        }
    }
}
