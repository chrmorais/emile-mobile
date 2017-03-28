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
    onUpdatePage: request();
    toolBarActions: {"toolButton4":{"action":"search","icon":"search"}}
    firstText: qsTr("Warning! No Wall message found!")

    property string nextPage
    property string previousPage
    property string searchTerm

    onSearchTermChanged: if (searchTerm) request();

    function apendObject(o, moveToTop) {
        listViewModel.append(o);
        if (moveToTop)
            listViewModel.move(listViewModel.count - 1, 0, 1);
    }

    function requestCallback(status, response) {
        if (status !== 200)
            return;
        if (searchTerm || !nextPage)
            listViewModel.clear();
        nextPage = response.next;
        previousPage = response.previous;
        var i = 0;
        while (i < response.results.length)
            apendObject(response.results[i++]);
    }

    function request() {
        if (isPageBusy || !userProfileData.id)
            return;
        if (nextPage)
            requestHttp.load(nextPage, requestCallback);
        else if (!previousPage && !searchTerm)
            requestHttp.load("wall_messages/" + userProfileData.id, requestCallback);
        else if (!previousPage && searchTerm)
            requestHttp.load("search_wall_messages/%1/%2".arg(userProfileData.id).arg(searchTerm), requestCallback);
    }

    function actionExec(actionName) {
        if (actionName === "cancel")
            resetWall();
    }

    function resetWall() {
        openAsyncRequest.start();
        searchTerm = "";
        nextPage = "";
        previousPage = "";
    }

    Component.onCompleted: request();

    Connections {
        target: listView
        onAtYEndChanged: {
            if (listView.atYEnd)
                openAsyncRequest.start();
        }
    }

    Timer {
        id: openAsyncRequest
        interval: 150
        onTriggered: request();
    }

    Component {
        id: pageDelegate

        Rectangle {
            id: delegate
            color: "#fff799"; radius: 4
            anchors.horizontalCenter: parent.horizontalCenter
            width: page.width * 0.94; height: columnLayoutDelegate.height

            Pane {
                z: parent.z-10; Material.elevation: 1
                width: parent.width-1; height: parent.height-1
            }

            ColumnLayout {
                id: columnLayoutDelegate
                spacing: 15; width: parent.width

                RowLayout {
                    spacing: 4
                    anchors { top: parent.top; topMargin: 5; left: parent.left; leftMargin: 10; right: parent.right; rightMargin: 10 }

                    AwesomeIcon {
                        size: 12; name: userProfileData.name === sender.name ? "arrow_right" : "commenting"; color: authorLabel.color; clickEnabled: false
                    }

                    Label {
                        id: authorLabel
                        text: userProfileData.name === sender.name ? qsTr("You") : sender ? sender.name || "" : ""; color: "#444"
                        Component.onCompleted: if (userProfileData.name !== sender.name) text += " (%1)".arg(sender.email)
                    }

                    Label {
                        text: "" // add o(s) destinatários da mensgems
                        anchors { right: parent.right; rightMargin: 15 }
                    }
                }

                Item {
                    Layout.fillWidth: true
                    height: labelMessage.implicitHeight; implicitHeight: height

                    Label {
                        id: labelMessage
                        z: 1000
                        text: message || ""
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
            var url = Qt.resolvedUrl(configJson.root_folder + "/DestinationGroupSelect.qml");
            pageStack.push(url, {"configJson": configJson});
        }
    }
}
