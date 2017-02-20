import QtQuick 2.7
import QtQuick.Controls 2.0

import "../../qml/components/" as AppComponents

Page {
    id: page
    title: qsTr("Course Sections")
    background: Rectangle {
        anchors.fill: parent
        color: appSettings.theme.colorWindowBackground
    }

    property var json: {}
    property var configJson: {}
    property string toolBarState: "goback"
    property string destination
    property int userTypeDestinationId

    function request() {
        jsonListModel.debug = true;
        jsonListModel.source += destination
        jsonListModel.load(function(response, status) {
            if (status !== 200)
                return;
            var i = 0;
            for (var prop in response) {
                while (i < response[prop].length) {
                    listModel.append(response[prop][i++]);
                }
            }
        });
    }

    Component.onCompleted: request();

    Connections {
        target: window
        onPageChanged: if (currentPage.title === page.title) request();
    }

    BusyIndicator {
        id: busyIndicator
        anchors.centerIn: parent
        visible: jsonListModel.state === "loading"
    }

    AppComponents.EmptyList {
        z: listView.z + 1
        visible: listView.count === 0 && !busyIndicator.visible
        onClicked: request();
    }

    Component {
        id: listViewDelegate

        AppComponents.ListItem {
            id: wrapper
            parent: listView.contentItem
            showSeparator: true
            badgeText: id !== undefined ? id : ""
            primaryLabelText: name + ""
            secondaryLabelText: code + ""

            x: ListView.view.currentItem.x
            y: ListView.view.currentItem.y

            onClicked: pushPage(configJson.root_folder + "/SendMessage.qml", {"userTypeDestinationId": userTypeDestinationId, "parameter": id});
        }
    }

    ListView {
        id: listView
        width: page.width
        height: page.height
        focus: true
        model: ListModel{id: listModel}
        delegate: listViewDelegate
        cacheBuffer: width
        onRemoveChanged: update()
        Keys.onUpPressed: scrollBar.decrease()
        Keys.onDownPressed: scrollBar.increase()
        ScrollBar.vertical: ScrollBar { id: scrollBar }
    }
}
