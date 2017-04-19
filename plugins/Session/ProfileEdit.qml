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
    toolBarState: "goback"
    toolBarActions: {"toolButton4": {"action":"update", "icon":"floppy_o"}}

    Component.onCompleted: if (userProfileData.type.id === 1) RegisterFunctions.loadPrograms();

    property string userImageProfile: userProfileData.image_path ? appSettings.restService.baseImagesUrl + userProfileData.image_path : ""
    property var requestResult
    property var courseSectionsArray: []
    property var gender: userProfileData.gender || ""
    property var birthDate: userProfileData.birth_date
    property bool editMode: true

    signal setProgramsFinish()

    ListModel { id: programsListModel }
    ListModel { id: courseSectionsListModel }

    onSetProgramsFinish: {
        if (userProfileData.program_id) {
            var object = {};
            for (var i = 0; i < programsListModel.count; i++) {
                object = programsListModel.get(i);
                if (object.id === userProfileData.program_id.id) {
                    programsListModel.get(i).isCheckedButton = true;
                    return;
                }
            }
        }
    }

    function userIsOnCourseSection(id) {
        for (var i = 0; i < userProfileData.course_sections.length; i++)
            if (userProfileData.course_sections[i].id == id)
                return true;
        return false;
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
        onDateSelected: birthDate = date.month + "-" + date.day + "-" + date.year;
    }

    Flickable {
        id: pageFlickable
        anchors.fill: parent
        contentHeight: Math.max(content.implicitHeight + 100, height + 100)

        Column {
            id: content
            spacing: 25
            topPadding: 0
            width: parent.width * 0.90
            anchors { top: parent.top; topMargin: 15; horizontalCenter: parent.horizontalCenter }

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

            ListItem {
                showShadow: true
                badgeText: typeof userProfileData.program_id != "undefined" ? "1" : ""
                primaryLabelText: userProfileData.program_id.abbreviation
                secondaryLabelText: userProfileData.program_id.name
                visible: userCourseSection.visible
                badgeTextColor: userCourseSection.badgeTextColor
                badgeBackgroundColor: userCourseSection.badgeBackgroundColor
                onClicked: if (programsListModel.count > 0) programChooserDialog.open();
            }

            Dialog {
                id: programChooserDialog
                modal: true; focus: true
                x: width > height ? -35 : -20; y : -65
                width: window.width; height: window.height
                title: qsTr("Check your program course")
                standardButtons: Dialog.Ok
                onAccepted: close();
                onRejected: close();

                ListView {
                    enabled: editMode; bottomMargin: 20
                    anchors.horizontalCenter: parent.horizontalCenter
                    boundsBehavior: Flickable.StopAtBounds
                    model: programsListModel
                    width: window.width; height: window.height
                    delegate: Rectangle {
                        width: parent.width; height: 50

                        property bool isCheckedButton: false

                        MouseArea {
                            anchors.fill: parent
                            onClicked: radioButton.checked = !radioButton.checked;
                        }

                        Label {
                            id: label
                            width: parent.width * 0.90
                            text: name; elide: Text.ElideRight
                            verticalAlignment: Label.AlignVCenter
                            color: appSettings.theme.colorPrimary
                            anchors { left: parent.left; leftMargin: 15; verticalCenter: parent.verticalCenter }
                        }

                        RadioButton {
                            id: radioButton
                            anchors { right: parent.right; rightMargin: 15; verticalCenter: parent.verticalCenter }
                            checked: isCheckedButton ? isCheckedButton : (userProfileData.program_id.id === id)
                            onCheckedChanged: {
                                RegisterFunctions.loadProgramsCourseSections(id);
                                programChooserDialog.close();
                            }

                            Component.onCompleted: {
                                if (userProfileData.program_id.id === id)
                                    RegisterFunctions.loadProgramsCourseSections(id);
                            }

                            indicator: Rectangle {
                                x: radioButton.leftPadding
                                y: parent.height / 2 - height / 2
                                implicitWidth: 22; implicitHeight: 22
                                radius: 3; border.color: label.color

                                Rectangle {
                                    radius: 200
                                    color: label.color
                                    width: 12; height: 12
                                    visible: radioButton.checked
                                    anchors.centerIn: parent
                                }
                            }
                        }

                        Rectangle { opacity: 0.2; width: parent.width; color: appSettings.theme.colorPrimary; height: 1; anchors.bottom: parent.bottom }
                    }

                    EmptyList {
                        z: courseSectionsChooserDialog.z+1
                        enabled: !isPageBusy
                        visible: parent.visible && programsListModel.count <= 0 && enabled
                        onClicked: RegisterFunctions.loadPrograms();
                    }
                }
            }

            ListItem {
                id: userCourseSection
                showShadow: true
                badgeText: typeof userProfileData.course_sections != "undefined" ? userProfileData.course_sections.length : 0
                primaryLabelText: qsTr("Course sections selected")
                secondaryLabelText: qsTr("Touch to edit/view the options")
                visible: userProfileData.type.id === 1
                badgeTextColor: badgeText ? appSettings.theme.colorAccent : "transparent"
                badgeBackgroundColor: badgeText ? appSettings.theme.colorPrimary : "transparent"
                onClicked: if (courseSectionsListModel.count > 0) courseSectionsChooserDialog.open()
            }

            Dialog {
                id: courseSectionsChooserDialog
                modal: true; focus: true
                x: width > height ? -35 : -20; y : 0
                width: window.width; height: window.height
                title: qsTr("Check the programs course sections")
                standardButtons: Dialog.Ok
                onAccepted: close();
                onRejected: close();

                ListView {
                    id: courseSectionListView
                    enabled: editMode
                    boundsBehavior: Flickable.StopAtBounds
                    width: page.width; height: page.height
                    topMargin: 15; bottomMargin: 20
                    anchors.horizontalCenter: parent.horizontalCenter
                    model: courseSectionsListModel
                    delegate: Rectangle {
                        width: parent.width; height: 50

                        MouseArea {
                            anchors.fill: parent
                            onClicked: checkBox.checked = !checkBox.checked;
                        }

                        Label {
                            id: labelDescription
                            width: parent.width * 0.70
                            text: description; elide: Text.ElideRight
                            verticalAlignment: Label.AlignVCenter
                            color: appSettings.theme.colorPrimary
                            anchors { left: parent.left; leftMargin: 15; verticalCenter: parent.verticalCenter }
                        }

                        CheckBox {
                            id: checkBox
                            anchors { right: parent.right; rightMargin: 15; verticalCenter: parent.verticalCenter }
                            checked: userIsOnCourseSection(id)
                            onCheckedChanged: if (checked) RegisterFunctions.appendCourseSection(id, checked);
                            indicator: Rectangle {
                                x: checkBox.leftPadding
                                y: parent.height / 2 - height / 2
                                implicitWidth: 22; implicitHeight: 22
                                radius: 3; border.color: labelDescription.color

                                Rectangle {
                                    radius: 3
                                    color: labelDescription.color
                                    width: 12; height: 12
                                    visible: checkBox.checked
                                    anchors.centerIn: parent
                                }
                            }
                        }

                        Rectangle { opacity: 0.2; width: parent.width; color: appSettings.theme.colorPrimary; height: 1; anchors.bottom: parent.bottom }
                    }

                    EmptyList {
                        z: courseSectionsChooserDialog.z+1
                        visible: courseSectionsChooserDialog.visible && courseSectionListView.count <= 0 && enabled
                        enabled: !isPageBusy
                        onClicked: loadProgramsCourseSections(programsList.currentIndex);
                    }
                }
            }
        }
    }
}
