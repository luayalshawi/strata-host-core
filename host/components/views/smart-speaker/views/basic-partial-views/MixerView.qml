import QtQuick 2.9
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.12

Rectangle {
    id: root
    width: 200
    height:200
    color:"dimgray"
    opacity:1
    radius: 10

    property int channelWidth: root.width/8

    Text{
        id:mixerText
        text:"Mixer"
        color:"white"
        font.pixelSize: 36
        anchors.top:parent.top
        anchors.horizontalCenter: parent.horizontalCenter
    }


    Row{
        id:sliderRow
        anchors.top:mixerText.bottom
        anchors.bottom:parent.bottom
        anchors.bottomMargin:50
        anchors.leftMargin:20
        //anchors.right: parent.right
        anchors.left:parent.left

        ColumnLayout {
            anchors.top: parent.top
            anchors.bottom: parent.bottom

            Label {
                text: "12 dB"
                color:"white"
                Layout.fillHeight: true
            }
            Label {
                text: "6 dB"
                color:"white"
                Layout.fillHeight: true
            }
            Label {
                text: "0 dB"
                color:"white"
                Layout.fillHeight: true
            }
            Label {
                text: "-6 dB"
                color:"white"
                Layout.fillHeight: true
            }
            Label {
                text: "-12 dB"
                color:"white"
                Layout.fillHeight: true
            }
        }


        Slider {
            id:channel1
            from: 200
            value: 25
            to: 2000
            orientation: Qt.Vertical
            anchors.top: parent.top
            width:channelWidth
            anchors.bottom:parent.bottom

            onMoved:{
                //send the new value to the platformInterface
            }
        }

        Slider {
            id:channel2
            from: 200
            value: 25
            to: 2000
            orientation: Qt.Vertical
            anchors.top: parent.top
            width:channelWidth
            anchors.bottom:parent.bottom

            onMoved:{
                //send the new value to the platformInterface
            }
        }


        Slider {
            id:channel3
            from: 200
            value: 25
            to: 2000
            orientation: Qt.Vertical
            anchors.top: parent.top
            width:channelWidth
            anchors.bottom:parent.bottom

            onMoved:{
                //send the new value to the platformInterface
            }
        }



        Slider {
            id:channel4
            from: 200
            value: 25
            to: 2000
            orientation: Qt.Vertical
            anchors.top: parent.top
            width:channelWidth
            anchors.bottom:parent.bottom

            onMoved:{
                //send the new value to the platformInterface
            }
        }
        Slider {
            id:channel5
            from: 200
            value: 25
            to: 2000
            orientation: Qt.Vertical
            anchors.top: parent.top
            width:channelWidth
            anchors.bottom:parent.bottom

            onMoved:{
                //send the new value to the platformInterface
            }
        }

        Rectangle{
            id:spacerRectangle
            height:parent.height
            width:channelWidth
            color:"transparent"
        }

        Slider {
            id:master
            from: 200
            value: 25
            to: 2000
            orientation: Qt.Vertical
            anchors.top: parent.top
            width:channelWidth
            anchors.bottom:parent.bottom

            onMoved:{
                //send the new value to the platformInterface
            }
        }
    }

    Row{
        id:channelLabels
        anchors.left: parent.left
        anchors.leftMargin: 20
        anchors.right:parent.right
        anchors.top:sliderRow.bottom

        Label {
            text: "channel:"
            color:"white"
            width:channelWidth
        }
        Label {
            text: "1"
            color:"white"
            width:channelWidth
            //horizontalAlignment: Text.AlignHCenter
        }
        Label {
            text: "2"
            color:"white"
            width:channelWidth
            //horizontalAlignment: Text.AlignHCenter
        }
        Label {
            text: "3"
            color:"white"
            width:channelWidth
            //horizontalAlignment: Text.AlignHCenter
        }
        Label {
            text: "4"
            color:"white"
            width:channelWidth
            //horizontalAlignment: Text.AlignHCenter
        }
        Label {
            text: "5"
            color:"white"
            width:channelWidth
            //horizontalAlignment: Text.AlignHCenter
        }
        Label {
            text: ""
            color:"white"
            width:channelWidth-20
        }
        Label {
            text: "MASTER"
            color:"white"
            width:channelWidth
        }

    }

}