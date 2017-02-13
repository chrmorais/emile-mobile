.import "../../qml/js/Utils.js" as Util

// a list of actions to use with toolbar
var actionCalls = ({
    "delete": deleteFromList,
    "cancel": unSelectItems,
    "save": saveRemote
})

function exec(fn) {
    if (actionCalls.hasOwnProperty(fn))
        actionCalls[fn]();
}

function addSelectedItem(index, isItemSelected, ignoreIfSelected) {
    var arrayTemp = selectedIndex; // to fix binding with array

    // if item is already in the list, return to not add index again!
    if (ignoreIfSelected && arrayTemp.indexOf(index) !== -1)
        return;

    // if the item is selected and user pressAndHolder again,
    // the item will be deselect and removed from selectedIndex array
    if (!ignoreIfSelected && isItemSelected)
        arrayTemp.splice(arrayTemp.indexOf(index), 1);
    else
        arrayTemp.push(index);

    selectedIndex = arrayTemp;
}

function unSelectItems() {
    var arrayTemp = selectedIndex;
    for (var i = 0; i < arrayTemp.length; i++)
        listView.contentItem.children[selectedIndex[i]].selected = false;
    arrayTemp.splice(0, selectedIndex.length)
    selectedIndex = arrayTemp;
}

function deleteFromList() {
    // after each item is removed, qml reorder the list.
    // so, we needs to uses descending order
    selectedIndex = Util.reverseList(selectedIndex);
    for (var i = 0; i < selectedIndex.length; i++) {
        var userFromModel = jsonListModel.model.get(selectedIndex[i])
        httpRequest("delete_user/%1".arg(userFromModel.id), null, "POST")
        jsonListModel.model.remove(selectedIndex[i])
    }
    var fixBind = [];
    selectedIndex = fixBind;
}

function selectAll() {
    for (var i = 0; i < listView.count; ++i)
        addSelectedItem(i, listView.contentItem.children[i], true)
}

function httpRequest(path, args, method) {
    jsonListModel.debug = true
    jsonListModel.requestMethod = method || "GET"
    jsonListModel.contentType = "application/json";
    jsonListModel.requestParams = args ? JSON.stringify(args) : ""
    jsonListModel.source += path
    jsonListModel.load()
}

function saveLocal(fieldName, fieldValue) {
    fieldName = fieldName.toLowerCase().trim()
    var objectTemp = formData
    objectTemp[fieldName] = fieldValue
    formData = objectTemp
}

function saveRemote() {
    var path = "%1".arg(action === "edit" ? "update_user/"+userId : "add_user");
    httpRequest(path, formData, "POST");
    //toast.show("Saving...");
    pageFlickable.contentY = 0;
    pageStack.pop()
}
