import QtQuick 2.7
import QtQuick.Controls 2.0

Menu {
    id: __menuCreator
    x: parent ? (parent.width - width) : 0
    y: parent ? parent.height : 0
    transformOrigin: Menu.BottomRight

    function reset() {
        for (var i = 0; i < __menuCreator.contentData.length; i++) {
            __menuCreator.removeItem(0)
            __menuCreator.removeItem(i)
        }
    }
}
