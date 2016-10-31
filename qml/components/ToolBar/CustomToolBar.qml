import QtQuick 2.7
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.0

import "../../js/Utils.js" as Util
import "../AwesomeIcon/" as Awesome

ToolBar {
    id: toolBar
    state: "normal"
    background: Rectangle {
        id: backgroundRec

        // set a thin border
        Rectangle {
            id: backgroundBorder
            width: parent.width
            height: 1
            anchors.bottom: parent.bottom
            color: "transparent"
            border.color: backgroundBorderColor
        }
    }

    // the states define and change the current appearance(icons and buttons) of toolbar
    states: [
        State {
            name: "normal"
            PropertyChanges { target: toolButtonDrawerIcon; name: "bars"; action: "openMenu" }
        },
        State {
            name: "actions"
            PropertyChanges { target: toolButtonDrawerIcon; name: "arrow_left"; action: "cancel" }
        },
        State {
            name: "goback"
            PropertyChanges { target: toolButtonDrawerIcon; name: "arrow_left"; action: "goback" }
        }
    ]

    property color backgroundBorderColor
    property alias customBackground: toolBar.background
    property alias backgroundColor: backgroundRec.color
    property alias backgroundBorderHeight: backgroundBorder.height

    // binding the state with currentPage state - it's only to page not access the ToolBar directly
    property string dynamicState: currentPage.toolBarState ? currentPage.toolBarState : toolBar.state

    // a list of strings with the actions name visible in toolbar
    // each page must be set the lists for the visible itens that will be use in the page
    property var toolBarActions: []

    // a list of actions defined to visible whren ToolBar state is "actions"
    property var actionsStateVisible: []

    // default itens to menu - "when" is the toolBar state
    readonly property var toolBarActionsDefault: [
        {"action": "submenu", "iconName": "ellipsis_v", "when": "none"},
        {"action": "remove", "iconName": "trash", "when": "action"},
        {"action": "crop", "iconName": "crop", "when": "action"},
        {"action": "copy", "iconName": "copy", "when": "action"}
    ]

    property Menu optionsToolbarMenu: Menu {
        x: parent.width - width
        transformOrigin: Menu.BottomRight
    }

    // this signal is emited when user click in any action button in toolbar.
    // will sent the action name as parameter
    signal actionExec(var actionName)

    // update the state mode of toolbar to change the icons and actions
    onDynamicStateChanged: toolBar.state = currentPage.toolBarState || toolBar.state

    onActionExec: {
        // if current page define a list of itens to submenu(the last displayed in toolbar),
        // the itens will be append into dropdown. And whewn user click in the list, the menu needs to be opened here!
        if (actionName === "submenu")
            optionsToolbarMenu.open()

        // if current page define a function to receiver action message
        // set the action name send from click by user
        else if (currentPage.actionExec)
            currentPage.actionExec(actionName)
    }

    Connections {
        target: window
        onCurrentPageChanged: {
            console.log("currentPageChanged!")

            var submenu = ({})

            // hide the search input
            searchComponent.searchSection.visible = false

            // set the dynamic toolBar title
            searchComponent.currentPageTitle = currentPage.title

            // reset the actions for each page
            var fixBinding = []
            toolBar.toolBarActions = fixBinding

            if (currentPage.actionsStateVisible)
                actionsStateVisible = currentPage.actionsStateVisible
            else
                actionsStateVisible = fixBinding

            // reset the submenu
            if (optionsToolbarMenu != null) {
                for (var i = 0; i < optionsToolbarMenu.contentData.length; i++)
                    optionsToolbarMenu.removeItem(i)
            }

            // if current page has menu items in ToolBar submenu, will be set
            if (currentPage.subMenuToolBarItens && currentPage.subMenuToolBarItens.length > 0) {
                for (i = 0; i < currentPage.subMenuToolBarItens.length; i++)
                    optionsToolbarMenu.addItem(currentPage.subMenuToolBarItens[i])

                // get the submenu object from toolBarActionsDefault that already define the iconName and action
                submenu = toolBarActionsDefault[0]
                submenu["when"] = "normal" //update the state to normal

                // append submenu object into actions list to turn submenu available in normal state
                // the array temp is to fix dynamic array bind
                var toolBarActionsTemp = toolBarActions
                toolBarActionsTemp.push(submenu)
                toolBarActions = toolBarActionsTemp
            }

            // if current page has search support, when user enter a text in the textfield
            // the string from search input term will be pass to the page
            if (currentPage.searchText)
                currentPage.searchText = searchComponent.searchText

            // if current page uses actions in toolbar will be set
            if (currentPage.toolBarActions) {
                var toolBarActionsTemp2 = []
                toolBarActionsTemp2 = currentPage.toolBarActions
                if (submenu.when) {
                    console.log("has submenu!!")
                    toolBarActionsTemp2.push(submenu)
                }
                toolBarActions = toolBarActionsTemp2
                console.log("toolBarActions: " + JSON.stringify(toolBarActions))
            } else {
                toolBarActions = fixBinding
                toolBarActions = toolBarActionsDefault
            }

            // if current page has back action, set the toolBar state to goback action
            toolBar.state = toolBarActions.indexOf("goback") !== -1 ? "goback" : "normal"
        }
    }

    RowLayout {
        id: toolBarItens
        spacing: 0
        anchors.fill: parent

        ToolButton {
            id: toolButtonDrawer
            height: parent.height
            anchors.left: toolBarItens.left
            onClicked: {
                actionExec(toolButtonDrawerIcon.action)

                // after a click from any action, the toolBar needs to be reseted!
                if (toolBar.state === "actions")
                    toolBar.state = "normal"
            }
            contentItem: Awesome.AwesomeIcon {
                id: toolButtonDrawerIcon
                name: "bars"
                anchors.horizontalCenter: parent.horizontalCenter

                property string action
            }
        }

        SearchToolbar {
            id: searchComponent
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
                visible: toolBar.state == modelData.when //|| actionsStateVisible.indexOf(action) !== -1
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
