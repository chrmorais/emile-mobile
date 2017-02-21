import QtQuick 2.7

import "../../qml/components/"

BasePage {
    objectName: qsTr("Logout")
    busyIndicator.visible: true

    Component.onCompleted: {
        window.menu.enabled = false;
        window.isUserLoggedIn = false;
        window.userProfileData = {};
    }

    Timer {
        running: true; interval: 1000
        onTriggered: setIndexPage(true, false);
    }
}
