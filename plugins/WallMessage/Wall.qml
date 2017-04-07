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

    property int totalMessages: -1
    property string nextPage
    property string previousPage
    property string searchTerm
    property ListModel oldListModel: ListModel { }

    onIsActivePageChanged: if (isActivePage) request(null, true);
    onSearchTermChanged: if (searchTerm.length > 0) request(searchTerm, false);

    function apendObject(o, moveToTop) {
        listViewModel.append(o);
        if (moveToTop)
            listViewModel.move(listViewModel.count - 1, 0, 1);
    }

    function requestCallback(status, response) {
        if (status !== 200)
            return;
        if (searchTerm) {
            if (oldListModel.count == 0) {
                for (var i = 0; i < listViewModel.count; ++i)
                    oldListModel.append(listViewModel.get(i));
            }
            listViewModel.clear();
        }
        totalMessages = response.count;
        nextPage = response.next;
        previousPage = response.previous;
        var k = 0;
        while (k < response.results.length)
            apendObject(response.results[k++]);
    }

    function request(newSearchTerm, forceUpdate) {
        if (isPageBusy || !userProfileData.id)
            return;
        if (listView.count == totalMessages && !forceUpdate && !newSearchTerm)
            return;
        if (nextPage && !newSearchTerm && !forceUpdate)
            requestHttp.load(nextPage, requestCallback);
        else if (forceUpdate || (!previousPage && !searchTerm && !nextPage))
            requestHttp.load("wall_messages/" + userProfileData.id, requestCallback);
        else if ((!previousPage || !nextPage) && searchTerm)
            requestHttp.load("search_wall_messages/%1/%2".arg(userProfileData.id).arg(searchTerm), requestCallback);
    }

    // called by toolbar when user click in any buttons!
    // for this page is: search icon to start a new search or
    // the back or cancel button when cancel a search and back to normal page state
    function actionExec(actionName) {
        if (actionName === "cancel") {
            if (searchTerm) {
                totalMessages = -1;
                searchTerm = "";
                nextPage = "";
                previousPage = "";
            }
            if (oldListModel && oldListModel.count > 0) {
                listViewModel.clear();
                for (var i = 0; i < oldListModel.count; ++i)
                    apendObject(oldListModel.get(i));
                oldListModel.clear();
            } else {
                openAsyncRequest.start();
            }
        }
    }

    // called by delegate for build the date and time for
    // display in wall message item.
    // messageTimestamp is a integer with unix timestamp
    // return a array with date string and time string respectively
    function getDateTimeArray(messageTimestamp) {
        var dateArray = [];
        var dateObject = new Date (messageTimestamp * 1000);
        dateArray.push(dateObject.toLocaleDateString(Qt.locale()));
        dateArray.push(dateObject.toTimeString());
        return dateArray;
    }

    Component.onCompleted: request(null, true);

    Connections {
        target: listView
        onAtYEndChanged: if (listView.atYEnd) request();
    }

    Timer {
        id: updatePageCountdown
        repeat: true
        interval: 150000
        onTriggered: request();
    }

    Timer {
        id: openAsyncRequest
        interval: 150
        onTriggered: request();
    }

    Component {
        id: pageDelegate
        MessageDelegate { }
    }

    FloatingButton {
        iconName: "pencil"; enabled: !isPageBusy
        visible: typeof userProfileData.type !== "undefined" && userProfileData.type.name !== "student"
        onClicked: pushPage(configJson.root_folder + "/DestinationGroupSelect.qml", {"configJson": configJson});
    }
}
