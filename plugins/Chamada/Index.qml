import QtQuick 2.8
import QtQuick.Controls 2.1
import QtQuick.Controls.Material 2.1

import "../../qml/components/"

BasePage {
    id: page
    title: qsTr("Courses in progress")
    hasListView: false
    onUpdatePage: request();

    function requestCallback(status, response) {
        if (status !== 200)
            return;
        if (response.section_times)
            json = response.section_times[0];
        else
            json = {};
        var i = 0;
    }

    function request() {
        requestHttp.load("section_time_in_progress/" + userProfileData.id, requestCallback);
    }

    Component.onCompleted: request();

    Column {
        visible: !isPageBusy
        spacing: 25
        anchors { top: parent.top; topMargin: 15; horizontalCenter: parent.horizontalCenter }

        Column {
            spacing: 5
            anchors.horizontalCenter: parent.horizontalCenter

            Label {
                font { pointSize: appSettings.theme.middleFontSize; weight: Font.Bold }
                color: appSettings.theme.textColorPrimary
                anchors.horizontalCenter: parent.horizontalCenter
                text: {
                    if (json && typeof json != "undefined" && json.course_section[0].course[0])
                        return json.course_section[0].course[0].code + " - " + json.course_section[0].course[0].name;
                    return "";
                }
            }

            Label {
                font { pointSize: appSettings.theme.smallFontSize; weight: Font.Bold }
                color: appSettings.theme.textColorPrimary
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
                color:appSettings.theme.colorPrimary
                font { pointSize: appSettings.theme.bigFontSize; weight: Font.Bold }
                anchors.horizontalCenter: parent.horizontalCenter
                text: {
                    if (isPageBusy)
                       return qsTr("Checking for courses in progress...");
                    else if (json)
                        return qsTr("Do you want register attendance?");
                    else
                        return qsTr("None courses in progress!");
                }
            }

            CustomButton {
                visible: json !== undefined && !isPageBusy
                text: qsTr("Student attendance")
                textColor: appSettings.theme.colorAccent
                backgroundColor: appSettings.theme.colorPrimary
                anchors.horizontalCenter: parent.horizontalCenter
                onClicked: {
                    var attendanceDate = Qt.formatDateTime(new Date(), "MM-dd-yyyy");
                    pushPage(configJson.root_folder+"/RealizarChamada.qml", {"attendanceDate":attendanceDate.toString(), "course_section_id": json.course_section[0].id});
                }
            }
        }
    }

    CustomButton {
        text: qsTr("My courses")
        visible: !isPageBusy
        textColor: appSettings.theme.colorAccent
        backgroundColor: appSettings.theme.colorPrimary
        anchors { horizontalCenter: parent.horizontalCenter; bottom: parent.bottom; bottomMargin: 15 }
        onClicked: pushPage(configJson.root_folder+"/TurmasDoProfessor.qml", {"root_folder":configJson.root_folder});
    }
}
