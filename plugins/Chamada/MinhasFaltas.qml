import QtQuick 2.7
import QtQml.Models 2.2
import QtQuick.Controls 2.0

import "../../qml/js/Utils.js" as Util
import "../../qml/components/" as AppComponents

Page {
    id: page
    title: "My attendance"
    objectName: "My attendance"

    property var configJson: ({})

    Component.onCompleted: {
        var i
        var json = {
            "lessons": [{
                    "id": 1,
                    "cod": "inf011",
                    "name": "Padrões de Projeto"
                }, {
                    "id": 2,
                    "cod": "inf009",
                    "name": "Sistemas Operacionais"
                }, {
                    "id": 3,
                    "cod": "inf012",
                    "name": "Programação WEB"
                }, {
                    "id": 4,
                    "cod": "inf010",
                    "name": "Banco de dados 2"
                }]
        }
        for (var i = 0; i < json.lessons.length; i++) {
            listModel.append(json.lessons[i]);
        }
    }

    BusyIndicator {
        id: loading
        anchors.centerIn: parent
        visible: listView.count === 0
    }

    AppComponents.EmptyList {
        z: listView.z + 1
        visible: listView.count === 0 && !loading.visible
        onClicked: console.log("Clicou")
    }

    Component {
        id: listViewDelegate

        AppComponents.ListItem {
            id: wrapper
            parent: listView.contentItem
            showSeparator: true
            primaryLabelText: name
            badgeText: id
            secondaryLabelText: cod

            x: ListView.view.currentItem.x
            y: ListView.view.currentItem.y

            onClicked: pushPage(configJson.root_folder+"/FaltasPorDisciplina.qml", {"title": "Attendance in " + primaryLabelText, "userId": model.id})
        }
    }

    ListView {
        id: listView
        width: page.width
        height: page.height
        focus: true
        model: ListModel { id: listModel }
        delegate: listViewDelegate
        cacheBuffer: width
        onRemoveChanged: update()
        Keys.onUpPressed: scrollBar.decrease()
        Keys.onDownPressed: scrollBar.increase()
        ScrollBar.vertical: ScrollBar { id: scrollBar }
    }
}
