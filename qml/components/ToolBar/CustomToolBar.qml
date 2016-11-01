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
        }
    ]

    property var submenu: ({"action": "submenu", "iconName": "ellipsis_v", "when": "normal"})

    // a list of strings with the actions name visible in toolbar
    // each page must be set the lists for the visible itens that will be use in the page
    property var toolBarActions: []

    // default itens to menu - The "when" is a alias to the toolBar state
    // these actions is to copy, crop and remove itens from page
    // page can set your property actions
    readonly property var toolBarActionsDefault: [
        {"action": "remove", "iconName": "trash", "when": "action"},
        {"action": "crop", "iconName": "crop", "when": "action"},
        {"action": "copy", "iconName": "copy", "when": "action"}
    ]

    // define a Menu object to append dynamic page sub-itens
    property Menu optionsToolbarMenu: Menu {
        x: toolBarItens.width - width
        y: toolBarItens.height
        transformOrigin: Menu.BottomRight
    }

    // this signal is emited when user click in any action button in toolbar.
    // will sent the action name as parameter
    signal actionExec(var actionName)

    onActionExec: {
        // if current page define a list of itens to submenu(the last displayed in toolbar),
        // the itens will be append into dropdown. And whewn user click in the list, the menu needs to be opened here!
        if (actionName === "submenu")
            optionsToolbarMenu.open()

        // after a click from any action, the toolBar needs to be reseted!
        else if (actionName === "goback" && toolBar.state === "actions")
            toolBar.state = "normal"

        // if current page define a function to receiver action message
        // set the action name send from click by user
        else if (currentPage.actionExec)
            currentPage.actionExec(actionName)
    }

    Connections {
        target: window
        onCurrentPageChanged: {
            var fixBinding = []

            // hide the search input on each page changed
            searchComponent.searchSection.visible = false

            // reset the actions for each page
            toolBar.toolBarActions = fixBinding

            // if current page has menu items in ToolBar submenu, will be set
            if (currentPage.subMenuToolBarItens && currentPage.subMenuToolBarItens.length > 0) {
                for (var i = 0; i < currentPage.subMenuToolBarItens.length; i++) {
                    optionsToolbarMenu.removeItem(i)
                    optionsToolbarMenu.addItem(currentPage.subMenuToolBarItens[i])
                }

                // append submenu object into actions list to turn submenu available in normal state
                // the array temp is to fix dynamic array bind
                var toolBarActionsTemp = toolBarActions
                toolBarActionsTemp.push(submenu)
                toolBarActions = toolBarActionsTemp
            }

            // if current page has search support, when user enter a text in the textfield
            // from searchComponent, the string from search input will be pass to the page
            if (currentPage.searchText)
                currentPage.searchText = searchComponent.searchText

            // if current page uses actions in toolbar will be set
            // else the defaults actions will be set to ToolBar actions
            if (currentPage.toolBarActions) {
                toolBarActionsTemp = fixBinding
                toolBarActionsTemp = currentPage.toolBarActions
                if (submenu.when)
                    toolBarActionsTemp.push(submenu)
                toolBarActions = toolBarActionsTemp
            } else {
                toolBarActions = fixBinding
                toolBarActions = toolBarActionsDefault
            }
        }
    }

    RowLayout {
        id: toolBarItens
        anchors.fill: parent

        ToolButtonCreator {
            id: toolButtonDrawer
            anchors.left: toolBarItens.left
            iconName: "bars"
        }

        SearchToolbar {
            id: searchComponent
            currentPageTitle: currentPage.title
            visible: toolBar.state === "normal" || toolBar.state === "goback"
            anchors {
                left: toolButtonDrawer.right
                leftMargin: 5
            }
        }

        Repeater {
            id: toolButtonsRepeater
            model: toolBarActions
            width: 0
            visible: false
            onItemAdded: toolButtonsRepeater.lastChildren = item

            ToolButtonCreator {
                parent: toolBarItens
                action: modelData.action
                iconName: modelData.iconName
                visible: toolBar.state == modelData.when
                anchors {
                    right: index == 0 ? toolBarItens.right : toolButtonsRepeater.lastChildren.left
                    leftMargin: 0
                    rightMargin: 0
                }
            }

            // keep the last item added to define the anchor based in the last item
            property Item lastChildren
        }
    }
}
