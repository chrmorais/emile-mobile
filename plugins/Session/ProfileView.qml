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
    hasRemoteRequest: false
    toolBarActions: ({"toolButton4": {"action":"edit", "icon":"pencil"}})

    property string userImageProfile: userProfileData.image_path ? appSettings.rest_service.baseImagesUrl + userProfileData.image_path : ""

    function actionExec(action) {
        if (action === "edit") {
            var url = Qt.resolvedUrl(configJson.root_folder+"/Profile.qml");
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

            AwesomeIcon {
                id: awesomeIcon
                name: "photo"
                size: 64; color: appSettings.theme.colorPrimary
                visible: !userImageProfile
                anchors { horizontalCenter: parent.horizontalCenter; verticalCenter: undefined }

                MouseArea {
                    id: awesomeIconControl
                    hoverEnabled: true
                    anchors.fill: parent; onClicked: window.profileImageConfigure(); // is a function on main.qml
                }

                Ripple {
                    z: -1
                    x: (parent.width - width) / 2
                    y: (parent.height - height) / 2
                    width: drawerUserImageProfile.width; height: width
                    anchor: awesomeIconControl
                    pressed: awesomeIconControl.pressed
                    active: awesomeIconControl.pressed
                    color: awesomeIconControl.pressed ? Material.highlightedRippleColor : Material.rippleColor
                }
            }

            RoundedImage {
                id: drawerUserImageProfile
                visible: !awesomeIcon.visible
                width: 90; height: width
                imgSource: userImageProfile
                anchors.horizontalCenter: parent.horizontalCenter

                MouseArea {
                    id: drawerUserImageProfileControl
                    hoverEnabled: true
                    anchors.fill: parent; onClicked: window.profileImageConfigure(); // is a function on main.qml
                }

                Ripple {
                    z: -1
                    x: (parent.width - width) / 2
                    y: (parent.height - height) / 2
                    width: drawerUserImageProfile.width; height: width
                    anchor: drawerUserImageProfileControl
                    pressed: drawerUserImageProfileControl.pressed
                    active: drawerUserImageProfileControl.pressed
                    color: drawerUserImageProfileControl.pressed ? Material.highlightedRippleColor : Material.rippleColor
                }
            }

            Item { width: parent.width; height: 30 }

            ListItem {
                showSeparator: true
                primaryLabelText: "<b>" + qsTr("Name: ") + "</b>"
                secondaryLabelText: userProfileData.name
                primaryIconName: "tag"
                backgroundColor: appSettings.theme.colorWindowBackground
            }

            ListItem {
                showSeparator: true
                primaryLabelText: "<b>" + qsTr("Email: ") + "</b>"
                secondaryLabelText: userProfileData.email
                primaryIconName: "envelope"
                backgroundColor: appSettings.theme.colorWindowBackground
            }

            ListItem {
                showSeparator: true
                primaryLabelText: "<b>" + qsTr("Username: ") + "</b>"
                secondaryLabelText: userProfileData.username
                primaryIconName: "user"
                backgroundColor: appSettings.theme.colorWindowBackground
            }

            ListItem {
                showSeparator: true
                primaryLabelText: "<b>" + qsTr("Address: ") + "</b>"
                secondaryLabelText: userProfileData.address
                primaryIconName: "map_marker"
                backgroundColor: appSettings.theme.colorWindowBackground
            }

            ListItem {
                showSeparator: true; showIconBold: true
                primaryLabelText: "<b>" + qsTr("Gender: ") + "</b>"
                primaryIconName: userProfileData.gender === "M" ? "mars" : "venus"
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
                showSeparator: true
                primaryLabelText: "<b>" + qsTr("Birthdate: ") + "</b>"
                secondaryLabelText: userProfileData.birth_date
                primaryIconName: "birthday_cake"
                backgroundColor: appSettings.theme.colorWindowBackground
            }

            ListItem {
                showSeparator: true
                primaryLabelText: "<b>" + qsTr("Course: ") + "</b>"
                secondaryLabelText: userProfileData.program_id[0].name
                primaryIconName: "book"
                backgroundColor: appSettings.theme.colorWindowBackground
            }

//            Item {
//                height: 10
//            }

//            Label {
//                text: qsTr("Course Sections")
//                font.bold : true
//            }

            ListItem {
                showSeparator: false
                primaryLabelText: "<b>" + qsTr("Course Sections: ") + "</b>"
                primaryIconName: "gear"
                backgroundColor: appSettings.theme.colorWindowBackground
            }

            Repeater {
                model: userProfileData.course_sections

                ListItem {
                    showSeparator: true
                    primaryLabelText: modelData.code
                    primaryIconName: "thumb_tack"
                    backgroundColor: appSettings.theme.colorWindowBackground
                }
            }
        }
    }
}
