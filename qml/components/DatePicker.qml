import QtQml 2.2
import QtQuick 2.7
import QtQuick.Layouts 1.0
import QtQuick.Controls 2.0
import Qt.labs.calendar 1.0
import QtGraphicalEffects 1.0

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
        x: window.width / 2 - width / 2; y: window.height / 2 - height / 2

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

                    Image {
                        id: previousYearIcon
                        antialiasing: true
                        asynchronous: true; cache: true; clip: true
                        source: Qt.resolvedUrl("left.svg"); width: 25; height: width
                        anchors { left: parent.left; verticalCenter: parent.verticalCenter }

                        ColorOverlay {
                            antialiasing: true
                            color: previousYear.color; cached: true
                            anchors.fill: parent; source: parent
                        }
                    }

                    Label {
                        id: previousYear
                        color: "#b1b1b1"
                        text: datepicker.currentYear-1
                        font { pointSize: 12; bold: false }
                        anchors { left: previousYearIcon.right; verticalCenter: parent.verticalCenter }
                    }

                    MouseArea {
                        anchors.fill: parent
                        onClicked: datepicker.currentYear--;
                        onPressAndHold: datepicker.currentYear -= 10;
                        onEntered: previousYearRect.color = "#f7f7f7"
                        onExited: previousYearRect.color = "#fafafa"
                    }
                }

                Label {
                    text: datepicker.currentYear
                    color: "#777"
                    font { pointSize: 15; bold: true }
                    anchors.horizontalCenter: parent.horizontalCenter
                }

                Rectangle {
                    id: nextYearRect
                    color: "#fafafa"; radius: 4
                    width: nextYear.implicitWidth * 2.5; height: 40
                    anchors.right: parent.right

                    Image {
                        id: nextYearIcon
                        antialiasing: true
                        asynchronous: true; cache: true; clip: true
                        source: Qt.resolvedUrl("right.svg"); width: 25; height: width
                        anchors { right: parent.right; verticalCenter: parent.verticalCenter }

                        ColorOverlay {
                            antialiasing: true
                            color: nextYear.color; cached: true
                            anchors.fill: parent; source: parent
                        }
                    }

                    Label {
                        id: nextYear
                        text: datepicker.currentYear+1; color: "#b1b1b1"
                        font { pointSize: 12; bold: false }
                        anchors { right: nextYearIcon.left; verticalCenter: parent.verticalCenter }
                    }

                    MouseArea {
                        anchors.fill: parent
                        onClicked: datepicker.currentYear++;
                        onEntered: nextYearRect.color = "#f7f7f7"
                        onExited: nextYearRect.color = "#fafafa"
                        onPressAndHold: {
                            nextYearRect.color = "#f0f0f0"
                            datepicker.currentYear += 10;
                        }
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
                    opacity: model.month === grid.month ? 1 : 0.3
                    enabled: model.month === grid.month
                    text: model.day; color: "#777"
                    verticalAlignment: Text.AlignVCenter; horizontalAlignment: Text.AlignHCenter
                    font {
                        bold: false
                        pointSize: 18
                    }
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
