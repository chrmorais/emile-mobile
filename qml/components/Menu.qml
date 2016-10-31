import QtQuick 2.7
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.0

Drawer {
    id: menu

    property int listItemIndexPages: 0
    signal profileImageChange()

    // window is ApplicationWindow in Main.qml
    Component.onCompleted: {
        menu.height = window.height
        menu.width = window.width * 0.85
        menu.dragMargin = Qt.styleHints.startDragDistance
        window.menu = menu
    }

    Connections {
        target: window
        onWidthChanged: menu.width = window.width * window.width > window.height ? 0.60 : 0.85
        onHeightChanged: menu.height = window.height
        onCurrentPageChanged: if (menu.visible) close()
    }

    Flickable {
        width: parent.width
        anchors.fill: parent
        contentHeight: Math.max(content.implicitHeight, height)
        boundsBehavior: Flickable.StopAtBounds

        Rectangle {
            anchors.fill: parent
            color: appSettings.theme.colorPrimary
            anchors.horizontalCenter: parent.horizontalCenter

            Column {
                id: content
                width: parent.width
                anchors.fill: parent

                Image {
                    id: drawerImage
                    clip: true
                    cache: true
                    asynchronous: true
                    width: parent.width
                    fillMode: Image.PreserveAspectFit
                    source: "qrc:/assets/menu-temp.png"

                    ColumnLayout {
                        spacing: 15
                        Layout.fillWidth: true

                        Image {
                            smooth: true
                            width: 100
                            height: 100
                            source: "qrc:/assets/default-user-profile.png"

                            anchors {
                                left: parent.left
                                leftMargin: 15
                                top: parent.top
                                topMargin: 20
                            }

                            TouchFx {
                                circular: true
                                anchors.fill: parent
                                onClicked: profileImageChange()
                            }
                        }

                        Label {
                            text: user_profile_data.name || ""
                            color: appSettings.theme.colorHintText
                            font {
                                bold: true
                                pointSize: 12
                                weight: Font.DemiBold
                            }
                        }

                        Label {
                            text: user_profile_data.email || ""
                            color: appSettings.theme.colorHintText
                            font.pointSize: 10
                        }
                    }
                }

                Repeater {
                    model: menuPages

                    ListItem {
                        id: listItem
                        width: menu.width
                        backgroundColor: appSettings.theme.colorPrimary
                        primaryLabelText: menuPages[index].menu_name
                        primaryLabelColor: appSettings.theme.textColorPrimary
                        selected: currentPage.visible_name === primaryLabelText
                        primaryImageIcon: Qt.createComponent(Qt.resolvedUrl("AwesomeIcon/AwesomeIcon.qml")).createObject(primaryAction, {"name":menuPages[index].icon_name, "color":"#fff"})
                        onClicked: {
                            menu.close()
                            if (!selected) {
                                var pageSource = "%1/%2".arg(menuPages[index].configJson.root_folder).arg(menuPages[index].main_qml)
                                pageStack.push(Qt.resolvedUrl(pageSource), {"configJson":menuPages[index].configJson})
                            }
                        }
                    }
                }
            }
        }
    }
}
