import QtQuick 2.7
import QtQml.Models 2.2
import QtQuick.Controls 2.0

import "../../qml/js/Utils.js" as Util
import "../../qml/components/" as AppComponents

Page {
    id: page
    title: "My attendance"
    objectName: "My attendance"

    property var json: {}
    property int userId: 0

    Component.onCompleted: {
        jsonListModel.source += "students_attendance/" + 1 + "/" + userProfileData.id
        jsonListModel.load()
    }

    Connections {
        target: jsonListModel
        onStateChanged: {
            if (jsonListModel.state === "ready" && currentPage.title === page.title) {
                var jsonTemp = jsonListModel.model;
                json = jsonTemp;
            }
        }
    }

    BusyIndicator {
        id: loading
        anchors.centerIn: parent
        visible: listView.count === 0 && jsonListModel.state !== "ready"
    }

    AppComponents.EmptyList {
        z: listView.z + 1
        visible: listView.count === 0 && !loading.visible
        onClicked: {
            jsonListModel.source += "students_attendance/" + 1 + "/" + userProfileData.id
            jsonListModel.load()
        }
    }

    Component {
        id: listViewDelegate

        AppComponents.ListItem {
            id: wrapper
            parent: listView.contentItem
            showSeparator: true
            primaryLabelText: section_time_date
            badgeText: status
            badgeBackgroundColor: status === "F" ? "red" : "blue"

            x: ListView.view.currentItem.x
            y: ListView.view.currentItem.y
        }
    }

    ListView {
        id: listView
        width: page.width
        height: page.height
        focus: true
        model: json
        delegate: listViewDelegate
        cacheBuffer: width
        onRemoveChanged: update()
        Keys.onUpPressed: scrollBar.decrease()
        Keys.onDownPressed: scrollBar.increase()
        ScrollBar.vertical: ScrollBar { id: scrollBar }
    }
}
