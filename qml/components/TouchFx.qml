import QtQuick 2.6
import QtGraphicalEffects 1.0

MouseArea {
    id: view
    clip: true
    hoverEnabled: false
    width: parent.width * 2
    height: parent.height * 2
    z: 30
    anchors {
        fill: circular ? undefined : parent
        centerIn: circular ? parent : undefined
    }

    property int endRadius: 0
    property int focusWidth: width - 32
    property int startRadius: circular ? width/10 : width/6

    property Item lastCircle

    property bool focused: false
    property bool circular: false
    property bool centered: false
    property bool showFocus: true

    property color viewColor: Qt.rgba(0,0,0,0.1)
    property color focusColor: Qt.rgba(0,0,0,0.1)

    onCanceled: lastCircle.removeCircle()
    onReleased: lastCircle.removeCircle()
    onPressed: createTapCircle(mouse.x, mouse.y)

    function createTapCircle(x, y) {
        endRadius = centered ? width/2 : radius(x, y)
        showFocus = false
        lastCircle = tapCircle.createObject(view, {
            "circleX": centered ? width/2 : x,
            "circleY": centered ? height/2 : y
        })
    }

    function radius(x, y) {
        return Math.max(
            Math.max(dist(x, y, 0, 0), dist(x, y, width, height)),
            Math.max(dist(x, y, width, 0), dist(x, y, 0, height))
        )
    }

    function dist(x1, y1, x2, y2) {
        return Math.sqrt(((x2-x1)*(x2-x1)) + ((y2-y1)*(y2-y1)));
    }

    Rectangle {
        id: focusCircle
        antialiasing: true
        anchors.centerIn: parent
        width: focused ? focusedState ? focusWidth : Math.min(parent.width - 8, focusWidth + 12) : parent.width/5
        height: width
        radius: width/2
        opacity: showFocus && focused ? 1 : 0
        color: focusColor.a === 0 ? Qt.rgba(0,0,0,0.1) : focusColor

        property bool focusedState

        Behavior on opacity {
            NumberAnimation { duration: 400; easing.type: Easing.InOutQuad }
        }

        Behavior on width {
            NumberAnimation { duration: focusTimer.interval; }
        }

        Timer {
            id: focusTimer
            repeat: true
            interval: 50
            running: focused
            onTriggered: focusCircle.focusedState = !focusCircle.focusedState
        }
    }

    Component {
        id: tapCircle

        Item {
            id: circleItem
            anchors.fill: parent

            property real circleX
            property real circleY
            property bool closed
            property bool done

            function removeCircle() {
                done = true
                if (fillSizeAnimation.running) {
                    fillOpacityAnimation.stop()
                    closeAnimation.start()
                    circleItem.destroy(100)
                } else {
                    showFocus = true
                    fadeAnimation.start()
                    circleItem.destroy(300)
                }
            }

            Item {
                id: circleParent
                anchors.fill: parent
                visible: !circular

                Rectangle {
                    id: circleRectangle
                    opacity: 0
                    antialiasing: true
                    color: viewColor
                    width: radius * 2
                    height: radius * 2
                    x: circleItem.circleX - radius
                    y: circleItem.circleY - radius

                    NumberAnimation {
                        id: fillSizeAnimation
                        running: true
                        target: circleRectangle; property: "radius"; duration: 350;
                        from: startRadius; to: endRadius; easing.type: Easing.InOutQuad
                        onStopped: if (done) showFocus = true
                    }

                    NumberAnimation {
                        id: fillOpacityAnimation
                        running: true
                        target: circleRectangle; property: "opacity"; duration: 150;
                        from: 0; to: 1; easing.type: Easing.InOutQuad
                    }

                    NumberAnimation {
                        id: fadeAnimation
                        target: circleRectangle; property: "opacity"; duration: 150;
                        from: 1; to: 0; easing.type: Easing.InOutQuad
                    }

                    SequentialAnimation {
                        id: closeAnimation

                        NumberAnimation {
                            target: circleRectangle; property: "opacity"; duration: 150;
                            from: 0; to: 1; easing.type: Easing.InOutQuad
                        }

                        NumberAnimation {
                            target: circleRectangle; property: "opacity"; duration: 150;
                            from: 1; to: 0; easing.type: Easing.InOutQuad
                        }
                    }
                }
            }

            Item {
                z: 20
                anchors.fill: parent
                visible: circular

                Rectangle {
                    id: cMask
                    clip: true
                    smooth: true
                    visible: false
                    antialiasing: true
                    anchors.fill: parent
                    radius: Math.max(width/2, height/2)
                }

                OpacityMask {
                    id: mask
                    maskSource: cMask
                    anchors.fill: parent
                    source: circleParent
                }
            }
        }
    }
}
