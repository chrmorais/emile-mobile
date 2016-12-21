import QtQuick 2.7
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.0

import "../AwesomeIcon/" as Awesome

ToolBar {
    id: toolBar
    state: currentPage.toolBarState ? currentPage.toolBarState : "normal"
    states: [
        State {
            name: "normal"
            PropertyChanges { target: toolButtonDrawer; iconName: "bars"; action: "openMenu" }
        },
        State {
            name: "action"
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

    property bool hasMenuList: false
    property color defaultTextColor: "#fff"

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

    // if current page define a list of itens to submenu (the last item displayed in ToolBar),
    // the itens will be append into a dropdown list. So, whewn user click in the list,
    // the menu needs to be opened here! because the page not know the submenu item
    onActionExec: {
        if (actionName === "submenu" && optionsToolbarMenu != null)
            optionsToolbarMenu.open();
        else if (actionName === "goback" && (toolBar.state === "actions" || toolBar.state === "search"))
            toolBar.state = "normal";
        else if (actionName === "search" && toolBar.state === "normal")
            toolBar.state = "search";
        else if (actionName === "cancel" && toolBar.state === "search")
            toolBar.state = "normal";
        else if (currentPage.actionExec)
            currentPage.actionExec(actionName);
    }

    Connections {
        target: window
        onPageChanged: {
            var fixBind             = []
            hasMenuList             = false
            toolBarActions          = fixBind
            searchToolbar.visible   = false

            if (currentPage.toolBarActions)
                toolBarActions = currentPage.toolBarActions

            if (currentPage.toolBarMenuList && currentPage.toolBarMenuList.length > 0) {
                hasMenuList = true
                optionsToolbarMenu.reset()
                for (var i = 0; i < currentPage.toolBarMenuList.length; i++)
                    optionsToolbarMenu.addItem(currentPage.toolBarMenuList[i])
            }
        }
    }

    RowLayout {
        id: toolBarItens
        anchors.fill: parent

        ToolButtonCreator {
            id: toolButtonDrawer
            iconColor: defaultTextColor
        }

        Item {
            id: title
            width: visible ? parent.width * 0.55 : 0
            height: parent.height
            visible: toolBar.state === "normal" || toolBar.state === "goback"
            anchors {
                left: toolButtonDrawer.right
                leftMargin: 10
                verticalCenter: parent.verticalCenter
            }

            Text {
                clip: true
                width: parent.width
                elide: Text.ElideRight
                text: currentPage.title || ""
                color: defaultTextColor
                anchors.verticalCenter: parent.verticalCenter
                font {
                    weight: Font.DemiBold
                    pointSize: 10
                }
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

        ToolButtonCreator {
            id: toolButtonSave
            action: "save"
            iconName: "save"
            iconColor: defaultTextColor
            visible: toolBarActions.indexOf("save") !== -1 && (toolBar.state === "action" || toolBar.state === "goback")
            anchors.right: toolButtonDelete.left
        }

        ToolButtonCreator {
            id: toolButtonDelete
            action: "delete"
            iconName: "trash"
            iconColor: defaultTextColor
            visible: toolBarActions.indexOf("delete") !== -1 && (toolBar.state === "action" || toolBar.state === "goback")
            anchors.right: toolButtonSearch.left
        }

        ToolButtonCreator {
            id: toolButtonSearch
            action: "search"
            iconName: "search"
            iconColor: defaultTextColor
            visible: toolBarActions.indexOf("search") !== -1 && (toolBar.state === "normal" || toolBar.state === "goback")
            anchors.right: toolButtonMenuList.left
        }

        ToolButtonCreator {
            id: toolButtonMenuList
            action: "submenu"
            iconName: "ellipsis_v"
            iconColor: defaultTextColor
            visible: hasMenuList && (toolBar.state === "normal" || toolBar.state === "goback")
            anchors.right: parent.right

            MenuCreator {
                id: optionsToolbarMenu
            }
        }
    }
}
