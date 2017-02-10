import QtQuick 2.7
import QtQml.Models 2.2
import QtQuick.Controls 2.0

import "functions.js" as AlunoFunc
import "../../qml/js/Utils.js" as Util
import "../../qml/components/" as AppComponents

Page {
    id: page
    title: qsTr("List of students")
    objectName: qsTr("Students")
    background: Rectangle{
        anchors.fill: parent
        color: appSettings.theme.colorWindowBackground
    }

    property var json

    property list<MenuItem> toolBarMenuList: [
        MenuItem {
            text: "Select all"
            onTriggered: AlunoFunc.selectAll()
        }
    ]

    property string searchText: ""

    // make a binding with toolbar
    property string toolBarState: selectedIndex.length > 0 ? "action" : "normal"

    property var configJson: ({})
    property var fieldsVisible: []
    property var selectedIndex: []
    property var toolBarActions: ["search", "delete"]

    // called by ToolBar on action click
    function actionExec(actionName) {
        AlunoFunc.exec(actionName);
    }

    onSearchTextChanged: {
        console.log("search term changed: " + searchText)
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
        jsonListModel.debug = false;
        jsonListModel.source += "students"
        jsonListModel.load()
    }

//    onVisibleChanged: {
//        if (visible) { // is the active page, start a request!
//            if (jsonListModel.model)
//                jsonListModel.model.clear();
//            request();
//        }
//    }

    Connections {
        target: window
        onPageChanged: if (currentPage.title === page.title) request();
    }

    Connections {
        target: jsonListModel
        onStateChanged: {
            if (jsonListModel.state === "ready" && currentPage.title === page.title)
                var jsonTemp = jsonListModel.model
                json = jsonTemp;
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
        onClicked: request()
    }

    Component {
        id: listViewDelegate

        AppComponents.ListItem {
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

    ListView {
        id: listView
        focus: true; cacheBuffer: width
        width: page.width; height: page.height
        model: json; delegate: listViewDelegate
        onRemoveChanged: update();
        Keys.onUpPressed: scrollBar.decrease();
        Keys.onDownPressed: scrollBar.increase();
        ScrollBar.vertical: ScrollBar { id: scrollBar }
    }

    AppComponents.FloatingButton {
        onClicked: pushPage(configJson.root_folder+"/AlunoProfile.qml", {"action": "newRegister"})
    }
}
