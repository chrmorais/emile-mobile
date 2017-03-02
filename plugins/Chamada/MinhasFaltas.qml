import QtQuick 2.7

import "../../qml/components/"

BasePage {
    id: page
    title: qsTr("My attendance")
    objectName: title
    listViewDelegate: pageDelegate
    onUpdatePage: request();

    function request() {
        jsonListModel.source += "students_course_sections/" + userProfileData.id;
        jsonListModel.load(function(result, status) {
            if (status !== 200)
                return;
            var i = 0;
            if (listViewModel && listViewModel.count > 0)
                listViewModel.clear();
            for (var prop in result) {
                while (i < result[prop].length)
                    listViewModel.append(result[prop][i++]);
            }
        });
    }

    Component.onCompleted: request();

    Component {
        id: pageDelegate

        ListItem {
            id: wrapper
            parent: listView.contentItem
            showSeparator: true
            badgeText: course.id
            primaryLabelText: name + ""
            secondaryLabelText: code + ""
            onClicked: pushPage(configJson.root_folder+"/FaltasPorDisciplina.qml", {"title": "Attendance in " + primaryLabelText, "courseId": id})
        }
    }
}
