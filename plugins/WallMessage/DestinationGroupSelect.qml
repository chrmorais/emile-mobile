import QtQuick 2.8
import QtQuick.Controls 2.1

import "../../qml/components/"

BasePage {
    id: page
    title: qsTr("Send to:")
    objectName: title
    listViewDelegate: pageDelegate
    onUpdatePage: request();

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
        requestHttp.load("destinations_by_user_type/" + userProfileData.type.id, requestCallback);
    }

    Component.onCompleted: request();

    Component {
        id: pageDelegate

        ListItem {
            id: wrapper
            showSeparator: true
            primaryIconName: "thumb_tack"
            primaryIconColor: appSettings.theme.colorPrimary
            badgeBackgroundColor: "transparent"
            primaryLabelText: name + ""
            secondaryLabelText: ""
            onClicked: {
                var destination = listViewModel.get(index).param_values_service;
                var id = listViewModel.get(index).id;
                if(destination.indexOf("/programs") > -1) {
                    pushPage(configJson.root_folder+"/SendMessage.qml", {"userTypeDestinationId": id, "parameter": userProfileData.program_id.id});
                }
                else {
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
}
