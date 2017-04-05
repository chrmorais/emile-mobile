import QtQml 2.2
import QtQuick 2.8
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.1
import Qt.labs.calendar 1.0
import QtGraphicalEffects 1.0

import "AwesomeIcon/"

Item {
    id: datepicker

    property var dateObject: new Date()
    property string calendarLocale: "pt_BR"
    property int currentDay: dateObject.getDay()
    property int currentMonth: dateObject.getMonth()
    property int currentYear: dateObject.getFullYear()
    property var currentLocale: Qt.locale(calendarLocale)
    property var monthsList: {
        var list = [];
        for (var i = 0; i < 12; ++i)
            list.push(currentLocale.standaloneMonthName(i, Locale.ShortFormat));
        return list;
    }

    function open() {
        popup.open();
    }

    signal dateSelected(var date)

    Popup {
        id: popup
        x: (window.width / 2)-(width / 2); y: (window.height / 2)-(height / 2) - 50

        Column {
            id: column
            spacing: 16
            anchors.horizontalCenter: parent.horizontalCenter

            RowLayout {
                id: row
                width: parent.width

                Rectangle {
                    id: previousYearRect
                    width: previousYear.implicitWidth * 2.5; height: 40
                    color: "#fafafa"; radius: 4; anchors.left: parent.left

                    AwesomeIcon {
                        id: previousYearIcon
                        name: "chevron_left"; opacity: 0.7
                        width: 25; height: width; color: previousYear.color
                        anchors { left: parent.left; verticalCenter: parent.verticalCenter }
                    }

                    Label {
                        id: previousYear
                        color: appSettings.theme.colorPrimary
                        text: datepicker.currentYear-1
                        font { pointSize: 12; bold: false }
                        anchors { left: previousYearIcon.right; verticalCenter: parent.verticalCenter }
                    }

                    MouseArea {
                        anchors.fill: parent
                        onClicked: datepicker.currentYear--;
                        onPressAndHold: datepicker.currentYear -= 10;
                        onEntered: previousYearRect.opacity = 1.0
                        onExited: previousYearRect.color = 0.7
                    }
                }

                Label {
                    text: datepicker.currentYear
                    color: previousYear.color; opacity: 0.5
                    font { pointSize: 15; bold: true }
                    anchors.horizontalCenter: parent.horizontalCenter
                }

                Rectangle {
                    id: nextYearRect
                    color: "#fafafa"; radius: 4
                    width: nextYear.implicitWidth * 2.5; height: 40
                    anchors.right: parent.right

                    AwesomeIcon {
                        id: nextYearIcon
                        name: "chevron_right"; opacity: 0.7
                        width: 25; height: width; color: previousYear.color
                        anchors { left: parent.left; verticalCenter: parent.verticalCenter }
                    }

                    Label {
                        id: nextYear
                        text: datepicker.currentYear+1; color: previousYear.color
                        font { pointSize: 12; bold: false }
                        anchors { right: nextYearIcon.left; verticalCenter: parent.verticalCenter }
                    }

                    MouseArea {
                        anchors.fill: parent
                        onClicked: datepicker.currentYear++;
                        onEntered: nextYearRect.opacity = 1.0
                        onExited: nextYearRect.color = 0.7
                        onPressAndHold: datepicker.currentYear += 10;
                    }
                }
            }

            GridLayout {
                rows: 2; columns: 6
                columnSpacing: 2; rowSpacing: 2

                Repeater {
                    model: datepicker.monthsList

                    Rectangle {
                        color: selected ? "#777" : "#fafafa"
                        radius: 2; width: 35; height: width

                        Text {
                            color: parent.selected ? "#fff" : "#777"
                            text: modelData; anchors.centerIn: parent
                            font.weight: parent.selected ? Font.DemiBold : Font.Normal
                        }

                        property bool selected: index === datepicker.currentMonth

                        MouseArea { anchors.fill: parent; onClicked: {var newIndex = index; datepicker.currentMonth = newIndex} }
                    }
                }
            }

            DayOfWeekRow {
                id: dayListRow
                locale: grid.locale
                width: parent.width; Layout.fillWidth: true
                anchors.horizontalCenter: parent.horizontalCenter
                delegate: Text {
                    color: "#444"
                    text: model.shortName
                    font: dayListRow.font
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                }
            }

            MonthGrid {
                id: grid
                spacing: 8
                locale: datepicker.currentLocale
                width: parent.width; Layout.fillWidth: true
                month: datepicker.currentMonth; year: datepicker.currentYear
                anchors.horizontalCenter: parent.horizontalCenter
                delegate: Text {
                    id: textDelegate
                    text: model.day; color: "#777"
                    font { bold: false; pointSize: 18 }
                    enabled: model.month === grid.month
                    opacity: model.month === grid.month ? 1 : 0.3
                    verticalAlignment: Text.AlignVCenter; horizontalAlignment: Text.AlignHCenter
                    MouseArea {
                        anchors.fill: parent
                        onClicked: {
                            datepicker.dateSelected({"month":(datepicker.currentMonth+1),"day":textDelegate.text,"year":datepicker.currentYear});
                            popup.close();
                        }
                    }
                }
            }
        }
    }
}
