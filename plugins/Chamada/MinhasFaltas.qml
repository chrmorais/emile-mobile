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
    property var configJson: {}

    onConfigJsonChanged: {
        if (!configJson.index_fields.length) return
        var arrayTemp = []
        for (var i = 0; i < configJson.index_fields.length; i++)
            arrayTemp.push(configJson.index_fields[i])
        fieldsVisible = arrayTemp
    }

    Component.onCompleted: {
        jsonListModel.source += "students_course_sections/" + userProfileData.id
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
            jsonListModel.source += "students_course_sections/" + userProfileData.id
            jsonListModel.load()
        }
    }

    Component {
        id: listViewDelegate

        AppComponents.ListItem {
            id: wrapper
            parent: listView.contentItem
            showSeparator: true
            badgeText: course.id
            primaryLabelText: name + ""
            secondaryLabelText: code + ""

            x: ListView.view.currentItem.x
            y: ListView.view.currentItem.y

            onClicked: pushPage(configJson.root_folder+"/FaltasPorDisciplina.qml", {"title": "Attendance in " + primaryLabelText, "courseId": id})
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
