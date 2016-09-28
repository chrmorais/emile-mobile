/* JSONListModel - a QML ListModel with JSON and JSONPath support
 *
 * Copyright (c) 2012 Romain Pokrzywka (KDAB) (romain@kdab.com)
 * Licensed under the MIT licence (http://opensource.org/licenses/mit-license.php)
 */

import QtQuick 2.0
import "../js/JsonPath.js" as JSONPath

Item {
    id: jsonlistmodel
    states: [
        State {
            name: "noconection"
            PropertyChanges { target: jsonlistmodel; message: "Could not connect to link remote! Check your internet connection and try again." }
        },
        State {
            name: "timeout"
            PropertyChanges { target: jsonlistmodel; message: "Request timed out. Try again!" }
        },
        State {
            name: "running"
            PropertyChanges { target: jsonlistmodel; message: "" }
        },
        State {
            name: "finished"
            PropertyChanges { target: jsonlistmodel; message: "" }
        }
    ]

    property int resultCode
    property var customHeaders: []

    property alias count: jsonModel.count
    property ListModel model : ListModel { id: jsonModel }

    property string json: ""
    property string query: ""
    property string message: ""

    property string baseUrl: ""
    property string baseImagesUrl: ""

    property string userServiceName: ""
    property string userServicePassword: ""

    property string requestParams: ""
    property string requestSource: ""
    property string requestType: "GET"
    property string requestContentType: "application/json"
    property string requestAuthorization: "Basic " + Qt.btoa("%1:%2".arg(userServiceName).arg(userServicePassword))

    signal error()

    onRequestSourceChanged: {
        var uri = ""
        var xhr = new XMLHttpRequest;

        xhr.open(requestType, requestSource.indexOf("http") === -1 ? baseUrl + requestSource : requestSource, true);
        xhr.setRequestHeader("Content-Type", requestContentType)

        xhr.onerror = function() {
            error()
            jsonlistmodel.state = "finished";
        }

        if (userServiceName && userServicePassword)
            xhr.setRequestHeader("Authorization", requestAuthorization)

        if (customHeaders.length > 0)
            for (var i = 0; i < customHeaders.length; i++)
                xhr.setRequestHeader(customHeaders[i].key, customHeaders[i].value)

        xhr.onreadystatechange = function() {
            resultCode = xhr.status;
            if (resultCode === 408) {
                error()
                jsonlistmodel.state = "timeout";
            }
            if (xhr.readyState === XMLHttpRequest.DONE) {
                json = xhr.responseText;
                jsonlistmodel.state = "finished";
            }
        }

        jsonlistmodel.state = "running"
        xhr.send(requestParams);
    }

    onJsonChanged: updateJSONModel()
    onQueryChanged: updateJSONModel()

    function updateJSONModel() {
        jsonModel.clear();
        if (!json) return;
        var objectArray = parseJSONString(json, query);
        if (objectArray.exception) {
            jsonModel.append(objectArray);
            return;
        } else {
            for (var key in objectArray)
                jsonModel.append(objectArray[key]);
        }
    }

    function parseJSONString(jsonString, jsonPathQuery) {
        var objectArray = {};
        try {
            objectArray = JSON.parse(jsonString);
        } catch(e) {
            objectArray = {"exception":"Parse json failed! The server send a invalid json!"};
        }
        if (jsonPathQuery !== "")
            objectArray = JSONPath.jsonPath(objectArray, jsonPathQuery);
        return objectArray;
    }
}
