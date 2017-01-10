import QtQuick 2.7
import QtQuick.Controls 2.0
import QtQuick.Dialogs 1.2
import QtQuick.Layouts 1.3
import QtQuick.Controls.Material 2.0


import "../../qml/components/"
import "../../qml/components/AwesomeIcon/"
import "../../qml/js/"

Page {
    id: page
    title: "Meus dados"
    objectName: "Meus dados"

    property string defaultUserImg: "qrc:/assets/user-default-icon.png"

    Flickable {
        id: flickable
        visible: true
        anchors.fill: parent
        contentHeight: Math.max(profileColumn.implicitHeight, height)

        Column {
            id: profileColumn
            width: page.width / 1.3 ; height: page.height
            anchors { horizontalCenter: parent.horizontalCenter }
            topPadding: 10
            spacing: 5

            Rectangle {
                height: drawerUserImageProfile.height + 10; width: drawerUserImageProfile.width + 10
                border.color: "green"
                anchors { horizontalCenter: parent.horizontalCenter }

                RoundedImage {
                    id: drawerUserImageProfile
                    width: 95; height: width
                    imgSource: menu.userImageProfile
                    anchors { horizontalCenter: parent.horizontalCenter; verticalCenter: parent.verticalCenter }
                }
            }

            Label {
                text: qsTr("Name :")
                textFormat: Text.RichText
                font { pointSize: 16; bold: true }
                topPadding: 15
                anchors { horizontalCenter: parent.horizontalCenter; left: parent.left }
            }

            Label {
                id: userName
                text: userProfileData.name
                textFormat: Text.RichText
                font.pointSize: 14
                wrapMode: Text.WrapAnywhere
                anchors { horizontalCenter: parent.horizontalCenter }
            }

            Label {
                text: qsTr("Email :")
                textFormat: Text.RichText
                font { pointSize: 16; bold: true }
                topPadding: 15
                anchors { horizontalCenter: parent.horizontalCenter; left: parent.left }
            }

            Label {
                id: userEmail
                text: userProfileData.email
                textFormat: Text.RichText
                horizontalAlignment: Text.AlignJustify
                font.pointSize: 14
                wrapMode: Text.WrapAnywhere
                anchors { horizontalCenter: parent.horizontalCenter }
            }
        }
    }
}
