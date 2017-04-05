.pragma library

.import QtQuick 2.8 as QtQuick

/**
 * print messages in console to display debug informations - used in http requests
 * @param  {string} funcName   the function name
 * @param  {integer} status    the current status
 * @param  {object} jsonObject the json result
 * @return {void}
 */
function debugme(funcName, status, jsonObject) {
    console.log("-------")
    console.log("debugme(...) ->")
    console.log("funcName: " + funcName + "() {...}")
    console.log("status:")
    console.log(status)
    console.log("jsonObject:")
    console.log(JSON.stringify(jsonObject))
    console.log("-------")
}

function sortArrayByObjectKey(key) {
    var sortOrder = 1;
    if (key[0] === "-") {
        sortOrder = -1;
        key = key.substr(1);
    }
    return function (a,b) {
        var result = (a[key] < b[key]) ? -1 : (a[key] > b[key]) ? 1 : 0;
        return result * sortOrder;
    }
}

/**
 * iterate a list to order values in reverse mode - Numeric values only
 * @param {array} list a javascript array to sort the list
 * @return array the list sorted by values
 */
function reverseList(list) {
    var arrayTemp = list

    arrayTemp.sort(function (a,b) {
        return b - a
    });

    return arrayTemp;
}

/**
 * iterate a object for search the value for key set in keyName param
 * @param {object} object a qml object to find value
 * @param {string} keyName the name of the key to find into object param
 * @return string the value for keyName if found, otherwise a empty string
 */
function getObjectValueByKey(object, keyName) {
    if (!keyName)
        return ""
    for (var item in object) {
        if (keyName && object.hasOwnProperty(keyName))
            return object[keyName] !== undefined ? object[keyName] : ""
    }
    return ""
}

/**
 * get the current timestamp
 * @return {integer}
 */
function getTimestamp() {
    return Math.floor(new Date().getTime() / 1000)
}

/**
 * generate and return a random number using size as size limiter
 * @param  {integer} option the size limit to generate the nonce
 * @return {integer}
 */
function getNonce(size) {
    var code = ""
    if (!size)
        size = 20
    for (var i = 0; i < size; i++)
        code += Math.floor(Math.random() * 9).toString()
    return code
}

/**
 * search in parent component for object obj
 * @param  {object} obj the object to start the search
 * @return QML object the last object parent founded
 */
function findRoot(obj) {
    while (obj.parent)
        obj = obj.parent
    return obj
}

/**
 * search in Object(obj) component for objectName child
 * @param  {object} obj the object to start the search
 * @param  {string} objectName the name of the object to search
 * @return QML object if is found null otherwise
 */
function findRootChild(obj, objectName) {
    var root = findRoot(obj)
    return findChild(root,objectName)
}

/**
 * search in Object(obj) component for objectName child
 * @param  {object} obj the object to start the search
 * @param  {string} objectName the name of the object to search
 * @return QML object if is found null otherwise
 */
function findChild(obj,objectName) {
    var childs = new Array(0)
    childs.push(obj)
    while (childs.length > 0) {
        if (childs[0].objectName === objectName)
            return childs[0]
        for (var i in childs[0].data)
            childs.push(childs[0].data[i])
        childs.splice(0,1)
    }
    return null
}

/**
 * iterate a array and applying a filter for each item from the list using filter param as callback
 * @param  {[type]} list   the list to iterate to filter
 * @param  {Function} filter the callback function to check or validate data into each item from the the list
 * @return {array}
 */
function filter(list, filter) {
    var filtered = []
    forEach(list, function(item) {
        if (filter(item))
            filtered.push(item)
    })
    return filtered
}

/**
 * foreach loop iterator for javascript array|list implementation
 * @param  {array}   list     [description]
 * @param  {Function} callback [description]
 * @return {void}
 */
function forEach(list, callback) {
    var listLength = length(list)
    for (var i = 0; i < listLength; i++) {
        var item = getItem(list,i)
        callback(item)
    }
}

