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
    property ListModel oldListModel

    onSearchTermChanged: if (searchTerm) request(); else requestFirst();

    function apendObject(o, moveToTop) {
        listViewModel.append(o);
        if (moveToTop)
            listViewModel.move(listViewModel.count - 1, 0, 1);
    }

    function requestCallback(status, response) {
        if (status !== 200)
            return;
        if (searchTerm) {
            oldListModel = listViewModel;
            listViewModel.clear();
        }
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
        else if ((!previousPage || !nextPage) && searchTerm)
            requestHttp.load("search_wall_messages/%1/%2".arg(userProfileData.id).arg(searchTerm), requestCallback);
    }

    function requestCallbackFirst(status, response) {
        if (status !== 200)
            return;
        listViewModel.clear();
        nextPage = response.next;
        previousPage = response.previous;
        var i = 0;
        while (i < response.results.length)
            apendObject(response.results[i++]);
    }

    function requestFirst() {
        requestHttp.load("wall_messages/" + userProfileData.id, requestCallbackFirst);
    }

    // called by toolbar when user click in any buttons!
    // for this page is: search icon to start a new search or
    // the back or cancel button when cancel a search and back to normal page state
    function actionExec(actionName) {
        if (actionName === "cancel") {
            if (oldListModel && oldListModel.count > 0)
                listViewModel = oldListModel;
            else
                openAsyncRequest.start();
            searchTerm = "";
            nextPage = "";
            previousPage = "";
        }
    }

    function getHumanDate(dateSection) {
        var originalDate = new Date (dateSection * 1000);
        return originalDate.toLocaleDateString("pt_BR") + " " + originalDate.toTimeString();
    }

    Component.onCompleted: requestFirst();

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
            color: sender.type.id === 3 ? "#dab47c" : "#fff799"; radius: 4
            anchors.horizontalCenter: parent.horizontalCenter
            width: page.width * 0.94; height: columnLayoutDelegate.height
            border { width: 1; color: sender.type.id === 3 ? "#7cc8d8" : "#b2cc9e" }

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
                        text: getHumanDate(date) || ""
                        font.pointSize: appSettings.theme.smallFontSize
                        color: appSettings.theme.colorPrimary
                        anchors.verticalCenter: parent.verticalCenter
                    }
                }
            }
        }
    }

    FloatingButton {
        iconName: "pencil"; enabled: !isPageBusy
        visible: typeof userProfileData.type !== "undefined" && userProfileData.type.name !== "student"
        onClicked: pushPage(configJson.root_folder + "/DestinationGroupSelect.qml", {"configJson": configJson});
    }
}
