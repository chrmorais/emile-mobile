import QtQuick 2.7

Rectangle {
    width: 200; height: 200
    color: "blue"
    MouseArea {
        anchors.fill: parent
        onClicked: { stackView.pop() }
    }
}
