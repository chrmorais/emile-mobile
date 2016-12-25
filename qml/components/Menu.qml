import QtQuick 2.7
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.0

Drawer {
    id: menu
    width: window.width * 0.75; height: window.height
    dragMargin: enabled ? Qt.styleHints.startDragDistance : 0

    property bool enabled: true
    property color userInfoTextColor: "#fff"
    property color menuItemTextColor: "#444"
    property alias menuBackgroundColor: menuRectangle.color
    property alias userImageProfile: drawerUserImageProfile.imgSource
    property string defaultUserImg: "qrc:/assets/user-default-icon.png"

    signal profileImageChange()

    Connections {
        target: window
        onWidthChanged: menu.width = window.width * window.width > window.height ? 0.60 : 0.85
        onCurrentPageChanged: if (menu.visible) close();
    }

    Flickable {
        width: parent.width
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
                    spacing: 15
                    width: parent.width; height: drawerUserImageProfile.height * 1.75
                    anchors.horizontalCenter: parent.horizontalCenter

                    Rectangle { id: userInfoRec; anchors.fill: parent; color: "transparent" }

                    RoundedImage {
                        id: drawerUserImageProfile
                        width: 75; height: width
                        imgSource: userProfileData.profileImg ? userProfileData.profileImg : defaultUserImg
                        anchors { top: parent.top; topMargin: 15; horizontalCenter: parent.horizontalCenter }
                        MouseArea { anchors.fill: parent; onClicked: profileImageConfigure() }
                    }

                    Label {
                        color: userInfoTextColor; textFormat: Text.RichText
                        text: userProfileData.name + "<br><b>" + userProfileData.email + "</b>"
                        font.pointSize: 12
                        horizontalAlignment: Text.AlignHCenter
                        anchors {
                            top: drawerUserImageProfile.bottom
                            topMargin: 5
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
                        onClicked: {
                            menu.close();
                            if (!selected) {
                                var pageSource = "%1/%2".arg(modelData.configJson.root_folder).arg(modelData.main_qml);
                                pushPage(pageSource, {"configJson":modelData.configJson, "objectName": modelData.menu_name});
                            }
                        }
                    }
                }
            }
        }
    }
}
