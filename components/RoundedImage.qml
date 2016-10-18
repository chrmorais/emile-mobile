import QtQuick 2.6
import QtQuick.Controls 2.0
import QtQuick.Controls.Styles 1.4
import QtQuick.Controls.Material 2.0

Rectangle {
    id: roundedImage
    objectName: "RoundedImage"
    antialiasing: true
    color: "transparent"

    property int displayBusy: 1
    property alias source: img.source
    property color borderColor: "transparent"

    // this Rectangle is needed to keep the source image's fillMode
    Rectangle {
        id: imageSource
        visible: false
        anchors.fill: parent
        layer.enabled: true
        antialiasing: true
        states: [
            State {
                when: img.progress === 1.0
                PropertyChanges { target: img; opacity: 1.0 }
            },
            State {
                when: img.progress !== 1.0
                PropertyChanges { target: img; opacity: 0.0 }
            }
        ]
        transitions: [
            Transition {
                NumberAnimation {
                    property: "opacity"; duration: 300
                }
            }
        ]

        Image {
            id: img
            clip: true
            cache: true
            smooth: true
            asynchronous: true
            anchors.fill: parent
            fillMode: Image.PreserveAspectCrop
        }
    }

    BusyIndicator {
        z: 10
        width: 48
        height: 48
        antialiasing: true
        anchors.centerIn: parent
        visible: displayBusy && img.progress !== 1.0
    }

    Rectangle {
        antialiasing: true
        color: "#fff"
        layer.enabled: true
        anchors.fill: parent
        radius: parent.width
        layer.samplerName: "maskSource"
        layer.effect: ShaderEffect {
            property var colorSource: imageSource
            fragmentShader: "
                uniform lowp sampler2D colorSource;
                uniform lowp sampler2D maskSource;
                uniform lowp float qt_Opacity;
                varying highp vec2 qt_TexCoord0;
                void main() {
                    gl_FragColor = texture2D(colorSource, qt_TexCoord0) * texture2D(maskSource, qt_TexCoord0).a * qt_Opacity;
                }"
        }
    }

    // only for draw border line
    Rectangle {
        border.width: 1
        anchors.fill: parent
        color: "transparent"
        radius: parent.width
        border.color: borderColor
        antialiasing: true
    }
}
