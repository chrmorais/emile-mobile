import QtQuick 2.8
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.1
import QtQuick.Controls.Material 2.1
import QtQuick.Controls.Material.impl 2.1

import "../../qml/components/"
import "../../qml/components/AwesomeIcon"
import "Functions.js" as RegisterFunctions

BasePage {
    id: page
    title: qsTr("Profile editable")
    objectName: title
    hasListView: false
    hasRemoteRequest: false
    toolBarState: "goback"
    toolBarActions: {"toolButton4": {"action":"update", "icon":"floppy_o"}}

    Component.onCompleted: userProfileData.type.id === 1 ? RegisterFunctions.loadPrograms() : ""

    property string userImageProfile: userProfileData.image_path ? appSettings.restService.baseImagesUrl + userProfileData.image_path : ""
    property var requestResult
    property var courseSectionsArray: []
    property ListModel programsListModel: ListModel { }
    property ListModel courseSectionsListModel: ListModel { }
    property var gender: userProfileData.gender || ""
    property var birthDate: userProfileData.birth_date
    property bool editMode: true

    signal setProgramsFinish()

    onSetProgramsFinish: {
        if (userProfileData.program_id) {
            var object = {};
            for (var i = 0; i < programsListModel.count; i++) {
                object = programsListModel.get(i);
                if (object.id === userProfileData.program_id[0].id) {
                    programsList.currentIndex = i;
                    return;
                }
            }
        }
    }

    function actionExec(action) {
        if (action === "update") {
            if (editMode) {
                username.focus = false;
                email.focus = false;
                address.focus = false;
                lockerButtons.running = true;
                RegisterFunctions.requestEditUser(username.text, email.text, address.text, gender, birthDate);
            } else {
                editMode = true;
                snackbar.show(qsTr("Edit activated"));
            }
        }
    }

    Timer {
        id: lockerButtons
        repeat: false; running: false; interval: 100
    }

    Timer {
        id: loginPopShutdown
        repeat: false; running: false; interval: 2000
        onTriggered: window.starSession(requestResult); // is a signal on the main.qml
    }

    DatePicker {
        id: datePicker
        anchors.centerIn: parent.center
        z: parent.z + 1
        onDateSelected: {
            birthDate = date.month + "-" + date.day + "-" + date.year;
            requestToSave();
        }
    }

    Flickable {
        id: pageFlickable
        anchors.fill: parent
        contentHeight: Math.max(content.implicitHeight, height) + 35

        Column {
            id: content
            spacing: 25
            topPadding: 5
            width: parent.width * 0.90
            anchors.horizontalCenter: parent.horizontalCenter

            AwesomeIcon {
                id: awesomeIcon
                name: "photo"
                size: 64; color: appSettings.theme.colorPrimary
                visible: !userImageProfile
                anchors.horizontalCenter: parent.horizontalCenter

                MouseArea {
                    id: awesomeIconControl
                    hoverEnabled: true
                    anchors.fill: parent; onClicked: profileImageConfigure()
                }

                Ripple {
                    z: parent.z + 1
                    x: (parent.width - width) / 2
                    y: (parent.height - height) / 2
                    width: drawerUserImageProfile.width; height: width
                    anchor: awesomeIconControl
                    pressed: awesomeIconControl.pressed
                    active: awesomeIconControl.pressed
                    color: awesomeIconControl.pressed ? Material.highlightedRippleColor : Material.rippleColor
                }
            }

            RoundedImage {
                id: drawerUserImageProfile
                visible: !awesomeIcon.visible
                width: 90; height: width
                imgSource: userImageProfile
                anchors.horizontalCenter: parent.horizontalCenter

                MouseArea {
                    id: drawerUserImageProfileControl
                    hoverEnabled: true
                    anchors.fill: parent; onClicked: editMode ? window.profileImageConfigure() : "" // is a function on main.qml

                    Ripple {
                        z: parent.z + 1
                        x: (parent.width - width) / 2
                        y: (parent.height - height) / 2
                        width: drawerUserImageProfile.width; height: width
                        anchor: drawerUserImageProfileControl
                        pressed: drawerUserImageProfileControl.pressed
                        active: drawerUserImageProfileControl.pressed
                        color: drawerUserImageProfileControl.pressed ? Material.highlightedRippleColor : Material.rippleColor
                    }
                }
            }

            TextField {
                id: username
                text: userProfileData.name || ""
                color: appSettings.theme.colorPrimary
                width: window.width - (window.width*0.15)
                selectByMouse: true
                inputMethodHints: isIOS ? Qt.ImhNoPredictiveText : Qt.ImhNone
                anchors.horizontalCenter: parent.horizontalCenter
                onAccepted: email.focus = true
                renderType: isIOS ? Text.NativeRendering : Text.QtRendering
                placeholderText: qsTr("Enter your name")
                readOnly: !editMode
                background: Rectangle {
                    color: appSettings.theme.colorPrimary
                    y: (username.height-height) - (username.bottomPadding / 2)
                    width: username.width; height: username.activeFocus ? 2 : 1
                    border { width: 1; color: appSettings.theme.colorPrimary }
                }
            }

            TextField {
                id: email
                text: userProfileData.email || ""
                color: appSettings.theme.colorPrimary
                width: window.width - (window.width*0.15)
                selectByMouse: true
                inputMethodHints: isIOS ? Qt.ImhNoPredictiveText : Qt.ImhNone
                anchors.horizontalCenter: parent.horizontalCenter
                font.capitalization: Font.AllLowercase
                renderType: isIOS ? Text.NativeRendering : Text.QtRendering
                placeholderText: qsTr("youremail@example.com")
                onFocusChanged: echoMode = TextInput.Normal
                onEditingFinished: text = text.toLocaleLowerCase().trim();
                readOnly: !editMode
                background: Rectangle {
                    color: appSettings.theme.colorPrimary
                    y: (email.height-height) - (email.bottomPadding / 2)
                    width: email.width; height: email.activeFocus ? 2 : 1
                    border { width: 1; color: appSettings.theme.colorPrimary }
                }
            }

            TextField {
                id: address
                text: userProfileData.address || ""
                color: appSettings.theme.colorPrimary
                width: window.width - (window.width*0.15)
                selectByMouse: true
                inputMethodHints: isIOS ? Qt.ImhNoPredictiveText : Qt.ImhNone
                anchors.horizontalCenter: parent.horizontalCenter
                font.capitalization: Font.AllLowercase
                renderType: isIOS ? Text.NativeRendering : Text.QtRendering
                placeholderText: qsTr("Address")
                onFocusChanged: echoMode = TextInput.Normal
                readOnly: !editMode
                background: Rectangle {
                    color: appSettings.theme.colorPrimary
                    y: (address.height-height) - (address.bottomPadding / 2)
                    width: address.width; height: address.activeFocus ? 2 : 1
                    border { width: 1; color: appSettings.theme.colorPrimary }
                }
            }

            Row {
                width: parent.width

                RadioButton {
                    id: male
                    text: "M"
                    width: parent.width / 3
                    checked: userProfileData.gender === "M"
                    onCheckedChanged: gender = "M"
                    enabled: editMode
                }

                RadioButton {
                    id: female
                    text: "F"
                    width: parent.width / 3
                    checked: userProfileData.gender === "F"
                    onCheckedChanged: gender = "F"
                    enabled: editMode
                }

                RadioButton {
                    id: other
                    text: qsTr("Other")
                    width: parent.width / 3
                    checked: userProfileData.gender === "O"
                    onCheckedChanged: gender = "O"
                    enabled: editMode
                }
            }

            TextField {
                id: brthdate
                text: birthDate || ""
                color: appSettings.theme.colorPrimary
                width: window.width - (window.width*0.15)
                selectByMouse: true
                inputMethodHints: isIOS ? Qt.ImhNoPredictiveText : Qt.ImhNone
                anchors.horizontalCenter: parent.horizontalCenter
                font.capitalization: Font.AllLowercase
                renderType: isIOS ? Text.NativeRendering : Text.QtRendering
                placeholderText: qsTr("birthdate")
                onFocusChanged: echoMode = TextInput.Normal
                readOnly: true
                background: Rectangle {
                    color: appSettings.theme.colorPrimary
                    y: (email.height-height) - (email.bottomPadding / 2)
                    width: email.width; height: email.activeFocus ? 2 : 1
                    border { width: 1; color: appSettings.theme.colorPrimary }
                }

                MouseArea {
                    anchors.fill: parent
                    z: parent.z + 1
                    onClicked: editMode ? datePicker.open() : ""
                }
            }

            ComboBox {
                id: programsList
                textRole: "name"
                model: programsListModel
                width: window.width - (window.width*0.15)
                anchors.horizontalCenter: parent.horizontalCenter
                visible: userProfileData.type.id === 1
                onCurrentIndexChanged: {
                    var courseSectionsArrayTemp = [];
                    if (programsListModel.count > 0 && currentIndex > 0 && userProfileData.type.id === 1) {
                        RegisterFunctions.loadProgramsCourseSections(currentIndex);
                        courseSectionsArray = courseSectionsArrayTemp;
                    }
                }
            }

            ComboBox {
                id: programCourseSectionsList
                z: 1; width: window.width - (window.width * 0.15)
                anchors.horizontalCenter: parent.horizontalCenter
                visible: userProfileData.type.id === 1

                MouseArea {
                    z: 10; anchors.fill: parent
                    onClicked: {
                        if (programCourseSectionsList.model && courseSectionsListModel.count > 0 && userProfileData.type.id === 1)
                            courseSectionsChooserDialog.open();
                    }
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
                    courseSectionsChooserDialog.close();
                }
                onRejected: {
                    programsList.currentIndex = -1;
                    courseSectionsChooserDialog.close();
                }

                contentItem: ListView {
                    id: courseSectionListView
                    enabled: editMode
                    displayMarginBeginning: 10
                    model: courseSectionsListModel
                    width: courseSectionsChooserDialog.width
                    height: courseSectionsChooserDialog.height
                    delegate: Rectangle {
                        color: "#fff"; opacity: (courseSectionsArray.indexOf(id) >= 0) ? 0.5 : 1.0
                        width: parent.width; height: 50

                        MouseArea {
                            anchors.fill: parent
                            onClicked: control.checked = !control.checked;
                        }

                        Label {
                            id: label
                            width: parent.width * 0.65
                            text: description; elide: Text.ElideRight
                            verticalAlignment: Label.AlignVCenter
                            color: appSettings.theme.colorPrimary
                            anchors { left: parent.left; leftMargin: 15; verticalCenter: parent.verticalCenter }
                        }

                        CheckBox {
                            id: control
                            anchors { right: parent.right; rightMargin: 15; verticalCenter: parent.verticalCenter }
                            onCheckedChanged: RegisterFunctions.appendCourseSection(id, checked);
                            checked: {
                                for (var i = 0; i < userProfileData.course_sections.length; i++) {
                                    if (userProfileData.course_sections[i].id === id)
                                        return true;
                                }
                                return false;
                            }

                            indicator: Rectangle {
                                x: control.leftPadding
                                y: parent.height / 2 - height / 2
                                implicitWidth: 22; implicitHeight: 22
                                radius: 3; border.color: label.color

                                Rectangle {
                                    radius: 3
                                    color: label.color
                                    width: 12; height: 12
                                    visible: control.checked
                                    anchors.centerIn: parent
                                }
                            }
                        }

                        Rectangle { width: parent.width; color: appSettings.theme.colorAccent; height: 1; anchors.bottom: parent.bottom }
                    }

                    EmptyList {
                        z: courseSectionsChooserDialog.z+1
                        visible: courseSectionsChooserDialog.visible && courseSectionListView.count <= 0 && !isPageBusy
                        enabled: !isPageBusy
                        onClicked: loadProgramsCourseSections(programsList.currentIndex);
                    }
                }
            }
        }
    }
}
