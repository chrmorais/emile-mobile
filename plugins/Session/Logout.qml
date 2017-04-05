import QtQuick 2.8
import QtQuick.Controls 2.1

import "../../qml/components/"

BasePage {
    objectName: qsTr("Logout")
    hasListView: false
    busyIndicator.visible: true

    Component.onCompleted: window.menu.enabled = false

    Label {
        opacity: 0.7
        text: qsTr("You is exiting. Bye!")
        color: appSettings.theme.colorPrimary
        anchors { bottom: parent.bottom; bottomMargin: 15 }
    }

    Timer {
        running: true; interval: 1000
        onTriggered: window.endSession();
    }
}
