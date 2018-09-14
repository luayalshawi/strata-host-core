import QtQuick 2.9
import QtQuick.Controls 2.2

Rectangle {
    id: root
    color: statusBoxColor
    border {
        color: statusBoxBorderColor
        width: 1
    }

    property alias model: statusList.model

    property string input: ""
    property string title: qsTr("")
    property color titleTextColor: "#000000"
    property color titleBoxColor: "#eeeeee"
    property color titleBoxBorderColor: "#dddddd"
    property color statusTextColor: "#000000"
    property color statusBoxColor: "#ffffff"
    property color statusBoxBorderColor: "#dddddd"

    property bool running: true

    implicitHeight: 200
    implicitWidth: 300

    Rectangle {
        id: titleArea
        anchors {
            left: parent.left
            right: parent.right
            top: parent.top
        }
        height: visible ? 35 : 0
        color: root.titleBoxColor
        border {
            color: root.titleBoxBorderColor
            width: 1
        }
        visible: title.text !== ""

        Text {
            id: title
            text: root.title
            color: root.titleTextColor
            anchors {
                fill: parent
            }
            padding: 10
        }
    }

    ListView {
        id: statusList
        implicitWidth: contentItem.childrenRect.width
        implicitHeight: contentItem.childrenRect.height
        //interactive: false
        clip: true

        anchors {
            left: parent.left
            right: parent.right
            top: titleArea.bottom
            bottom: parent.bottom
            margins: 10
        }

        delegate: Text {
            text: model.status // modelData
            color: root.statusTextColor
            font {
                family: "Courier" // Monospaced font for better text width uniformity
                pixelSize: (Qt.platform.os === "osx") ? 12 : 10;
            }
        }

        highlightFollowsCurrentItem: true
        onContentHeightChanged: {
            if (running) { scroll() }
        }
    }

    // Make sure focus follows current transcript messages when window is full
    function scroll() {
        if (statusList.contentHeight > statusList.height && statusList.contentY > (statusList.contentHeight - statusList.height - 50))
        {
            statusList.contentY = statusList.contentHeight - statusList.height;
        }
    }

    // Debug button to start/stop logging data
    FontLoader {
        id: sgicons
        source: "fonts/sgicons.ttf"
    }

    //    Button {
    //        visible: false
    //        width: 30
    //        height: 30
    //        flat: true
    //        text: "\ue800"
    //        font.family: sgicons.name
    //        anchors {
    //            right: flickableContainer.right
    //            top: flickableContainer.top
    //        }
    //        checkable: true
    //        onClicked: root.running = !root.running
    //    }

    Rectangle {
        id: filterContainer
        width: 100
        height: 30
        anchors {
            top: titleArea.bottom
            right: titleArea.right
        }
        color: "#eee"
        visible: false

        SGSubmitInfoBox {
            id: filterBox
            infoBoxColor: "#fff"
            infoBoxWidth: 80
            anchors {
                top: filterContainer.top
                left: filterContainer.left
                bottom: filterContainer.bottom
                margins: 3
            }
            placeholderText: "Filter..."
            leftJustify: true

            onApplied: {
                for (var i = 0; i< statusList.children[0].children.length; i++) {
                    statusList.children[0].children[i].visible = true
                    statusList.children[0].children[i].height = 12
                    if (statusList.children[0].children[i].text) {
                        if ( !statusList.children[0].children[i].text.includes(value)) {
                            statusList.children[0].children[i].visible = false
                            statusList.children[0].children[i].height = 0
                        }
                    }
                }
            }
        }
    }

    Shortcut {
        sequence: StandardKey.Find
        onActivated: {
            filterContainer.visible = true
            filterBox.textInput.forceActiveFocus()
        }
    }

    Shortcut {
        sequence: StandardKey.Cancel
        onActivated: {
            filterContainer.visible = false
        }
    }
}
