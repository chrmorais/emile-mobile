import QtQuick 2.6
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.0
import QtQuick.Controls.Material 2.0

Page {
    id: logoutPage
    objectName: "Logout"

    Component.onCompleted: {
        window.user_logged_in = 0
        window.user_profile_data = ""
    }

    BusyIndicator {
        anchors.centerIn: parent
    }

    Timer {
        id: countDownToDestroy
        interval: 3000
        onTriggered: setPage(null, null, true)
    }
}
