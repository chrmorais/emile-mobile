import QtQuick 2.7
import QtQuick.Controls 2.0

import "../../qml/components/" as AppComponents

Page {
    id: page
    title: qsTr("DestinationGroupSelect")

    property var json: {}
    property var configJson: {}

//    function request() {
//        jsonListModel.debug = false;
//        jsonListModel.source += "teachers_course_sections/" + userProfileData.id;
//        jsonListModel.load();
//    }

    Component.onCompleted: {
//        request();
        json = [{
           "id": 1,
           "code": "teste",
           "name": "Todos os alunos"
        }, {
           "id": 2,
           "code": "teste2",
           "name": "Alunos de uma turma"
        }];
        for(var i = 0; i < json.length; i++)
            modelTest.append(json[i]);
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
            secondaryLabelText: code + ""

            x: ListView.view.currentItem.x
            y: ListView.view.currentItem.y

            onClicked: pushPage(configJson.root_folder+"/DestinationSelect.qml", {"title": name, "configJson": configJson});
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
