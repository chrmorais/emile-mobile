import QtQuick 2.7
import QtQuick.Controls 2.1
import QtQuick.Controls.Material 2.1

import "../../qml/components/"

BasePage {
    id: page
    title: qsTr("Courses in progress")
    hasListView: false
    hasRemoteRequest: true
    onUpdatePage: request();

    function requestCallback(status, response) {
        if (status !== 200)
            return;
        var i = 0;
        if (listViewModel.count > 0)
            listViewModel.clear();
        for (var prop in response) {
            while (i < response[prop].length)
                listViewModel.append(response[prop][i++]);
        }
    }

    function request() {
        requestHttp.load("section_time_in_progress/" + userProfileData.id, requestCallback);
    }

    Component.onCompleted: request();

    Column {
        visible: !busyIndicator.visible
        spacing: 25
        anchors { top: parent.top; topMargin: 15; horizontalCenter: parent.horizontalCenter }

        Column {
            spacing: 5
            anchors.horizontalCenter: parent.horizontalCenter

            Label {
                font { pointSize: 16; weight: Font.Bold }
                text: {
                    if (json && typeof json != "undefined")
                        return json.course_section.course.code + " - " + json.course_section.course.name;
                    return "";
                }
                anchors.horizontalCenter: parent.horizontalCenter
                color: appSettings.theme.defaultTextColor
            }

            Label {
                font { pointSize: 14; weight: Font.Bold }
                color: appSettings.theme.defaultTextColor
                anchors.horizontalCenter: parent.horizontalCenter
                text: {
                    if (json && typeof json != "undefined")
                        return json.section_time_start_time + " - " + json.section_time_finish_time;
                    return "";
                }
            }
        }

        Column {
            spacing: 5

            Label {
                color: Material.color(Material.Red)
                font { pointSize: 16; weight: Font.Bold }
                anchors.horizontalCenter: parent.horizontalCenter
                text: {
                    if (requestHttp.state === "running")
                        qsTr("Check for courses in progress...")
                    else if (json)
                        qsTr("Do you want register attendance?")
                    else
                        qsTr("None courses in progress!")
                }
            }

            CustomButton {
                enabled: json !== undefined && requestHttp.state !== "running"
                text: qsTr("Student attendance")
                textColor: appSettings.theme.colorAccent
                backgroundColor: appSettings.theme.colorPrimary
                anchors.horizontalCenter: parent.horizontalCenter
                onClicked: {
                    var date = new Date();
                    var attendanceDate = Qt.formatDateTime(new Date(), "MM-dd-yyyy");
                    pushPage(configJson.root_folder+"/RealizarChamada.qml", {"attendanceDate":attendanceDate,"section_times_id": json.id, "course_section_id": json.course_section.id});
                }
            }
        }
    }

    CustomButton {
        visible: requestHttp.state !== "loading"
        text: qsTr("My courses")
        textColor: appSettings.theme.colorPrimary
        backgroundColor: appSettings.theme.colorAccent
        anchors { horizontalCenter: parent.horizontalCenter; bottom: parent.bottom; bottomMargin: 15 }
        onClicked: pushPage(configJson.root_folder+"/TurmasDoProfessor.qml", {"root_folder":configJson.root_folder});
    }
}
