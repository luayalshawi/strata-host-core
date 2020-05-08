import QtQuick 2.12
import QtQuick.Window 2.2
import QtGraphicalEffects 1.0
import QtQuick.Dialogs 1.3
import QtQuick.Controls 2.3
import QtQuick.Layouts 1.3
import tech.strata.sgwidgets 1.0


Rectangle {
    id: root

    Text{
        id:title
        anchors.top:parent.top
        anchors.topMargin: 40
        anchors.horizontalCenter: parent.horizontalCenter
        text:"relay"
        font.pixelSize: 72
    }

//    Image{
//            anchors.fill: parent
//            source: "qrc:/views/meshNetwork/images/relayDemo.png"
//            height:parent.height
//            anchors.centerIn: parent
//            fillMode: Image.PreserveAspectFit
//            mipmap:true
//        }

    MSwitch{
        id:switchOutline
        anchors.left:parent.left
        anchors.leftMargin:parent.width*.05
        anchors.verticalCenter: parent.verticalCenter

        //this switch should have no effect on the lightbulb if the relay switch is off
        onIsOnChanged: {
            if (isOn && relaySwitch.checked){
                lightBulb.onOpacity = 1
                platformInterface.demo_click.update("relay","switch1","on")
            }
              else if (!isOn && relaySwitch.checked){
                lightBulb.onOpacity = 0
                platformInterface.demo_click.update("relay","switch1","off")
            }
        }
    }

    Image{
        id:arrowImage
        anchors.left:switchOutline.right
        anchors.right:switchOutline2.left
        anchors.verticalCenter: parent.verticalCenter
        source: "qrc:/views/meshNetwork/images/rightArrow.svg"
        height:25
        fillMode: Image.PreserveAspectFit
        mipmap:true
    }

    MSwitch{
        id:switchOutline2
        anchors.horizontalCenter:parent.horizontalCenter
        anchors.verticalCenter: parent.verticalCenter

        onIsOnChanged: {
            if (isOn){
                lightBulb.onOpacity = 1
                platformInterface.demo_click.update("relay","switch2","on")
            }
              else{
                lightBulb.onOpacity = 0
                platformInterface.demo_click.update("relay","switch2","off")
            }
        }
    }

    SGSwitch{
        id:relaySwitch
        anchors.top:switchOutline2.bottom
        anchors.topMargin: 10
        anchors.horizontalCenter: switchOutline2.horizontalCenter
        width:100
        height:50
        grooveFillColor: "limegreen"
        grooveColor:"lightgrey"

        onToggled: {
            if (checked){
                platformInterface.demo_click.update("relay","relay_switch","on")
                if (switchOutline.isOn){
                    lightBulb.onOpacity = 1
                }
            }
            else{
                platformInterface.demo_click.update("relay","relay_switch","off")
                if (switchOutline.isOn){
                    lightBulb.onOpacity = 0
                }
            }
        }
    }

    Text{
        id:relaySwitchLabel
        anchors.top:relaySwitch.bottom
        anchors.topMargin: 10
        anchors.horizontalCenter: relaySwitch.horizontalCenter
        text:"relay"
        font.pixelSize: 24
    }

    Image{
        id:arrowImage2
        anchors.left:switchOutline2.right
        anchors.right:lightBulb.left
        anchors.verticalCenter: parent.verticalCenter
        source: "qrc:/views/meshNetwork/images/rightArrow.svg"
        height:25
        fillMode: Image.PreserveAspectFit
        mipmap:true
    }

    MLightBulb{
        id:lightBulb
        anchors.right:parent.right
        anchors.rightMargin:parent.width*.05
        anchors.verticalCenter: parent.verticalCenter

        onBulbClicked: {
            platformInterface.demo_click.update("relay","bulb1","on")
            console.log("bulb clicked")
        }
    }

    Button{
        id:resetButton
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottom:parent.bottom
        anchors.bottomMargin: 20
        text:"reconfigure"

        contentItem: Text {
                text: resetButton.text
                font.pixelSize: 20
                opacity: enabled ? 1.0 : 0.3
                color: "grey"
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                elide: Text.ElideRight
            }

            background: Rectangle {
                implicitWidth: 100
                implicitHeight: 40
                color: resetButton.down ? "lightgrey" : "transparent"
                border.color: "grey"
                border.width: 2
                radius: 10
            }

            onClicked: {
                platformInterface.set_demo.update("relay")
            }
    }
}
