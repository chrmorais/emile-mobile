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

            Item { width: parent.width; height: 55 }

            Label {
                textFormat: Text.RichText
                text: "<b>" + qsTr("Name: ") + "</b>" + userProfileData.name
                font { pointSize: 13; weight: Font.DemiBold }
                color: appSettings.theme.defaultTextColor
                anchors.horizontalCenter: parent.horizontalCenter
            }

            Label {
                text: "<b>" + qsTr("Email: ") + "</b>" + userProfileData.email
                font { pointSize: 13; weight: Font.DemiBold }
                color: appSettings.theme.defaultTextColor
                anchors.horizontalCenter: parent.horizontalCenter
            }

            Label {
                text: "<b>" + qsTr("Username: ") + "</b>" + userProfileData.username
                font { pointSize: 13; weight: Font.DemiBold }
                color: appSettings.theme.defaultTextColor
                anchors.horizontalCenter: parent.horizontalCenter
            }

            Label {
                text: "<b>" + qsTr("User type: ") + "</b>" + userProfileData.type.name
                font { pointSize: 13; weight: Font.DemiBold }
                color: appSettings.theme.defaultTextColor
                anchors.horizontalCenter: parent.horizontalCenter
            }

            Label {
                text: "<b>" + qsTr("Adress: ") + "</b>" + userProfileData.address
                font { pointSize: 13; weight: Font.DemiBold }
                color: appSettings.theme.defaultTextColor
                anchors.horizontalCenter: parent.horizontalCenter
            }

            Label {
                text: "<b>" + qsTr("Gender: ") + "</b>" + userProfileData.gender
                font { pointSize: 13; weight: Font.DemiBold }
                color: appSettings.theme.defaultTextColor
                anchors.horizontalCenter: parent.horizontalCenter
            }
        }
    }
}
