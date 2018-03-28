import QtQuick 2.6
import "../Controls" as Controls

import "Tools"
import "Notifications"
import "Topbar"
import "Video"
import "Map"
import "Dashboard"
import "Menu"

Controls.ApplicationWindow  {
    id: main

    property bool fullscreen: false
    property bool cornerMap: false
    property bool cornerVisible: false
    property bool dashboardVisible: true
    property int mapType: -1

    property QtObject map

    function reloadMap(type) {
        mapType = type !== undefined ? type : parseInt(settings.value("Map/plugin"));
        mapLoader.sourceComponent = mapFactory.create(mapType);
    }

    Component.onCompleted: reloadMap()
    visible: true

    header: TopbarView {
        id: topbar
        anchors.left: parent.left
        anchors.right: parent.right
    }

    Item {
        id: substrate
        anchors.fill: parent
    }

    MouseArea {
        id: corner
        anchors.top: tools.top
        anchors.left: tools.left
        width: Math.min(parent.width - dashboard.width -
                        drawer.position * drawer.width - sizings.margins * 2,
                        cornerMap ? map.implicitWidth : video.implicitWidth)
        height: parent.height / 2
        z: cornerVisible ? 2 : -1
        enabled: cornerVisible
        onClicked: cornerMap = !cornerMap
    }

    ActiveVideoView {
        id: video
        anchors.fill: cornerMap ? substrate : corner
        visible: cornerVisible || cornerMap
        z: !cornerMap
    }

    Loader {
        id: mapLoader
        anchors.fill: cornerMap ? corner : substrate
        visible: cornerVisible || !cornerMap
        onItemChanged: map = item
        z: cornerMap
    }

    MapFactory { id: mapFactory }

    DashboardView {
        id: dashboard
        anchors.top: topbar.top
        anchors.right: parent.right
        anchors.rightMargin: dashboardVisible ? 0 : -width
        width: sizings.controlBaseSize * 8
        height: Math.min(implicitHeight, main.height)
        z: 1
        visible: anchors.rightMargin != -width

        Behavior on anchors.rightMargin { PropertyAnimation { duration: 200 } }
    }

    ToolsPanel {
        id: tools
        x: drawer.position * drawer.width + sizings.margins
        anchors.top: topbar.bottom
        anchors.bottom: parent.bottom
        anchors.margins: sizings.margins
        z: 3
    }

    NotificationListView {
        id: notifications
        anchors.top: corner.bottom
        anchors.left: tools.right
        anchors.bottom: parent.bottom
        anchors.right: corner.height < dashboard.height ? dashboard.left : parent.right
        anchors.margins: sizings.margins
        z: 3
    }

    Controls.Drawer {
        id: drawer
        width: menu.width
        height: parent.height - y

        MenuView {
            id: menu
            anchors.top: parent.top
            anchors.bottom: parent.bottom
            anchors.right: parent.right
            visible: drawer.position > 0
        }

        Behavior on width { PropertyAnimation { duration: 200 } }
    }
}
