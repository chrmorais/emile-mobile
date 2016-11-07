.import "../../qml/js/Utils.js" as Util

// a list of actions to use with toolbar
var actionCalls = ({
    "delete": deleteFromList,
    "cancel": unSelectItems,
    "save": saveRemote
})

function exec(fn) {
    if (actionCalls.hasOwnProperty(fn))
        actionCalls[fn]()
}

function addSelectedItem(index, item, ignoreIfSelected) {
    var arrayTemp = selectedIndex // to fix binding with array

    // if item is already in the list, return to not add index again!
    if (ignoreIfSelected && arrayTemp.indexOf(index) !== -1)
        return

    // if the item is selected and user pressAndHolder again,
    // the item will be deselect and removed from selectedIndex array
    if (!ignoreIfSelected && item.selected)
        arrayTemp.splice(arrayTemp.indexOf(index), 1)
    else
        arrayTemp.push(index)

    selectedIndex = arrayTemp
    item.selected = !ignoreIfSelected && item.selected ? false : true
}

function unSelectItems() {
    var arrayTemp = selectedIndex

    for (var i = 0; i < arrayTemp.length; i++)
        listView.contentItem.children[selectedIndex[i]].selected = false

    arrayTemp.splice(0, selectedIndex.length)
    selectedIndex = arrayTemp
}

function deleteFromList() {
    // after each item is removed, qml reorder the list.
    // so, we needs to uses descending order
    selectedIndex = Util.reverseList(selectedIndex)

    for (var i = 0; i < selectedIndex.length; i++)
        listModel.remove(selectedIndex[i])

    var fixBind = []
    selectedIndex = fixBind
}

function selectAll() {
    for (var i = 0; i < listView.count; ++i)
        addSelectedItem(i, listView.contentItem.children[i], true)
}

function httpRequest(url, args, method) {
    jsonListModel.debug = true
    jsonListModel.requestMethod = method || "GET"
    jsonListModel.source = url || "https://emile-server.herokuapp.com/users"
    jsonListModel.requestParams = args ? Util.serialize(args) : ""
    jsonListModel.load()
}

function saveLocal(fieldName, fieldValue) {
    fieldName = fieldName.toLowerCase().trim()
    var objectTemp = formData
    objectTemp[fieldName] = fieldValue
    formData = objectTemp
}

function saveRemote() {
    var url = "https://emile-server.herokuapp.com/%1".arg(action === "edit" ? "update_user/"+userId : "add_user")
    httpRequest(url, formData, "POST")
    toast.show("Saving...")
}
