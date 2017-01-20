import QtQuick 2.7
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.0

import "../../qml/components/"

Page {
    id: page
    title: qsTr("Student attendance")

    property bool checkedAll: true
    property int section_times_id: 0
    property int course_section_id: 0

    property var configJson: ({})
    property var checkedStatus: ({})
    property var toolBarActions: ["save"]
    property var attendance: {"student_attendance": []};

    property string attendanceDate: ""
    property string toolBarState: "goback"
    property string defaultUserImage: "user-default.png"

    property list<MenuItem> toolBarMenuList: [
        MenuItem {
            text: "Exibir em " + (listView.visible ? "grade" : "lista")
            onTriggered: gridView.visible = !gridView.visible
        },
        MenuItem {
            text: checkedAll ? "Desmarcar todos" : "Marcar todos"
            onTriggered: {
                var attendanceTemp = attendance["student_attendance"];
                for (var i = 0; i < attendanceTemp.length; i++) {
                    var studentStatus = attendanceTemp[i];
                    studentStatus.status = checkedAll ? "F" : "P";
                    attendanceTemp[i] = studentStatus;
                    updateStatus(studentStatus.student_id, studentStatus.status);
                }
                checkedAll = !checkedAll;
                attendance["attendance"] = attendanceTemp;
            }
        }
    ]

    function saveAttendenceValidateStatus() {
        // after get server response, close the current page
        if (["ready", "error"].indexOf(jsonListModel.state) !== -1) {
            if (jsonListModel.httpStatus === 200)
                popPage(); // is a function from Main.qml
            else if (jsonListModel.httpStatus === 400)
                alert("Warning!", "The attendance date is already registered for this course section! Set another date.", "OK", function() { }, "CANCEL", function() { });
            else if (jsonListModel.httpStatus === 404)
                alert("Warning!", "The attendance date is invalid for this course section!", "OK", function() { }, "CANCEL", function() { });
        }
    }

    function requestToSave() {
        if (gridView.model.count === 0) {
            alert("Warning!", "The students list is empty!");
            return;
        }
        if (!attendanceDate) {
            alert("Warning!", "You need to inform the attendance date for this course section!", "OK", function() { datePicker.open(); }, "CANCEL", function() { });
            return;
        }
        attendance["section_time_date"] = attendanceDate;
        jsonListModel.requestMethod = "POST";
        jsonListModel.contentType = "application/json";
        jsonListModel.requestParams = JSON.stringify(attendance);
        jsonListModel.source += "student_attendance_register/"+section_times_id;
        jsonListModel.load();
        jsonListModel.stateChanged.connect(saveAttendenceValidateStatus);
    }

    function actionExec(action) {
        if (action === "save")
            requestToSave();
    }

    function save(student_id, status) {
        for (var i = 0; i < attendance["student_attendance"].length; ++i) {
            if (attendance["student_attendance"][i].student_id && attendance["student_attendance"][i].student_id === student_id)
                attendance["student_attendance"].splice(i,1);
        }
        attendance["student_attendance"].push({"student_id": student_id, "status": status});
        updateStatus(student_id, status);
    }

    function updateStatus(student_id, status) {
        var fixBind = ({});
        if (typeof checkedStatus != "undefined")
            fixBind = checkedStatus;
        fixBind[student_id.toString()] = status;
        checkedStatus = fixBind;
    }

    Component.onCompleted: {
        jsonListModel.debug = false
        jsonListModel.source += "course_sections_students/" + course_section_id
        jsonListModel.load()
    }

    Connections {
        target: window
        onPageChanged: jsonListModel.stateChanged.disconnect(saveAttendenceValidateStatus);
    }

    Connections {
        target: jsonListModel
        onStateChanged: {
            if (jsonListModel.state === "ready" && page.visible)
                gridView.model = jsonListModel.model;
        }
    }

    DatePicker {
        id: datePicker
        onDateSelected: {
            attendanceDate = date.month + "-" + date.day + "-" + date.year;
            requestToSave();
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
        delegate: GridViewDelegate { }
        cellWidth: parent.width > parent.height ? parent.width * 0.25 : parent.width * 0.50; cellHeight: cellWidth
        Keys.onUpPressed: gridViewScrollBar.decrease()
        Keys.onDownPressed: gridViewScrollBar.increase()
        ScrollBar.vertical: ScrollBar { id: gridViewScrollBar }
    }

    ListView {
        id: listView
        visible: !busyIndicator.visible && !gridView.visible
        anchors.fill: parent
        model: gridView.model
        delegate: ListViewDelegate { }
        Keys.onUpPressed: listViewScrollBar.decrease()
        Keys.onDownPressed: listViewScrollBar.increase()
        ScrollBar.vertical: ScrollBar { id: listViewScrollBar }
    }
}
