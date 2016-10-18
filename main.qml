import QtQuick 2.7
import QtQuick.Layouts 1.0
import QtQuick.Dialogs 1.2
import QtQuick.Controls 2.0
import QtQuick.Controls.Material 2.0

import "components/"
//import "components/AwesomeIcon/"

ApplicationWindow {
    id: window
    visible: true
    width: 380
    height: 580
    title: qsTr("Hello World")

    StackView {
        id: pageStack
        anchors.fill: parent
        initialItem: page

        Page {
            id: page
            anchors.fill: parent

            Column {
                anchors.centerIn: parent

                Button {
                    text: "Test the Toast"
                    anchors.horizontalCenter: parent.horizontalCenter
                    onClicked: toast.show(text)
                }

                Button {
                    text: "Test the Snackbar"
                    anchors.horizontalCenter: parent.horizontalCenter
                    onClicked: snackbar.show(text)
                }

                Button {
                    text: "Test the FontAwesome Icon"
                    anchors.horizontalCenter: parent.horizontalCenter
                    onClicked: awesomeIconDialog.open()
                }

                Button {
                    text: "Test the Material Icon"
                    anchors.horizontalCenter: parent.horizontalCenter
                    onClicked: materialIconDialog.open()
                }

                ListItem {
                    showSeparator: true
                    primaryLabelText: "Listem Item 1"
                    primaryImageIcon: Qt.createComponent("AwesomeIcon.qml").createObject(primaryAction,{"name":"bars","color":"red"})
                }

                ListItem {
                    showSeparator: true
                    primaryLabelText: "Listem Item 2"
                    secondaryLabelText: "With subtitle"
                    primaryImageIcon: Qt.createComponent("AwesomeIcon.qml").createObject(primaryAction,{"name":"camera","color":"black"})
                }

                ListItem {
                    showSeparator: true
                    primaryLabelText: "Listem Item 3"
                    secondaryLabelText: "With subtitle and two icons and actions"
                    primaryImageIcon: Qt.createComponent("AwesomeIcon.qml").createObject(primaryAction,{"name":"instagram","color":"blue"})
                    secondaryImageIcon: Qt.createComponent("AwesomeIcon.qml").createObject(secondaryAction,{"name":"arrows_v","color":"blue"})
                }
            }
        }
    }

    Dialog {
        id: awesomeIconDialog

        Row {
            spacing: 15

            AwesomeIcon {
                name: "bars"
                color: "red"
            }

            AwesomeIcon {
                name: "anchor"
                color: "blue"
            }

            AwesomeIcon {
                name: "graduation_cap"
                color: "black"
            }

            AwesomeIcon {
                name: "twitter"
                color: "#1dcaff"
            }

            AwesomeIcon {
                name: "android"
                color: "green"
            }
        }
    }

    Dialog {
        id: materialIconDialog

        Row {
            spacing: 15

            MaterialIcon {
                source: "action/3d_rotation"
                color: "black"
            }

            MaterialIcon {
                source: "communication/call"
                color: "blue"
            }

            MaterialIcon {
                source: "communication/vpn_key"
                color: "black"
            }

            MaterialIcon {
                source: "file/cloud_done"
                color: "green"
            }
        }
    }

    Snackbar {
        id: snackbar
        isAutoDestroy: false
    }

    Toast {
        id: toast
    }
}
