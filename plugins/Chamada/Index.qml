import QtQuick 2.7
import QtQuick.Controls 2.0
import QtQuick.Controls.Material 2.0

import "../../qml/components/"

Page {
    id: page
    title: qsTr("Courses in progress")
    background: Rectangle{
        anchors.fill: parent
        color: appSettings.theme.colorWindowBackground
    }

    property var json: {}
    property var configJson: {}

    function request() {
        jsonListModel.source += "section_time_in_progress/" + userProfileData.id
        jsonListModel.load(function(response, status) {
            if (status !== 200)
                return;
            json = response;
        });
    }

    Component.onCompleted: request();

    Connections {
        target: window
        onPageChanged: if (currentPage.title === page.title) request();
    }

    BusyIndicator {
        id: busyIndicator
        anchors.centerIn: parent
        visible: jsonListModel.state === "loading"
    }

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
                text: {
                    if (json && typeof json != "undefined")
                        return json.section_time_start_time + " - " + json.section_time_finish_time;
                    return "";
                }
                anchors.horizontalCenter: parent.horizontalCenter
                color: appSettings.theme.defaultTextColor
            }
        }

        Column {
            spacing: 5

            Label {
                color: Material.color(Material.Red)
                text: {
                    if (jsonListModel.state === "running")
                        qsTr("Checkin for courses in progress...")
                    else if (json)
                        qsTr("Do you want register attendance?")
                    else
                        qsTr("None courses in progress!")
                }
                anchors.horizontalCenter: parent.horizontalCenter
                font { pointSize: 16; weight: Font.Bold }
            }

            CustomButton {
                enabled: json !== undefined && jsonListModel.state !== "running"
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
        enabled: jsonListModel.state !== "running"
        text: qsTr("My courses")
        textColor: appSettings.theme.colorPrimary
        backgroundColor: appSettings.theme.colorAccent
        anchors { horizontalCenter: parent.horizontalCenter; bottom: parent.bottom; bottomMargin: 15 }
        onClicked: pushPage(configJson.root_folder+"/TurmasDoProfessor.qml", {"root_folder":configJson.root_folder});
    }
}
