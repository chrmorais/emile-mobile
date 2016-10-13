import QtQuick 2.7
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.0
//import QMob.Meg 1.0 as Meg

ApplicationWindow {
    visible: true
    width: 640
    height: 480
    title: qsTr("Hello World")

    JSONListModel {
        id: jsonListModel
        requestMethod: "POST"
    }

    StackView {
        id: stackView
        anchors.fill: parent

        initialItem: ListView {
            model: crudModel
            anchors.centerIn: parent
            delegate: Rectangle {
                width: parent.width / 2
                height: 30
                anchors.horizontalCenter: parent.horizontalCenter

                Rectangle {
                    width: modelName.width
                    height: modelName.height
                    color: "#fff"

                    Text {
                        id: modelName
                        text: modelData.name
                        font.pointSize: 25

                        MouseArea {
                            anchors.fill: parent
                            onClicked: {
                                var pageSource = "%1/%2".arg(modelData.root_folder).arg(modelData.main_qml)
                                stackView.push(Qt.resolvedUrl(pageSource), {"configJson":modelData})
                            }
                        }
                    }
                }
            }
        }
    }
}
