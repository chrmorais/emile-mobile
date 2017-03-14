import QtQuick 2.8
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.1
import QtQuick.Controls.Material 2.0

import "../../qml/components/"
import "../../qml/components/AwesomeIcon"
import "Functions.js" as RegisterFunctions

BasePage {
    id: page
    objectName: qsTr("Register")
    hasListView: false
    centralizeBusyIndicator: false

    Component.onCompleted: {
        if (window.menu)
            window.menu.enabled = false;
        RegisterFunctions.loadPrograms();
    }

    property var requestResult
    property var courseSectionsArray: []
    property ListModel programsListModel: ListModel { }
    property ListModel courseSectionsListModel: ListModel { }

    Timer {
        id: lockerButtons
        repeat: false; running: false; interval: 100
    }

    Timer {
        id: loginPopShutdown
        repeat: false; running: false; interval: 2000
        onTriggered: window.starSession(requestResult); // is a signal on the main.qml
    }

    Flickable {
        id: pageFlickable
        anchors.fill: parent
        contentHeight: Math.max(content.implicitHeight, height) + 35
        //boundsBehavior: Flickable.DragOverBounds

        Column {
            id: content
            spacing: 25
            topPadding: 5
            width: parent.width * 0.90
            anchors.horizontalCenter: parent.horizontalCenter

            Rectangle {
                color: "transparent"
                width: parent.width; height: parent.height * 0.20
                anchors.horizontalCenter: parent.horizontalCenter

                Label {
                    id: brand
                    anchors.centerIn: parent
                    text: appSettings.applicationName; color: appSettings.theme.defaultTextColor
                    font { pointSize: appSettings.theme.extraLargeFontSize; weight: Font.Bold }
                }
            }

            TextField {
                id: username
                color: appSettings.theme.colorPrimary
                width: window.width - (window.width*0.15)
                selectByMouse: true
                inputMethodHints: Qt.ImhNoPredictiveText
                anchors.horizontalCenter: parent.horizontalCenter
                onAccepted: email.focus = true
                renderType: isIOS ? Text.NativeRendering : Text.QtRendering
                placeholderText: qsTr("Enter your name")
                onEditingFinished: text = text.toLocaleLowerCase().trim();
                background: Rectangle {
                    color: appSettings.theme.colorPrimary
                    y: (username.height-height) - (username.bottomPadding / 2)
                    width: username.width; height: username.activeFocus ? 2 : 1
                    border { width: 1; color: appSettings.theme.colorPrimary }
                }
            }

            TextField {
                id: email
                color: appSettings.theme.colorPrimary
                width: window.width - (window.width*0.15)
                echoMode: TextInput.Password
                selectByMouse: true
                inputMethodHints: Qt.ImhNoPredictiveText
                anchors.horizontalCenter: parent.horizontalCenter
                font.capitalization: Font.AllLowercase
                onAccepted: password.focus = true
                renderType: isIOS ? Text.NativeRendering : Text.QtRendering
                placeholderText: qsTr("youremail@example.com")
                onFocusChanged: echoMode = TextInput.Normal
                onEditingFinished: text = text.toLocaleLowerCase().trim();
                background: Rectangle {
                    color: appSettings.theme.colorPrimary
                    y: (email.height-height) - (email.bottomPadding / 2)
                    width: email.width; height: email.activeFocus ? 2 : 1
                    border { width: 1; color: appSettings.theme.colorPrimary }
                }
            }

            TextField {
                id: password1
                color: appSettings.theme.colorPrimary
                width: window.width - (window.width*0.15)
                echoMode: TextInput.Password
                anchors.horizontalCenter: parent.horizontalCenter
                selectByMouse: true; renderType: Text.NativeRendering
                onAccepted: password2.focus = true;
                inputMethodHints: Qt.ImhNoPredictiveText
                placeholderText: qsTr("Create a password")
                background: Rectangle {
                    color: appSettings.theme.colorPrimary
                    y: (password1.height-height) - (password1.bottomPadding / 2)
                    width: password1.width; height: password1.activeFocus ? 2 : 1
                    border { width: 1; color: appSettings.theme.colorPrimary }
                }

                AwesomeIcon {
                    z: parent.z + 150; size: 20
                    name: password1.echoMode == TextInput.Password ? "eye" : "eye_slash"
                    opacity: password1.echoMode == TextInput.Password ? 0.7 : 1.0; color: parent.color
                    anchors { verticalCenter: parent.verticalCenter; right: parent.right; rightMargin: 0 }
                    onClicked: parent.echoMode = parent.echoMode == TextInput.Password ? TextInput.Normal : TextInput.Password
                }
            }

            TextField {
                id: password2
                color: appSettings.theme.colorPrimary
                width: window.width - (window.width*0.15)
                echoMode: TextInput.Password
                anchors.horizontalCenter: parent.horizontalCenter
                selectByMouse: true; renderType: Text.NativeRendering
                onAccepted: courseSections.forceActiveFocus();
                inputMethodHints: Qt.ImhNoPredictiveText
                placeholderText: qsTr("Confirm your password")
                background: Rectangle {
                    color: appSettings.theme.colorPrimary
                    y: (password2.height-height) - (password2.bottomPadding / 2)
                    width: password2.width; height: password2.activeFocus ? 2 : 1
                    border { width: 1; color: appSettings.theme.colorPrimary }
                }

                AwesomeIcon {
                    z: parent.z + 150; size: 20
                    name: password2.echoMode == TextInput.Password ? "eye" : "eye_slash"
                    opacity: password2.echoMode == TextInput.Password ? 0.7 : 1.0; color: parent.color
                    anchors { verticalCenter: parent.verticalCenter; right: parent.right; rightMargin: 0 }
                    onClicked: parent.echoMode = parent.echoMode == TextInput.Password ? TextInput.Normal : TextInput.Password
                }
            }

            ComboBox {
                id: programsList
                textRole: "name"
                model: programsListModel
                width: window.width - (window.width*0.15)
                anchors.horizontalCenter: parent.horizontalCenter
                onCurrentIndexChanged: {
                    if (currentIndex > 0)
                        RegisterFunctions.loadProgramsCourseSections(currentIndex);
                }
            }

            ComboBox {
                id: programCourseSectionsList
                z: 1; width: window.width - (window.width * 0.15)
                anchors.horizontalCenter: parent.horizontalCenter

                MouseArea {
                    z: 10; anchors.fill: parent
                    onClicked: courseSectionsChooserDialog.open();
                }
            }

            Dialog {
                id: courseSectionsChooserDialog
                modal: true; focus: true
                x: width > height ? -35 : -20; y : 0
                width: window.width; height: window.height
                title: qsTr("Check the programs course sections")

                standardButtons: Dialog.Ok

                onAccepted: {
                    courseSectionsChooserDialog.close()
                }
                onRejected: {
                    programsList.currentIndex = -1;
                    courseSectionsChooserDialog.close();
                }

                contentItem: ListView {
                    spacing: 1
                    width: courseSectionsChooserDialog.width
                    height: courseSectionsChooserDialog.height
                    displayMarginBeginning: 10
                    model: courseSectionsListModel
                    delegate: Rectangle {
                        color: "#fff"
                        width: parent.width; height: 50

                        Label {
                            width: parent.width * 0.65
                            text: description; elide: Text.ElideRight
                            verticalAlignment: Label.AlignVCenter
                            anchors { left: parent.left; leftMargin: 15; verticalCenter: parent.verticalCenter }
                        }

                        CheckBox {
                            anchors { right: parent.right; rightMargin: 15; verticalCenter: parent.verticalCenter }
                            onClicked: RegisterFunctions.appendCourseSection(id, checked);
                        }

                        Rectangle { width: parent.width; color: "#ccc"; height: 1; anchors.bottom: parent.bottom }
                    }
                }
            }

            CustomButton {
                id: registerButton
                enabled: !lockerButtons.running && !isPageBusy
                text: qsTr("Create Account");
                textColor: appSettings.theme.colorAccent
                backgroundColor: appSettings.theme.colorPrimary
                onClicked: {
                    email.focus = false;
                    password.focus = false;
                    lockerButtons.running = true;
                    RegisterFunctions.requestRegister();
                }
            }
        }
    }
}
