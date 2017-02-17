import QtQuick 2.7

Column {
    id: root
    z: Infinity
    spacing: 5
    anchors {
        bottom: atCenter ? undefined : parent.bottom
        bottomMargin: atCenter ? undefined : 10
        centerIn: atCenter ? parent : undefined
        horizontalCenter: atCenter ? undefined : parent.horizontalCenter
    }

    property bool atCenter: false

    function show(text, duration, putInCenter) {
        if (putInCenter)
            atCenter = putInCenter;
        var toast = toastComponent.createObject(root);
        toast.selfDestroying = true;
        toast.show(text, duration);
    }

    Component {
        id: toastComponent

        Rectangle {
            id: root
            opacity: 0
            radius: margin*2; color: "#323232"
            border { color: "transparent"; width: 0 }
            width: childrenRect.width + (2 * margin)
            height: childrenRect.height + (2 * margin)
            anchors.horizontalCenter: parent.horizontalCenter

            property real margin: 10
            property bool selfDestroying: false // Whether this Toast will selfdestroy when it is finished
            property real time: defaultTime
            readonly property real defaultTime: 3000
            readonly property real fadeTime: 350

            /**
             * @brief Shows this Toast
             *
             * @param {string} text Text to show
             * @param {real} duration Duration to show in milliseconds, defaults to 3000
             */
            function show(text, duration) {
                theText.text = text;
                if (typeof duration !== "undefined") {
                    if (duration >= (2*fadeTime))
                        time = duration;
                    else
                        time = 2*fadeTime;
                } else {
                    time = defaultTime;
                }
                anim.start();
            }

            Text {
                id: theText
                text: ""; color: "#fff"
                x: margin; y: margin
                horizontalAlignment: Text.AlignHCenter
            }

            SequentialAnimation on opacity {
                id: anim
                running: false

                NumberAnimation {
                    to: 0.9
                    duration: fadeTime
                }
                PauseAnimation {
                    duration: time - 2*fadeTime
                }
                NumberAnimation {
                    to: 0
                    duration: 2*fadeTime
                }

                onRunningChanged: {
                    if (!running && selfDestroying)
                        root.destroy();
                }
            }
        }
    }
}
