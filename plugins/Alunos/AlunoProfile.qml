import QtQuick 2.7
import QtQuick.Controls 2.0
import QtQuick.Controls.Material 2.0

import "../../qml/js/Utils.js" as Util
import "../../qml/components/" as AppComponents

Page {
    id: page
    title: "New Aluno"

    // ({"email":"enoque@gmail.com", "indentifier":"2012121212", "name": "Enoque Joseneas", "birthdate": "04-21-1987", "gender": "M", "adress": "avenida Brasil, Pirajá, 25"})
    property var fieldsData

    // the user Id to load details
    property int userId

    // the crud has 3 actions: create a new register, edit any register or view details
    // the action needs to be set in this property
    property string action: "view"

    property string toolBarState: "goback"

    // a list of actions to display in ToolBar
    property var toolBarActions: [
        ({"action": "save", "iconName": "floppy_o", "when": "goback"})
    ]

    /**
     * a object wuth fields name:value - like this:
     * {"username":"enoque joseneas","email":"enoque@gmail.com"}
     * The values will be saved after any change or enter new characters in the field
     */
    property var formData: ({})

    // will be called by toolbar when user click in action
    function actionExec(actionName) {
        if (actionName === "save")
            saveRemote()
    }

    function request(url, args, method) {
        jsonListModel.debug = true
        jsonListModel.requestMethod = method
        jsonListModel.requestParams = args ? Util.serialize(args) : ""
        jsonListModel.source = url
        jsonListModel.load(args)
    }

    function save(fieldName, fieldValue) {
        fieldName = fieldName.toLowerCase().trim()
        var objectTemp = formData
        objectTemp[fieldName] = fieldValue
        formData = objectTemp
    }

    function saveRemote() {
        var url = "https://emile-server.herokuapp.com/%1".arg(action == "edit" ? "update_user/"+userId : "add_user")
        request(url, formData, "POST")
    }

    Component.onCompleted: {
        if (action !== "newRegister")
            request("https://emile-server.herokuapp.com/user_details/"+userId, null, "GET")
    }

    Connections {
        target: jsonListModel
        onStateChanged: {
            if (jsonListModel.state === "ready") {
                fieldsData = jsonListModel.model.get(0)
                pageContentLoader.active = true
            }
        }
    }

    Loader {
        id: pageContentLoader
        active: action == "newRegister"
        sourceComponent: dynamicFlickable
        asynchronous: true
    }

    BusyIndicator {
        id: loading
        anchors.centerIn: parent
        visible: !pageContentLoader.active
    }

    Component {
        id: dynamicFlickable

        Flickable {
            id: pageFlickable
            width: page.width
            height: page.height
            contentHeight: Math.max(content.implicitHeight, height)
            anchors.horizontalCenter: page.horizontalCenter
            boundsBehavior: Flickable.StopAtBounds

            Column {
                id: content
                width: parent.width * 0.80
                height: parent.height
                spacing: 20
                anchors.horizontalCenter: parent.horizontalCenter
                topPadding: 25
                bottomPadding: 25

                Label {
                    id: labelName
                    text: "Name"
                }

                TextField {
                    width: parent.width
                    text: action === "view" || action === "edit" ? fieldsData.name : ""
                    readOnly: action === "view"
                    onTextChanged: save(labelName.text, text)
                }

                Label {
                    id: labelUsername
                    text: "Username"
                }

                TextField {
                    width: parent.width
                    text: action === "view" || action === "edit" ? fieldsData.username : ""
                    readOnly: action === "view"
                    onTextChanged: save(labelUsername.text, text)
                }

                Label {
                    id: labelAdress
                    text: "Adress"
                }

                TextArea {
                    width: parent.width
                    wrapMode: TextEdit.WrapAnywhere
                    text: action === "view" || action === "edit" ? fieldsData.address : ""
                    readOnly: action === "view"
                    onTextChanged: save(labelAdress.text, text)
                }

                Label {
                    id: labelGender
                    text: "Gender"
                }

                Row {
                    width: parent.width

                    ButtonGroup {
                        id: radioOptionGroup
                        onCheckedButtonChanged: save(labelGender.text, radioOptionGroup.checkedButton.value)
                    }

                    RadioButton {
                        text: "M"
                        width: parent.width / 3
                        checked: action !== "newRegister" && fieldsData.gender === "M"
                        enabled: action === "view" ? false : true

                        ButtonGroup.group: radioOptionGroup

                        property string value: "M"
                    }

                    RadioButton {
                        text: "F"
                        width: parent.width / 3
                        checked: action !== "newRegister" && fieldsData.gender === "F"
                        enabled: action === "view" ? false : true

                        ButtonGroup.group: radioOptionGroup

                        property string value: "F"
                    }

                    RadioButton {
                        text: "Other"
                        width: parent.width / 3
                        checked: action !== "newRegister" && fieldsData.gender === "O"
                        enabled: action === "view" ? false : true

                        ButtonGroup.group: radioOptionGroup

                        property string value: "O"
                    }
                }

                Label {
                    id: labelBirthdate
                    text: "Birthdate"
                }

                AppComponents.DateChooser {
                    width: parent.width
                    valueSelected: action === "view" || action === "edit" ? fieldsData.birth_date : ""
                    enabled: action !== "view"
                    onDateChooserChanged: save("birth_date", dateChooser)
                }

                Label {
                    id: labelIdentifier
                    text: "Identifier"
                }

                TextField {
                    width: parent.width
                    text: action === "view" || action === "edit" ? (fieldsData.indentifier || "") : ""
                    readOnly: action === "view"
                    onTextChanged: save(labelAdress.text, text)
                }

                Label {
                    id: labelEmail
                    text: "Email"
                }

                TextField {
                    width: parent.width
                    readOnly: action === "view"
                    text: action === "view" || action === "edit" ? fieldsData.email : ""
                    onTextChanged: save(labelEmail.text, text)
                }
            }
        }
    }

    AppComponents.FloatingButton {
        id: actionFloatingButton
        iconName: "pencil"
        onClicked: action = "edit"
        visible: action === "view" || action === "edit"
    }
}
