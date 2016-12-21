import QtQuick 2.7
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.0
import QtQuick.Controls.Material 2.0

Page {
    objectName: "Logout"

    Component.onCompleted: {
        window.isUserLoggedIn = false;
        window.userProfileData = {};
    }

    BusyIndicator {
        anchors.centerIn: parent
    }

    Timer {
        interval: 3000
        onTriggered: setPage(null, null, true);
    }
}
