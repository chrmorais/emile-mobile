import QtQuick 2.6
import "Awesome.js" as Awesome

Item {
    id: widget
    width: text.width
    height: text.height
    anchors.verticalCenter: parent.verticalCenter

    property string name
    property int size: 24
    property bool rotate: widget.name.match(/.*-rotate/) !== null
    property bool valid: text.implicitWidth > 0
    property bool shadow: false
    property var icons: Awesome.map
    property alias color: text.color
    property alias weight: text.font.weight

    FontLoader { id: fontAwesome; source: Qt.resolvedUrl("FontAwesome.otf") }

    Text {
        id: text
        anchors.centerIn: parent
        text: widget.icons.hasOwnProperty(name) ? widget.icons[name] : ""
        color: iconColor
        style: shadow ? Text.Raised : Text.Normal
        styleColor: Qt.rgba(0,0,0,0.5)
        font.pixelSize: widget.size
        font {
            weight: Font.Light
            family: fontAwesome.name
        }

        property string name: widget.name.match(/.*-rotate/) !== null ? widget.name.substring(0, widget.name.length - 7) : widget.name

        Behavior on color {
            ColorAnimation { duration: 200 }
        }

        NumberAnimation on rotation {
            running: widget.rotate
            from: 0
            to: 360
            loops: Animation.Infinite
            duration: 1100
        }
    }
}
