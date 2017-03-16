import QtQuick 2.8

Item {
    id: rootItem
    state: "null"
    states: [
        State {name: "null"},
        State {name: "ready"},
        State {name: "error"},
        State {name: "loading"}
    ]

    property int httpStatus: 0
    property bool debug: false
    property string source: ""
    property string requestParams: ""

    function load(path, callback, method, contentType, params) {
        var url = source + path;
        var xhr = new XMLHttpRequest();
        if (!method)
            method = "GET";
        if (method === "GET" && requestParams && !params)
            url += "?" + requestParams;
        xhr.open(method, url, true);
        xhr.setRequestHeader("Content-type", "application/json");
        xhr.onerror = function() {
            rootItem.errorString = qsTr("Cannot connect to server!");
            rootItem.state = "error";
        };
        xhr.onreadystatechange = function() {
            if (xhr.readyState === XMLHttpRequest.DONE) {
                rootItem.httpStatus = parseInt(xhr.status);
                if (debug) {
                    console.log("url: " + url);
                    console.log("xhr.status: " + rootItem.httpStatus);
                    console.log("xhr.responseText: " + xhr.responseText);
                }
                if (callback) {
                    rootItem.state = "ready";
                    rootItem.requestParams = "";
                    try {
                        callback(rootItem.httpStatus, JSON.parse(xhr.responseText));
                    } catch(e) {
                        callback(rootItem.httpStatus, {});
                    }
                }
            }
        };
        xhr.send(params ? params : requestParams);
        rootItem.state = "loading";
    }
}
