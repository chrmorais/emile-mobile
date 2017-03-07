import QtQuick 2.7
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.0
import QtQuick.Controls.Material 2.0

Item {
    id: item
    width: gridView.cellWidth; height: gridView.cellHeight
    opacity: switchStatus.checked ? 0.75 : 1.0

    Rectangle {
        radius: 6
        height: column.height; width: parent.width * 0.95
        color: appSettings.theme.colorWindowForeground
        anchors { top: parent.top; topMargin: 10; horizontalCenter: parent.horizontalCenter }

        Pane {
            z: parent.z-10
            width: parent.width; height: parent.height
            Material.elevation: 3
        }

        Column {
            id: column
            spacing: 15; width: parent.width - parent.width * 0.05
            anchors { top: parent.top; topMargin: 5; }

            Image {
                id: imgProfile
                asynchronous: true
                source: image_path ? appSettings.rest_service.baseImagesUrl + image_path : defaultUserImage
                width: 60; height: 60
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
                    var string
                    checked == true ? false : true
                    string = (checked == true ? "P" : "F")
                    save(id, string)
                }
            }
        }
    }
}
