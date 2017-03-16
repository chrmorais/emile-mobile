import QtQuick 2.8
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.1

import "../../qml/components/"

BasePage {
    id: page
    title: qsTr("Student attendance")
    toolBarState: "goback"
    firstText: qsTr("Warning! No students found!")
    toolBarActions: ({"toolButton4": {"action":"send", "icon":"send"}})
    listViewDelegate: pageDefaultDelegate

    property bool checkedAll: true
    property int section_times_id: 0
    property int course_section_id: 0
    property var checkedStatus: ({})
    property var attendance: {"student_attendance": []};

    property string attendanceDate: ""
    property string defaultUserImage: "user-default.png"

    property list<MenuItem> toolBarMenuList: [
        MenuItem {
            text: qsTr("Show in ") + (listView.visible ? qsTr("grid") : qsTr("list"))
            onTriggered: listView.visible = !listView.visible
        },
        MenuItem {
            text: checkedAll ? qsTr("Uncheck all") : qsTr("Check all")
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

    function saveAttendenceCallback(status, response) {
        if (status === 200) {
            gridView.visible = listView.visible = false;
            alert(qsTr("Success!"), qsTr("Attendance was successfully registered"), "OK", function() { popPage() }, "CANCEL", function() { });
        } else if (status === 400) {
            alert(qsTr("Warning!"), qsTr("The attendance date is already registered for this course section! Set another date."), "OK", function() { }, "CANCEL", function() { });
        } else if (status === 404) {
            alert(qsTr("Warning!"), qsTr("The attendance date is invalid for this course section!"), "OK", function() { }, "CANCEL", function() { });
        }
    }

    function requestToSave() {
        if (gridView.model.count === 0) {
            alert(qsTr("Warning!"), qsTr("The students list is empty!"));
            return;
        }
        if (!attendanceDate) {
            alert(qsTr("Warning!"), qsTr("You need to inform the attendance date for this course section!"), "OK", function() { datePicker.open(); }, "CANCEL", function() { });
            return;
        }
        attendance["section_time_date"] = attendanceDate;
        requestHttp.requestParams = JSON.stringify(attendance);
        requestHttp.load("student_attendance_register/" + section_times_id, saveAttendenceCallback, "POST");
        toast.show(qsTr("Saving attendance register..."));
    }

    function actionExec(action) {
        if (action === "send")
            requestToSave();
    }

    function save(student_id, status) {
        for (var i = 0; i < attendance["student_attendance"].length; ++i) {
            if (attendance["student_attendance"][i].student_id && attendance["student_attendance"][i].student_id === student_id)
                attendance["student_attendance"].splice(i,1);
        }
        attendance["student_attendance"].push({"student_id": student_id, "status": status});
        checkedAll = status === "F" ? false : true;
        updateStatus(student_id, status);
    }

    function updateStatus(student_id, status) {
        var fixBind = ({});
        if (typeof checkedStatus != "undefined")
            fixBind = checkedStatus;
        fixBind[student_id] = status;
        checkedStatus = fixBind;
    }

    function requestCallback(status, response) {
        if (status !== 200)
            return;
        var i = 0;
        if (listViewModel && listViewModel.count > 0)
            listViewModel.clear();
        for (var prop in response) {
            while (i < response[prop].length)
                listViewModel.append(response[prop][i++]);
        }
    }

    function request() {
        requestHttp.load("course_sections_students/" + course_section_id, requestCallback);
    }

    Component.onCompleted: request();

    Component {
        id: pageDefaultDelegate
        ListViewDelegate { }
    }

    DatePicker {
        id: datePicker
        onDateSelected: {
            attendanceDate = date.month + "-" + date.day + "-" + date.year;
            requestToSave();
        }
    }

    GridView {
        id: gridView
        visible: !listView.visible && listViewModel && listViewModel.count > 0
        anchors.fill: parent
        model: listViewModel
        delegate: GridViewDelegate { }
        cellWidth: parent.width > parent.height ? parent.width * 0.25 : parent.width * 0.50; cellHeight: cellWidth
        Keys.onUpPressed: gridViewScrollBar.decrease()
        Keys.onDownPressed: gridViewScrollBar.increase()
        ScrollBar.vertical: ScrollBar { id: gridViewScrollBar }
    }
}
