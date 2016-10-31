import QtQuick 2.7
import QtQuick.Controls 2.0

import "../../qml/components/FormBuilder"
import "../../qml/components/" as AppComponents

Page {
    id: page
    title: "New Aluno"

    property var fields: [
        {"data_type":"string", "field_type":"textfield", "lenght":"150", "field_name":"username", "label":"Username", "value": "Enoque Joseneas"},
        {"data_type":"string", "field_type":"textarea", "lenght":"250", "field_name":"address", "label":"Address", "value": "Rua Oito de Dezembro, 350 ap 21"},
        {"data_type":"char", "field_type":"radio", "field_name":"sexo", "checked_option":"M", "checked_label":"Masculino", "options":[{"label":"Masculino","value":"M"},{"label":"Feminino","value":"F"},{"label":"Outro","value":"O"}], "label":"Sex"},
        {"data_type":"string", "field_type":"datepicker", "lenght":"10", "field_name":"data_nascimento", "label":"Birthday", "value": "04-21-1987"},
        {"data_type":"string", "field_type":"textfield", "lenght":"80", "field_name":"matricula", "label":"Matricula", "value": "2012116025"},
        {"data_type":"string", "field_type":"textfield", "lenght":"80", "field_name":"email", "label":"Email", "value": "enoquejoseneas@ifba.edu.br"}
    ]

    // the crud has 3 actions: create a new register, edit any register or view details
    // the action needs to be set in this property
    property string action: "view"

    // define a custom action button to display in toolbar
    property var customToolButtons: [
        ({"iconName": "save", "actionName": "save", "visible": true}),
        ({"iconName": "pencil", "actionName": "save", "visible": true})
    ]

    property string toolBarState

    property var toolBarActions: ["goback"]

    function loadDetails() {
        // fazer requisição para pegar os detalhes do aluno passando o ID
        // o resultado deve ser algo como o array "fields" acima,
        // com objetos contendo o nome, o tipo de dado, o tipo do campo e o valor e etc.
    }

    Connections {
        target: toolBar // is a alias to app header defined in Main.qml
        onActionExec: {
            if (actionName === "save") // implementar aqui o processo de salvar no banco local e no remoto
                console.log("formBuilder callback: " + JSON.stringify(formBuilder.formData))
        }
    }

    FormBuilder {
        id: formBuilder
        formJson: fields
        action: page.action
        onFormUpdate: console.log("data: " + JSON.stringify(data))
    }

    AppComponents.FloatingButton {
        visible: action === "view" || action === "edition"
        iconName: "pencil"
        onClicked: page.action = "edition"
    }
}
