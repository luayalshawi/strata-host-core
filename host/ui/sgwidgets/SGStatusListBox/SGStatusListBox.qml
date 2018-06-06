import QtQuick 2.11
import QtQuick.Controls 2.2

Rectangle {
    id: root
    anchors { fill: parent }
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

    Rectangle {
        id: titleArea
        anchors {
            left: parent.left
            right: parent.right
            top: parent.top
        }
        height: 35
        width: 40
        color: root.titleBoxColor
        border {
            color: root.titleBoxBorderColor
            width: 1
        }

        Text {
            id: title
            text: root.title
            color: root.titleTextColor
            anchors {
                fill: parent
            }
            padding: 10
            font.family: sgicons.name
        }

        Component.onCompleted: {
            if (title.text === ""){ titleArea.visible = false }
        }
    }

//    ScrollView {
//        id: flickableContainer
//        clip: true
//        anchors {
//            left: parent.left
//            right: parent.right
//            top: titleArea.visible ? titleArea.bottom : parent.top
//            bottom: parent.bottom
//        }

//        Flickable {
//            id: transcriptContainer

//            anchors { fill:parent }
//            contentHeight: transcript.height
//            contentWidth: transcript.width

//            TextEdit {
//                id: transcript
//                height: contentHeight + padding * 2
//                width: root.parent.width
//                readOnly: true
//                selectByMouse: true
//                selectByKeyboard: true
//                font.family: "Courier"
//                wrapMode: TextEdit.Wrap
//                textFormat: Text.RichText
//                text: ""
//                padding: 10
//            }
//        }
//    }

    ListView {
        id: statusList
        implicitWidth: contentItem.childrenRect.width
        implicitHeight: contentItem.childrenRect.height
        //interactive: false
        clip: true

        anchors {
            left: parent.left
            right: parent.right
            top: titleArea.visible ? titleArea.bottom : parent.top
            bottom: parent.bottom
            margins: 10
        }

        delegate: Text {
            text: modelData
            color: "orangered"
            font.family: "Courier"
            //font.pointSize: smallFontSize
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
        source: "sgicons.ttf"
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
}
