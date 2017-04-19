import QtQuick 2.8
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.1
import QtQuick.Controls.Material 2.1
import QtQuick.Controls.Material.impl 2.1

import "AwesomeIcon/"

Drawer {
    id: menu
    width: window.width * 0.80; height: window.height
    dragMargin: enabled ? Qt.styleHints.startDragDistance : 0

    property bool enabled: true
    property color menuItemTextColor: appSettings.theme.colorPrimary
    property color menuBackgroundColor: appSettings.theme.colorWindowBackground
    property color userInfoTextColor: menuItemTextColor
    property string userImageProfile: userProfileData.image_path ? appSettings.restService.baseImagesUrl + userProfileData.image_path : ""
    property string pageSource: ""

    Rectangle {
        id: menuRectangle
        anchors.fill: parent
        color: menuBackgroundColor
    }

    ColumnLayout {
        id: userInfoColumn
        width: parent.width; height: 100
        anchors { top: parent.top; topMargin: 15; horizontalCenter: parent.horizontalCenter }

        AwesomeIcon {
            id: awesomeIcon
            name: "photo"
            size: 64; color: userInfoTextColor
            visible: !userImageProfile
            anchors { top: parent.top; topMargin: 10; horizontalCenter: parent.horizontalCenter }

            MouseArea {
                id: awesomeIconControl
                hoverEnabled: true
                anchors.fill: parent; onClicked: profileImageConfigure()
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
            anchors { top: parent.top; topMargin: 10; horizontalCenter: parent.horizontalCenter }

            MouseArea {
                id: drawerUserImageProfileControl
                hoverEnabled: true
                anchors.fill: parent; onClicked: profileImageConfigure()
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

        Label {
            color: userInfoTextColor; textFormat: Text.RichText
            text: userProfileData.name + "<br><b>" + userProfileData.email + "</b>"
            font.pointSize: appSettings.theme.middleFontSize; Layout.fillWidth: true
            horizontalAlignment: Text.AlignHCenter
            anchors {
                topMargin: 15
                top: awesomeIcon.visible ? awesomeIcon.bottom : drawerUserImageProfile.bottom
                horizontalCenter: parent.horizontalCenter
            }
        }
    }

    Flickable {
        anchors { top: userInfoColumn.bottom; topMargin: 55 }
        contentHeight: Math.max(content.implicitHeight, height)
        boundsBehavior: Flickable.StopAtBounds
        ScrollIndicator.vertical: ScrollIndicator { }

        Column {
            id: content

            Repeater {
                id: repeater
                model: menuPages

                ListItem {
                    width: menu.width; showSeparator: true
                    primaryIconName: modelData.icon_name
                    primaryLabelText: modelData.menu_name
                    primaryLabelColor: appSettings.theme.colorAccent
                    anchors { left: undefined; right: undefined }
                    selected: modelData.menu_name === window.currentPage.objectName
                    backgroundColor: menuBackgroundColor; selectedBackgroundColor: menuBackgroundColor
                    visible: {
                        if (!window.userProfileData || !window.userProfileData.type)
                            return false;
                        return modelData.roles.indexOf(window.userProfileData.type.name) > -1;
                    }
                    onClicked: {
                        menu.close();
                        if (!selected) {
                            pageSource = modelData.configJson.root_folder + "/" + modelData.main_qml;
                            pushPage(pageSource, {"configJson":modelData.configJson, "objectName": modelData.menu_name});
                        }
                    }
                }
            }
        }
    }
}
