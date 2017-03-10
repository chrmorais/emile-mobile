import QtQuick 2.8
import QtQuick.Controls 2.1

import "../../qml/components/"

BasePage {
    id: page
    title: qsTr("Course Sections")
    objectName: title
    toolBarState: "goback"
    listViewDelegate: pageDelegate
    onUpdatePage: request();

    property string destination
    property int userTypeDestinationId

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
        requestHttp.load(destination, requestCallback);
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
            onClicked: pushPage(configJson.root_folder + "/SendMessage.qml", {"userTypeDestinationId": userTypeDestinationId, "parameter": id});
        }
    }
}
