import QtQuick 2.6
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.0

// implementation of Google Material Snackbar.
// https://material.google.com/components/snackbars-toasts.html

Item {
    id: snackbar
    width: parent.width
    height: 48
    anchors {
        bottom: parent.bottom
        bottomMargin: -48
    }

    NumberAnimation {
        id: animateShowOpacity
        target: snackbar
        properties: "anchors.bottomMargin"
        from: -48
        to: 0
        duration: 400
    }

    NumberAnimation {
        id: animateHideOpacity
        target: snackbar
        properties: "anchors.bottomMargin"
        from: 0
        to: -48
        duration: 350
    }

    signal opened()
    signal closed()
    signal restarted()

    property bool isOpen: false
    property bool isAutoDestroy: true
    property bool isLongDuration: false
    property alias message: message.text
    property alias actionText: action.text
    property alias actionTextColor: action.color

    property var closeCallback
    property var actionCallback

    function close() {
        closed()
        if (closeCallback)
            closeCallback()
    }

    function show(s) {
        message.text = s
        if (isOpen) {
            restarted()
            close()
        } else {
            opened()
        }
    }

    onClosed: {
        isOpen = false
        animateHideOpacity.start()
        countdownToDestroy.running = true
    }

    onOpened: {
        isOpen = true
        countdownToClose.start()
        animateShowOpacity.start()
    }

    onRestarted: {
        countdownToReopen.start()
        countdownToDestroy.stop()
    }

    Timer {
        id: countdownToClose
        repeat: false
        interval: isLongDuration ? 8000 : 4000
        onTriggered: closed()
    }

    Timer {
        id: countdownToReopen
        repeat: false
        interval: 700
        onTriggered: opened()
    }

    Timer {
        id: countdownToDestroy
        repeat: false
        interval: 10000
        onTriggered: {
            message.text = ""
            actionText = ""
            actionTextColor = "#e7f740"
            if (isAutoDestroy)
                snackbar.destroy()
        }
    }

    Rectangle {
        id: rectSnack
        anchors.fill: parent
        color: "#323232"

        RowLayout {
            width: parent.width
            height: parent.height
            anchors {
                left: parent.left
                leftMargin: 15
                right: parent.right
                verticalCenter: parent.verticalCenter
            }

            Text {
                id: message
                fontSizeMode: Text.Fit
                width: parent.width * 0.70
                color: "#fff"
                font.pointSize: 14
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignLeft
                anchors.verticalCenter: parent.verticalCenter
                wrapMode: Text.WrapAtWordBoundaryOrAnywhere
                onTextChanged: {
                    while (snackbar.height < message.text.contentHeight)
                        snackbar.height *= 1.2
                }
            }

            Rectangle {
                id: actionRec
                color: "transparent"
                height: parent.height
                width: parent.width * 0.28
                anchors.right: parent.right

                Text {
                    id: action
                    color: "#e7f740"
                    font.pointSize: 16
                    verticalAlignment: Text.AlignVCenter
                    anchors {
                        verticalCenter: parent.verticalCenter
                        horizontalCenter: parent.horizontalCenter
                    }
                }

                MouseArea {
                    anchors.fill: parent
                    onEntered: actionRec.color = Qt.rgba(0,0,0,0.2)
                    onExited: actionRec.color = "transparent"
                    onClicked: {
                        countdownToClose.running = false
                        animateHideOpacity.start()
                        if (actionCallback)
                            actionCallback()
                    }
                }
            }
        }
    }
}