/**
 * get a item model data from QML ListModel (or List property) using index for retrieve
 * @param  {object} model QML Object
 * @param  {integer} index the index value
 * @return {object} QML Object
 */
function getItem(model, index) {
    var item = model.get ? model.get(index) : model[index]
    if (model.get && item.modelData)
        item = item.modelData
    return item
}

/**
 * sanitize a string removing all special chars except numbers and letters
 * @param  {string} str       the string to sanitize
 * @param  {string} replaceBy the character to join the strings from str
 * @return {string}
 */
function sanitizeString(str, replaceBy) {
    if (!replaceBy)
        replaceBy = '_'
    return str.replace(/[^a-zA-Z0-9]/g, replaceBy);
}

/**
 * serialize a object using delimiter to join the all pieces.
 * A string will be returned at the end
 * @param  {object} obj       [description]
 * @param  {string} delimeter [description]
 * @return {string}
 */
function serialize(obj, delimeter) {
    var str = [];
        if (!delimeter) delimeter = '&';
        for (var key in obj) {
            switch (typeof obj[key]) {
                case 'string':
                case 'number':
                    str[str.length] = key + '=' + obj[key];
                break;
                case 'object':
                    str[str.length] = serialize(obj[key], delimeter);
            }
        }
        return str.join(delimeter);
}

/**
 * capitalize words
 * @param  {string} string the string to capitalize all words
 * @return {string}
 */
function capitalizeWords(string) {
    string = string.toLowercase()
    var pieces = string.split(" ");
    for (var i = 0; i < pieces.length; i++) {
        if (pieces[i].length > 2) {
            var j = pieces[i].charAt(0).toUpperCase()
            pieces[i] = j + pieces[i].substr(1)
        }
    }
    return pieces.join(" ")
}

/**
 * capitalize and return the all first letter of string
 * @param  {string} string
 * @return {string}
 */
function capitalizeFirstLetter(string) {
    return string.replace(/^./, string[0].toUpperCase())
}

/**
 * strip a string using start and length to delimiters
 * @param  {string} str    the strig to strip
 * @param  {integer} start  the index to start strip
 * @param  {integer} length the index limiter of strip
 * @return {string}
 */
function stripStr(str, start, length) {
    if(!str) return ""
    if (str.length < length)
        return str
    return str.substring(start, length) + "..."
}

/**
 * create a qml component and return if is not asynchronous(incubated).
 * If is incubated is true or != zero, the component creation will be asynchronous and
 * incubatedCallback parameter will be called after component is Ready
 * @link http://doc.qt.io/qt-5/qml-qtqml-component.html
 * @param  {string} path              [description]
 * @param  {string} parent            [description]
 * @param  {object} args              [description]
 * @param  {bool|int} incubated       [description]
 * @param  {callback} incubatedCallback a function to execute when component is created - for Asynchronous object creation
 * @return {QML Object}
 */
function createComponent(path, parent, args, incubated, incubatedCallback) {
    path = path.indexOf(".qml") === -1 ? path + ".qml" : path
    var component = Qt.createComponent(Qt.resolvedUrl(path))
    if (component.status === QtQuick.Component.Ready) { // if component exists and is ok
        if (!incubated) {
            return component.createObject(parent, args)
        } else {
            var incubator = component.incubateObject(parent, args)
            if (incubator.status !== QtQuick.Component.Ready) {
                incubator.onStatusChanged = function(status) {
                    if (status === QtQuick.Component.Ready)
                        incubatedCallback(incubator.object)
                }
            } else {
                incubatedCallback(incubator.object)
            }
        }
    } else if (component.status === QtQuick.Component.Error) {
        console.log("Error loading component: " + component.errorString());
    }
    return null
}

/**
 * validate a string checkin if is valid email address
 * @param  {string}  strValue the email to check
 * @return {Boolean}
 */
function isValidEmail(strValue) {
    var objRegExp  = /^(([^<>()\[\]\\.,;:\s@"]+(\.[^<>()\[\]\\.,;:\s@"]+)*)|(".+"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/
    return objRegExp.test(strValue)
}
