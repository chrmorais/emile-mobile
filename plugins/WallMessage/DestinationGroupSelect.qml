import QtQuick 2.7
import QtQuick.Controls 2.0

import "../../qml/components/" as AppComponents

Page {
    id: page
    title: qsTr("Send to:")
    background: Rectangle {
        anchors.fill: parent
        color: appSettings.theme.colorWindowBackground
    }

    property var json: {}
    property var configJson: {}

    function request() {
        jsonListModel.debug = false;
        jsonListModel.source += "destinations_by_user_type/" + 2
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
            badgeText: id
            primaryLabelText: name + ""
            secondaryLabelText: ""

            x: ListView.view.currentItem.x
            y: ListView.view.currentItem.y

            onClicked: {
                var id = listModel.get(index).id;
                var destination = listModel.get(index).param_values_service;

                if (destination.indexOf("<%users%>") > -1) {
                    pushPage(configJson.root_folder+"/SendMessage.qml", {"userTypeDestinationId": id, "parameter": window.userProfileData.id});
                } else {
                    destination = destination.replace("$", "") + window.userProfileData.id;
                    pushPage(configJson.root_folder+"/DestinationSelect.qml", {"userTypeDestinationId": id, "configJson": configJson, "destination": destination});
                }
            }
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
