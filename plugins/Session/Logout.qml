import QtQuick 2.7

import "../../qml/components/"

BasePage {
    objectName: qsTr("Logout")
    hasListView: false
    busyIndicator.visible: true

    Component.onCompleted: window.menu.enabled = false

    Timer {
        running: true; interval: 1000
        onTriggered: window.endSession();
    }
}
