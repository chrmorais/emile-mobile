import QtQuick 2.7
import QtQuick.Controls 2.0

import "../../qml/components/" as AppComponents

Page {
    id: page
    title: qsTr("My courses")
    background: Rectangle{
        anchors.fill: parent
        color: appSettings.theme.colorWindowBackground
    }

    property var json: {}
    property string root_folder: {}

    function request() {
        jsonListModel.debug = false;
        jsonListModel.source += "teachers_course_sections/" + userProfileData.id;
        jsonListModel.load();
    }

    Component.onCompleted: request();

    Connections {
        target: window
        onPageChanged: if (currentPage.title === page.title) request();
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
            badgeText: course !== undefined ? course.id : ""
            primaryLabelText: name + ""
            secondaryLabelText: code + ""

            x: ListView.view.currentItem.x
            y: ListView.view.currentItem.y

            onClicked: {
                pushPage(root_folder+"/RealizarChamada.qml", {"section_times_id": course.id, "course_section_id": id});
                json = {}
            }
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
