import QtQuick 2.7
import QtQuick.Controls 2.0

import "../../qml/components/"

BasePage {
    id: page
    title: qsTr("My courses")
    objectName: title
    listViewDelegate: pageDelegate

    property string root_folder: {}
    property string toolBarState: "goback"

    onUpdatePage: request();

    function request() {
        jsonListModel.source += "teachers_course_sections/" + userProfileData.id;
        jsonListModel.load(function(response, status) {
            if (status !== 200)
                return;
            var i = 0;
            listViewModel.clear();
            for (var prop in response) {
                while (i < response[prop].length)
                   listViewModel.append(response[prop][i++]);
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
            badgeText: course !== undefined ? course.id : ""
            primaryLabelText: name + ""
            secondaryLabelText: code + ""
            onClicked: pushPage(root_folder+"/RealizarChamada.qml", {"section_times_id": course.id, "course_section_id": id});
        }
    }
}
