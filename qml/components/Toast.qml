import QtQuick 2.7
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.0

Rectangle {
    id: toast
    radius: 70
    width: parent.width / (textToast.text.length >= 20 ? 1.6 : 2.5)
    height: textToast.height * 2
    color: "#555"
    opacity: 0
    anchors {
        horizontalCenter: parent.horizontalCenter
        bottom: parent.bottom
        bottomMargin: 50
    }

    property string text: textToast.text
    property alias animation: animateShowOpacity

    function show(s) {
        toast.text = s
        toast.animation.start()
    }

    Timer {
        id: timer
        interval: 2000
        running: toast.opacity === 1
        onTriggered: animateHideOpacity.start()
    }

    Text {
        id: textToast
        anchors.centerIn: parent
        width: parent.width - 5
        wrapMode: Text.WrapAnywhere
        text: toast.text.length >= 35 ? toast.text.substring(0,35) + " ..." : toast.text
        horizontalAlignment: Text.AlignHCenter
        enabled: text !== ""
        color: "#ddd"
    }

    NumberAnimation {
        id: animateShowOpacity
        target: toast
        properties: "opacity"
        from: 0
        to: 1
        duration: 450
    }

    NumberAnimation {
        id: animateHideOpacity
        target: toast
        properties: "opacity"
        from: 1
        to: 0
        duration: 450
    }
}
