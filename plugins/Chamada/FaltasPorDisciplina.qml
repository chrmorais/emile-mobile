import QtQuick 2.7
import QtQml.Models 2.2
import QtQuick.Controls 2.0

import "../../qml/js/Utils.js" as Util
import "../../qml/components/" as AppComponents

Page {
    id: page
    title: "My attendance"
    objectName: "My attendance"

    property int userId: 0

    Component.onCompleted: {
        var json1 = {
            "attendance": [{
                    "date": "02-04-2016",
                    "status": "P"
                }, {
                    "date": "02-04-2016",
                    "status": "F"
                }, {
                    "date": "02-04-2016",
                    "status": "P"
                }, {
                    "date": "02-04-2016",
                    "status": "F"
                }]
        }
        var json2 = {
            "attendance": [{
                    "date": "02-04-2016",
                    "status": "F"
                }, {
                    "date": "02-04-2016",
                    "status": "P"
                }, {
                    "date": "02-04-2016",
                    "status": "P"
                }]
        }
        var json3 = {
            "attendance": [{
                    "date": "02-04-2016",
                    "status": "P"
                }, {
                    "date": "02-04-2016",
                    "status": "P"
                }, {
                    "date": "02-04-2016",
                    "status": "P"
                }]
        }
        var json4 = {
            "attendance": [{
                    "date": "02-04-2016",
                    "status": "F"
                }, {
                    "date": "02-04-2016",
                    "status": "F"
                }, {
                    "date": "02-04-2016",
                    "status": "F"
                }]
        }
        if(userId === 1)
            for (var i = 0; i < json1.attendance.length; i++) {
                listModel.append(json1.attendance[i]);
            }
        if(userId === 2)
            for (var i = 0; i < json2.attendance.length; i++) {
                listModel.append(json2.attendance[i]);
            }
        if(userId === 3)
            for (var i = 0; i < json3.attendance.length; i++) {
                listModel.append(json3.attendance[i]);
            }
        if(userId === 4)
            for (var i = 0; i < json4.attendance.length; i++) {
                listModel.append(json4.attendance[i]);
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
            primaryLabelText: date
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
        model: ListModel { id: listModel }
        delegate: listViewDelegate
        cacheBuffer: width
        onRemoveChanged: update()
        Keys.onUpPressed: scrollBar.decrease()
        Keys.onDownPressed: scrollBar.increase()
        ScrollBar.vertical: ScrollBar { id: scrollBar }
    }
}
