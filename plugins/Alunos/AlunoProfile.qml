import QtQuick 2.7
import QtQuick.Controls 2.0
import QtQuick.Controls.Material 2.0

//import "../../qml/components/FormBuilder"
import "../../qml/components/" as AppComponents

Page {
    id: page
    title: "New Aluno"

    // "email":"", "indentifier":"2012121212", "name": "Enoque Joseneas", "birthdate": "21-04-1987"
    property var fieldsData:({"email":"enoque@gmail.com", "indentifier":"2012121212", "name": "Enoque Joseneas", "birthdate": "04-21-1987", "gender": "M", "adress": "avenida Brasil, Pirajá, 25"})

    property int userId

    // the crud has 3 actions: create a new register, edit any register or view details
    // the action needs to be set in this property
    property string action: "view"

    property string toolBarState: "goback"

    // a list of actions to display in ToolBar
    property var toolBarActions: [
        ({"action": "save", "iconName": "floppy_o", "when": "normal"})
    ]

    function actionExec(actionName) {
        if (actionName === "save") // implementar aqui o processo de salvar no banco local e no remoto
            console.log("formBuilder callback: " + JSON.stringify(formBuilder.formData))
    }

    function loadDetails() {
        // fazer requisição para pegar os detalhes do aluno passando o ID
        // o resultado deve ser algo como o array "fields" acima,
        // com objetos contendo o nome e o valor
    }

    AppComponents.FloatingButton {
        visible: action === "view" || action === "edition"
        iconName: "pencil"
        onClicked: page.action = "edition"
    }

    Flickable {
        id: pageFlickable
        anchors.fill: parent
        contentHeight: Math.max(content.implicitHeight, height)
        boundsBehavior: Flickable.StopAtBounds

        Column {
            id: content
            width: parent.width * 0.90
            height: parent.height
            spacing: 20
            anchors.horizontalCenter: parent.horizontalCenter
            topPadding: 25
            bottomPadding: 25

            Label {
                id: labelNome
                text: "Name: "
            }

            TextField {
                id: nome
                width: parent.width
                text: action === "view" || action === "edit" ? fieldsData.name : ""
                readOnly: action === "view"
            }


            Label {
                id: labelEndereco
                text: "Adress: "
            }

            TextArea {
                id: endereco
                width: parent.width
                wrapMode: TextEdit.WrapAnywhere
                text: action === "view" || action === "edit" ? fieldsData.adress : ""
                readOnly: action === "view"
            }

            Label {
                id: labelBirthdate
                text: "Gender: "
            }

            Row {
                width: parent.width

                RadioButton {
                    text: "M"
                    width: parent.width / 3
                    checked: action !== "newRegister" && fieldsData.gender === "M" ? true : false
                    enabled: action === "view" ? false : true
                }

                RadioButton {
                    text: "F"
                    width: parent.width / 3
                    checked: action !== "newRegister" && fieldsData.gender === "F" ? true : false
                    enabled: action === "view" ? false : true
                }

                RadioButton {
                    text: "Other"
                    width: parent.width / 3
                    checked: action !== "newRegister" && fieldsData.gender === "Other" ? true : false
                    enabled: action === "view" ? false : true
                }
            }


            Label {
                id: labelNascimento
                text: "Birthdate: "
            }

            AppComponents.DateChooser {
                id: nascimento
                width: parent.width
                valueSelected: action === "view" || action === "edit" ? fieldsData.birthdate : ""
                enabled: action === "view" ? false : true
            }


            Label {
                id: labelMatricula
                text: "Identifier: "
            }

            TextField {
                id: matricula
                width: parent.width
                text: action === "view" || action === "edit" ? fieldsData.indentifier : ""
                readOnly: action === "view"
            }

            Label {
                id: labelEmail
                text: "Email: "
            }

            TextField {
                id: email
                width: parent.width
                readOnly: action === "view"
                text: action === "view" || action === "edit" ? fieldsData.email : ""
            }
        }
    }

    AppComponents.FloatingButton { }
}
