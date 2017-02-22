import QtQuick 2.7
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.0

import "../../qml/components/"

BasePage {
    id: page
    title: qsTr("My profile")
    objectName: title
    hasListView: false
    hasRemoteRequest: false

    property string defaultUserImg: menu.userImageProfile ? menu.userImageProfile : "qrc:/assets/user-default-icon.png"

    Flickable {
        id: flickable
        visible: true
        anchors.fill: parent
        contentHeight: Math.max(profileColumn.implicitHeight, height)

        ColumnLayout {
            id: profileColumn
            spacing: 5
            width: page.width; height: page.height
            anchors { top: parent.top; topMargin: 10; horizontalCenter: parent.horizontalCenter }

            RoundedImage {
                id: drawerUserImageProfile
                width: 89; height: width
                imgSource: defaultUserImg
                anchors { top: parent.top; topMargin: 5; horizontalCenter: parent.horizontalCenter }
            }

            Label {
                topPadding: 15
                textFormat: Text.RichText
                text: qsTr("Name: ") + userProfileData.name
                font { pointSize: 13; weight: Font.DemiBold }
                color: appSettings.theme.defaultTextColor
                anchors.horizontalCenter: parent.horizontalCenter
            }

            Label {
                topPadding: 15
                textFormat: Text.RichText
                text: qsTr("Email: ") + userProfileData.email
                font { pointSize: 13; weight: Font.DemiBold }
                color: appSettings.theme.defaultTextColor
                anchors.horizontalCenter: parent.horizontalCenter
            }
        }
    }
}
