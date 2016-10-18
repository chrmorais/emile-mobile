import QtQuick 2.6
import QtQuick.Window 2.2
import QtGraphicalEffects 1.0

Item {
    id: icon
    width: size
    height: size

    property real size: 30
    property color color: "#000"
    property string source

    Image {
        id: image
        asynchronous: true
        antialiasing: true
        anchors.fill: parent
        source: icon.source.indexOf("svg") === -1 ? icon.source + ".svg" : icon.source
        sourceSize {
            width: size * Screen.devicePixelRatio
            height: size * Screen.devicePixelRatio
        }
    }

    ColorOverlay {
        id: overlay
        cached: true
        source: image
        color: icon.color
        anchors.fill: parent
        opacity: icon.color.a
        visible: image.source != ""
    }
}
