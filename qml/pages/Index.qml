import QtQuick 2.6
import QtQuick.Controls 2.0
import QtQuick.Controls.Material 2.0

Page {
    id: page
    objectName: "Index"
    background: Rectangle {
        anchors.fill: parent
        color: colorWindowBackground
    }


    Text {
        anchors.centerIn: parent
        text: "Wellcome to the Emile!"
        color: colorPrimary
        font {
            bold: true
            pointSize: 20
        }
    }
}
