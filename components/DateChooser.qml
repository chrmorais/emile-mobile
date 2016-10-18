import QtQuick 2.6
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.0

Column {
    objectName: "DateChooser"
    width: 260

    property string message: "Select day, month and year respectively"
    property string monthText: __month.model[__month.currentIndex]

    property int day: __day.model[__day.currentIndex]
    property int month: __month.currentIndex + 1
    property int year: __year.model[__year.currentIndex]

    property var daysToShow: []
    property var yearsToShow: []
    property var monthsToShow: [
        "January", "February", "March", "April", "May", "June",
        "July", "August", "September", "October", "NOvember", "December"
    ]

    Component.onCompleted: {
        var currentYear = new Date().getFullYear()
        var yearsToShowTemp = []
        for (var i = currentYear-90; i <= currentYear-15; i++)
            yearsToShowTemp.push(i)
        yearsToShowTemp.reverse()
        yearsToShow = yearsToShowTemp

        var daysToShowTemp = []
        for (var k = 1; k <= 31; k++)
            daysToShowTemp.push(k)
        daysToShow = daysToShowTemp
    }

    Label {
        width: parent.width
        wrapMode: Label.Wrap
        horizontalAlignment: Qt.AlignHCenter
        text: message
        color: theme.colorPrimary
    }

    RowLayout {
        spacing: 5
        Layout.fillWidth: true
        anchors.horizontalCenter: parent.horizontalCenter

        Tumbler {
            id: __day
            model: daysToShow
            visibleItemCount: 4
            antialiasing: true
            width: 35
            implicitWidth: 35
            font {
                pointSize: 22
                weight: Font.DemiBold
            }
        }

        Tumbler {
            id: __month
            model: monthsToShow
            visibleItemCount: 4
            antialiasing: true
            width: 105
            implicitWidth: 105
            font {
                pointSize: 22
                weight: Font.DemiBold
            }
        }

        Tumbler {
            id: __year
            model: yearsToShow
            visibleItemCount: 4
            antialiasing: true
            width: 80
            implicitWidth: 80
            font {
                pointSize: 20
                weight: Font.DemiBold
            }
        }
    }
}
