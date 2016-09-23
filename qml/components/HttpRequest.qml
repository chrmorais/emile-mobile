import QtQuick 2.6

Item {
    objectName: "HttpRequest"

    property int debug: 1
    property var customHeaders: []
    property int withCredentials: 0

    property string userServiceName: ""
    property string userServicePassword: ""
    property string requestContentType: "application/json"

    readonly property string baseUrl: "https://emile-server.herokuapp.com/"
    readonly property string baseImagesUrl: "https://emile-server.herokuapp.com/media/"
    readonly property string requestAuthorization: "Basic " + Qt.btoa("%1:%2".arg(userServiceName).arg(userServicePassword))

    signal noConection()
    signal requestFinish()
    signal requestStopped()
    signal requestRunning()
    signal requestTimeout(var requestType, var requestPath, var dataToSend, var callback)

    Timer {
        id: requestTimmer
        interval: 30000
    }

    onRequestStopped: {
        resetVars()
    }
    onRequestRunning: {
        requestTimmer.running = true
    }
    onRequestFinish: {
        resetVars()
    }

    function resetVars() {
        customHeaders = []
        withCredentials = 0
        requestTimmer.running = false
    }

    function debugRequest(e,o) {
        if (debug) {
            console.log("exception error:")
            console.log(e)
            console.log(JSON.stringify(o))
        }
    }

    function request(requestType, requestPath, dataToSend, callback) {
        requestRunning() //signal
        var xhr = new XMLHttpRequest()

        if (requestPath.indexOf("http") === -1) // if is external request
            requestPath = baseUrl + requestPath

        xhr.open(requestType, requestPath, true)

        xhr.onerror = function() {
            requestFinish() //signal
        }

        requestTimmer.triggered.connect(function() {
            xhr.abort()
            requestFinish() //signal
            requestTimeout(requestType, requestPath, dataToSend || 0, callback) //signal
        })

        xhr.onreadystatechange = function() {
            if (xhr.readyState === XMLHttpRequest.DONE) {
                requestFinish() //signal

                if (xhr.status === 0) {
                    noConection() //signal
                    return
                }

                try {
                    callback(JSON.parse(xhr.responseText), parseInt(xhr.status))
                } catch(e) {
                    debugRequest(e, {
                         "requestType ": requestType,
                         "requestPath ": requestPath,
                         "xhr responseText": xhr.responseText,
                         "xhr.status": xhr.status
                     })
                    callback(null, 0)
                }
            }
        }
        
        xhr.setRequestHeader("Content-Type", requestContentType)

        if (userServiceName && userServicePassword)
            xhr.setRequestHeader("Authorization", requestAuthorization)

        if (customHeaders.length > 0)
            for (var i = 0; i < customHeaders.length; i++)
                xhr.setRequestHeader(customHeaders[i].key, customHeaders[i].value)

        xhr.withCredentials = (withCredentials === 1)
        xhr.send(dataToSend)
    }
    
    function put(path, dataToSend, callback) {
        request("PUT", path, dataToSend || 0, callback)
    }
    
    function get(path, dataToSend, callback) {
        request("GET", path, dataToSend || 0, callback)
    }
    
    function post(path, dataToSend, callback) {
        request("POST", path, dataToSend || 0, callback)
    }
}
