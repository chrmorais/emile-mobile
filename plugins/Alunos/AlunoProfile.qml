import QtQuick 2.7
import QtQuick.Controls 2.0
import QtQuick.Controls.Material 2.0

import "../../qml/components/"
import "functions.js" as AlunoFunc
import "../../qml/js/Utils.js" as Util

BasePage {
    id: page
    title: qsTr("New Aluno")
    objectName: qsTr("Students")
    hasListView: false
    hasRemoteRequest: false
    toolBarState: "goback"
    toolBarActions: action === "newRegister" ? ["save"] : []

    property int userId
    property string action: "view"
    property var fieldsData
    property var formData: ({})
    property bool editable: action === "view" || action === "edit"

    // called by ToolBar on action click
    function actionExec(actionName) {
        AlunoFunc.exec(actionName)
        if (action !== "view" && action !== "edit")
            textFieldBirthdate.text = "";
    }

    onFieldsDataChanged: {
        if (fieldsData && fieldsData.email)
            pageFlickable.visible = true;
    }

    Component.onCompleted: {
        if (action !== "newRegister")
            AlunoFunc.httpRequest("user_details/"+userId, null, "GET");
    }

    Connections {
        target: window
        onPageChanged: fieldsData = "";
    }

    Connections {
        target: jsonListModel
        onStateChanged: {
            if (jsonListModel.state === "ready" && currentPage.title === page.title) {
                var fieldsDataTemp = jsonListModel.model.get(0);
                fieldsData = fieldsDataTemp;
                AlunoFunc.saveLocal("type", 1);
                AlunoFunc.saveLocal("program_id", fieldsData.program_id);
                AlunoFunc.saveLocal("password", fieldsData.password);
            }
        }
    }

    DatePicker {
        id: datePickerBirthdate
        onDateSelected: textFieldBirthdate.text = (date.month + "-" + date.day + "-" + date.year)
    }

    Flickable {
        id: pageFlickable
        visible: action === "newRegister"
        width: parent.width; height: parent.height
        contentHeight: Math.max(content.implicitHeight, height)
        anchors.horizontalCenter: parent.horizontalCenter

        Column {
            id: content
            width: parent.width * 0.80; height: parent.height
            anchors.horizontalCenter: parent.horizontalCenter
            spacing: 10; topPadding: 25; bottomPadding: 25

            Label {
                id: labelName
                text: "Name"
                color: appSettings.theme.defaultTextColor
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
                color: appSettings.theme.defaultTextColor
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
                color: appSettings.theme.defaultTextColor
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
                color: appSettings.theme.defaultTextColor
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
                    checked: action !== "newRegister" && fieldsData !== null && fieldsData !== undefined && fieldsData.gender === "M"
                    enabled: action !== "view"

                    ButtonGroup.group: radioOptionGroup

                    property string value: "M"
                }

                RadioButton {
                    text: "F"
                    width: parent.width / 3
                    checked: action !== "newRegister" && fieldsData !== null && fieldsData !== undefined && fieldsData.gender === "F"
                    enabled: action !== "view"

                    ButtonGroup.group: radioOptionGroup

                    property string value: "F"
                }

                RadioButton {
                    text: "Other"
                    width: parent.width / 3
                    checked: action !== "newRegister" && fieldsData !== null && fieldsData !== undefined && fieldsData.gender === "O"
                    enabled: action !== "view"

                    ButtonGroup.group: radioOptionGroup

                    property string value: "O"
                }
            }

            Label {
                id: labelBirthdate
                text: "Birthdate"
                color: appSettings.theme.defaultTextColor
            }

            TextField {
                id: textFieldBirthdate
                width: parent.width
                readOnly: action === "view"
                text: editable && fieldsData ? fieldsData.birth_date || "" : ""
                onTextChanged: AlunoFunc.saveLocal("birth_date", text)

                MouseArea { anchors.fill: parent; onClicked: action === "view" ? "" : datePickerBirthdate.open() }
            }

            Label {
                id: labelEmail
                text: "Email"
                color: appSettings.theme.defaultTextColor
            }

            TextField {
                width: parent.width
                readOnly: action === "view"
                text: editable && fieldsData ? fieldsData.email || "" : ""
                onTextChanged: AlunoFunc.saveLocal(labelEmail.text, text)
            }
        }
    }

    FloatingButton {
        id: actionFloatingButton
        iconName: "pencil"
        visible: !busyIndicator.visible && (action === "view" || action === "edit")
        onClicked: {
            var toolBarActionsTemp = ["save"];
            toolBarActions = toolBarActionsTemp;
            action = "edit"
            toast.z = parent.z + !
            toast.show("Edit enabled")
        }
    }
}
