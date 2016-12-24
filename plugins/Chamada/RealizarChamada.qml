import QtQuick 2.7
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.0

Page {
    title: "Realizar chamada"

    property int classes_id: 0
    property int lesson_id: 0
    property bool checkedAll: true
    property var chamada: {"frequency": []};
    property var checkedStatus: {}
    property var configJson: ({})
    property string toolBarState: "goback"
    property var toolBarActions: ["save"]
    property string defaultUserImage: "user-default.png"
    property list<MenuItem> toolBarMenuList: [
        MenuItem {
            text: "Exibir em " + (listView.visible ? "grade" : "lista")
            onTriggered: gridView.visible = !gridView.visible
        },
        MenuItem {
            text: checkedAll ? "Desmarcar todos" : "Marcar todos"
            onTriggered: {
                var chamadaTemp = chamada
                for(var key in chamadaTemp)
                    chamadaTemp[key].status = checkedAll ? "F" : "P"
                chamada = chamadaTemp
                checkedAll = !checkedAll
            }
        }
    ]

    function requestToSave() {
        jsonListModel.requestMethod = "POST"
        jsonListModel.requestParams = JSON.stringify(chamada)
        jsonListModel.source += "/frequency_register/"+lesson_id
        jsonListModel.load()
        jsonListModel.stateChanged.connect(function() {
            // after get server response, close the current page
            if (jsonListModel.state === "ready")
                popPage(); // is a function from Main.qml
        })
    }

    function actionExec(actionusername) {
        if (actionusername == "save")
            requestToSave();
    }

    Component.onCompleted: {
        jsonListModel.source += "students_classes/" + classes_id
        jsonListModel.load()
    }

    Connections {
        target: jsonListModel
        onStateChanged: {
            if (jsonListModel.state === "ready")
                gridView.model = jsonListModel.model
        }
    }

    function save(student_id, status) {
        console.log("student_id: " + student_id + " status: " + status);
        chamada["frequency"].push({"student_id": student_id, "status": status});
        var checkedStatusTemp = ({});
        checkedStatusTemp[student_id] = status;
        checkedStatus = checkedStatusTemp;
    }

    Component {
        id: gridViewDelegate

        Item {
            id: item
            width: gridView.cellWidth; height: gridView.cellHeight
            opacity: switchStatus.checked ? 0.75 : 1.0

            Rectangle {
                width: parent.width * 0.70; height: 1
                color: switchStatus.checked ? "#ccc" : "#eee"
                anchors { bottom: parent.bottom; horizontalCenter: parent.horizontalCenter }
            }

            Column {
                spacing: 15; width: 200; height: 300
                anchors { top: parent.top; topMargin: 10; horizontalCenter: parent.horizontalCenter }

                Image {
                    id: imgProfile
                    asynchronous: true
                    source: defaultUserImage
                    width: 35; height: 35
                    fillMode: Image.PreserveAspectCrop
                    clip: true; cache: true; smooth: true
                    sourceSize { width: width; height: height }
                    anchors.horizontalCenter: parent.horizontalCenter
                }

                Column {
                    spacing: 2
                    anchors.horizontalCenter: parent.horizontalCenter

                    Label {
                        text: name || ""
                        font.pointSize: 10
                        anchors.horizontalCenter: parent.horizontalCenter
                    }

                    Label {
                        text: email
                        font.pointSize: 8
                        anchors.horizontalCenter: parent.horizontalCenter
                    }
                }

                Switch {
                    id: switchStatus
                    text: checkedStatus != null && checkedStatus[id] ? checkedStatus[id] : "P"
                    anchors.horizontalCenter: parent.horizontalCenter
                    font.weight: Font.DemiBold
                    checked: switchStatus.text == "P"
                    onClicked: {
                        switchStatus.text = (switchStatus.text == "F" ? "P" : "F")
                        save(id, switchStatus.text)
                    }
                }
            }
        }
    }

    Component {
        id: listViewDelegate

        Column {
            spacing: 0; width: parent.width; height: 60

            Component.onCompleted: save(id, labelStatus.text);

            Rectangle {
                width: parent.width; height: parent.height - 1

                RowLayout {
                    spacing: 35
                    anchors.fill: parent
                    width: parent.width; height: parent.height
                    anchors.verticalCenter: parent.verticalCenter

                    Image {
                        id: imgProfile
                        asynchronous: true
                        width: 35; height: 35
                        source: defaultUserImage
                        fillMode: Image.PreserveAspectCrop
                        clip: true; cache: true; smooth: true
                        sourceSize { width: width; height: height }
                        anchors { left: parent.left; leftMargin: 15; verticalCenter: parent.verticalCenter }
                    }

                    Column {
                        spacing: 2
                        anchors { left: imgProfile.right; leftMargin: 15; verticalCenter: parent.verticalCenter }

                        Label {
                            text: name || ""
                        }

                        Label {
                            text: email
                        }
                    }

                    RowLayout {
                        spacing: 15
                        anchors { right: parent.right; rightMargin: 15; verticalCenter: parent.verticalCenter }

                        CheckBox {
                            anchors.verticalCenter: parent.verticalCenter
                            checked: labelStatus.text == "P"
                            onClicked: {
                                labelStatus.text = (labelStatus.text == "F" ? "P" : "F")
                                save(id, labelStatus.text);
                            }
                        }

                        Label {
                            id: labelStatus
                            text: checkedStatus != null && checkedStatus[id] ? checkedStatus[id] : "P"
                            anchors.verticalCenter: parent.verticalCenter
                            color: text == "F" ? "red" : "blue"
                            font.weight: Font.DemiBold
                        }
                    }
                }
            }

            // draw a border separator
            Rectangle { color: "#ccc"; width: parent.width; height: 1 }
        }
    }

    BusyIndicator {
        id: busyIndicator
        antialiasing: true
        visible: jsonListModel.state === "running"
        anchors { top: parent.top; topMargin: 20; horizontalCenter: parent.horizontalCenter }
    }

    GridView {
        id: gridView
        visible: false
        anchors.fill: parent
        delegate: gridViewDelegate
        cellWidth: 180; cellHeight: cellWidth
        Keys.onUpPressed: gridViewScrollBar.decrease()
        Keys.onDownPressed: gridViewScrollBar.increase()
        ScrollBar.vertical: ScrollBar { id: gridViewScrollBar }
    }

    ListView {
        id: listView
        visible: !busyIndicator.visible && !gridView.visible
        anchors.fill: parent
        model: gridView.model
        delegate: listViewDelegate
        Keys.onUpPressed: listViewScrollBar.decrease()
        Keys.onDownPressed: listViewScrollBar.increase()
        ScrollBar.vertical: ScrollBar { id: listViewScrollBar }
    }
}
