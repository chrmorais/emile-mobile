import QtQuick 2.7
import QtQuick.Controls 2.1

Page {
    id: basePage
    background: Rectangle {
        anchors.fill: parent
        color: appSettings.theme.colorWindowBackground
    }

    property bool hasListView: true
    property bool hasRemoteRequest: true
    property bool centralizeBusyIndicator: true

    property var json: {}
    property var configJson: {}
    property var listViewDelegate: {}

    property alias emptyList: _emptyList
    property alias busyIndicator: _busyIndicator

    property ListView listView
    property ListModel listViewModel

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
        z: listView.z + 1
        visible: hasListView && listView.count === 0 && !_busyIndicator.visible
        onClicked: if (hasRemoteRequest) request();
    }

    Component {
        id: listViewComponent
        ListView {
            focus: true
            width: basePage.width; height: basePage.height
            model: listViewModel
            delegate: basePage.listViewDelegate
            cacheBuffer: width
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
