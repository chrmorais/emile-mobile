import QtQuick 2.7
import QtQuick.Controls 2.0
import QtQuick.Controls.Material 2.0

Page {
    id: page
    title: "Home"
    objectName: "Home"

    Text {
        anchors.centerIn: parent
        text: qsTr("Wellcome to the Emile!")
        color: appSettings.theme.colorPrimary
        font { bold: true; pointSize: 20 }
    }
}
