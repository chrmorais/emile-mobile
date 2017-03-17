import QtQuick 2.8
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.1

// implementation of Google Material Snackbar.
// https://material.google.com/components/snackbars-toasts.html

Item {
    id: snackbar
    width: parent.width; height: 48
    anchors { bottom: parent.bottom; bottomMargin: -48 }

    NumberAnimation {
        id: animateShowOpacity
        target: snackbar
        properties: "anchors.bottomMargin"
        from: -48
        to: 0
        duration: 400
        onStopped: if (closePending) closed();
    }

    NumberAnimation {
        id: animateHideOpacity
        target: snackbar
        properties: "anchors.bottomMargin"
        from: 0
        to: -48
        duration: 350
        onStopped: if (openPending) opened();
    }

    signal opened()
    signal closed()
    signal restarted()

    property bool isOpen: false
    property bool openPending: false
    property bool closePending: false
    property bool isLongDuration: false
    property string messageTemp: ""
    property alias actionText: action.text
    property alias actionTextColor: action.color

    property var closeCallback
    property var actionCallback

    function close() {
        closed();
        if (closeCallback) closeCallback();
    }

    function show(s) {
        messageTemp = s;
        if (isOpen) {
            restarted();
            close();
        } else {
            opened();
        }
    }

    onClosed: {
        if (!animateHideOpacity.running) {
            isOpen = false;
            animateHideOpacity.start();
        } else {
            openPending = true;
        }
    }

    onOpened: {
        if (!animateShowOpacity.running) {
            isOpen = true;
            message.text = messageTemp;
            countdownToClose.restart();
            animateShowOpacity.restart();
        } else {
            openPending = true;
        }
    }

    onRestarted: countdownToReopen.start();

    Timer {
        id: countdownToClose
        repeat: false
        interval: isLongDuration ? 8000 : 3500
        onTriggered: closed();
    }

    Timer {
        id: countdownToReopen
        repeat: false
        interval: 700
        onTriggered: opened();
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
                        snackbar.height *= 1.2;
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
                        countdownToClose.running = false;
                        animateHideOpacity.start();
                        if (actionCallback)
                            actionCallback();
                    }
                }
            }
        }
    }
}
