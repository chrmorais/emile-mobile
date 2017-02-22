import QtQuick 2.7
import QtQuick.Controls 2.1

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
    property bool hasRemoteRequest: true
    property bool centralizeBusyIndicator: true

    // for toolbar
    property string toolBarState: ""
    property var toolBarActions: []

    // for pageData
    property var json: {}

    // to keep the plugin config.json
    property var configJson: {}
    property var listViewDelegate: {}

    // to allow the child class to access follow itens
    property alias emptyList: _emptyList
    property alias busyIndicator: _busyIndicator

    property ListView listView
    property ListModel listViewModel

    signal updatePage()

    BusyIndicator {
        id: _busyIndicator
        visible: jsonListModel.state === "loading"
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
        visible: hasListView && listView.count === 0 && !_busyIndicator.visible
        enabled: jsonListModel.state !== "loading"
        onClicked: updatePage();
    }

    Component {
        id: listViewComponent
        ListView {
            model: listViewModel
            spacing: listViewSpacing
            cacheBuffer: width; focus: true
            topMargin: listViewTopMargin; bottomMargin: listViewBottomMargin
            delegate: basePage.listViewDelegate ? basePage.listViewDelegate : null
            width: basePage.width; height: basePage.height
            onRemoveChanged: update()
            Keys.onUpPressed: scrollBar.decrease()
            Keys.onDownPressed: scrollBar.increase()
            ScrollBar.vertical: ScrollBar { id: scrollBar; size: 0.01 }
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
