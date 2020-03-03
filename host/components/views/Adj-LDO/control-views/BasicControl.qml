import QtQuick 2.12
import QtQuick.Layouts 1.12
import tech.strata.sgwidgets 1.0
import QtQuick.Controls 2.12
import tech.strata.sgwidgets 0.9 as Widget09
import tech.strata.fonts 1.0
import "qrc:/js/help_layout_manager.js" as Help

Item {
    id: root
    property real ratioCalc: root.width / 1200

    property real initialAspectRatio: 1200/820
    property string warningTextIs: "DO NOT exceed LDO input voltage of 5.5V"

    anchors.centerIn: parent
    width: parent.width / parent.height > initialAspectRatio ? parent.height * initialAspectRatio : parent.width
    height: parent.width / parent.height < initialAspectRatio ? parent.width / initialAspectRatio : parent.height

    property var ext_load_checked: platformInterface.ext_load_status.value
    onExt_load_checkedChanged: {
        if (ext_load_checked === true) extLoadCheckbox.checked = true
        else extLoadCheckbox.checked = false
    }

    property var telemetry_notification: platformInterface.telemetry
    onTelemetry_notificationChanged: {
        tempGauge.value = telemetry_notification.board_temp
        efficiencyGauge.value = telemetry_notification.eff_ldo
        powerDissipatedGauge.value = telemetry_notification.ploss
        powerOutputGauge.value = telemetry_notification.pout_ldo

        externalInputVoltage.text = telemetry_notification.vin_ext
        usb5VVoltage.text = telemetry_notification.usb_5v
        ldoInputVoltage.text = telemetry_notification.vin_ldo
        ldoOutputVoltage.text = telemetry_notification.vout_ldo
        boardInputCurrent.text = telemetry_notification.iin
        ldoOutputCurrent.text = telemetry_notification.iout

    }

    Component.onCompleted: {
        platformInterface.get_all_states.send()
        Help.registerTarget(tempLabel, "aaa", 0, "AdjLDOBasicHelp")
        Help.registerTarget(efficiencyLabel, "aaa", 1, "AdjLDOBasicHelp")
        Help.registerTarget(powerDissipatedLabel, "aaa", 2, "AdjLDOBasicHelp")
        Help.registerTarget(outputPowerContainer, "aaa", 3, "AdjLDOBasicHelp")
        Help.registerTarget(vinReadyLabel, "aaa", 4, "AdjLDOBasicHelp")
        Help.registerTarget(pgoodLabel, "aaa", 5, "AdjLDOBasicHelp")
        Help.registerTarget(intLdoTempLabel, "aaa", 6, "AdjLDOBasicHelp")
        Help.registerTarget(boardInputLabel, "aaa", 7, "AdjLDOBasicHelp")
        Help.registerTarget(ldoInputLabel, "aaa", 8, "AdjLDOBasicHelp")
        Help.registerTarget(ldoPackageLabel, "aaa", 9, "AdjLDOBasicHelp")
        Help.registerTarget(ldoEnableSwitchLabel, "aaa", 10, "AdjLDOBasicHelp")
        Help.registerTarget(ldoInputVolSliderLabel, "aaa", 11, "AdjLDOBasicHelp")
        Help.registerTarget(externalInputVoltageLabel, "aaa", 12, "AdjLDOBasicHelp")
        Help.registerTarget(usb5VVoltageLabel, "aaa", 13, "AdjLDOBasicHelp")
        Help.registerTarget(ldoInputVoltageLabel, "aaa", 14, "AdjLDOBasicHelp")
        Help.registerTarget(ldoOutputVoltageLabel, "aaa", 15, "AdjLDOBasicHelp")
        Help.registerTarget(boardInputCurrentLabel, "aaa", 16, "AdjLDOBasicHelp")
        Help.registerTarget(ldoOutputCurrentLabel, "aaa", 17, "AdjLDOBasicHelp")
        Help.registerTarget(setLDOOutputVoltageLabel, "aaa", 18, "AdjLDOBasicHelp")
        Help.registerTarget(loadEnableSwitchLabel, "aaa", 19 , "AdjLDOBasicHelp")
        Help.registerTarget(extLoadCheckboxLabel, "aaa", 20, "AdjLDOBasicHelp")
        Help.registerTarget(setLoadCurrentLabel, "aaa", 21, "AdjLDOBasicHelp")

    }

    property var control_states: platformInterface.control_states
    onControl_statesChanged: {
        if(control_states.vin_sel === "USB 5V")  boardInputComboBox.currentIndex = 0
        else if(control_states.vin_sel === "External") boardInputComboBox.currentIndex = 1
        else if (control_states.vin_sel === "Off") boardInputComboBox.currentIndex = 2

        if(control_states.vin_ldo_sel === "Bypass") ldoInputComboBox.currentIndex = 0
        else if (control_states.vin_ldo_sel === "Buck Regulator") ldoInputComboBox.currentIndex = 1
        else if (control_states.vin_ldo_sel === "Off") ldoInputComboBox.currentIndex = 2
        else if (control_states.vin_ldo_sel === "Isolated") ldoInputComboBox.currentIndex = 3

        ldoInputVolSlider.value = control_states.vin_ldo_set
        setLDOOutputVoltage.value = control_states.vout_ldo_set
        setLoadCurrent.value = control_states.load_set

        if(control_states.load_en === "on")
            loadEnableSwitch.checked = true
        else loadEnableSwitch.checked = false

        if(control_states.ldo_sel === "TSOP5")  ldoPackageComboBox.currentIndex = 0
        else if(control_states.ldo_sel === "DFN6") ldoPackageComboBox.currentIndex = 1
        else if (control_states.ldo_sel === "DFN8") ldoPackageComboBox.currentIndex = 2

        if(control_states.ldo_en === "on")
            ldoEnableSwitch.checked = true
        else ldoEnableSwitch.checked = false

    }

    property var variant_name: platformInterface.variant_name.value
    onVariant_nameChanged: {
        if(variant_name === "NCP164C_TSOP5") {
            warningTextIs = "DO NOT exceed LDO input voltage of 5V"
            //"Set LDO Output Voltage" PlaceHolder
            setLDOOutputVoltage.fromText.text = "1.1V"
            setLDOOutputVoltage.toText.text =  "4.7V"
            setLDOOutputVoltage.from = 1.1
            setLDOOutputVoltage.to = 4.7

            //"Set LDO Input Voltage" Placeholder
            ldoInputVolSlider.fromText.text ="1.5V"
            ldoInputVolSlider.toText.text =  "5V"
            ldoInputVolSlider.from = 1.5
            ldoInputVolSlider.to = 5

        }
        else if (variant_name === "NCP164A_DFN6") {
            warningTextIs = "DO NOT exceed LDO input voltage of 5.5V"
            //"Set LDO Output Voltage" PlaceHolder
            setLDOOutputVoltage.fromText.text ="1.1V"
            setLDOOutputVoltage.toText.text =  "5.2V"
            setLDOOutputVoltage.from = 1.1
            setLDOOutputVoltage.to = 5.2

            //"Set LDO Input Voltage" Placeholder
            ldoInputVolSlider.fromText.text ="1.5V"
            ldoInputVolSlider.toText.text =  "5.5V"
            ldoInputVolSlider.from = 1.5
            ldoInputVolSlider.to = 5.5
        }
        else if (variant_name === "NCP164C_DFN8") {
            warningTextIs = "DO NOT exceed LDO input voltage of 5V"
            //"Set LDO Output Voltage" PlaceHolder
            setLDOOutputVoltage.fromText.text ="1.1V"
            setLDOOutputVoltage.toText.text =  "4.7V"
            setLDOOutputVoltage.from = 1.1
            setLDOOutputVoltage.to = 4.7

            //"Set LDO Input Voltage" Placeholder
            ldoInputVolSlider.fromText.text ="1.5V"
            ldoInputVolSlider.toText.text =  "5V"
            ldoInputVolSlider.from = 1.5
            ldoInputVolSlider.to = 5
        }
        else if (variant_name === "NCV8164A_TSOP5") {
            warningTextIs = "DO NOT exceed LDO input voltage of 5.5V"
            //"Set LDO Output Voltage" PlaceHolder
            setLDOOutputVoltage.fromText.text ="1.2V"
            setLDOOutputVoltage.toText.text =  "5.2V"
            setLDOOutputVoltage.from = 1.2
            setLDOOutputVoltage.to = 5.2

            //"Set LDO Input Voltage" Placeholder
            ldoInputVolSlider.fromText.text ="1.5V"
            ldoInputVolSlider.toText.text =  "5.5V"
            ldoInputVolSlider.from = 1.5
            ldoInputVolSlider.to = 5.5
        }
        else if (variant_name === "NCV8164C_DFN6") {
            warningTextIs = "DO NOT exceed LDO input voltage of 5V"
            //"Set LDO Output Voltage" PlaceHolder
            setLDOOutputVoltage.fromText.text ="1.2V"
            setLDOOutputVoltage.toText.text =  "4.7V"
            setLDOOutputVoltage.from = 1.2
            setLDOOutputVoltage.to = 4.7

            //"Set LDO Input Voltage" Placeholder
            ldoInputVolSlider.fromText.text ="1.5V"
            ldoInputVolSlider.toText.text =  "5V"
            ldoInputVolSlider.from = 1.5
            ldoInputVolSlider.to = 5
        }
        else if (variant_name === "NCV8164A_DFN8") {
            warningTextIs = "DO NOT exceed LDO input voltage of 5.5V"
            //"Set LDO Output Voltage" PlaceHolder
            setLDOOutputVoltage.fromText.text ="1.2V"
            setLDOOutputVoltage.toText.text =  "5.2V"
            setLDOOutputVoltage.from = 1.1
            setLDOOutputVoltage.to = 5.2

            //"Set LDO Input Voltage" Placeholder
            ldoInputVolSlider.fromText.text ="1.5V"
            ldoInputVolSlider.toText.text =  "5.5V"
            ldoInputVolSlider.from = 1.5
            ldoInputVolSlider.to = 5.5
        }
    }

    ColumnLayout {
        anchors.fill :parent
        Text {
            text:  " NCP164/NCV8164 \n Low-noise, High PSRR Linear Regulator"
            font.bold: true
            horizontalAlignment: Text.AlignHCenter
            font.pixelSize: ratioCalc * 20
            color: "black"
            Layout.alignment: Qt.AlignHCenter
            Layout.topMargin: 10
        }

        Rectangle {
            Layout.fillWidth: true
            Layout.preferredHeight: root.height/2.8
            color: "transparent"

            RowLayout {
                anchors.fill: parent

                Rectangle {
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    RowLayout {
                        anchors.fill: parent
                        Rectangle {
                            id: tempGaugeContainer
                            Layout.fillHeight: true
                            Layout.fillWidth: true
                            color: "transparent"
                            SGAlignedLabel {
                                id: tempLabel
                                target: tempGauge
                                text: "Board \n Temperature"
                                margin: 0

                                alignment: SGAlignedLabel.SideBottomCenter
                                fontSizeMultiplier:  ratioCalc
                                font.bold : true
                                anchors.centerIn: parent
                                horizontalAlignment: Text.AlignHCenter

                                SGCircularGauge {
                                    id: tempGauge
                                    minimumValue: -55
                                    maximumValue: 125
                                    width: tempGaugeContainer.width
                                    height: tempGaugeContainer.height/1.6
                                    anchors.centerIn: parent
                                    gaugeFillColor1: "blue"
                                    gaugeFillColor2: "red"
                                    tickmarkStepSize: 20
                                    unitText: "˚C"

                                    unitTextFontSizeMultiplier: ratioCalc * 2.5
                                    //value:platformInterface.status_temperature_sensor.temperature
                                    valueDecimalPlaces: 1
                                    //Behavior on value { NumberAnimation { duration: 300 } }
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

                        Rectangle {
                            id: efficiencyGaugeContainer
                            Layout.fillHeight: true
                            Layout.fillWidth: true
                            color: "transparent"
                            SGAlignedLabel {
                                id: efficiencyLabel
                                target: efficiencyGauge
                                text: "Efficiency"
                                margin: 0
                                anchors.centerIn: parent
                                alignment: SGAlignedLabel.SideBottomCenter
                                fontSizeMultiplier:  ratioCalc
                                font.bold : true
                                horizontalAlignment: Text.AlignHCenter
                                SGCircularGauge {
                                    id: efficiencyGauge
                                    minimumValue: 0
                                    maximumValue: 100
                                    tickmarkStepSize: 10
                                    gaugeFillColor1: "red"
                                    gaugeFillColor2:  "green"
                                    width: efficiencyGaugeContainer.width
                                    height: efficiencyGaugeContainer.height/1.6
                                    anchors.centerIn: parent
                                    unitText: "%"
                                    unitTextFontSizeMultiplier: ratioCalc * 2.5
                                    //value: platformInterface.status_voltage_current.efficiency
                                    valueDecimalPlaces: 1
                                    // Behavior on value { NumberAnimation { duration: 300 } }

                                }
                            }
                        }

                        Rectangle {
                            id: powerDissipatedContainer
                            Layout.fillHeight: true
                            Layout.fillWidth: true
                            color: "transparent"
                            SGAlignedLabel {
                                id: powerDissipatedLabel
                                target: powerDissipatedGauge
                                text: "Power Loss"
                                margin: 0
                                anchors.centerIn: parent
                                alignment: SGAlignedLabel.SideBottomCenter
                                fontSizeMultiplier:   ratioCalc
                                font.bold : true
                                horizontalAlignment: Text.AlignHCenter

                                SGCircularGauge {
                                    id: powerDissipatedGauge
                                    minimumValue: 0
                                    maximumValue: 2.01
                                    tickmarkStepSize: 0.2
                                    gaugeFillColor1:"green"
                                    gaugeFillColor2:"red"
                                    width: powerDissipatedContainer.width
                                    height: powerDissipatedContainer.height/1.6
                                    anchors.centerIn: parent
                                    unitTextFontSizeMultiplier: ratioCalc * 2.5
                                    unitText: "W"
                                    valueDecimalPlaces: 3
                                    //value: platformInterface.status_voltage_current.power_dissipated
                                    //Behavior on value { NumberAnimation { duration: 300 } }
                                }
                            }
                        }

                        Rectangle {
                            id: outputPowerContainer
                            Layout.fillHeight: true
                            Layout.fillWidth: true
                            color: "transparent"

                            SGAlignedLabel {
                                id: outputPowerLabel
                                target: powerOutputGauge
                                text: "Output Power"
                                margin: 0
                                anchors.centerIn: parent
                                alignment: SGAlignedLabel.SideBottomCenter
                                fontSizeMultiplier: ratioCalc
                                font.bold : true
                                horizontalAlignment: Text.AlignHCenter

                                SGCircularGauge {
                                    id: powerOutputGauge
                                    minimumValue: 0
                                    maximumValue:  3.01
                                    tickmarkStepSize: 0.2
                                    gaugeFillColor1:"green"
                                    gaugeFillColor2:"red"
                                    width: outputPowerContainer.width
                                    height: outputPowerContainer.height/1.6
                                    anchors.centerIn: parent
                                    unitText: "W"
                                    valueDecimalPlaces: 3
                                    unitTextFontSizeMultiplier: ratioCalc * 2.5
                                    //Behavior on value { NumberAnimation { duration: 300 } }

                                }
                            }
                        }
                    }
                }

                Rectangle {
                    Layout.fillHeight: true
                    Layout.fillWidth: true

                    RowLayout {
                        anchors.fill:parent

                        Rectangle {
                            Layout.fillHeight: true
                            Layout.fillWidth: true
                            SGAlignedLabel {
                                id:vinReadyLabel
                                target: vinReadyLight
                                alignment: SGAlignedLabel.SideTopCenter
                                anchors.centerIn: parent
                                fontSizeMultiplier: ratioCalc
                                text: "VIN_LDO Ready \n (Above 1.6V)"
                                font.bold: true

                                SGStatusLight {
                                    id: vinReadyLight
                                    property var vin_ldo_good: platformInterface.int_status.vin_ldo_good
                                    onVin_ldo_goodChanged: {
                                        if(vin_ldo_good === true)
                                            vinReadyLight.status  = SGStatusLight.Green

                                        else vinReadyLight.status  = SGStatusLight.Off
                                    }
                                }
                            }
                        }
                        Rectangle {
                            Layout.fillHeight: true
                            Layout.fillWidth: true
                            SGAlignedLabel {
                                id:pgoodLabel
                                target: pgoodLight
                                alignment: SGAlignedLabel.SideTopCenter
                                anchors.centerIn: parent
                                fontSizeMultiplier: ratioCalc
                                text: "Power Good \n (PG_LDO)"
                                font.bold: true

                                SGStatusLight {
                                    id: pgoodLight
                                    property var int_pg_ldo:  platformInterface.int_status.int_pg_ldo
                                    onInt_pg_ldoChanged: {
                                        if(int_pg_ldo === true)
                                            pgoodLight.status  = SGStatusLight.Green

                                        else pgoodLight.status  = SGStatusLight.Off
                                    }
                                }
                            }
                        }
                        Rectangle {
                            Layout.fillHeight: true
                            Layout.fillWidth: true
                            color: "transparent"

                            SGAlignedLabel {
                                id:intLdoTempLabel
                                target: intLdoTemp
                                alignment: SGAlignedLabel.SideTopCenter
                                anchors.centerIn: parent
                                fontSizeMultiplier: ratioCalc
                                text: "LDO Temp Alert \n (LDO_Temp#)"
                                font.bold: true

                                SGStatusLight {
                                    id: intLdoTemp
                                    property var int_ldo_temp: platformInterface.int_status.int_ldo_temp
                                    onInt_ldo_tempChanged: {
                                        if(int_ldo_temp === true)
                                            intLdoTemp.status  = SGStatusLight.Red

                                        else intLdoTemp.status  = SGStatusLight.Off
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }

        Rectangle {
            Layout.fillWidth: true
            Layout.fillHeight: true
            color: "transparent"

            RowLayout {
                anchors.fill: parent

                Rectangle {
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    color: "transparent"
                    ColumnLayout {
                        anchors.fill: parent
                        Text {
                            id: inputConfigurationText
                            font.bold: true
                            text: "Input Configuration"
                            font.pixelSize: ratioCalc * 20
                            Layout.topMargin: 20
                            color: "#696969"
                            Layout.leftMargin: 20

                        }
                        Rectangle {
                            id: line
                            Layout.preferredHeight: 2
                            Layout.alignment: Qt.AlignCenter
                            Layout.preferredWidth: parent.width + 10
                            border.color: "lightgray"
                            radius: 2
                        }


                        Rectangle {
                            Layout.fillWidth: true
                            Layout.fillHeight: true
                            Layout.leftMargin: 20
                            RowLayout{
                                anchors.fill:parent
                                Rectangle {
                                    Layout.fillWidth: true
                                    Layout.fillHeight: true

                                    SGAlignedLabel {
                                        id: boardInputLabel
                                        target: boardInputComboBox
                                        text: "Board Input \nVoltage Selection"
                                        alignment: SGAlignedLabel.SideTopLeft
                                        anchors.centerIn: parent
                                        fontSizeMultiplier: ratioCalc
                                        font.bold : true

                                        SGComboBox {
                                            id: boardInputComboBox
                                            fontSizeMultiplier: ratioCalc
                                            model: ["USB 5V", "External", "Off"]
                                            onActivated: {

                                                platformInterface.select_vin.update(currentText)

                                            }
                                        }
                                    }
                                }

                                Rectangle {
                                    Layout.fillWidth: true
                                    Layout.fillHeight: true
                                    color: "transparent"

                                    SGAlignedLabel {
                                        id: ldoInputLabel
                                        target: ldoInputComboBox
                                        text: "LDO Input \nVoltage Selection"
                                        alignment: SGAlignedLabel.SideTopLeft
                                        anchors.centerIn: parent
                                        fontSizeMultiplier: ratioCalc
                                        font.bold : true

                                        SGComboBox {
                                            id: ldoInputComboBox
                                            fontSizeMultiplier: ratioCalc
                                            model: ["Bypass", "Buck Regulator", "Off", "Isolated"]
                                            onActivated: {
                                                platformInterface.select_vin_ldo.update(currentText)

                                            }
                                        }
                                    }
                                }

                                Rectangle {
                                    Layout.fillWidth: true
                                    Layout.fillHeight: true
                                    color: "transparent"

                                    SGAlignedLabel {
                                        id: ldoPackageLabel
                                        target: ldoPackageComboBox
                                        text: "LDO Package \nSelection"
                                        alignment: SGAlignedLabel.SideTopLeft
                                        anchors.centerIn: parent
                                        fontSizeMultiplier: ratioCalc
                                        font.bold : true

                                        SGComboBox {
                                            id: ldoPackageComboBox
                                            fontSizeMultiplier: ratioCalc
                                            model: ["TSOP5", "WDFN6", "DFNW8"]
                                            onActivated: {
                                                if(currentIndex === 0)
                                                    platformInterface.select_ldo.update("TSOP5")
                                                else if(currentIndex === 1)
                                                    platformInterface.select_ldo.update("DFN6")
                                                else if(currentIndex === 2)
                                                    platformInterface.select_ldo.update("DFN8")
                                                else console.log("Unknown State")


                                            }
                                        }
                                    }
                                }
                            }
                        }

                        Rectangle {
                            Layout.fillWidth: true
                            Layout.fillHeight: true
                            Layout.leftMargin: 20

                            SGAlignedLabel {
                                id: ldoEnableSwitchLabel
                                target: ldoEnableSwitch
                                text: "Enable LDO"
                                alignment: SGAlignedLabel.SideTopCenter
                                anchors.centerIn: parent
                                fontSizeMultiplier: ratioCalc
                                font.bold : true
                                SGSwitch {
                                    id: ldoEnableSwitch
                                    labelsInside: true
                                    checkedLabel: "On"
                                    uncheckedLabel:   "Off"
                                    textColor: "black"              // Default: "black"
                                    handleColor: "white"            // Default: "white"
                                    grooveColor: "#ccc"             // Default: "#ccc"
                                    grooveFillColor: "#0cf"         // Default: "#0cf"
                                    onToggled: {
                                        if(checked)
                                            platformInterface.set_ldo_enable.update("on")
                                        else  platformInterface.set_ldo_enable.update("off")
                                    }
                                }
                            }
                        }

                        Rectangle {
                            id: ldoInputVolSliderContainer
                            Layout.fillWidth: true
                            Layout.fillHeight: true
                            Layout.leftMargin: 20
                            SGAlignedLabel {
                                id: ldoInputVolSliderLabel
                                target: ldoInputVolSlider
                                text:"Set LDO Input Voltage"
                                alignment: SGAlignedLabel.SideTopLeft
                                anchors.centerIn: parent
                                fontSizeMultiplier: ratioCalc
                                font.bold : true
                                SGSlider {
                                    id:ldoInputVolSlider
                                    width: ldoInputVolSliderContainer.width/1.1
                                    textColor: "black"
                                    stepSize: 0.01
                                    from: 0.6
                                    to: 5
                                    live: false
                                    fromText.text: "0.6V"
                                    toText.text: "5V"
                                    inputBoxWidth: ldoInputVolSliderContainer.width/6
                                    onUserSet: {
                                        platformInterface.set_vin_ldo.update(value.toFixed(2))
                                    }
                                }
                            }
                        }
                    }
                }

                Rectangle {
                    id: middleLine
                    Layout.preferredHeight: parent.height
                    Layout.alignment: Qt.AlignCenter
                    Layout.preferredWidth: 2
                    border.color: "lightgray"
                    radius: 2
                }

                Rectangle {
                    Layout.fillWidth: true
                    Layout.fillHeight: true

                    Rectangle {
                        anchors {
                            fill:parent
                            left: parent.left
                            leftMargin: -5
                        }

                        color: "transparent"

                        ColumnLayout {
                            id: inputReadingContainer
                            anchors.fill: parent
                            Text {
                                id: inputReadingText
                                font.bold: true
                                text: "Telemetry"
                                font.pixelSize: ratioCalc * 20
                                Layout.topMargin: 20
                                color: "#696969"
                                Layout.leftMargin: 20

                            }
                            Rectangle {
                                id: line2
                                Layout.preferredHeight: 2
                                Layout.alignment: Qt.AlignCenter
                                Layout.preferredWidth: inputReadingContainer.width + 10
                                border.color: "lightgray"
                                radius: 2
                            }
                            Rectangle {
                                Layout.preferredWidth: parent.width/1.1
                                Layout.preferredHeight: 40
                                Layout.alignment: Qt.AlignCenter
                                Rectangle {
                                    id: warningBox
                                    color: "red"
                                    anchors.fill: parent

                                    Text {
                                        id: warningText
                                        anchors.centerIn: warningBox
                                        font.bold: true
                                        text : warningTextIs
                                        // text: "<b>DO NOT exceed LDO input voltage of 5.5V</b>"
                                        font.pixelSize:  ratioCalc * 12
                                        color: "white"
                                    }

                                    Text {
                                        id: warningIconleft
                                        anchors {
                                            right: warningText.left
                                            verticalCenter: warningText.verticalCenter
                                            rightMargin: 5
                                        }
                                        text: "\ue80e"
                                        font.family: Fonts.sgicons
                                        font.pixelSize:  ratioCalc * 14
                                        color: "white"
                                    }

                                    Text {
                                        id: warningIconright
                                        anchors {
                                            left: warningText.right
                                            verticalCenter: warningText.verticalCenter
                                            leftMargin: 5
                                        }
                                        text: "\ue80e"
                                        font.family: Fonts.sgicons
                                        font.pixelSize:  ratioCalc * 14
                                        color: "white"
                                    }
                                }


                            }

                            Rectangle {
                                id: inputContainer
                                Layout.fillWidth: true
                                Layout.fillHeight: true

                                RowLayout {
                                    anchors.fill: parent
                                    anchors {

                                        left: parent.left
                                        leftMargin: 15

                                    }

                                    Rectangle {
                                        id : externalInputVoltageContainer
                                        Layout.fillWidth: true
                                        Layout.fillHeight: true
                                        SGAlignedLabel {
                                            id: externalInputVoltageLabel
                                            target: externalInputVoltage
                                            text: "External Input Voltage \n(VIN_EXT)"
                                            alignment: SGAlignedLabel.SideTopLeft
                                            anchors.verticalCenter: parent.verticalCenter
                                            fontSizeMultiplier: ratioCalc
                                            font.bold : true

                                            SGInfoBox {
                                                id: externalInputVoltage
                                                unit: "V"
                                                fontSizeMultiplier: ratioCalc === 0 ? 1.0 : ratioCalc * 1.2
                                                //  height: externalInputVoltageContainer.height/1.3
                                                width: 100 * ratioCalc
                                                boxColor: "lightgrey"
                                                boxFont.family: Fonts.digitalseven
                                                unitFont.bold: true


                                            }
                                        }

                                    }

                                    Rectangle {
                                        id: usb5VVoltageContainer
                                        Layout.fillWidth: true
                                        Layout.fillHeight: true
                                        SGAlignedLabel {
                                            id: usb5VVoltageLabel
                                            target: usb5VVoltage
                                            text: "USB 5V Voltage \n(5V_USB)"
                                            alignment: SGAlignedLabel.SideTopLeft
                                            anchors.verticalCenter: parent.verticalCenter
                                            fontSizeMultiplier: ratioCalc
                                            font.bold : true

                                            SGInfoBox {
                                                id: usb5VVoltage
                                                unit: "V"
                                                fontSizeMultiplier: ratioCalc === 0 ? 1.0 : ratioCalc * 1.2
                                                //  height: usb5VVoltageContainer.height/1.3
                                                width: 100 * ratioCalc
                                                boxColor: "lightgrey"
                                                boxFont.family: Fonts.digitalseven
                                                unitFont.bold: true

                                            }
                                        }
                                    }
                                }
                            }

                            Rectangle {
                                Layout.fillWidth: true
                                Layout.fillHeight: true

                                RowLayout {
                                    anchors.fill:parent
                                    anchors {

                                        left: parent.left
                                        leftMargin: 15

                                    }
                                    Rectangle {
                                        id: ldoInputVoltageContainer
                                        Layout.fillWidth: true
                                        Layout.fillHeight: true
                                        SGAlignedLabel {
                                            id: ldoInputVoltageLabel
                                            target: ldoInputVoltage
                                            text: "LDO Input Voltage \n(VIN_LDO)"
                                            alignment: SGAlignedLabel.SideTopLeft
                                            anchors.verticalCenter: parent.verticalCenter
                                            fontSizeMultiplier: ratioCalc
                                            font.bold : true

                                            SGInfoBox {
                                                id: ldoInputVoltage
                                                unit: "V"
                                                width: 100* ratioCalc
                                                fontSizeMultiplier: ratioCalc === 0 ? 1.0 : ratioCalc * 1.2
                                                boxColor: "lightgrey"
                                                boxFont.family: Fonts.digitalseven
                                                unitFont.bold: true

                                            }
                                        }
                                    }

                                    Rectangle {
                                        id: ldoOutputVoltageContainer
                                        Layout.fillWidth: true
                                        Layout.fillHeight: true
                                        SGAlignedLabel {
                                            id: ldoOutputVoltageLabel
                                            target: ldoOutputVoltage
                                            text: "LDO Output Voltage \n(VOUT_LDO)"
                                            alignment: SGAlignedLabel.SideTopLeft
                                            anchors.verticalCenter: parent.verticalCenter
                                            fontSizeMultiplier: ratioCalc
                                            font.bold : true

                                            SGInfoBox {
                                                id: ldoOutputVoltage
                                                unit: "V"
                                                width: 100* ratioCalc
                                                fontSizeMultiplier: ratioCalc === 0 ? 1.0 : ratioCalc * 1.2
                                                boxColor: "lightgrey"
                                                boxFont.family: Fonts.digitalseven
                                                unitFont.bold: true

                                            }
                                        }
                                    }
                                }
                            }

                            Rectangle {
                                id: outputCurrentContainer
                                Layout.fillWidth: true
                                Layout.fillHeight: true

                                RowLayout {
                                    anchors.fill:parent
                                    anchors {

                                        left: parent.left
                                        leftMargin: 15

                                    }

                                    Rectangle {
                                        id: boardInputCurrentContainer
                                        Layout.fillWidth: true
                                        Layout.fillHeight: true

                                        SGAlignedLabel {
                                            id: boardInputCurrentLabel
                                            target: boardInputCurrent
                                            text: "Board Input Current \n(IIN)"
                                            alignment: SGAlignedLabel.SideTopLeft
                                            anchors.verticalCenter: parent.verticalCenter
                                            fontSizeMultiplier: ratioCalc
                                            font.bold : true

                                            SGInfoBox {
                                                id: boardInputCurrent
                                                unit: "mA"
                                                width: 110* ratioCalc
                                                fontSizeMultiplier: ratioCalc === 0 ? 1.0 : ratioCalc * 1.2
                                                boxColor: "lightgrey"
                                                boxFont.family: Fonts.digitalseven
                                                unitFont.bold: true

                                            }
                                        }
                                    }

                                    Rectangle {
                                        id: ldoOutputCurrentContainer
                                        Layout.fillWidth: true
                                        Layout.fillHeight: true

                                        SGAlignedLabel {
                                            id: ldoOutputCurrentLabel
                                            target: ldoOutputCurrent
                                            text: "LDO Output Current \n(IOUT)"
                                            alignment: SGAlignedLabel.SideTopLeft
                                            anchors.verticalCenter: parent.verticalCenter
                                            fontSizeMultiplier: ratioCalc
                                            font.bold : true

                                            SGInfoBox {
                                                id: ldoOutputCurrent
                                                unit: "mA"
                                                width: 110* ratioCalc
                                                fontSizeMultiplier: ratioCalc === 0 ? 1.0 : ratioCalc * 1.2
                                                boxColor: "lightgrey"
                                                boxFont.family: Fonts.digitalseven
                                                unitFont.bold: true

                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }

                Rectangle {
                    id: middleLine2
                    Layout.preferredHeight: parent.height
                    Layout.alignment: Qt.AlignCenter
                    Layout.preferredWidth: 2
                    border.color: "lightgray"
                    radius: 2
                }

                Rectangle {
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    ColumnLayout {
                        id: outputConfigurationContainer
                        anchors.fill: parent
                        Text {
                            id: outputConfigurationText
                            font.bold: true
                            text: "Output Configuration"
                            font.pixelSize: ratioCalc * 20
                            Layout.topMargin: 20
                            color: "#696969"
                            Layout.leftMargin: 20

                        }
                        Rectangle {
                            id: line4
                            Layout.preferredHeight: 2
                            Layout.alignment: Qt.AlignCenter
                            Layout.preferredWidth: inputReadingContainer.width
                            border.color: "lightgray"
                            Layout.leftMargin: -10
                            radius: 2
                        }
                        Rectangle {
                            id: setLDOOutputVoltageContainer
                            Layout.fillWidth: true
                            Layout.fillHeight: true
                            SGAlignedLabel {
                                id: setLDOOutputVoltageLabel
                                target: setLDOOutputVoltage
                                text: "Set LDO Output Voltage"
                                alignment: SGAlignedLabel.SideTopLeft
                                anchors.verticalCenter: parent.verticalCenter
                                anchors.left: parent.left
                                anchors.leftMargin: 10
                                fontSizeMultiplier: ratioCalc
                                font.bold : true

                                SGSlider {
                                    id:setLDOOutputVoltage
                                    width: setLDOOutputVoltageContainer.width/1.1
                                    textColor: "black"
                                    stepSize: 0.01
                                    from: 1.1
                                    to: 4.7
                                    live: false
                                    fromText.text: "1.1V"
                                    toText.text: "4.7V"
                                    inputBoxWidth: setLDOOutputVoltageContainer.width/6

                                    onUserSet: {
                                        platformInterface.set_vout_ldo.update(value.toFixed(2))
                                    }
                                }
                            }
                        }

                        RowLayout {
                            Layout.fillWidth: true
                            Layout.fillHeight: true

                            Rectangle {
                                Layout.fillWidth: true
                                Layout.fillHeight: true
                                SGAlignedLabel {
                                    id: loadEnableSwitchLabel
                                    target: loadEnableSwitch
                                    text: "Enable Onboard \nLoad"
                                    alignment: SGAlignedLabel.SideTopLeft
                                    anchors.centerIn: parent
                                    fontSizeMultiplier: ratioCalc
                                    font.bold : true
                                    SGSwitch {
                                        id: loadEnableSwitch
                                        labelsInside: true
                                        checkedLabel: "On"
                                        uncheckedLabel:   "Off"
                                        textColor: "black"              // Default: "black"
                                        handleColor: "white"            // Default: "white"
                                        grooveColor: "#ccc"             // Default: "#ccc"
                                        grooveFillColor: "#0cf"         // Default: "#0cf"
                                        onToggled: {
                                            if(checked)
                                                platformInterface.set_load_enable.update("on")
                                            else  platformInterface.set_load_enable.update("off")
                                        }

                                    }
                                }

                            }
                            Rectangle {
                                id:extLoadCheckboxContainer
                                Layout.fillWidth: true
                                Layout.fillHeight: true
                                color: "transparent"

                                SGAlignedLabel {
                                    id: extLoadCheckboxLabel
                                    target: extLoadCheckbox
                                    text: "External Load \n Connected?"
                                    horizontalAlignment: Text.AlignHCenter
                                    font.bold : true
                                    font.italic: true
                                    alignment: SGAlignedLabel.SideTopCenter
                                    fontSizeMultiplier: ratioCalc
                                    anchors.left: parent.left
                                    anchors.verticalCenter: parent.verticalCenter


                                    Rectangle {
                                        color: "transparent"
                                        anchors { fill: extLoadCheckboxLabel }
                                        MouseArea {
                                            id: hoverArea
                                            anchors { fill: parent }
                                            hoverEnabled: true
                                        }
                                    }

                                    CheckBox {
                                        id: extLoadCheckbox
                                        checked: false

                                        onClicked: {
                                            if(checked) {
                                                platformInterface.ext_load_conn.update(true)
                                            } else {
                                                platformInterface.ext_load_conn.update(false)
                                            }

                                        }
                                    }
                                }
                            }
                        }

                        Rectangle {
                            id:setLoadCurrentContainer
                            Layout.fillWidth: true
                            Layout.fillHeight: true
                            SGAlignedLabel {
                                id: setLoadCurrentLabel
                                target: setLoadCurrent
                                text:"Set Load Current"
                                alignment: SGAlignedLabel.SideTopLeft
                                anchors.verticalCenter: parent.verticalCenter
                                anchors.left: parent.left
                                anchors.leftMargin: 10
                                fontSizeMultiplier: ratioCalc
                                font.bold : true
                                SGSlider {
                                    id:setLoadCurrent
                                    width: setLoadCurrentContainer.width/1.1
                                    textColor: "black"
                                    stepSize: 0.1
                                    from: 0
                                    to: 650
                                    live: false
                                    fromText.text: "0mA"
                                    toText.text: "650mA"
                                    inputBoxWidth: setLoadCurrentContainer.width/6
                                    onUserSet: {
                                        platformInterface.set_load.update(value.toFixed(1))
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


