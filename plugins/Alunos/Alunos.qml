import QtQuick 2.7
import QtQml.Models 2.2
import QtQuick.Controls 2.0

import "../../qml/js/Utils.js" as Util
import "../../qml/components/" as AppComponents

Page {
    id: page
    title: "Alunos"

    property list<MenuItem> subMenuToolBarItens: [
        MenuItem {
            text: "Select all"
            onTriggered: updateSelected(true)
        },
        MenuItem {
            text: "Sort by name"
            onTriggered: console.log("sort not implemented")
        }
    ]

    // the plugin config.json as object
    property var configJson: ({})

    // the fields visible for current listView
    property var fieldsVisible: []

    // a list of itens selected in the ListView
    property var selectedIndex: []

    // a dynamic state visible by ToolBar to bind the ToolBar state mode
    property string toolBarState: selectedIndex.length > 0 ? "actions" : "normal"

    onToolBarStateChanged: console.log("toolBarState: " + toolBarState)

    // a list of actions to display in ToolBar
    property var toolBarActions: [
        ({"action": "remove", "iconName": "trash", "when": "actions"}),
    ]

    // set by ToolBar when user search any thing
    property string searchTerm

    signal updateItem(var index, var item)

    function removeItems() {
        // after each item is removed, qml reorder the list.
        // then, we will uses descending order
        selectedIndex.sort(function (a,b) {
            return b - a
        })

        for (var i = 0; i < selectedIndex.length; i++)
            theModel.remove(selectedIndex[i])

        // reset the selectedIndex array
        var arrayTemp = []
        selectedIndex = arrayTemp
    }

    function updateSelected(turnSelected) {
        var item = ({})
        for (var i = 0; i < listView.count; ++i) {
            item = listView.contentItem.children[i]
            if (turnSelected)
                updateItem(i, item)
            else
                item.selected = false
        }
    }

    function actionExec(actionName) {
        switch(actionName) {
        case "remove":
            removeItems()
            break
        case "cancel":
            updateSelected(false)
            break
        }
    }

    onUpdateItem: {
        // it's necessary to make binding with array
        var arrayTemp = selectedIndex

        // if the item is selected and user pressAndHolder again,
        // the item will be deselect and removed from selectedIndex array
        if (item.selected)
            arrayTemp.splice(arrayTemp.indexOf(index), 1)
        else
            arrayTemp.push(index)

        selectedIndex = arrayTemp
        item.selected = !item.selected
    }

    onConfigJsonChanged: {
        if (!configJson.index_fields.length)
            return
        var arrayTemp = []
        for (var i = 0; i < configJson.index_fields.length; i++)
            arrayTemp.push(configJson.index_fields[i])
        fieldsVisible = arrayTemp
    }

    Component.onCompleted: {
        //        jsonListModel.debug = true
        //        jsonListModel.requestMethod = "GET"
        //        jsonListModel.source = "https://emile-server.herokuapp.com/users"
        //        jsonListModel.load()
    }

    ListModel {
        id: theModel

        ListElement {
            itemId: 10
            username: "José"
            email: "jose@ifba.edu.br"
        }
        ListElement {
            itemId: 11
            username: "João"
            email: "joao@ifba.edu.br"
            profileImage: "qrc:/assets/default-user-profile.png"
        }
        ListElement {
            itemId: 12
            username: "Maria"
            email: "maria@ifba.edu.br"
        }
        ListElement {
            itemId: 13
            username: "Pedro"
            email: "pedro@ifba.edu.br"
        }
        ListElement {
            itemId: 16
            username: "Marta"
            email: "marta@ifba.edu.br"
        }
        ListElement {
            itemId: 18
            username: "Zuleide"
            email: "zuleide@ifba.edu.br"
        }
        ListElement {
            itemId: 19
            username: "Mário"
            email: "mario@ifba.edu.br"
        }
        ListElement {
            itemId: 28
            username: "Raquel"
            email: "raquel@ifba.edu.br"
        }
        ListElement {
            itemId: 26
            username: "Camila"
            email: "camila@ifba.edu.br"
        }
        ListElement {
            itemId: 12
            username: "André"
            email: "andre@ifba.edu.br"
        }
        ListElement {
            itemId: 13
            username: "Carla"
            email: "carla@ifba.edu.br"
        }
    }

    Component {
        id: listViewDelegate

        AppComponents.ListItem {
            id: wrapper
            parent: listView.contentItem
            showSeparator: true
            primaryImageIconSource: model.profileImage ? Util.getObjectValueByKey(model, "profileImage") : ""
            primaryLabelText: fieldsVisible.length > 0 ? Util.getObjectValueByKey(model, fieldsVisible[0]) : ""
            badgeText: model.profileImage ? "" : primaryLabelText.substring(0,1)
            secondaryLabelText: fieldsVisible.length > 1 ? Util.getObjectValueByKey(model, fieldsVisible[1]) : ""

            x: ListView.view.currentItem.x
            y: ListView.view.currentItem.y

            onClicked: {
                var args = {"title": primaryLabelText, "actionId": model.actionId}
                pageStack.push(Qt.resolvedUrl("AlunoProfile.qml"), args)
            }

            onPressAndHold: updateItem(index, listView.itemAt(wrapper.x, wrapper.y))
        }
    }

    ListView {
        id: listView
        width: page.width
        height: page.height
        focus: true
        model: theModel // jsonListModel.model
        delegate: listViewDelegate
        cacheBuffer: width
        onRemoveChanged: update()
        Keys.onUpPressed: scrollBar.decrease()
        Keys.onDownPressed: scrollBar.increase()
        ScrollBar.vertical: ScrollBar { id: scrollBar }
    }

    AppComponents.FloatingButton {
        onClicked: pageStack.push(Qt.resolvedUrl("AlunoProfile.qml"), {"action": "newRegister"})
    }
}
