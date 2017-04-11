import QtQuick 2.8
import QtQuick.Controls 2.1

import "../../qml/components/"

BasePage {
    objectName: qsTr("Logout")
    hasListView: false
    busyIndicator.visible: true

    Component.onCompleted: window.menu.enabled = false

    Label {
        text: qsTr("You is exiting. Bye!")
        color: appSettings.theme.colorPrimary
        opacity: 0.7; font { pointSize: appSettings.theme.bigFontSize; bold: true }
        anchors { bottom: parent.bottom; bottomMargin: 20; horizontalCenter: parent.horizontalCenter }
    }

    Timer {
        running: true; interval: 1000
        onTriggered: window.endSession();
    }
}
