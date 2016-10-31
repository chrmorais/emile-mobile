import QtQuick 2.6
import QtQuick.Controls 2.0
import QtQuick.Controls.Material 2.0

Button {
    id: __customButton
    width: buttonWidth
    anchors.horizontalCenter: parent.horizontalCenter
    background: Rectangle {
        id: __backgroundButton
        width: __customButton.width
        height: __customButton.height
        opacity: enabled ? 1 : 0.3
    }
    contentItem: Text {
        id: __customButtonText
        text: __customButton.text
        opacity: enabled ? 1.0 : 0.5
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        elide: Text.ElideRight
        font.bold: true
    }

    TouchFx {
        circular: __backgroundButton.radius > 5
        anchors.fill: parent
        onClicked: __customButton.clicked()
    }

    property int buttonWidth: 185
    property alias radius: __backgroundButton.radius
    property alias textColor: __customButtonText.color
    property alias backgroundColor: __backgroundButton.color

    signal clicked()
}
