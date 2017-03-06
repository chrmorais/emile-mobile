import QtQuick 2.7
import QtQuick.Controls 2.0

import "../../qml/components/"

BasePage {
    id: page
    title: qsTr("My courses")
    objectName: title
    toolBarState: "goback"
    listViewDelegate: pageDelegate
    onUpdatePage: request();

    property string root_folder: {}

    function request() {
        jsonListModel.source += "teachers_course_sections/" + userProfileData.id;
        jsonListModel.load(function(response, status) {
            if (status !== 200)
                return;
            var i = 0;
            if (listViewModel && listViewModel.count > 0)
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
            showSeparator: true
            badgeRadius: 0
            badgeText: course_section_period
            primaryLabelText: code + ""
            secondaryLabelText: name + ""
            onClicked: pushPage(root_folder+"/RealizarChamada.qml", {"section_times_id": course.id, "course_section_id": id});
        }
    }
}
