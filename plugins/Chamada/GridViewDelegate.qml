import QtQuick 2.8
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.1
import QtQuick.Controls.Material 2.1

import "../../qml/components/"
import "../../qml/components/AwesomeIcon"

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

            AwesomeIcon {
                id: userNoImageIcon
                width: 60; height: 60; size: 50
                visible: typeof image_path == "undefined"
                name: "user"; clickEnabled: false; color: appSettings.theme.colorPrimary
                anchors.horizontalCenter: parent.horizontalCenter
            }

            RoundedImage {
                id: imgProfile
                width: 60; height: 60; visible: !userNoImageIcon.visible
                imgSource: visible ? appSettings.restService.baseImagesUrl + image_path : ""
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
