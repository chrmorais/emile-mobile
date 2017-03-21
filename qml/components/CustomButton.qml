import QtQuick 2.7
import QtQuick.Controls 2.0
import QtQuick.Controls.Material 2.0

Button {
    id: __customButton
    radius: 25
    opacity: enabled ? 1.0 : 0.8
    anchors.horizontalCenter: parent.horizontalCenter
    background: Rectangle {
        id: __backgroundButton
        opacity: __customButton.opacity; color: appSettings.theme.colorPrimary
        implicitWidth: 180; implicitHeight: 25
    }
    contentItem: Text {
        id: __customButtonText
        elide: Text.ElideRight; font.bold: true; color: appSettings.theme.colorAccent
        text: __customButton.text.toUpperCase(); opacity: __backgroundButton.opacity
        horizontalAlignment: Text.AlignHCenter; verticalAlignment: Text.AlignVCenter
    }

    property alias radius: __backgroundButton.radius
    property alias textColor: __customButtonText.color
    property alias backgroundColor: __backgroundButton.color

    signal clicked()

    MouseArea {
        anchors.fill: parent
        onClicked: __customButton.clicked()
    }
}
