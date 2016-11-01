import QtQuick 2.6
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.0

Column {
    objectName: "DateChooser"
    width: parent && parent.width > 0 ? parent.width : 280
    spacing: 0

    property alias message: label.text

    // month-day-year
    property string valueSelected

    property string dateChooser

    property string day: daysToShow[__day.currentIndex]
    property int month: __month.currentIndex + 1
    property int year: __year.model[__year.currentIndex]

    property var daysToShow: []
    property var yearsToShow: []
    property var monthsToShow: [
        "January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"
    ]

    signal updateDate()

    onDayChanged: updateDate()
    onMonthChanged: updateDate()
    onYearChanged: updateDate()

    onUpdateDate: {
        dateChooser = [(month < 10 ? "0" : "") + month, (day < 10 ? "0" : "") + day, year].join("-")
    }

    Component.onCompleted: {
        // if selected date isset - will turn the selected day, month and year
        var valuesToSelect = valueSelected ? valueSelected.split("-") : []

        // create the years list
        var currentYear = new Date().getFullYear()
        var yearsToShowTemp = []
        for (var i = currentYear-100; i <= currentYear; i++)
            yearsToShowTemp.push(i)
        yearsToShow = yearsToShowTemp // to fix the bind with array type

        // create the days list
        var daysToShowTemp = []
        for (i = 1; i <= 31; i++)
            daysToShowTemp.push(i)
        daysToShow = daysToShowTemp

        // if valueSelected isset turn the values selected
        if (valuesToSelect.length) {
            __day.currentIndex = parseInt(valuesToSelect[1]) - 1
            __month.currentIndex = parseInt(valuesToSelect[0].substring(1,2)) - 1
            __year.currentIndex = parseInt(valuesToSelect[2]) + 3
        }
    }

    Label {
        id: label
        width: parent.width
        wrapMode: Label.Wrap
        horizontalAlignment: Qt.AlignHCenter
        text: "Select day, month and year respectively"
        color: "#777"
    }

    RowLayout {
        spacing: 0
        Layout.fillWidth: true
        anchors.horizontalCenter: parent.horizontalCenter

        Tumbler {
            id: __day
            model: daysToShow
            visibleItemCount: 4
            antialiasing: true
            width: 10
            clip: true
            font {
                pointSize: 12
                weight: Font.DemiBold
            }
        }

        Tumbler {
            id: __month
            model: monthsToShow
            visibleItemCount: 4
            antialiasing: true
            width: 160
            clip: true
            font {
                pointSize: 12
                weight: Font.DemiBold
            }
        }

        Tumbler {
            id: __year
            model: yearsToShow
            visibleItemCount: 4
            antialiasing: true
            width: 10
            clip: true
            font {
                pointSize: 12
                weight: Font.DemiBold
            }
        }
    }
}
