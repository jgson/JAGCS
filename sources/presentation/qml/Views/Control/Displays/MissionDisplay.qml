import QtQuick 2.6
import QtQuick.Layouts 1.3

import "qrc:/Controls" as Controls

RowLayout {
    id: root

    property int waypoint: 0

    signal commandReturn()
    signal commandStart()
    signal commandJumpTo(int item)

    Controls.Button {
        iconSource: "qrc:/icons/left.svg"
        onClicked: commandJumpTo(waypoint - 1)
    }

    Controls.Label {
        text: qsTr("WP: ") + waypoint
        font.pixelSize: palette.fontPixelSize * 0.6
        font.bold: true
    }

    Controls.Button {
        iconSource: "qrc:/icons/right.svg"
        onClicked: commandJumpTo(waypoint + 1)
    }

    Item {
        Layout.fillWidth: true
    }

    Controls.Button {
        iconSource: "qrc:/icons/home.svg"
        onClicked: commandReturn()
    }

    Controls.Button {
        iconSource: "qrc:/icons/play.svg"
        onClicked: commandStart()
    }
}