import QtQuick 2.7

import "../../qml/components/"

BasePage {
    id: page
    title: qsTr("My attendance")
    objectName: title
    listViewDelegate: pageDelegate
    onUpdatePage: request();
    firstText: qsTr("Warning! No attendance found!")

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
        requestHttp.load("students_course_sections/" + userProfileData.id, requestCallback);
    }

    Component.onCompleted: request();

    Component {
        id: pageDelegate

        ListItem {
            id: wrapper
            parent: listView.contentItem
            showSeparator: true
            badgeRadius: 0
            badgeText: course_section_period
            primaryLabelText: code + ""
            secondaryLabelText: name + ""
            onClicked: pushPage(configJson.root_folder+"/FaltasPorDisciplina.qml", {"title": "Attendance in " + primaryLabelText, "courseId": id})
        }
    }
}
