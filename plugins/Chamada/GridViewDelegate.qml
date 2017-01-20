import QtQuick 2.7
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.0
import QtQuick.Controls.Material 2.0

Item {
    id: item
    width: gridView.cellWidth; height: gridView.cellHeight
    opacity: switchStatus.checked ? 0.75 : 1.0

    Rectangle {
        height: column.height; width: parent.width
        color: "transparent"
        border.color: switchStatus.checked ? appSettings.theme.colorPrimary : appSettings.theme.colorAccent
        anchors { top: parent.top; topMargin: 10; horizontalCenter: parent.horizontalCenter }

        Column {
            id: column
            spacing: 15; width: parent.width - parent.width * 0.05

            Image {
                id: imgProfile
                asynchronous: true
                source: defaultUserImage
                width: 55; height: 55
                fillMode: Image.PreserveAspectCrop
                clip: true; cache: true; smooth: true
                sourceSize { width: width; height: height }
                anchors.horizontalCenter: parent.horizontalCenter
            }

            Label {
                text: email + ""
                width: parent.width / 1.3
                color: appSettings.theme.colorPrimary
                font.pointSize: appSettings.theme.middleFontSize
                anchors.horizontalCenter: parent.horizontalCenter
                elide: Text.ElideRight
            }

            Switch {
                id: switchStatus
                text: checkedStatus != null && checkedStatus[id] ? checkedStatus[id] : "P"
                anchors.horizontalCenter: parent.horizontalCenter
                font.weight: Font.DemiBold
                checked: switchStatus.text == "P"
                onClicked: {
                    switchStatus.text = (switchStatus.text == "F" ? "P" : "F")
                    save(id, switchStatus.text)
                }
            }
        }
    }
}
