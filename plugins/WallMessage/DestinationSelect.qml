import QtQuick 2.7
import QtQuick.Controls 2.0

import "../../qml/components/" as AppComponents

Page {
    id: page
    title: qsTr("teste")

    property var json: {}
    property var configJson: {}
    property string toolBarState: "goback"

//    function request() {
//        jsonListModel.debug = false;
//        jsonListModel.source += "teachers_course_sections/" + userProfileData.id;
//        jsonListModel.load();
//    }

    Component.onCompleted: {
        //request();
        json = [{
                "id": 1,
                "week_day": 0,
                "code": "INF022 - T01",
                "course": {
                    "code": "INF022",
                    "id": 1,
                    "name": "Tópicos Avançados"
                },
                "name": "Turma de Renato",
                "teacher_id": 5
            }, {
                "id": 2,
                "week_day": 0,
                "code": "INF021 - T01",
                "course": {
                    "code": "INF021",
                    "id": 1,
                    "name": "Test"
                },
                "name": "Turma de Renato 21",
                "teacher_id": 5
            }]
        for(var i = 0; i < json.length; i++)
            modelTest.append(json[i]);
    }

//    Connections {
//        target: window
//        onPageChanged: if (currentPage.title === page.title) request();
//    }

//    Connections {
//        target: jsonListModel
//        onStateChanged: {
//            if (jsonListModel.state === "ready" && currentPage.title === page.title) {
//                var jsonTemp = jsonListModel.model;
//                json = jsonTemp;
//                console.log("Json = " + JSON.stringify(json.get(0)))
//            }
//        }
//    }

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

            onClicked: pushPage(configJson.root_folder + "/SendMessage.qml", {});
        }
    }

    ListView {
        id: listView
        width: page.width
        height: page.height
        focus: true
        model: ListModel{id: modelTest}
        delegate: listViewDelegate
        cacheBuffer: width
        onRemoveChanged: update()
        Keys.onUpPressed: scrollBar.decrease()
        Keys.onDownPressed: scrollBar.increase()
        ScrollBar.vertical: ScrollBar { id: scrollBar }
    }
}
