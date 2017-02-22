import QtQuick 2.7

import "../../qml/components/"

BasePage {
    objectName: qsTr("Logout")
    hasListView: false
    hasRemoteRequest: false
    busyIndicator.visible: true

    Timer {
        running: true; interval: 1000
        onTriggered: window.endSession();
    }
}
