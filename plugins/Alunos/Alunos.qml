import QtQuick 2.7
import QtQml.Models 2.2
import QtQuick.Controls 2.0

import "../../qml/components/"
import "functions.js" as AlunoFunc
import "../../qml/js/Utils.js" as Util

BasePage {
    id: page
    title: qsTr("List of students")
    objectName: qsTr("Students")
    listViewDelegate: pageDelegate
    toolBarState: selectedIndex.length > 0 ? "action" : "normal"
    toolBarActions: ["search", "delete"]
    onUpdatePage: request();

    property list<MenuItem> toolBarMenuList: [
        MenuItem {
            text: "Select all"
            onTriggered: AlunoFunc.selectAll();
        }
    ]

    property string searchText: ""
    property var fieldsVisible: []
    property var selectedIndex: []

    // called by ToolBar on action click
    function actionExec(actionName) {
        AlunoFunc.exec(actionName);
    }

    onSearchTextChanged: {
        console.log("search term changed: " + searchText);
    }

    onConfigJsonChanged: {
        if (!configJson.index_fields.length)
            return;
        var arrayTemp = [];
        for (var i = 0; i < configJson.index_fields.length; i++)
            arrayTemp.push(configJson.index_fields[i]);
        fieldsVisible = arrayTemp;
    }

    function request() {
        jsonListModel.source += "students";
        if (listViewModel && listViewModel.count > 0)
            listViewModel.clear();
        jsonListModel.load();
    }

    Connections {
        target: window
        onPageChanged: if (currentPage.title === page.title) request();
    }

    Connections {
        target: jsonListModel
        onStateChanged: {
            if (jsonListModel.state === "ready" && currentPage.title === page.title) {
                var jsonTemp = jsonListModel.model
                json = jsonTemp;
            }
        }
    }

    Component {
        id: pageDelegate

        ListItem {
            id: wrapper
            showSeparator: true
            primaryImageSource: model.profileImage ? Util.getObjectValueByKey(model, "profileImage") : ""
            primaryLabelText: username
            badgeText: model.profileImage ? "" : primaryLabelText.substring(0,1).toUpperCase()
            onPressAndHold: AlunoFunc.addSelectedItem(index, selected, false)
            onClicked: pushPage(configJson.root_folder+"/AlunoProfile.qml", {"title": primaryLabelText, "userId": id})
            selected: selectedIndex.indexOf(index) !== -1
        }
    }

    FloatingButton {
        onClicked: pushPage(configJson.root_folder+"/AlunoProfile.qml", {"action": "newRegister"})
    }
}
