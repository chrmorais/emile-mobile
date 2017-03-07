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
    property color userInfoTextColor: appSettings.theme.colorPrimary
    property color menuItemTextColor: appSettings.theme.colorPrimary
    property color menuBackgroundColor: appSettings.theme.colorWindowBackground
    property string userImageProfile: userProfileData.image_path ? appSettings.rest_service.baseImagesUrl + userProfileData.image_path : ""
    property string pageSource: ""

    ColumnLayout {
        id: userInfoColumn
        width: parent.width; height: 100
        anchors { top: parent.top; topMargin: 15; horizontalCenter: parent.horizontalCenter }

        AwesomeIcon {
            id: awesomeIcon
            name: "camera"
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

        Keys.onUpPressed: flickableScrollBar.decrease()
        Keys.onDownPressed: flickableScrollBar.increase()
        ScrollBar.vertical: ScrollBar { id: flickableScrollBar; size: 0.1 }

        Rectangle { id: menuRectangle; color: menuBackgroundColor; anchors.fill: parent }

        Column {
            id: content

            Repeater {
                id: repeater
                model: menuPages

                Rectangle {
                    id: item
                    width: menu.width; height: 50; z: width
                    color: isSelected ? Qt.lighter(menuItemTextColor, 4.5) : "transparent"
                    visible: {
                        if (!window.userProfileData || !window.userProfileData.type)
                            return false;
                        return modelData.roles.indexOf(window.userProfileData.type.name) > -1;
                    }

                    property bool isSelected: window.currentPage ? modelData.menu_name === window.currentPage.objectName : false

                    Row {
                        id: row
                        spacing: 22
                        anchors { left: parent.left; leftMargin: 16; right: parent.right; rightMargin: 16; verticalCenter: parent.verticalCenter }

                        AwesomeIcon {
                            color: menuItemTextColor; size: 20; z: 0
                            name:  modelData.icon_name; clickEnabled: false
                        }

                        Text {
                            text: modelData.menu_name
                            color: menuItemTextColor
                            font { pointSize: appSettings.theme.bigFontSize; bold: true }
                            anchors.verticalCenter: parent.verticalCenter
                        }
                    }

                    MouseArea {
                        anchors.fill: parent
                        onClicked: {
                            menu.close();
                            if (!item.isSelected) {
                                pageSource = modelData.configJson.root_folder + "/" + modelData.main_qml;
                                pushPage(pageSource, {"configJson":modelData.configJson, "objectName": modelData.menu_name});
                            }
                        }
                    }

                    Rectangle { width: parent.width; height: 1; color: menuItemTextColor; opacity: 0.1; anchors.bottom: parent.bottom }
                }
            }
        }
    }
}
