import QtQuick 2.8
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.1
import QtQuick.Controls.Material 2.1
import QtQuick.Controls.Material.impl 2.1

import "../../qml/components/"
import "../../qml/components/AwesomeIcon"
import "Functions.js" as RegisterFunctions

BasePage {
    id: page
    title: qsTr("My profile")
    objectName: title
    hasListView: false
    toolBarActions: ({"toolButton4": {"action":"edit", "icon":"pencil"}})

    property string userImageProfile: userProfileData.image_path ? appSettings.restService.baseImagesUrl + userProfileData.image_path : ""

    function actionExec(action) {
        if (action === "edit") {
            var url = Qt.resolvedUrl(configJson.root_folder + "/ProfileEdit.qml");
            pageStack.push(url, {"configJson": configJson});
        }
    }

    Flickable {
        id: flickable
        visible: true
        anchors.fill: parent
        contentHeight: Math.max(column.implicitHeight + 100, height + 100)

        Column {
            id: column
            width: parent.width; height: 100
            anchors { top: parent.top; topMargin: 15; horizontalCenter: parent.horizontalCenter }

            Rectangle {
                width: parent.width; height: 120; color: "transparent"
                anchors.horizontalCenter: parent.horizontalCenter

                AwesomeIcon {
                    id: awesomeIcon
                    visible: !userImageProfile
                    name: "photo"; clickEnabled: false
                    size: 64; color: appSettings.theme.colorPrimary
                    anchors { centerIn: parent; verticalCenter: undefined }
                }

                RoundedImage {
                    id: drawerUserImageProfile
                    visible: !awesomeIcon.visible
                    width: 90; height: width
                    imgSource: userImageProfile
                    anchors.centerIn: parent
                }
            }

            ListItem {
                showSeparator: true; primaryLabel.font.bold: true
                primaryLabelText: qsTr("Name: ")
                secondaryLabelText: userProfileData.name
                primaryIconName: "tag"
                backgroundColor: appSettings.theme.colorWindowBackground
            }

            ListItem {
                showSeparator: true; primaryLabel.font.bold: true
                primaryLabelText: qsTr("Email: ")
                secondaryLabelText: userProfileData.email
                primaryIconName: "envelope"
                backgroundColor: appSettings.theme.colorWindowBackground
            }

            ListItem {
                showSeparator: true; primaryLabel.font.bold: true
                primaryLabelText: qsTr("Address: ")
                secondaryLabelText: userProfileData.address
                primaryIconName: "map_marker"
                backgroundColor: appSettings.theme.colorWindowBackground
            }

            ListItem {
                primaryLabel.font.bold: true
                showSeparator: true; showIconBold: true
                primaryLabelText: qsTr("Gender: ")
                primaryIconName: userProfileData.gender === "M" ? "mars" : userProfileData.gender === "F" ? "venus" : "transgender_alt"
                backgroundColor: appSettings.theme.colorWindowBackground
                secondaryLabelText: {
                    if (userProfileData.gender === "M")
                        return qsTr("Male");
                    else if (userProfileData.gender === "F")
                        return qsTr("Female");
                    else
                        return qsTr("Other");
                }
            }

            ListItem {
                showSeparator: true; primaryLabel.font.bold: true
                primaryLabelText: qsTr("Birthdate: ")
                secondaryLabelText: userProfileData.birth_date
                primaryIconName: "birthday_cake"
                backgroundColor: appSettings.theme.colorWindowBackground
            }

            ListItem {
                showSeparator: true; primaryLabel.font.bold: true
                primaryLabelText: qsTr("Course: ")
                secondaryLabelText: userProfileData.program_id.name
                primaryIconName: "book"
                visible: userProfileData.type.id === 1
                backgroundColor: appSettings.theme.colorWindowBackground
            }

            ListItem {
                showSeparator: false; primaryLabel.font.bold: true
                primaryLabelText: qsTr("Course Sections: ")
                primaryIconName: "gear"
                visible: userProfileData.type.id === 1
                backgroundColor: appSettings.theme.colorWindowBackground
            }

            Repeater {
                model: userProfileData.course_sections

                ListItem {
                    showSeparator: true
                    primaryLabelText: modelData.code
                    primaryIconName: "thumb_tack"
                    visible: userProfileData.type.id === 1
                    backgroundColor: appSettings.theme.colorWindowBackground
                }
            }
        }
    }
}
