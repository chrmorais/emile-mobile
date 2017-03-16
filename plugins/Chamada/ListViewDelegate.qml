import QtQuick 2.8
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.1
import QtQuick.Controls.Material 2.1

import "../../qml/components/"

Column {
    spacing: 0; width: parent.width; height: 60

    Component.onCompleted: save(id, labelStatus.text);

    Rectangle {
        width: parent.width; height: parent.height - 1

        RowLayout {
            spacing: 35
            anchors.fill: parent
            width: parent.width; height: parent.height
            anchors.verticalCenter: parent.verticalCenter

            RoundedImage {
                id: imgProfile
                width: 40; height: 40
                imgSource: image_path ? appSettings.restService.baseImagesUrl + image_path : defaultUserImage
                anchors { left: parent.left; leftMargin: 15; verticalCenter: parent.verticalCenter }
            }

            Column {
                spacing: 2
                anchors { left: imgProfile.right; leftMargin: 15; verticalCenter: parent.verticalCenter }

                Label {
                    text: email + ""
                    color: appSettings.theme.colorPrimary
                    font.pointSize: appSettings.theme.middleFontSize
                }
            }

            RowLayout {
                spacing: 15
                anchors { right: parent.right; rightMargin: 15; verticalCenter: parent.verticalCenter }

                CheckBox {
                    anchors.verticalCenter: parent.verticalCenter
                    checked: labelStatus.text == "P"
                    onClicked: {
                        var string
                        checked == true ? false : true
                        string = (checked == true ? "P" : "F")
                        save(id, string);
                    }
                }

                Label {
                    id: labelStatus
                    text: checkedStatus && checkedStatus[id] ? checkedStatus[id] : "P"
                    anchors.verticalCenter: parent.verticalCenter
                    color: text == "F" ? "red" : "blue"
                    font.weight: Font.DemiBold
                }
            }
        }
    }

    // draw a border separator
    Rectangle { color: "#ccc"; width: parent.width; height: 1 }
}
