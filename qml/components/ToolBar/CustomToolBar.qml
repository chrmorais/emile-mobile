import QtQuick 2.8
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.1
import QtGraphicalEffects 1.0

import "../AwesomeIcon/" as Awesome

ToolBar {
    id: toolBar
    visible: window.menu && window.menu.enabled
    height: visible ? 50 : 0
    state: window.currentPage.toolBarState ? window.currentPage.toolBarState : "normal"
    states: [
        State {
            name: "normal"
            PropertyChanges { target: toolButtonFirst; iconName: "bars"; action: "openMenu" }
        },
        State {
            name: "action"
            PropertyChanges { target: toolButtonFirst; iconName: "arrow_left"; action: "cancel" }
        },
        State {
            name: "goback"
            PropertyChanges { target: toolButtonFirst; iconName: "arrow_left"; action: "goback" }
        },
        State {
            name: "search"
            PropertyChanges { target: toolButtonFirst; iconName: "arrow_left"; action: "cancel" }
            PropertyChanges { target: searchToolbar; visible: true }
        }
    ]

    property bool hasMenuList: false
    property string toolBarColor: appSettings.theme.colorPrimary
    property color defaultTextColor: appSettings.theme.colorAccent

    property alias toolButtonFirst: toolButtonFirst
    property alias toolButton2: toolButton2
    property alias toolButton3: toolButton3
    property alias toolButton4: toolButton4
    property alias toolButtonLast: toolButtonLast

    /**
     * A object to the toolbar actions for the current page.
     * Each page can set the icons that needs to be used.
     * For the, needs to be set a object like this:
     *    {
     *       "toolButton3": {"action":"delete", "icon":"trash"},
     *       "toolButton4": {"action":"copy", "icon":"copy"}
     *    }
     */
    property var toolBarActions: ({})

    // emited when user click in any button from toolbar
    signal actionExec(var actionName)

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

    Loader {
        onLoaded: toolBar.background = item
        asynchronous: false; active: toolBarColor.length > 0
        sourceComponent: Rectangle {
            color: toolBarColor
            width: toolBar.width; height: toolBar.height - 2
            layer.enabled: true
            layer.effect: DropShadow {
                visible: toolBar.visible
                verticalOffset: 1; horizontalOffset: 0
                color: toolBarColor; spread: 0.4
                samples: 15
            }
        }
    }

    Connections {
        target: window.currentPage && window.currentPage.toolBarActions ? window.currentPage : null
        ignoreUnknownSignals: true
        onToolBarActionsChanged: {
            if (currentPage.toolBarActions)
                toolBarActions = currentPage.toolBarActions;
        }
    }

    Connections {
        target: window
        onPageChanged: {
            var fixBind = [];
            hasMenuList = false;
            toolBarActions = fixBind;
            searchToolbar.visible = false;

            if (currentPage.toolBarActions)
                toolBarActions = window.currentPage.toolBarActions;

            // if current page define a list of itens to submenu (the last item displayed in ToolBar),
            // the itens will be append into a dropdown list
            if (window.currentPage.toolBarMenuList && window.currentPage.toolBarMenuList.length > 0) {
                hasMenuList = true;
                optionsToolbarMenu.reset();
                for (var i = 0; i < window.currentPage.toolBarMenuList.length; i++)
                    optionsToolbarMenu.addItem(window.currentPage.toolBarMenuList[i]);
            }
        }
    }

    RowLayout {
        id: toolBarItens
        anchors { fill: parent; leftMargin: 8; rightMargin: 8 }

        CustomToolButton {
            id: toolButtonFirst
            iconColor: defaultTextColor
        }

        Item {
            id: title
            width: visible ? parent.width * 0.55 : 0; height: parent.height
            visible: toolBar.state === "normal" || toolBar.state === "goback"
            anchors { left: toolButtonFirst.right; leftMargin: 12; verticalCenter: parent.verticalCenter }

            Text {
                elide: Text.ElideRight
                text: currentPage.title || ""; color: defaultTextColor
                anchors.verticalCenter: parent.verticalCenter
                font { weight: Font.DemiBold; pointSize: appSettings.theme.bigFontSize }
            }
        }

        SearchToolbar {
            id: searchToolbar
            visible: toolBar.state == "search"; defaultTextColor: defaultTextColor
            onSearchTextChanged: if (currentPage.searchText) currentPage.searchText = searchToolbar.searchText
            anchors { left: title.right; leftMargin: 10; verticalCenter: parent.verticalCenter }
        }

        CustomToolButton {
            id: toolButton2
            iconColor: defaultTextColor
            anchors.right: toolButton3.left
            action: toolBarActions.hasOwnProperty("toolButton2") ? toolBarActions.toolButton2.action : "save"
            iconName: toolBarActions.hasOwnProperty("toolButton2") ? toolBarActions.toolButton2.icon : "save"
            visible: toolBarActions.hasOwnProperty("toolButton2") && (toolBar.state === "action" || toolBar.state === "goback")
        }

        CustomToolButton {
            id: toolButton3
            iconColor: defaultTextColor
            anchors.right: toolButton4.left
            action: toolBarActions.hasOwnProperty("toolButton3") ? toolBarActions.toolButton3.action : "delete"
            iconName: toolBarActions.hasOwnProperty("toolButton3") ? toolBarActions.toolButton3.icon : "trash"
            visible: toolBarActions.hasOwnProperty("toolButton3") && (toolBar.state === "action" || toolBar.state === "goback")
        }

        CustomToolButton {
            id: toolButton4
            iconColor: defaultTextColor
            anchors.right: toolButtonLast.left
            action: toolBarActions.hasOwnProperty("toolButton4") ? toolBarActions.toolButton4.action : "search"
            iconName: toolBarActions.hasOwnProperty("toolButton4") ? toolBarActions.toolButton4.icon : "search"
            visible: toolBarActions.hasOwnProperty("toolButton4") && (toolBar.state === "normal" || toolBar.state === "goback")
        }

        CustomToolButton {
            id: toolButtonLast
            iconColor: defaultTextColor;
            anchors.right: parent.right
            action: "submenu"; iconName: "ellipsis_v"
            visible: hasMenuList && (toolBar.state === "normal" || toolBar.state === "goback")

            Menu {
                id: optionsToolbarMenu
                x: parent ? (parent.width - width) : 0
                y: parent ? parent.height : 0
                transformOrigin: Menu.BottomRight

                function reset() {
                    for (var i = 0; i < optionsToolbarMenu.contentData.length; i++) {
                        optionsToolbarMenu.removeItem(0);
                        optionsToolbarMenu.removeItem(i);
                    }
                }
            }
        }
    }
}
