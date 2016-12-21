import QtQuick 2.7
import QtQuick.Controls 2.0

import "Awesome.js" as Awesome

Item {
    id: widget
    width: text.width; height: text.height
    anchors.verticalCenter: parent.verticalCenter

    property string name
    property int size: 20
    property bool shadow: false
    property bool valid: text.implicitWidth > 0
    property bool rotate: widget.name.match(/.*-rotate/) !== null
    property var icons: Awesome.map
    property alias color: text.color
    property alias weight: text.font.weight

    FontLoader { id: fontAwesome; source: Qt.resolvedUrl("FontAwesome.otf") }

    Text {
        id: text
        anchors.centerIn: parent
        styleColor: Qt.rgba(0,0,0,0.5)
        text: widget.icons.hasOwnProperty(name) ? widget.icons[name] : ""
        color: widget.color; style: shadow ? Text.Raised : Text.Normal
        font {
            weight: Font.Light
            pointSize: widget.size
            family: fontAwesome.name
        }

        property string name: widget.name.match(/.*-rotate/) !== null ? widget.name.substring(0, widget.name.length - 7) : widget.name

        Behavior on color {
            ColorAnimation { duration: 200 }
        }

        NumberAnimation on rotation {
            running: widget.rotate
            loops: Animation.Infinite
            from: 0; to: 360; duration: 1100
        }
    }
}
