import QtQuick 2.8
import QtQuick.Controls 2.1

import "../../qml/components/"

BasePage {
    id: page
    title: qsTr("My courses")
    objectName: title
    toolBarState: "goback"
    listViewDelegate: pageDelegate
    onUpdatePage: request();
    firstText: qsTr("Warning! No courses sections found!")

    property string root_folder: ""

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
        requestHttp.load("teachers_course_sections/" + userProfileData.id, requestCallback);
    }

    Component.onCompleted: request();

    Component {
        id: pageDelegate

        ListItem {
            id: wrapper
            badgeRadius: 0
            showSeparator: true
            badgeText: course_section_period
            primaryLabelText: code + ""
            secondaryLabelText: name + ""
            onClicked: pushPage(root_folder+"/RealizarChamada.qml", {"root_folder":root_folder,"section_times_id":course.id,"course_section_id":id});
        }
    }
}
