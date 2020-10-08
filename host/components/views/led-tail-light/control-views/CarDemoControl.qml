import QtQuick 2.12
import QtQuick.Layouts 1.12
import tech.strata.sgwidgets 1.0
import tech.strata.sgwidgets 0.9 as Widget09
import "qrc:/js/help_layout_manager.js" as Help
import QtQuick.Controls 2.12
import QtGraphicalEffects 1.12

Rectangle{
    anchors.fill: parent
    color: "lightgray"
    Rectangle {
        id: root
        color: "lightgray"
        property real ratioCalc: root.width / 1200
        property real initialAspectRatio: 1400/900
        anchors.centerIn: parent
        height: parent.height
        width: parent.width / parent.height > initialAspectRatio ? parent.height * initialAspectRatio : parent.width

        Component.onCompleted: {
            blinkerContainer.enabled = false
            Help.registerTarget(controlContainerForHelp, "Use these clickable controls to simulate common tail lights on a passenger vehicle: brake, hazard, reverse, and turn signals. The hazard signals are enabled by default and must be disabled to use individual left and right turn signals.", 0, "carDemoHelp")
            Help.registerTarget(carContainer, "The LEDs on the PCB are updated and then subsequently updated here in the user interface from the hardware. The background behind the vehicle is correlated to an onboard ambient light sensor to simulate brighter or darker conditions. Automatic rear running lights (and front headlights in UI only) will be enabled during darker conditions. Hover your hand over the light sensor near the bottom right of the PCB to simulate darker conditions. Expose the light sensor to a brighter light, such as a cell phone flashlight, for brighter background conditions. An initial ambient light value is measured during each Car Demo Mode session – this value is considered 50% brightness and may not correlate directly with actual ambient light conditions. Starting Car Demo Mode in low light conditions will have adverse effects on demonstration.", 1, "carDemoHelp")
        }

        property int transformX:0;
        property int transformY:0;


        property var car_demo_brightness: platformInterface.car_demo_brightness.value
        onCar_demo_brightnessChanged: {
            if(car_demo_brightness !== undefined) {
                baseCar.brightness = car_demo_brightness
            }
        }

        property var car_demo_brightness_headlights: platformInterface.car_demo_brightness.headlights
        onCar_demo_brightness_headlightsChanged: {
            if(car_demo_brightness_headlights === true){
                headlights.visible = true
                runningLight.visible = true
            }
            else {
                headlights.visible = false
                runningLight.visible = false
            }
        }

        property var  manual_value : platformInterface.manual_value
        onManual_valueChanged: {
            if(manual_value === false)
                brigtnesseImage.source = "sun_moon_off.png"
        }

        Connections {
            target: Help.utility
            onInternal_tour_indexChanged: {
                if(Help.current_tour_targets[index]["target"] === carContainer) {
                    Help.current_tour_targets[index]["helpObject"].toolTipPopup.contentItem.width = 800
                }
                if(Help.current_tour_targets[index]["target"] === controlContainerForHelp) {
                    Help.current_tour_targets[index]["helpObject"].toolTipPopup.contentItem.width = 650
                }
            }
        }

        Item {
            id: carContainer
            width: parent.width/2.8
            height: parent.height/6.8
            anchors.verticalCenter: parent.verticalCenter
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.horizontalCenterOffset: 80

        }
        Item {
            id: controlContainerForHelp
            width: parent.width/8
            height: parent.height/1.8
            anchors.right: parent.right
            anchors.rightMargin: 20
            anchors.verticalCenter: parent.verticalCenter
        }

        RowLayout {
            anchors.fill: parent
            Rectangle {
                Layout.alignment: Qt.AlignHCenter
                Layout.fillHeight: parent.height
                Layout.preferredWidth: parent.width/1.2
                color: "lightgray"

                Image {
                    id: base
                    source: "car-Images/base.jpg"
                    fillMode: Image.PreserveAspectFit
                    anchors.fill: parent
                }


                BrightnessContrast {
                    id: baseCar
                    anchors.fill: base
                    source: base
                    contrast: 0
                }

                Image {
                    id: headlights
                    source: "car-Images/headlights.png"
                    anchors.fill: parent
                    fillMode: Image.PreserveAspectFit
                    visible: false
                }

                Image {
                    id: brakeLights
                    source: "car-Images/brakes.png"
                    anchors.fill: parent
                    fillMode: Image.PreserveAspectFit
                    visible: false

                }

                Image {
                    id: reverseLights
                    source: "car-Images/reverse.png"
                    anchors.fill: parent
                    visible: false
                    fillMode: Image.PreserveAspectFit
                }

                Image {
                    id: hazardLights
                    source: "car-Images/markers.png"
                    anchors.fill: parent
                    visible: false
                    fillMode: Image.PreserveAspectFit


                }

                Image {
                    id: leftSignal
                    source: "car-Images/left.png"
                    anchors.fill: parent
                    visible: false
                    fillMode: Image.PreserveAspectFit

                }

                Image {
                    id: rightSignal
                    source: "car-Images/right.png"
                    anchors.fill: parent
                    visible: false
                    fillMode: Image.PreserveAspectFit


                }

                Image {
                    id: runningLight
                    source: "car-Images/running.png"
                    anchors.fill: parent
                    visible: false
                    fillMode: Image.PreserveAspectFit
                }

            }


            Rectangle {
                Layout.fillHeight: true
                Layout.fillWidth: true
                color: "lightgray"

                ColumnLayout {
                    id: controlContainer
                    width: parent.width
                    height: parent.height/1.5
                    anchors.centerIn: parent
                    spacing: 20
                    Rectangle {
                        Layout.fillHeight: true
                        Layout.fillWidth: true
                        color: "lightgray"
                        Image {
                            id: brake
                            source:  "car-icon/brake.svg"
                            anchors.fill: parent
                            fillMode: Image.PreserveAspectFit
                            visible: false

                            MouseArea {
                                id: withbrakes
                                anchors.fill: parent
                                onClicked: {
                                    console.log("withBrakes")
                                    if(platformInterface.brake_value === false) {
                                        noBrake.visible = false
                                        brake.visible = true
                                        brakeLights.visible = true
                                        platformInterface.brake_value = true
                                        if(platformInterface.hazard_value === true) {
                                            platformInterface.set_car_demo.update(true,
                                                                                  true,
                                                                                  platformInterface.brake_value,
                                                                                  platformInterface.reverse_value,
                                                                                  platformInterface.manual_value
                                                                                  )
                                        }

                                        else {
                                            platformInterface.set_car_demo.update(platformInterface.left_value,
                                                                                  platformInterface.right_value,
                                                                                  platformInterface.brake_value,
                                                                                  platformInterface.reverse_value,
                                                                                  platformInterface.manual_value
                                                                                  )
                                        }

                                    }
                                    else {
                                        noBrake.visible = true
                                        brake.visible = false
                                        brakeLights.visible = false
                                        platformInterface.brake_value = false
                                        if(platformInterface.hazard_value === true) {
                                            platformInterface.set_car_demo.update(true,
                                                                                  true,
                                                                                  platformInterface.brake_value,
                                                                                  platformInterface.reverse_value,
                                                                                  platformInterface.manual_value

                                                                                  )
                                        }
                                        else {
                                            platformInterface.set_car_demo.update(platformInterface.left_value,
                                                                                  platformInterface.right_value,
                                                                                  platformInterface.brake_value,
                                                                                  platformInterface.reverse_value,
                                                                                  platformInterface.manual_value
                                                                                  )
                                        }
                                    }
                                }

                            }

                        }


                        Image {
                            id: noBrake
                            source: "car-icon/no-brake.svg"
                            anchors.fill: parent
                            fillMode: Image.PreserveAspectFit
                            visible: false

                            MouseArea {
                                id: nobrakes
                                anchors.fill: parent
                                onClicked: {
                                    console.log("No Brakes")
                                    if(platformInterface.brake_value === false) {
                                        noBrake.visible = false
                                        brake.visible = true
                                        brakeLights.visible = true
                                        platformInterface.brake_value = true
                                        if(platformInterface.hazard_value === true) {
                                            platformInterface.set_car_demo.update(true,
                                                                                  true,
                                                                                  platformInterface.brake_value,
                                                                                  platformInterface.reverse_value,
                                                                                  platformInterface.manual_value
                                                                                  )
                                        }

                                        else {
                                            platformInterface.set_car_demo.update(platformInterface.left_value,
                                                                                  platformInterface.right_value,
                                                                                  platformInterface.brake_value,
                                                                                  platformInterface.reverse_value,
                                                                                  platformInterface.manual_value
                                                                                  )
                                        }

                                    }
                                    else {
                                        noBrake.visible = true
                                        brake.visible = false
                                        brakeLights.visible = false
                                        platformInterface.brake_value = false
                                        if(platformInterface.hazard_value === true) {
                                            platformInterface.set_car_demo.update(true,
                                                                                  true,
                                                                                  platformInterface.brake_value,
                                                                                  platformInterface.reverse_value,
                                                                                  platformInterface.manual_value

                                                                                  )
                                        }
                                        else {
                                            platformInterface.set_car_demo.update(platformInterface.left_value,
                                                                                  platformInterface.right_value,
                                                                                  platformInterface.brake_value,
                                                                                  platformInterface.reverse_value,
                                                                                  platformInterface.manual_value
                                                                                  )
                                        }
                                    }
                                }


                            }
                            property var car_demo_brake: platformInterface.car_demo.brake
                            onCar_demo_brakeChanged: {
                                console.log("car_demo_brake", car_demo_brake)
                                if(car_demo_brake === false) {
                                    brakeLights.visible = false
                                    noBrake.visible = true
                                    brake.visible = false
                                }
                                else {
                                    brakeLights.visible = true
                                    noBrake.visible = false
                                    brake.visible = true
                                }
                                platformInterface.brake_value = car_demo_brake
                            }

                        }
                    }
                    Rectangle {
                        Layout.fillHeight: true
                        Layout.fillWidth: true
                        color: "lightgray"

                        Image {
                            id: hazard
                            width: 50
                            height: 50
                            source: "car-icon/hazard.svg"
                            anchors.fill: parent
                            fillMode: Image.PreserveAspectFit
                            visible: true
                            MouseArea {
                                id: hazards
                                anchors.fill: parent
                                onClicked: {
                                    if(platformInterface.hazard_value === false) {
                                        leftSignal.visible = true
                                        rightSignal.visible = true
                                        hazard.visible = true
                                        noHazard.visible = false
                                        platformInterface.hazard_value = true
                                        blinkerContainer.enabled = false
                                        platformInterface.set_car_demo.update(true,
                                                                              true,
                                                                              platformInterface.brake_value,
                                                                              platformInterface.reverse_value,
                                                                              platformInterface.manual_value
                                                                              )
                                    }
                                    else {
                                        hazard.visible = false
                                        noHazard.visible = true
                                        leftSignal.visible = false
                                        rightSignal.visible = false
                                        platformInterface.hazard_value = false
                                        blinkerContainer.enabled = true
                                        platformInterface.set_car_demo.update(platformInterface.left_value,
                                                                              platformInterface.right_value,
                                                                              platformInterface.brake_value,
                                                                              platformInterface.reverse_value,
                                                                              platformInterface.manual_value
                                                                              )

                                    }
                                }

                            }

                        }

                        Image {
                            id: noHazard
                            width: 50
                            height: 50
                            source: "car-icon/no-hazard.svg"
                            anchors.fill: parent
                            fillMode: Image.PreserveAspectFit
                            visible: false
                            MouseArea {
                                id: noHazards
                                anchors.fill: parent
                                onClicked: {
                                    if(platformInterface.hazard_value === false) {
                                        leftSignal.visible = true
                                        rightSignal.visible = true
                                        hazard.visible = true
                                        noHazard.visible = false
                                        blinkerContainer.enabled = false
                                        platformInterface.hazard_value = true
                                        //hazard on send true for right and left
                                        platformInterface.set_car_demo.update(true,
                                                                              true,
                                                                              platformInterface.brake_value,
                                                                              platformInterface.reverse_value,
                                                                              platformInterface.manual_value
                                                                              )
                                    }
                                    else {
                                        console.log("hazard")
                                        leftSignal.visible = false
                                        rightSignal.visible = false
                                        hazard.visible = false
                                        noHazard.visible = true
                                        blinkerContainer.enabled = true
                                        platformInterface.hazard_value = false
                                        platformInterface.set_car_demo.update(platformInterface.left_value,
                                                                              platformInterface.right_value,
                                                                              platformInterface.brake_value,
                                                                              platformInterface.reverse_value,
                                                                              platformInterface.manual_value
                                                                              )

                                    }
                                }

                            }

                        }
                    }

                    Rectangle {
                        Layout.fillHeight: true
                        Layout.fillWidth: true
                        color: "lightgray"

                        Image {
                            id: reverseIcon
                            source: "car-icon/reverse.svg"
                            anchors.fill: parent
                            fillMode: Image.PreserveAspectFit
                            MouseArea {
                                id: reverseClick
                                anchors.fill: parent
                                onClicked: {
                                    if(!reverseLights.visible){
                                        reverseIcon.visible = false
                                        noReverseIcon.visible = true
                                        platformInterface.reverse_value = true
                                        if(platformInterface.hazard_value === true) {
                                            platformInterface.set_car_demo.update(true,
                                                                                  true,
                                                                                  platformInterface.brake_value,
                                                                                  platformInterface.reverse_value,
                                                                                  platformInterface.manual_value

                                                                                  )
                                        }
                                        else{

                                            platformInterface.set_car_demo.update(platformInterface.left_value,
                                                                                  platformInterface.right_value,
                                                                                  platformInterface.brake_value,
                                                                                  platformInterface.reverse_value,
                                                                                  platformInterface.manual_value

                                                                                  )
                                        }
                                    }
                                    else {
                                        reverseIcon.visible = true
                                        noReverseIcon.visible = false
                                        platformInterface.reverse_value = false
                                        if(platformInterface.hazard_value === true) {
                                            platformInterface.set_car_demo.update(true,
                                                                                  true,
                                                                                  platformInterface.brake_value,
                                                                                  platformInterface.reverse_value,
                                                                                  platformInterface.manual_value

                                                                                  )
                                        }
                                        else  {
                                            platformInterface.set_car_demo.update(platformInterface.left_value,
                                                                                  platformInterface.right_value,
                                                                                  platformInterface.brake_value,
                                                                                  platformInterface.reverse_value,
                                                                                  platformInterface.manual_value
                                                                                  )
                                        }
                                    }
                                }

                            }

                        }

                        Image {
                            id: noReverseIcon
                            source: "car-icon/drive.svg"
                            anchors.fill: parent
                            fillMode: Image.PreserveAspectFit
                            MouseArea {
                                id: noReverseClick
                                anchors.fill: parent
                                onClicked: {
                                    if(!reverseLights.visible){
                                        reverseIcon.visible = false
                                        noReverseIcon.visible = true
                                        platformInterface.reverse_value = true
                                        if(platformInterface.hazard_value === true) {
                                            platformInterface.set_car_demo.update(true,
                                                                                  true,
                                                                                  platformInterface.brake_value,
                                                                                  platformInterface.reverse_value,
                                                                                  platformInterface.manual_value

                                                                                  )
                                        }
                                        else{

                                            platformInterface.set_car_demo.update(platformInterface.left_value,
                                                                                  platformInterface.right_value,
                                                                                  platformInterface.brake_value,
                                                                                  platformInterface.reverse_value
                                                                                  ,   platformInterface.manual_value

                                                                                  )
                                        }
                                    }
                                    else {
                                        reverseIcon.visible = true
                                        noReverseIcon.visible = false
                                        platformInterface.reverse_value = false
                                        if(platformInterface.hazard_value === true) {
                                            platformInterface.set_car_demo.update(true,
                                                                                  true,
                                                                                  platformInterface.brake_value,
                                                                                  platformInterface.reverse_value,
                                                                                  platformInterface.manual_value

                                                                                  )
                                        }
                                        else  {
                                            platformInterface.set_car_demo.update(platformInterface.left_value,
                                                                                  platformInterface.right_value,
                                                                                  platformInterface.brake_value,
                                                                                  platformInterface.reverse_value,
                                                                                  platformInterface.manual_value
                                                                                  )
                                        }
                                    }
                                }

                            }

                        }

                        property var car_demo_reverse: platformInterface.car_demo.reverse
                        onCar_demo_reverseChanged: {
                            reverseLights.visible = car_demo_reverse
                            if(car_demo_reverse === true){
                                reverseIcon.visible = true
                                noReverseIcon.visible = false
                            }
                            else {
                                reverseIcon.visible = false
                                noReverseIcon.visible = true
                            }

                            platformInterface.reverse_value = car_demo_reverse
                            //console.log(platformInterface.reverse_value)
                        }

                    }

                    Rectangle{
                        id: blinkerContainer
                        Layout.fillHeight: true
                        Layout.fillWidth: true
                        color: "light gray"


                        Image{
                            id: blinkerBaseImage
                            source: "car-icon/no-signal.svg"
                            anchors.fill: parent
                            fillMode: Image.PreserveAspectFit

                            Rectangle{
                                width: parent.width/2
                                height: parent.height
                                anchors.left: parent.left
                                color: "transparent"

                                MouseArea{
                                    id: leftSignalContainer
                                    anchors.fill: parent
                                    onClicked: {
                                        platformInterface.right_value = false
                                        rightSignal.visible = false
                                        console.log("left clicked", platformInterface.left_value)
                                        if(platformInterface.left_value === false){
                                            leftSignal.visible = true
                                            blinkerBaseImage.source = "car-icon/left-signal.svg"
                                            platformInterface.left_value = true
                                            platformInterface.set_car_demo.update(true,
                                                                                  platformInterface.right_value,
                                                                                  platformInterface.brake_value,
                                                                                  platformInterface.reverse_value,
                                                                                  platformInterface.manual_value
                                                                                  )
                                        }
                                        else {
                                            leftSignal.visible = false
                                            blinkerBaseImage.source = "car-icon/no-signal.svg"
                                            platformInterface.left_value = false
                                            platformInterface.set_car_demo.update(false,
                                                                                  platformInterface.right_value,
                                                                                  platformInterface.brake_value,
                                                                                  platformInterface.reverse_value,
                                                                                  platformInterface.manual_value
                                                                                  )
                                        }

                                    }
                                }
                            }

                            Rectangle{
                                width: parent.width/2
                                height: parent.height
                                anchors.right: parent.right
                                color: "transparent"
                                MouseArea{
                                    id: rightSignalContainer
                                    anchors.fill: parent

                                    onClicked: {
                                        leftSignal.visible = false
                                        platformInterface.left_value = false
                                        console.log("right clicked", platformInterface.right_value)
                                        if(platformInterface.right_value === false) {
                                            rightSignal.visible = true
                                            blinkerBaseImage.source = "car-icon/right-signal.svg"
                                            platformInterface.right_value = true
                                            platformInterface.set_car_demo.update(platformInterface.left_value,
                                                                                  platformInterface.right_value,
                                                                                  platformInterface.brake_value,
                                                                                  platformInterface.reverse_value,
                                                                                  platformInterface.manual_value
                                                                                  )
                                        }
                                        else {
                                            rightSignal.visible = false
                                            blinkerBaseImage.source = "car-icon/no-signal.svg"
                                            platformInterface.right_value = false
                                            platformInterface.set_car_demo.update(platformInterface.left_value,
                                                                                  platformInterface.right_value,
                                                                                  platformInterface.brake_value,
                                                                                  platformInterface.reverse_value,
                                                                                  platformInterface.manual_value
                                                                                  )
                                        }

                                    }
                                }
                            }

                        }
                        property var car_demo_left: platformInterface.car_demo.left
                        onCar_demo_leftChanged: {
                            leftSignal.visible = car_demo_left
                            console.log("left on", car_demo_left)
                        }

                        property var car_demo_right: platformInterface.car_demo.right
                        onCar_demo_rightChanged: {
                            console.log("right on", car_demo_right)
                            rightSignal.visible = car_demo_right

                        }

                    }

                    Rectangle{
                        id: brigtnessContainer
                        Layout.fillHeight: true
                        Layout.fillWidth: true
                        color: "light gray"


                        Image {
                            id:  brigtnesseImage
                            source: "sun_moon_off.png"
                            anchors.fill: parent
                            fillMode: Image.PreserveAspectFit

                            Rectangle{
                                width: parent.width/2
                                height: parent.height
                                anchors.left: parent.left
                                color: "transparent"
                                MouseArea{
                                    anchors.fill: parent
                                    onClicked: {

                                        if(platformInterface.manual_value === false) {
                                            brigtnesseImage.source = "sun_moon_on.png"
                                            platformInterface.manual_value = true
                                            platformInterface.set_car_demo.update(
                                                        platformInterface.left_value,
                                                        platformInterface.right_value,
                                                        platformInterface.brake_value,
                                                        platformInterface.reverse_value,
                                                        platformInterface.manual_value
                                                        )

                                        }
                                        else {
                                            platformInterface.manual_value = "down"
                                            platformInterface.set_car_demo.update(
                                                        platformInterface.left_value,
                                                        platformInterface.right_value,
                                                        platformInterface.brake_value,
                                                        platformInterface.reverse_value,
                                                        platformInterface.manual_value
                                                        )
                                        }
                                    }
                                }

                            }
                            Rectangle{
                                width: parent.width/2
                                height: parent.height
                                anchors.right: parent.right
                                color: "transparent"
                                MouseArea{
                                    anchors.fill: parent
                                    onClicked: {
                                        if(platformInterface.manual_value === false) {
                                            brigtnesseImage.source = "sun_moon_on.png"
                                            platformInterface.manual_value = true
                                            platformInterface.set_car_demo.update(
                                                        platformInterface.left_value,
                                                        platformInterface.right_value,
                                                        platformInterface.brake_value,
                                                        platformInterface.reverse_value,
                                                        platformInterface.manual_value
                                                        )

                                        }
                                        else {
                                            platformInterface.manual_value = "up"
                                            platformInterface.set_car_demo.update(
                                                        platformInterface.left_value,
                                                        platformInterface.right_value,
                                                        platformInterface.brake_value,
                                                        platformInterface.reverse_value,
                                                        platformInterface.manual_value
                                                        )
                                        }
                                    }
                                }
                            }
                        }
                    }

                }
            }
        }
    }
}








