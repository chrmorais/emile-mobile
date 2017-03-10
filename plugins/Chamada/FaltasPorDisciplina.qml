import QtQuick 2.8
import QtQuick.Controls 2.1

import "../../qml/components/"
import "../../qml/js/Utils.js" as Util

BasePage {
    id: page
    title: qsTr("My attendance")
    objectName: title
    listViewDelegate: pageDelegate

    property int courseId: 0
    property string toolBarState: "goback"

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
        requestHttp.load("students_attendance/" + courseId + "/" + userProfileData.id, requestCallback);
    }

    Component.onCompleted: request();

    Component {
        id: pageDelegate

        ListItem {
            id: wrapper
            parent: listView.contentItem
            showSeparator: true
            primaryLabelText: typeof section_time_date !== "undefined" ? section_time_date : ""
            badgeText: typeof status !== "undefined" ? status : ""
            badgeBackgroundColor: typeof status !== "undefined" ? status === "F" ? "red" : "blue" : ""
        }
    }
}
