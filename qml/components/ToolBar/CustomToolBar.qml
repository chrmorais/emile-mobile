import QtQuick 2.7
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.0

import "../AwesomeIcon/" as Awesome

ToolBar {
    id: toolBar
    state: currentPage.toolBarState ? currentPage.toolBarState : "normal"

    // the states define and change the current appearance(icons and buttons) of toolbar
    states: [
        State {
            name: "normal"
            PropertyChanges { target: toolButtonDrawer; iconName: "bars"; action: "openMenu" }
        },
        State {
            name: "actions"
            PropertyChanges { target: toolButtonDrawer; iconName: "arrow_left"; action: "cancel" }
        },
        State {
            name: "goback"
            PropertyChanges { target: toolButtonDrawer; iconName: "arrow_left"; action: "goback" }
        },
        State {
            name: "search"
            PropertyChanges { target: toolButtonDrawer; iconName: "arrow_left"; action: "cancel" }
            PropertyChanges { target: searchToolbar; visible: true }
        }
    ]

    // the color to icons and page title text
    property color defaultTextColor: "#fff"

    // flag to simpilfy bind when dynamic pages has menu list
    property bool hasMenuList: false

    /**
     * a list of objects to the toolbar actions.
     * each page must be set the lists for the visible itens that will be use in the page
     * binding with ToolBar state. The object needs to be like this: {"action": "copy", "iconName": "copy", "when": "action"},
     */
    property var toolBarActions: []

    // define a Menu object to append dynamic sub-itens from currentPage
    property MenuCreator optionsToolbarMenu : MenuCreator { }

    // this signal is emited when user click in any action button in toolbar.
    // will sent the action name as parameter
    signal actionExec(var actionName)

    onActionExec: {
        // if current page define a list of itens to submenu (the last item displayed in ToolBar),
        // the itens will be append into a dropdown list. So, whewn user click in the list,
        // the menu needs to be opened here! because the page not know the submenu item
        if (actionName === "submenu" && optionsToolbarMenu != null)
            optionsToolbarMenu.open()

        // after a click from any action, the toolBar needs to be reseted!
        else if (actionName === "goback" && (toolBar.state === "actions" || toolBar.state === "search"))
            toolBar.state = "normal"

        // after a click from any action, the toolBar needs to be reseted!
        else if (actionName === "search" && toolBar.state === "normal")
            toolBar.state = "search"

        // after a click from any action, the toolBar needs to be reseted!
        else if (actionName === "cancel" && toolBar.state === "search")
            toolBar.state = "normal"

        // if current page define a function to receiver action message
        // set the action name send from click by user to the current page
        else if (currentPage.actionExec)
            currentPage.actionExec(actionName)

        console.log("action name: " + actionName)
    }

    Connections {
        target: window
        onPageChanged: {
            // to fix bind with array when new item is pushed
            // and qml not emit sigal changed!
            var fixBinding = []

            // hide the search input on each page changed
            searchToolbar.visible = false

            // reset the actions for each page
            toolBar.toolBarActions = fixBinding

            // if current page has menu items in ToolBar submenu, will be set
            if (currentPage.subMenuToolBarItens && currentPage.subMenuToolBarItens.length > 0) {
                optionsToolbarMenu.reset()

                for (var i = 0; i < currentPage.subMenuToolBarItens.length; i++)
                    optionsToolbarMenu.addItem(currentPage.subMenuToolBarItens[i])

                // append submenu object into actions list to turn submenu available in normal state
                // the array temp is to fix dynamic array bind
                var toolBarActionsTemp = toolBarActions
                toolBarActionsTemp.push(submenu)
                toolBarActions = toolBarActionsTemp
            }

            // if current page uses actions in toolbar will be set
            // else the defaults actions will be set to ToolBar actions
            if (currentPage.toolBarActions) {
                toolBarActionsTemp = currentPage.toolBarActions
                if (submenu.when)
                    toolBarActionsTemp.push(submenu)
                toolBarActions = toolBarActionsTemp
            }
        }
    }

    RowLayout {
        id: toolBarItens
        width: parent.width
        height: parent.height
        anchors.fill: parent
        Layout.fillWidth: true

        ToolButtonCreator {
            id: toolButtonDrawer
            iconColor: appSettings.theme.textColorPrimary
            anchors {
                left: toolBarItens.left
                leftMargin: 0
            }
        }

        Label {
            id: title
            clip: true
            width: visible ? toolBarItens.width * 0.60 : 0
            visible: toolBar.state === "normal" || toolBar.state === "goback"
            elide: Text.ElideRight
            text: currentPage.title || ""
            wrapMode: Text.WordWrap
            color: appSettings.theme.textColorPrimary
            font {
                weight: Font.DemiBold
                pointSize: 10
            }
            anchors {
                left: toolButtonDrawer.right
                leftMargin: 10
                verticalCenter: parent.verticalCenter
            }
        }

        SearchToolbar {
            id: searchToolbar
            visible: toolBar.state == "search"
            onSearchTextChanged: if (currentPage.searchText) currentPage.searchText = searchToolbar.searchText
            anchors {
                left: title.right
                leftMargin: 10
                verticalCenter: parent.verticalCenter
            }
        }

        Repeater {
            id: toolBarActionsRepeater
            model: toolBarActions
            anchors {
                right: toolBarItens.right
                rightMargin: 10
                verticalCenter: parent.verticalCenter
            }

            ToolButtonCreator {
                parent: toolBarItens
                action: modelData.action
                iconName: modelData.iconName
                iconColor: toolButtonDrawer.iconColor
                visible: toolBar.state === modelData.when
            }
        }
    }
}
