import QtQuick 2.7
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.0
import QtQuick.Controls.Material 2.1
import QtQuick.Controls.Material.impl 2.1

import "../../qml/components/"
import "../../qml/components/AwesomeIcon"

BasePage {
    id: page
    title: qsTr("My profile")
    objectName: title
    hasListView: false
    hasRemoteRequest: false

    property string userImageProfile: userProfileData.image_path ? appSettings.rest_service.baseImagesUrl + userProfileData.image_path : ""

    Flickable {
        id: flickable
        visible: true
        anchors.fill: parent
        contentHeight: Math.max(column.implicitHeight, height)

        Column {
            id: column
            width: parent.width; height: 100
            anchors { top: parent.top; topMargin: 15; horizontalCenter: parent.horizontalCenter }

            AwesomeIcon {
                id: awesomeIcon
                name: "camera"
                size: 64; color: appSettings.theme.colorPrimary
                visible: !userImageProfile
                anchors { horizontalCenter: parent.horizontalCenter; verticalCenter: undefined }

                MouseArea {
                    id: awesomeIconControl
                    hoverEnabled: true
                    anchors.fill: parent; onClicked: profileImageConfigure();
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
                    anchors.fill: parent; onClicked: profileImageConfigure();
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
                showSeparator: true
                primaryLabelText: "<b>" + qsTr("Gender: ") + "</b>"
                secondaryLabelText: userProfileData.gender
                primaryIconName: "arrows_alt"
                backgroundColor: appSettings.theme.colorWindowBackground
            }
        }
    }
}
