import QtQuick 2.7
import QtQuick.Controls 2.0

import "../../qml/components/"

BasePage {
    id: page
    title: qsTr("Send to:")
    objectName: title
    toolBarState: "goback"
    listViewDelegate: pageDelegate
    onUpdatePage: request();

    function request() {
        jsonListModel.source += "destinations_by_user_type/" + 2
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
            badgeText: id
            primaryLabelText: name + ""
            secondaryLabelText: ""
            onClicked: {
                var id = listViewModel.get(index).id;
                var destination = listViewModel.get(index).param_values_service;
                if (destination.indexOf("<%users%>") > -1) {
                    pushPage(configJson.root_folder+"/SendMessage.qml", {"userTypeDestinationId": id, "parameter": window.userProfileData.id});
                } else {
                    destination = destination.replace("$", "") + window.userProfileData.id;
                    pushPage(configJson.root_folder+"/DestinationSelect.qml", {"userTypeDestinationId": id, "configJson": configJson, "destination": destination});
                }
            }
        }
    }
}
