import QtQuick 2.7
import QtQuick.Controls 2.0
import QtQuick.Controls.Material 2.0

import "functions.js" as AlunoFunc
import "../../qml/js/Utils.js" as Util
import "../../qml/components/" as AppComponents

Page {
    id: page
    title: "New Aluno"
    objectName: ""

    property int userId

    property string action: "view"
    property string toolBarState: "goback"

    property var fieldsData
    property var formData: ({})
    property var toolBarActions: ["save"]

    property bool editable: action === "view" || action === "edit"

    // called by ToolBar on action click
    function actionExec(actionName) {
        AlunoFunc.exec(actionName)
    }

    onFieldsDataChanged: {
        if (fieldsData && fieldsData.email)
            pageFlickable.visible = true
    }

    Component.onCompleted: {
        fieldsData = Qt.binding(function() { return jsonListModel.model.get(0) })
        if (action !== "newRegister")
            AlunoFunc.httpRequest("/user_details/"+userId, null, "GET")
    }

    AppComponents.Toast {
        id: toast
    }

    BusyIndicator {
        id: loading
        anchors.centerIn: parent
        visible: !pageFlickable.visible || jsonListModel.state === "loading"
    }

    Flickable {
        id: pageFlickable
        visible: action === "newRegister"
        width: parent.width
        height: parent.height
        contentHeight: Math.max(content.implicitHeight, height)
        anchors.horizontalCenter: parent.horizontalCenter

        Column {
            id: content
            width: parent.width * 0.80
            height: parent.height
            spacing: 10
            anchors.horizontalCenter: parent.horizontalCenter
            topPadding: 25
            bottomPadding: 25

            Label {
                id: labelName
                text: "Name"
            }

            TextField {
                width: parent.width
                text: editable && fieldsData ? fieldsData.name || "" : ""
                readOnly: action === "view"
                onTextChanged: AlunoFunc.saveLocal(labelName.text, text)
            }

            Label {
                id: labelUsername
                text: "Username"
            }

            TextField {
                width: parent.width
                text: editable && fieldsData ? fieldsData.username || "" : ""
                readOnly: action === "view"
                onTextChanged: AlunoFunc.saveLocal(labelUsername.text, text)
            }

            Label {
                id: labelAddress
                text: "Address"
            }

            TextArea {
                width: parent.width
                wrapMode: TextEdit.WrapAnywhere
                text: editable && fieldsData ? fieldsData.address || "" : ""
                readOnly: action === "view"
                onTextChanged: AlunoFunc.saveLocal(labelAddress.text, text)
            }

            Label {
                id: labelGender
                text: "Gender"
            }

            Row {
                width: parent.width

                ButtonGroup {
                    id: radioOptionGroup
                    onCheckedButtonChanged: AlunoFunc.saveLocal(labelGender.text, radioOptionGroup.checkedButton.value)
                }

                RadioButton {
                    text: "M"
                    width: parent.width / 3
                    checked: action !== "newRegister" && fieldsData && fieldsData.gender === "M"
                    enabled: action === "view" ? false : true

                    ButtonGroup.group: radioOptionGroup

                    property string value: "M"
                }

                RadioButton {
                    text: "F"
                    width: parent.width / 3
                    checked: action !== "newRegister" && fieldsData && fieldsData.gender === "F"
                    enabled: action === "view" ? false : true

                    ButtonGroup.group: radioOptionGroup

                    property string value: "F"
                }

                RadioButton {
                    text: "Other"
                    width: parent.width / 3
                    checked: action !== "newRegister" && fieldsData && fieldsData.gender === "O"
                    enabled: action === "view" ? false : true

                    ButtonGroup.group: radioOptionGroup

                    property string value: "O"
                }
            }

            Label {
                id: labelBirthdate
                text: "Birthdate"
            }

            TextField {
                id: textFieldBirthdate
                width: parent.width
                readOnly: action === "view"
                text: editable && fieldsData ? fieldsData.birth_date || "" : ""
                onTextChanged: AlunoFunc.saveLocal("birth_date", textFieldBirthdate.text)

                MouseArea { anchors.fill: parent; onClicked: datePickerBirthdate.open() }
            }

            AppComponents.DatePicker {
                id: datePickerBirthdate
                onDateSelected: textFieldBirthdate.text = (data.month + "-" + data.day + "-" + data.year)
            }

            Label {
                id: labelEmail
                text: "Email"
            }

            TextField {
                width: parent.width
                readOnly: action === "view"
                text: editable && fieldsData ? fieldsData.email || "" : ""
                onTextChanged: AlunoFunc.saveLocal(labelEmail.text, text)
            }
        }
    }

    AppComponents.FloatingButton {
        id: actionFloatingButton
        iconName: "pencil"
        onClicked: action = "edit"
        visible: !loading.visible && (action === "view" || action === "edit")
    }
}
