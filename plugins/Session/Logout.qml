import QtQuick 2.7
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.0
import QtQuick.Controls.Material 2.0

Page {
    objectName: "Logout"

    Component.onCompleted: {
        window.menu.enabled = false;
        window.isUserLoggedIn = false;
        window.userProfileData = {};
    }

    BusyIndicator {
        anchors.centerIn: parent
    }

    Timer {
        running: true; interval: 1000
        onTriggered: setIndexPage(true);
    }
}
