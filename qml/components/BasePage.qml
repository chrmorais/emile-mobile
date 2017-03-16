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
    property bool hasRemoteRequest: true
    property bool centralizeBusyIndicator: true
    property bool isPageBusy: requestHttp.state === "loading"

    property bool isActivePage: currentPage.objectName && currentPage.objectName === objectName

    // for toolbar
    property string toolBarState: ""
    property var toolBarActions: ({})

    // for page data
    property var json: {}

    // to keep the plugin config.json for current page
    property var configJson: {}

    // A component implemented by child page that uses ListView
    property var listViewDelegate: {}

    // empty list is a item to show a warning when list view is empty
    property alias emptyList: _emptyList

    // a alias to busyIndicator to child pages manage them
    property alias busyIndicator: _busyIndicator

    // a alias to progressBar to child pages manage them
    property alias progressBar: _progressBar

    // a alias to firstText of emptyList to child pages manage them
    property alias firstText: _emptyList.firstText

    property ListView listView
    property ListModel listViewModel

    signal updatePage()

    BusyIndicator {
        id: _busyIndicator
        visible: isPageBusy
        z: parent.z + 1
        anchors {
            centerIn: centralizeBusyIndicator ? parent : undefined
            top: centralizeBusyIndicator ? undefined : parent.top
            topMargin: centralizeBusyIndicator ? undefined : 20
            horizontalCenter: centralizeBusyIndicator ? undefined : parent.horizontalCenter
        }
    }

    ProgressBar {
        id: _progressBar
        visible: !_busyIndicator.visible && isPageBusy
        indeterminate: visible
        width: parent.width; z: parent.z + 100
        anchors { top: parent.top; topMargin: 0 }
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
            highlightMoveDuration: 1250; clip: true
            spacing: listViewSpacing; cacheBuffer: width
            topMargin: listViewTopMargin; bottomMargin: listViewBottomMargin
            delegate: basePage.listViewDelegate ? basePage.listViewDelegate : null
            width: basePage.width; height: basePage.height
            onRemoveChanged: update()
            Keys.onUpPressed: scrollBar.decrease()
            Keys.onDownPressed: scrollBar.increase()
            moveDisplaced: Transition {
                NumberAnimation { properties: "x,y"; duration: 250 }
            }
            ScrollBar.vertical: ScrollBar {
                id: scrollBar
                contentItem: Rectangle {
                    implicitWidth: 0.1
                    implicitHeight: scrollBar.height
                    opacity: enabled ? 1 : 0.7
                    color: Material.highlightedRippleColor
                    radius: 100
                }
                background: Rectangle {
                    width: 1; height: scrollBar.height; color: Material.highlightedRippleColor
                }
            }
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
