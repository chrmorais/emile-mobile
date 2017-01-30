import QtQuick 2.7
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.0
import QtQuick.Controls.Material 2.0

import "../../qml/components/" as AppComponents
import "../../qml/components/AwesomeIcon/" as AwesomeIcon

Page {
    id: page
    title: qsTr("Wall messages")

    property var json: []

    function request() {
        for (var i = 0; i < json.length; ++i)
            model.append(json[i]);
    }

    Component.onCompleted: {
        json = [
            {
                "message": "Lorem Ipsum é simplesmente uma simulação de texto da indústria tipográfica e de impressos, e vem sendo utilizado desde o século XVI, quando um impressor desconhecido pegou uma bandeja de tipos e os embaralhou para fazer um livro de modelos de tipos.",
                "author": "Marcos Silva",
                "date": "21-04-2017"
            },
            {
                "message": "É um fato conhecido de todos que um leitor se distrairá com o conteúdo de texto legível de uma página quando estiver examinando sua diagramação. A vantagem de usar Lorem Ipsum é que ele tem uma distribuição normal de letras.",
                "author": "João Pedro",
                "date": "21-04-2017"
            },
            {
                "message": "O trecho padrão original de Lorem Ipsum, usado desde o século XVI, está reproduzido abaixo para os interessados.",
                "author": "Maria José",
                "date": "21-04-2017"
            },
            {
                "message": "Pessoal, não teremos aula hoje de ADM201. Marcaremos resposição posteriormente.",
                "author": "João Pedro",
                "date": "21-04-2017"
            },
            {
                "message": "Aula de Lab3 será na sala 401 do pavilhão O. Lembrem-se de levar o livro de ADM900.",
                "author": "Marcos Brasil",
                "date": "21-04-2017"
            },
            {
                "message": "Prezados alunos de ENG806, a visita técnica a Petrobrás foi adiada para semana que vem. Conversaremos amanhã mais detalhes. Aos interessados favor não faltar a aula.",
                "author": "Joaquim Ferreia",
                "date": "21-04-2017"
            },
            {
                "message": "É um fato conhecido de todos que um leitor se distrairá com o conteúdo de texto legível de uma página quando estiver examinando sua diagramação. A vantagem de usar Lorem Ipsum é que ele tem uma distribuição normal de letras.",
                "author": "Juliana Macedo-",
                "date": "21-04-2017"
            },
            {
                "message": "Olá turma! Só para lembrar vocês, amanhã teremos prova de ADM301, em dupla e ",
                "author": "Carla Maria",
                "date": "19-04-2017"
            }
        ]
    }

    BusyIndicator {
        id: busyIndicator
        anchors.centerIn: parent
        visible: jsonListModel.state === "loading"
    }

    AppComponents.EmptyList {
        z: listView.z + 1
        visible: listView.count === 0 && !busyIndicator.visible
        onClicked: request();
    }

    Component {
        id: listViewDelegate

        Rectangle {
            id: delegate
            color: "#fff799"; radius: 4
            anchors.horizontalCenter: parent.horizontalCenter
            width: parent.width * 0.95; height: columnLayoutDelegate.height

            Pane {
                z: parent.z-10
                width: parent.width; height: parent.height
                Material.elevation: 3
            }

            ColumnLayout {
                id: columnLayoutDelegate
                spacing: 15
                width: parent.width

                Row {
                    spacing: 4
                    anchors { top: parent.top; topMargin: 5; left: parent.left; leftMargin: 10 }

                    AwesomeIcon.AwesomeIcon {
                        size: 12; name: "commenting"; color: authorLabel.color
                    }

                    Label {
                        id: authorLabel
                        text: author; color: "#444"
                    }
                }

                Item {
                    Layout.fillWidth: true
                    height: labelMessage.implicitHeight; implicitHeight: height

                    Label {
                        id: labelMessage
                        text: message
                        width: parent.width * 0.95
                        wrapMode: Text.Wrap
                        font.wordSpacing: 1
                        color: "#333"
                        anchors { right: parent.right; left: parent.left; margins: 10 }
                    }
                }

                Row {
                    spacing: 4
                    anchors { bottom: parent.bottom; bottomMargin: 5; left: parent.left; leftMargin: 10 }

                    AwesomeIcon.AwesomeIcon {
                        size: 12; name: "clock_o"; color: dateLabel.color
                    }

                    Label {
                        id: dateLabel
                        color: "#777"
                        text: date
                    }
                }
            }
        }
    }

    ListView {
        id: listView
        spacing: 7
        model: ListModel { id: model }
        focus: true; cacheBuffer: width
        topMargin: 10; bottomMargin: 10
        width: page.width; height: page.height
        delegate: listViewDelegate
        Keys.onUpPressed: scrollBar.decrease()
        Keys.onDownPressed: scrollBar.increase()
        ScrollBar.vertical: ScrollBar { id: scrollBar }
    }
}
