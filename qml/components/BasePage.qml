import QtQuick 2.8
import QtQuick.Controls 2.1
import QtQuick.Controls.Material 2.1

Page {
    id: basePage
    background: Rectangle {
        anchors.fill: parent
        color: appSettings.theme.colorWindowBackground
    }

    property int listViewSpacing: 0
    property int listViewTopMargin: 0
    property int listViewBottomMargin: 0

    // to auto-loader the listView
    property bool hasListView: true

    // if set to false, the busyIndicator will be put in the page top
    property bool centralizeBusyIndicator: true

    // keep the state to page based on request state
    // The requestHttp is a window object - window is Main.qml
    property bool isPageBusy: requestHttp.state === "loading"

    // keep the status for current page
    // The currentPage is a window alias to pageStack active page - window is Main.qml
    property bool isActivePage: window.currentPage && window.currentPage.objectName === objectName

    // for toolbar binds
    property string toolBarState: ""
    property var toolBarActions: ({})

    // for page data
    property var json: ({})

    // to keep the plugin config.json for current page
    property var configJson: ({})

    // A component implemented by child page that uses ListView
    property var listViewDelegate: ({})

    // a alias to busyIndicator to child page manage them
    property alias busyIndicator: _busyIndicator

    // empty list is a item to show a warning when list view is empty
    property alias emptyList: _emptyList

    // a alias to primary text of the emptyList to child page set a specific text
    property alias firstText: _emptyList.firstText

    // a alias to secondary text of the emptyList to child page set a specific text
    property alias secondText: _emptyList.secondText

    property ListView listView
    property ListModel listViewModel

    signal loadItens()
    signal updatePage()

    BusyIndicator {
        id: _busyIndicator
        visible: isPageBusy
        z: parent.z + 1
        width: 56; height: width
        anchors {
            centerIn: centralizeBusyIndicator ? parent : undefined
            top: centralizeBusyIndicator ? undefined : parent.top
            topMargin: centralizeBusyIndicator ? undefined : 20
            horizontalCenter: centralizeBusyIndicator ? undefined : parent.horizontalCenter
        }
    }

    EmptyList {
        id: _emptyList
        z: basePage.z+1
        visible: hasListView && listView && listView.count === 0 && !_busyIndicator.visible
        enabled: !isPageBusy
        onClicked: updatePage();
    }

    Component {
        id: listViewComponent
        ListView {
            model: listViewModel
            clip: true; spacing: listViewSpacing; cacheBuffer: width
            topMargin: listViewTopMargin; bottomMargin: listViewBottomMargin
            delegate: basePage.listViewDelegate ? basePage.listViewDelegate : null
            width: basePage.width; height: basePage.height
            onRemoveChanged: update();
            onAtYEndChanged: if (atYEnd) loadItens();
            ScrollIndicator.vertical: ScrollIndicator { }
        }
    }

    Component {
        id: listViewModelComponent
        ListModel { }
    }

    Loader {
        asynchronous: true
        active: hasListView
        sourceComponent: listViewComponent
        onLoaded: basePage.listView = item;
    }

    Loader {
        asynchronous: true
        active: hasListView
        sourceComponent: listViewModelComponent
        onLoaded: basePage.listViewModel = item;
    }
}
