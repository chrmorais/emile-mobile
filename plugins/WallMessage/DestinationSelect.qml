import QtQuick 2.7
import QtQuick.Controls 2.0

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

    function request() {
        jsonListModel.source += destination
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
            // parent: listView.contentItem
            showSeparator: true
            badgeText: id !== undefined ? id : ""
            primaryLabelText: name + ""
            secondaryLabelText: code + ""
            onClicked: pushPage(configJson.root_folder + "/SendMessage.qml", {"userTypeDestinationId": userTypeDestinationId, "parameter": id});
        }
    }
}
