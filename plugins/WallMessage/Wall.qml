import QtQml 2.2
import QtQuick 2.8
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.1
import QtQuick.Controls.Material 2.1

import "../../qml/components/"
import "../../qml/components/AwesomeIcon/"

BasePage {
    id: page
    title: qsTr("Message wall")
    objectName: qsTr("Message wall")
    listViewSpacing: 13
    listViewTopMargin: 10
    listViewBottomMargin: 10
    listViewDelegate: pageDelegate
    onUpdatePage: requestEmptyList();
    firstText: qsTr("Warning! No Wall message found!")

    property int totalItens: 0
    property int paginateIndex: 0
    property string nextPage
    property string previousPage
    property string searchUrl: "search_wall_messages/id_usuario/search_term"

    function apendObject(o, moveToTop) {
        listViewModel.append(o);
        if (moveToTop)
            listViewModel.move(listViewModel.count - 1, 0, 1);
    }

    function requestCallback(status, response) {
        if (status !== 200)
            return;
        totalItens = response.count;
        if (!nextPage && listViewModel.count === response.results.length)
            listViewModel.clear();
        nextPage = response.next;
        previousPage = response.previous;
        var i = 0;
        while (i < response.results.length)
            apendObject(response.results[i++]);
        paginateIndex++;
    }

    function messageLink(message) {
        var pos = 0;
        var result = "";
        var text = urlify(message);
        var exp = /(\b(https?|ftp|file):\/\/[-A-Z0-9+&@#\/%?=~_|!:,.;]*[-A-Z0-9+&@#\/%=~_|])/ig;
        var temp = text.replace(exp, "<a href=\"$1\" target=\"_blank\">$1</a>");
        while (temp.length > 0) {
            pos = temp.indexOf("href=\"");
            if (pos === -1) {
                result += temp;
                break;
            }
            result += temp.substring(0, pos + 6);
            temp = temp.substring(pos + 6, temp.length);
            if ((temp.indexOf("://") > 8) || (temp.indexOf("://") === -1))
                result += "http://";
        }
        return result;
    }

    function urlify(text) {
        var urlRegex = /(((https?:\/\/)|(www\.))[^\s]+)/g;
        return text.replace(urlRegex, function(url,b,c) {
            var url2 = (c === "www.") ?  "https://" + url : url;
            return '<a href="%1'.arg(url2);
        });
    }

    function request() {
        if (!userProfileData.id || (listViewModel && listViewModel.count === totalItens))
            return;
        if (nextPage)
            requestHttp.load(nextPage, requestCallback);
        else if (!previousPage)
            requestHttp.load("wall_messages/" + userProfileData.id, requestCallback);
    }

    function requestEmptyList() {
        requestHttp.load("wall_messages/" + userProfileData.id, requestCallback);
    }

    Component.onCompleted: request();

    Connections {
        target: listView
        onContentYChanged: {
            busyIndicator.visible = false;
            if (listView.contentY < -65 && !isPageBusy && !lockMultipleRequests.running) {
                nextPage = "";
                previousPage = "";
                lockMultipleRequests.running = true;
            }
        }
        onCurrentIndexChanged: {
            if (listView.currentIndex == (listView.count - 3) && paginateIndex > 0)
                request();
        }
    }

    Timer {
        id: lockMultipleRequests
        interval: 2000
        onTriggered: {
            request();
            lockMultipleRequests.interval = 2000;
        }
    }

    Component {
        id: pageDelegate

        Rectangle {
            id: delegate
            color: "#fff799"; radius: 4
            anchors.horizontalCenter: parent.horizontalCenter
            width: page.width * 0.95; height: columnLayoutDelegate.height
            opacity: isFullyVisible ? 1.0 : 0.8

            property int yoff: Math.round(delegate.y - delegate.ListView.view.contentY)
            property bool isFullyVisible: (yoff > delegate.ListView.view.y && ((yoff + height) < (delegate.ListView.view.y + delegate.ListView.view.height)))

            onIsFullyVisibleChanged: if (isFullyVisible) delegate.ListView.view.currentIndex = index;

            SequentialAnimation on opacity {
                id: anim
                running: false

                NumberAnimation {
                    to: 0.8
                    duration: 350
                }
                PauseAnimation {
                    duration: 350
                }
                NumberAnimation {
                    to: 1.0
                    duration: 350
                }
            }

            Pane {
                z: parent.z-10; Material.elevation: 1
                width: parent.width-1; height: parent.height-1
            }

            ColumnLayout {
                id: columnLayoutDelegate
                spacing: 15; width: parent.width

                Row {
                    spacing: 4
                    anchors { top: parent.top; topMargin: 5; left: parent.left; leftMargin: 10 }

                    AwesomeIcon {
                        size: 12; name: userProfileData.name === sender.name ? "arrow_right" : "commenting"; color: authorLabel.color; clickEnabled: false
                    }

                    Label {
                        id: authorLabel
                        text: userProfileData.name === sender.name ? qsTr("You") : sender ? sender.name || "" : ""; color: "#444"
                    }
                }

                Item {
                    Layout.fillWidth: true
                    height: labelMessage.implicitHeight; implicitHeight: height

                    Label {
                        id: labelMessage
                        text: messageLink(message) || ""
                        width: parent.width * 0.95
                        wrapMode: Text.Wrap
                        font.wordSpacing: 1
                        textFormat: Text.RichText
                        onLinkActivated: Qt.openUrlExternally(link)
                        color: appSettings.theme.colorPrimary
                        anchors { right: parent.right; left: parent.left; margins: 10 }
                    }
                }

                Row {
                    spacing: 4
                    anchors { bottom: parent.bottom; bottomMargin: 5; left: parent.left; leftMargin: 10 }

                    AwesomeIcon {
                        size: 10; name: "clock_o"; color: dateLabel.color; clickEnabled: false
                        anchors.verticalCenter: parent.verticalCenter
                    }

                    Label {
                        id: dateLabel
                        text: date || ""
                        font.pointSize: appSettings.theme.smallFontSize
                        color: appSettings.theme.colorPrimary
                        anchors.verticalCenter: parent.verticalCenter
                    }
                }
            }
        }
    }

    FloatingButton {
        enabled: !isPageBusy
        iconName: "pencil"; iconColor: appSettings.theme.colorAccent
        visible: typeof userProfileData.type !== "undefined" && userProfileData.type.name !== "student"
        onClicked: {
            var url = Qt.resolvedUrl(configJson.root_folder+"/DestinationGroupSelect.qml");
            pageStack.push(url, {"configJson": configJson});
        }
    }
}
