import QtQuick 2.7
import QtQml.Models 2.2
import QtQuick.Controls 2.0

import "functions.js" as AlunoFunc
import "../../qml/js/Utils.js" as Util
import "../../qml/components/" as AppComponents

Page {
    id: page
    title: "Lista de Alunos"

    property list<MenuItem> toolBarMenuList: [
        MenuItem {
            text: "Select all"
            onTriggered: AlunoFunc.selectAll()
        }
    ]

    property string searchText: "olá"

    // make a binding with toolbar
    property string toolBarState: selectedIndex.length > 0 ? "actions" : "normal"

    property var configJson: ({})
    property var fieldsVisible: []
    property var selectedIndex: []
    property var toolBarActions: [
        ({"action": "delete", "iconName": "trash", "when": "actions"}),
        ({"action": "search", "iconName": "search", "when": "normal"}),
    ]

    // called by ToolBar on action click
    function actionExec(actionName) {
        AlunoFunc.exec(actionName)
    }

    onSearchTextChanged: {
        console.log("search term changed: " + searchText)
    }

    onConfigJsonChanged: {
        if (!configJson.index_fields.length) return
        var arrayTemp = []
        for (var i = 0; i < configJson.index_fields.length; i++)
            arrayTemp.push(configJson.index_fields[i])
        fieldsVisible = arrayTemp
    }

    onVisibleChanged: {
        if (visible) { // is the active page, start a request!
            if (jsonListModel.model) jsonListModel.model.clear()
            AlunoFunc.httpRequest("users")
        }
    }

    Component.onCompleted: AlunoFunc.httpRequest("users")

    BusyIndicator {
        id: loading
        anchors.centerIn: parent
        visible: listView.count === 0 && jsonListModel.state !== "ready"
    }

    AppComponents.NoItem {
        z: listView.z + 1
        visible: listView.count === 0 && !loading.visible
        onClicked: AlunoFunc.httpRequest("users")
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

            onPressAndHold: AlunoFunc.addSelectedItem(index, listView.itemAt(wrapper.x, wrapper.y), false)
            onClicked: pushPage(configJson.root_folder+"/AlunoProfile.qml", {"title": primaryLabelText, "userId": model.id})
        }
    }

    ListView {
        id: listView
        width: page.width
        height: page.height
        focus: true
        model: listModel
        delegate: listViewDelegate
        cacheBuffer: width
        onRemoveChanged: update()
        Keys.onUpPressed: scrollBar.decrease()
        Keys.onDownPressed: scrollBar.increase()
        ScrollBar.vertical: ScrollBar { id: scrollBar }
    }

    AppComponents.FloatingButton {
        onClicked: pushPage(configJson.root_folder+"/AlunoProfile.qml", {"action": "newRegister"})
    }
}
