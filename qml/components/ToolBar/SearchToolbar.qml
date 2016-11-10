import QtQuick 2.6
import QtQuick.Controls 2.0
import QtQuick.Controls.Material 2.0

Item {
    width: visible ? parent.width * 0.55 : 0
    height: parent.height

    property alias searchText: __searchInput.text

    TextField {
        id: __searchInput
        focus: visible
        color: "#fff"
        width: parent.width
        placeholderText: qsTr("Search")
        inputMethodHints: Qt.ImhNoPredictiveText
        anchors.verticalCenter: parent.verticalCenter
        onVisibleChanged: {
            var strTemp = ""
            __searchInput.text = strTemp
            if (__searchInput.visible)
                __searchInput.forceActiveFocus()
        }
    }
}
