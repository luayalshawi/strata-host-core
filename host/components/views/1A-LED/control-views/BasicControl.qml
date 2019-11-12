import QtQuick 2.12
import QtQuick.Layouts 1.12
import QtQuick.Controls 2.12
import tech.strata.sgwidgets 0.9 as SG0_9
import tech.strata.sgwidgets 1.0
import tech.strata.fonts 1.0
import "qrc:/js/help_layout_manager.js" as Help
import "../components"

ColumnLayout {
    id: root
    //Layout.fillWidth: true
    //Layout.fillHeight: true
    anchors.fill: parent
    anchors.leftMargin: -25
    anchors.rightMargin: 25

    property real ratioCalc: root.width / 1200
    property real initialAspectRatio: 1200/820

    width: parent.width / parent.height > initialAspectRatio ? parent.height * initialAspectRatio : parent.width
    height: parent.width / parent.height < initialAspectRatio ? parent.width / initialAspectRatio : parent.height

    spacing: 15

    Component.onCompleted: {
        platformInterface.get_all_states.send()
        Help.registerTarget(platformName, "This is the platform name.", 0, "1A-LEDHelp")
        Help.registerTarget(tempGaugeLabel, "This gauge shows the temperature of the ground pad of the 3rd onboard LED.", 1, "1A-LEDHelp")
        Help.registerTarget(enableSwitchLabel, "This switch enables the LED driver.", 2, "1A-LEDHelp")
        Help.registerTarget(vinConnLabel, "This info box shows the input voltage to the board. The voltage is sensed at the cathode of the catch diode.", 3, "1A-LEDHelp")
        Help.registerTarget(vinLabel, "This info box shows the input voltage to the LEDs. The voltage is sensed directly at the anode of the 1st onboard LED.", 4, "1A-LEDHelp")
        Help.registerTarget(inputCurrentLabel, "This info box shows the input current to the board.", 5, "1A-LEDHelp")
        Help.registerTarget(voutLEDLabel, "This info box shows the output voltage of the LEDs. This voltage is sensed directly at the cathode of the 3rd onboard LED.", 6, "1A-LEDHelp")
        Help.registerTarget(csCurrentLabel, "This info box shows the approximate average value of the current through the CS resistor. This value will vary greatly at low DIM#_EN frequencies. See the FAQ for the relationship between this current and the average LED current.", 7, "1A-LEDHelp")
        Help.registerTarget(dutySliderLabel, "This slider allows you to set the duty cycle of the DIM#_EN PWM signal. The duty cycle can be reduced to decrease the average LED current.", 8, "1A-LEDHelp")
        Help.registerTarget(freqSliderLabel, "This slider allows you to set the frequency of the DIM#_EN PWM signal.", 9, "1A-LEDHelp")
        Help.registerTarget(ledConfigLabel, "This combo box allows you to choose the operating mode for the LEDs. See the FAQ for more info on the different LED configurations.", 10, "1A-LEDHelp")
    }

    Text {
        id: platformName
        Layout.alignment: Qt.AlignHCenter
        text: "NCL30160 1A LED Driver"
        font.bold: true
        font.pixelSize: ratioCalc * 40
        topPadding: 20
    }



    property var lcsm_change:  platformInterface.telemetry.lcsm
    onLcsm_changeChanged: {
        csCurrent.text = lcsm_change
    }

    property var gcsm_change:  platformInterface.telemetry.gcsm
    onGcsm_changeChanged: {
        inputCurrent.text = gcsm_change
    }

    property var vin_change:  platformInterface.telemetry.vin
    onVin_changeChanged: {
        vin.text = vin_change
    }

    property var vout_change:  platformInterface.telemetry.vout
    onVout_changeChanged: {
        voutLED.text =  vout_change
    }

    //control properties

    property var control_states_enable: platformInterface.control_states.enable
    onControl_states_enableChanged: {
        if(control_states_enable === "on")
            enableSwitch.checked = true
        else enableSwitch.checked = false
    }

    property var control_states_dim_en_duty: platformInterface.control_states.dim_en_duty

    onControl_states_dim_en_dutyChanged: {
        dutySlider.value = control_states_dim_en_duty
    }

    property var control_states_dim_en_freq: platformInterface.control_states.dim_en_freq

    onControl_states_dim_en_freqChanged: {
        freqSlider.value = control_states_dim_en_freq
    }

    property var control_states_led_config: platformInterface.control_states.led_config
    onControl_states_led_configChanged: {
        if(control_states_led_config !== "") {
            for(var i = 0; i < ledConfigCombo.model.length; ++i){
                if(control_states_led_config === ledConfigCombo.model[i]){
                    ledConfigCombo.currentIndex = i
                    return
                }
            }
        }
    }


    Popup{
        id: warningPopupOsAlert
        width: root.width/1.7
        height: root.height/3
        anchors.centerIn: parent
        modal: true
        focus: true
        closePolicy:Popup.NoAutoClose
        background: Rectangle{
            id: warningContainerForOsAlert
            width: warningPopupOsAlert.width
            height: warningPopupOsAlert.height
            color: "white"
            border.color: "black"
            border.width: 4
            radius: 10
        }

        Rectangle {
            id: warningBoxForOsAlert
            color: "transparent"
            anchors {
                top: parent.top
                topMargin: 5
                horizontalCenter: parent.horizontalCenter
            }
            width: warningContainerForOsAlert.width - 50
            height: warningContainerForOsAlert.height - 50

            Rectangle {
                id:warningLabelForOsAlert
                width: warningBoxForOsAlert.width - 100
                height: parent.height/5
                color:"red"
                anchors {
                    horizontalCenter: parent.horizontalCenter
                    top:parent.top
                }

                Text {
                    id: warningLabelTextForOsAlert
                    anchors.centerIn: warningLabelForOsAlert
                    text: "<b>WARNING</b>"
                    font.pixelSize: ratioCalc * 15
                    color: "white"
                }

                Text {
                    id: warningIconLeft
                    anchors {
                        right: warningLabelTextForOsAlert.left
                        verticalCenter: warningLabelTextForOsAlert.verticalCenter
                        rightMargin: 10
                    }
                    text: "\ue80e"
                    font.family: Fonts.sgicons
                    font.pixelSize: (parent.width + parent.height)/25
                    color: "white"
                }

                Text {
                    id: warningIconRight
                    anchors {
                        left: warningLabelTextForOsAlert.right
                        verticalCenter: warningLabelTextForOsAlert.verticalCenter
                        leftMargin: 10
                    }
                    text: "\ue80e"
                    font.family: Fonts.sgicons
                    font.pixelSize: (parent.width + parent.height)/25
                    color: "white"
                }

            }

            Rectangle {
                id: messageContainerForOsAlert
                anchors {
                    top: warningLabelForOsAlert.bottom
                    topMargin: 10
                    centerIn:  parent.Center
                }
                color: "transparent"
                width: parent.width
                height:  parent.height - warningLabelForOsAlert.height - selectionContainerForOsAlert.height
                Text {
                    id: warningTextForForOsAlert
                    anchors.fill:parent
                    text:  "The temperature of the onboard LEDs has exceeded the specified temperature threshold. The duty cycle of the DIM#/EN signal is now being reduced automatically to bring the LED temperature to a safe operating region. The duty cycle cannot be adjusted during this time period unless the device is disabled."
                    verticalAlignment:  Text.AlignVCenter
                    horizontalAlignment: Text.AlignHCenter
                    wrapMode: Text.WordWrap
                    fontSizeMode: Text.Fit
                    width: parent.width
                    font.bold: true
                    font.pixelSize: ratioCalc * 15
                }
            }

            Rectangle {
                id: selectionContainerForOsAlert
                width: parent.width
                height: parent.height/4.5
                anchors{
                    top: messageContainerForOsAlert.bottom
                }
                color: "transparent"

                Rectangle {
                    id: okButtonForOsAlert
                    width: parent.width/2
                    height:parent.height
                    anchors.centerIn: parent
                    color: "transparent"


                    SGButton {
                        anchors.centerIn: parent
                        text: "OK"
                        color: checked ? "#353637" : pressed ? "#cfcfcf": hovered ? "#eee" : "#e0e0e0"
                        roundedLeft: true
                        roundedRight: true
                        onClicked: {
                            warningPopupOsAlert.close()
                        }
                    }
                }
            }
        }
    }


    RowLayout {
        id: mainSetting
        Layout.fillWidth: true
        Layout.maximumHeight: parent.height / 1.3
        Layout.alignment: Qt.AlignCenter

        Rectangle{
            id: mainSettingContainer
            Layout.fillWidth: true
            Layout.fillHeight: true
            color:"transparent"

            ColumnLayout{
                anchors {
                    margins: 15
                    fill: parent
                }

                Rectangle {
                    id: enableSwitchContainer
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    SGAlignedLabel {
                        id: enableSwitchLabel
                        target: enableSwitch
                        text: "Enable"
                        font.bold: true
                        alignment: SGAlignedLabel.SideTopCenter
                        anchors.centerIn: parent
                        fontSizeMultiplier: ratioCalc * 1.3
                        CustomSGSwitch{
                            id: enableSwitch
                            height: 35 * ratioCalc
                            width: 95 * ratioCalc
                            labelsInside: true
                            checkedLabel: "On"
                            uncheckedLabel:   "Off"
                            textColor: "black"              // Default: "black"
                            handleColor: "white"            // Default: "white"
                            grooveColor: "#ccc"             // Default: "#ccc"
                            grooveFillColor: "#0cf"         // Default: "#0cf"
                            checked: true
                            fontSizeMultiplier: ratioCalc * 1.3

                            onToggled: {
                                checked ? platformInterface.set_enable.update("on") : platformInterface.set_enable.update("off")
                            }
                        }

                    }
                }

                Rectangle {
                    id: dutySliderContainer
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    color: "transparent"

                    SGAlignedLabel {
                        id: dutySliderLabel
                        target: dutySlider
                        text: "DIM#/EN Positive Duty Cycle"
                        font.bold: true
                        alignment: SGAlignedLabel.SideTopCenter
                        fontSizeMultiplier: ratioCalc * 1.3
                        anchors.centerIn: parent

                        SGSlider{
                            id: dutySlider
                            width: dutySliderContainer.width/1.3
                            from: 0
                            to: 100
                            fromText.text: "0 %"
                            toText.text: "100 %"
                            stepSize: 0.1
                            live: false
                            fontSizeMultiplier: ratioCalc * 1.2
                            inputBox.validator: DoubleValidator {

                                top: dutySlider.to
                                bottom: dutySlider.from
                            }

                            onUserSet: {
                                platformInterface.set_dim_en_duty.update(value)

                            }


                        }

                    }

                }

                Rectangle {
                    id: freqSliderContainer
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    color: "transparent"
                    SGAlignedLabel {
                        id: freqSliderLabel
                        target: freqSlider
                        text: "DIM#/EN Frequency"
                        alignment: SGAlignedLabel.SideTopCenter
                        fontSizeMultiplier: ratioCalc * 1.3
                        anchors.centerIn: parent
                        font.bold: true

                        SGSlider{
                            id: freqSlider
                            width: freqSliderContainer.width/1.3
                            from: 0.1
                            to: 10
                            stepSize: 0.001
                            value: 1
                            fromText.text: "0.1kHz"
                            toText.text: "10kHz"
                            live: false
                            fontSizeMultiplier: ratioCalc * 1.2
                            inputBox.validator: DoubleValidator {
                                top: freqSlider.to
                                bottom: freqSlider.from
                            }

                            onUserSet:  {
                                platformInterface.set_dim_en_freq.update(value)
                            }

                        }
                    }
                }

                Rectangle {
                    id:ledConfigContainer
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    color: "transparent"

                    SGAlignedLabel {
                        id: ledConfigLabel
                        target: ledConfigCombo
                        text: "LED Configuration"
                        horizontalAlignment: Text.AlignHCenter
                        font.bold : true
                        alignment: SGAlignedLabel.SideTopCenter
                        anchors.centerIn: parent
                        fontSizeMultiplier: ratioCalc * 1.3

                        SGComboBox {
                            id: ledConfigCombo
                            model: ["1 LED","2 LEDs","3 LEDs", "External LEDs", "Shorted"]
                            borderColor: "black"
                            textColor: "black"          // Default: "black"
                            indicatorColor: "black"
                            fontSizeMultiplier:  ratioCalc * 1.2
                            onActivated: {
                                if(currentIndex == 0)
                                    platformInterface.set_led.update("1_led")
                                else if(currentIndex == 1)
                                    platformInterface.set_led.update("2_leds")
                                else if (currentIndex == 2)
                                    platformInterface.set_led.update("3_leds")
                                else if(currentIndex == 3)
                                    platformInterface.set_led.update("external")
                                else  platformInterface.set_led.update("short")
                            }
                        }
                    }
                }


            }
        }

        Rectangle {
            id: telemetryContainer
            Layout.fillWidth: true
            Layout.fillHeight: true
            color: "transparent"

            ColumnLayout {
                anchors{
                    fill: parent
                    margins: 15
                }

                Rectangle {
                    id: infoBoxRow1Container
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    color: "transparent"
                    RowLayout {
                        anchors {
                            margins: 10
                            fill: parent
                        }
                        Rectangle {
                            id: vinConnContainer
                            Layout.fillWidth: true
                            Layout.fillHeight: true
                            color:"transparent"
                            SGAlignedLabel {
                                id: vinConnLabel
                                text: "<b>Input Voltage<br>(VIN_CONN)</b>"
                                target: vin_conn
                                alignment: SGAlignedLabel.SideTopCenter
                                anchors.centerIn: parent
                                fontSizeMultiplier: ratioCalc * 1.3

                                font.bold : true

                                SGInfoBox {
                                    id: vin_conn
                                    height:  35 * ratioCalc
                                    width: 140 * ratioCalc
                                    unit: "<b>V</b>"
                                    text: platformInterface.telemetry.vin_conn
                                    fontSizeMultiplier: ratioCalc === 0 ? 1.0 : ratioCalc * 1.3
                                    boxFont.family: Fonts.digitalseven
                                    unitFont.bold: true
                                }
                            }
                        }
                        Rectangle {
                            id: vinContainer
                            Layout.fillWidth: true
                            Layout.fillHeight: true
                            color: "transparent"
                            SGAlignedLabel {
                                id: vinLabel
                                text: "<b>LED Input Voltage<br>(VIN)</b>"
                                target: vin
                                alignment: SGAlignedLabel.SideTopCenter
                                anchors.centerIn: parent
                                fontSizeMultiplier: ratioCalc * 1.3
                                font.bold : true

                                SGInfoBox {
                                    id: vin
                                    height:  35 * ratioCalc
                                    width: 140 * ratioCalc
                                    unit: "<b>V</b>"
                                    text: platformInterface.telemetry.vin
                                    fontSizeMultiplier: ratioCalc === 0 ? 1.0 : ratioCalc * 1.3
                                    boxFont.family: Fonts.digitalseven
                                    unitFont.bold: true
                                }
                            }
                        }
                        Rectangle {
                            id: inputCurrentContainer
                            Layout.fillWidth: true
                            Layout.fillHeight: true
                            color: "transparent"
                            SGAlignedLabel {
                                id: inputCurrentLabel
                                text: "<b>Input Current<br>(GCSM)</b>"
                                target: inputCurrent
                                alignment: SGAlignedLabel.SideTopCenter
                                anchors.centerIn: parent
                                fontSizeMultiplier: ratioCalc * 1.3
                                font.bold : true

                                SGInfoBox {
                                    id: inputCurrent
                                    height:  35 * ratioCalc
                                    width: 140 * ratioCalc
                                    unit: "<b>mA</b>"
                                    text: platformInterface.telemetry.gcsm
                                    fontSizeMultiplier: ratioCalc === 0 ? 1.0 : ratioCalc * 1.3
                                    boxFont.family: Fonts.digitalseven
                                    unitFont.bold: true
                                }
                            }
                        }
                    }
                }

                Rectangle {
                    id: infoBoxRow2Container
                    Layout.fillWidth: true
                    Layout.fillHeight: true

                    color: "transparent"
                    RowLayout {
                        anchors {
                            topMargin: 20
                            fill: parent
                            // margins: 10
                        }

                        Rectangle {
                            id:  vledContainer
                            Layout.fillWidth: true
                            Layout.fillHeight: true
                            color:"transparent"
                            SGAlignedLabel {
                                id: vledLabel
                                text: "<b>Approximate LED<br>Voltage</b>"
                                target: vled
                                alignment: SGAlignedLabel.SideTopCenter
                                anchors.centerIn: parent
                                fontSizeMultiplier: ratioCalc * 1.3
                                font.bold : true
                                SGInfoBox {
                                    id: vled
                                    height:  35 * ratioCalc
                                    width: 140 * ratioCalc
                                    fontSizeMultiplier: ratioCalc === 0 ? 1.0 : ratioCalc * 1.3
                                    unit: "<b>V</b>"
                                    text: platformInterface.telemetry.vled
                                    boxFont.family: Fonts.digitalseven
                                }

                            }
                        }

                        Rectangle {
                            id:  voutLEDContainer
                            Layout.fillWidth: true
                            Layout.fillHeight: true
                            color:"transparent"
                            SGAlignedLabel {
                                id: voutLEDLabel
                                text: "<b>LED Output Voltage<br>(VOUT_LED)</b>"
                                target: voutLED
                                alignment: SGAlignedLabel.SideTopCenter
                                anchors.centerIn: parent
                                fontSizeMultiplier: ratioCalc * 1.3
                                font.bold : true
                                SGInfoBox {
                                    id: voutLED
                                    height:  35 * ratioCalc
                                    width: 140 * ratioCalc
                                    fontSizeMultiplier: ratioCalc === 0 ? 1.0 : ratioCalc * 1.3
                                    unit: "<b>V</b>"
                                    text: platformInterface.telemetry.vout
                                    boxFont.family: Fonts.digitalseven
                                }

                            }
                        }

                        Rectangle {
                            id:  csCurrentContainer
                            Layout.fillWidth: true
                            Layout.fillHeight: true
                            color:"transparent"
                            SGAlignedLabel {
                                id: csCurrentLabel
                                text: "<b>Average CS Current<br>(LCSM)</b>"
                                target: csCurrent
                                alignment: SGAlignedLabel.SideTopCenter
                                anchors.centerIn: parent
                                fontSizeMultiplier: ratioCalc * 1.3
                                font.bold : true
                                SGInfoBox {
                                    id: csCurrent
                                    height:  35 * ratioCalc
                                    width: 140 * ratioCalc
                                    fontSizeMultiplier: ratioCalc === 0 ? 1.0 : ratioCalc * 1.3
                                    unit: "<b>mA</b>"
                                    text:  platformInterface.telemetry.lcsm
                                    boxFont.family: Fonts.digitalseven
                                }

                            }
                        }
                    }

                }

                Rectangle {
                    id: temperatureContainer
                    Layout.fillWidth: true
                    Layout.preferredHeight: parent.height/1.5
                    color: "transparent"

                    RowLayout {
                        anchors.fill: parent

                        Rectangle {
                            id: osAlertSettingsContainer
                            Layout.fillWidth: true
                            Layout.preferredHeight: parent.height/1.3

                            color: "transparent"
                            ColumnLayout {
                                anchors.fill: parent
                                Rectangle {
                                    id:  osAlertThresholdContainer
                                    Layout.fillWidth: true
                                    Layout.fillHeight: true
                                    color:"white"
                                    SGAlignedLabel {
                                        id:osAlertThresholdLabel
                                        text: "<b>Set OS#/ALERT# </b><br><b>Temperature Threshold</b>"
                                        target: osAlertThreshold
                                        alignment: SGAlignedLabel.SideTopCenter
                                        anchors.centerIn: parent
                                        fontSizeMultiplier: ratioCalc * 1.3
                                        font.bold : true
                                        CustomSGSubmitInfoBox {
                                            id: osAlertThreshold
                                            infoBoxHeight:  35 * ratioCalc
                                            infoBoxWidth: 140 * ratioCalc
                                            fontSizeMultiplier: ratioCalc === 0 ? 1.0 : ratioCalc * 1.3
                                            unit: "<b>°C</b>"
                                            validator: DoubleValidator {
                                                top: 110
                                                bottom: -55
                                            }
                                            buttonText: "Apply"
                                            placeholderText: platformInterface.control_states.os_alert_threshold
                                            onAccepted: {
                                                platformInterface.set_os_alert.update(value)
                                            }
                                        }
                                    }
                                }

                                Rectangle {
                                    id: osAlertContainer
                                    Layout.fillWidth: true
                                    Layout.fillHeight: true
                                    SGAlignedLabel {
                                        id: osAlertLabel
                                        target: osAlert
                                        text:  "OS#/ALERT#"
                                        alignment: SGAlignedLabel.SideLeftCenter
                                        anchors {
                                            top: parent.top
                                            topMargin: 10
                                            centerIn: parent
                                        }
                                        fontSizeMultiplier: ratioCalc * 1.3
                                        font.bold : true

                                        property bool osAlertNoti: platformInterface.int_os_alert.value
                                        onOsAlertNotiChanged: {
                                            if(osAlertNoti == true) {
                                                osAlert.status =  SGStatusLight.Red
                                            }
                                            else osAlert.status = SGStatusLight.Off
                                        }

                                        property var foldback_status_value: platformInterface.foldback_status.value
                                        onFoldback_status_valueChanged: {
                                            console.log("foldback_status_value",foldback_status_value)
                                            if(foldback_status_value === "on") {
                                                if (!warningPopupOsAlert.opened) {
                                                    warningPopupOsAlert.open()
                                                }
                                                dutySliderContainer.enabled = false
                                                dutySliderContainer.opacity = 0.5
                                            }
                                            else  {
                                                dutySliderContainer.enabled = true
                                                dutySliderContainer.opacity = 1.0
                                            }
                                        }

                                        SGStatusLight {
                                            id: osAlert
                                        }

                                    }
                                }
                            }
                        }

                        Rectangle{
                            id: tempGaugeContainer
                            Layout.fillHeight: true
                            Layout.fillWidth: true
                            Layout.topMargin: 5
                            color:"transparent"
                            SGAlignedLabel {
                                id: tempGaugeLabel
                                target: tempGauge
                                text: "Board \n Temperature"
                                margin: -40
                                anchors.top: parent.top
                                anchors.centerIn: parent
                                alignment: SGAlignedLabel.SideBottomCenter
                                fontSizeMultiplier: ratioCalc * 1.3
                                font.bold : true
                                horizontalAlignment: Text.AlignHCenter

                                SGCircularGauge {
                                    id: tempGauge

                                    property var temp_change: platformInterface.telemetry.temperature
                                    onTemp_changeChanged: {
                                        value = temp_change
                                    }

                                    tickmarkStepSize: 10
                                    minimumValue: 0
                                    maximumValue: 120
                                    gaugeFillColor1: "blue"
                                    gaugeFillColor2: "red"
                                    unitText: "°C"
                                    unitTextFontSizeMultiplier: ratioCalc * 2.2
                                    valueDecimalPlaces: 1
                                    Behavior on value { NumberAnimation { duration: 300 } }
                                    function lerpColor (color1, color2, x){
                                        if (Qt.colorEqual(color1, color2)){
                                            return color1;
                                        } else {
                                            return Qt.rgba(
                                                        color1.r * (1 - x) + color2.r * x,
                                                        color1.g * (1 - x) + color2.g * x,
                                                        color1.b * (1 - x) + color2.b * x, 1
                                                        );
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



