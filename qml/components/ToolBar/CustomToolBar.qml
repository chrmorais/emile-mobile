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

    // a default object with submenu to ToolBar
    property var submenu: ({"action": "submenu", "iconName": "ellipsis_v", "when": "normal"})

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
        else if (actionName === "goback" && toolBar.state === "actions")
            toolBar.state = "normal"

        // if current page define a function to receiver action message
        // set the action name send from click by user to the current page
        else if (currentPage.actionExec)
            currentPage.actionExec(actionName)
    }

    Connections {
        target: window
        onPageChanged: {
            // to fix bind with array when new item is pushed
            // and qml not emit sigal changed!
            var fixBinding = []

            // hide the search input on each page changed
            searchComponent.searchSection.visible = false

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

            // if current page has search support, when user enter a text in the textfield
            // from searchComponent, the string from search input will be pass to the page
            if (currentPage.searchText)
                currentPage.searchText = searchComponent.searchText

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
            onItemAdded: toolButtonsRepeater.lastChildren = item

            ToolButtonCreator {
                parent: toolBarItens;  action: modelData.action; iconName: modelData.iconName
                visible: toolBar.state == modelData.when
                anchors.right: index == 0 ? toolBarItens.right : toolButtonsRepeater.lastChildren.left
            }

            // keep the last item added to define the anchor based in the last item
            property Item lastChildren
        }
    }
}
