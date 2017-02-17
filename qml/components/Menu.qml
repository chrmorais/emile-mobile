import QtQuick 2.7
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.0
import QtQuick.Controls.Material 2.1
import QtQuick.Controls.Material.impl 2.1

import "AwesomeIcon/"

Drawer {
    id: menu
    width: window.width * 0.80; height: window.height
    dragMargin: enabled ? Qt.styleHints.startDragDistance : 0

    property bool enabled: true
    property color userInfoTextColor: "#fff"
    property color menuItemTextColor: "#444"
    property alias menuBackgroundColor: menuRectangle.color
    property alias userImageProfile: drawerUserImageProfile.imgSource
    property string pageSource: ""
    property string defaultUserImg: "qrc:/assets/user-default-icon.png"

    signal profileImageChange()

    Connections {
        target: menu
        onUserImageProfileChanged: if (userImageProfile) awesomeIcon.visible = false;
    }

    Flickable {
        anchors.fill: parent
        contentHeight: Math.max(content.implicitHeight, height)
        boundsBehavior: Flickable.StopAtBounds

        // adicionado para exibir o scrool lateral
        Keys.onUpPressed: flickableScrollBar.decrease()
        Keys.onDownPressed: flickableScrollBar.increase()
        ScrollBar.vertical: ScrollBar { id: flickableScrollBar }

        Rectangle {
            id: menuRectangle
            color: "#fff"; anchors.fill: parent
            anchors.horizontalCenter: parent.horizontalCenter

            Column {
                id: content
                width: parent.width; anchors.fill: parent

                ColumnLayout {
                    spacing: 25
                    width: parent.width; height: drawerUserImageProfile.height * 1.75
                    anchors.horizontalCenter: parent.horizontalCenter

                    Rectangle { id: userInfoRec; anchors.fill: parent; color: "transparent" }

                    AwesomeIcon {
                        id: awesomeIcon
                        name: "camera"
                        size: 64; color: userInfoTextColor
                        visible: !userProfileData.image_path
                        anchors { top: parent.top; topMargin: 15; horizontalCenter: parent.horizontalCenter }

                        MouseArea {
                            id: awesomeIconControl
                            hoverEnabled: true
                            anchors.fill: parent; onClicked: profileImageConfigure()
                        }

                        Ripple {
                            x: (parent.width - width) / 2
                            y: (parent.height - height) / 2
                            width: 75; height: width

                            z: -1
                            anchor: awesomeIconControl
                            pressed: awesomeIconControl.pressed
                            active: awesomeIconControl.pressed
                            color: awesomeIconControl.pressed ? Material.highlightedRippleColor : Material.rippleColor
                        }
                    }

                    RoundedImage {
                        id: drawerUserImageProfile
                        width: 75; height: width
                        visible: !awesomeIcon.visible
                        imgSource: userProfileData.image_path ? userProfileData.image_path : defaultUserImg
                        anchors { top: parent.top; topMargin: 15; horizontalCenter: parent.horizontalCenter }

                        MouseArea {
                            id: drawerUserImageProfileControl
                            hoverEnabled: true
                            anchors.fill: parent; onClicked: profileImageConfigure()
                        }

                        Ripple {
                            x: (parent.width - width) / 2
                            y: (parent.height - height) / 2
                            width: 75; height: width

                            z: -1
                            anchor: drawerUserImageProfileControl
                            pressed: drawerUserImageProfileControl.pressed
                            active: drawerUserImageProfileControl.pressed
                            color: drawerUserImageProfileControl.pressed ? Material.highlightedRippleColor : Material.rippleColor
                        }
                    }

                    Label {
                        color: userInfoTextColor; textFormat: Text.RichText
                        text: userProfileData.name + "<br><b>" + userProfileData.email + "</b>"
                        font.pointSize: 12
                        horizontalAlignment: Text.AlignHCenter
                        anchors {
                            top: drawerUserImageProfile.bottom; topMargin: 5
                            horizontalCenter: parent.horizontalCenter
                        }
                    }
                }

                Repeater {
                    model: menuPages

                    ListItem {
                        width: menu.width
                        primaryLabelColor: menuItemTextColor
                        primaryLabelText: modelData.menu_name
                        primaryLabel.font.bold: true
                        primaryIconName: modelData.icon_name
                        selected: modelData.menu_name === window.currentPage.objectName
                        showSeparator: true
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
}
