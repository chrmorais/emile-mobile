import QtQuick 2.7
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.0
import QtQuick.Controls.Material 2.0

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

            Image {
                id: imgProfile
                asynchronous: true
                width: 40; height: 40
                source: userProfileData.image_path ? appSettings.restService.baseImagesUrl + userProfileData.image_path : defaultUserImage
                clip: true; cache: true; smooth: true
                sourceSize { width: width; height: height }
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
