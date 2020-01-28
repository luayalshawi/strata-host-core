import QtQuick 2.9
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.7
import "../sgwidgets"
import "qrc:/js/help_layout_manager.js" as Help
import tech.strata.fonts 1.0
import tech.strata.sgwidgets 1.0



Item {
    id: root
    property real ratioCalc: root.width / 1200
    property real initialAspectRatio: 1200/820
    width: parent.width / parent.height > initialAspectRatio ? parent.height * initialAspectRatio : parent.width
    height: parent.width / parent.height < initialAspectRatio ? parent.width / initialAspectRatio : parent.height
    property var pwmArray: []
    property real fracValue1: 0.00
    property real fracValue2: 0.00
    property real fracValue3: 0.00



    property var temp_remote_value: platformInterface.temp_remote_value.value
    onTemp_remote_valueChanged: {
        remotetempGauge.value = temp_remote_value
    }


    property var temp_remote_state: platformInterface.temp_remote_state.state
    onTemp_remote_stateChanged: {
        if(temp_remote_state === "enabled"){
            remotetempGauge.enabled = true
            remotetempGauge.opacity = 1.0
        }
        else if (temp_remote_state === "disabled"){
            remotetempGauge.enabled = false
            remotetempGauge.opacity = 1.0

        }
        else {
            remotetempGauge.opacity = 0.5
            remotetempGauge.enabled = false
        }
    }

    property var temp_remote_scales: platformInterface.temp_remote_scales.scales
    onTemp_remote_scalesChanged: {
        remotetempGauge.maximumValue = parseInt(temp_remote_scales[0])
        remotetempGauge.minimumValue = parseInt(temp_remote_scales[1])
    }

    Rectangle {
        id: temperatureContainer
        width: parent.width - 50
        height:  parent.height - 10
        color: "transparent"

        anchors{
            verticalCenter: parent.verticalCenter
            horizontalCenter: parent.horizontalCenter
        }

        Rectangle {
            id: topContainer
            width: parent.width
            height: parent.height/2
            color: "transparent"
            anchors.top: parent.top



            ColumnLayout {
                id: leftContainer
                width: parent.width/4
                height:  parent.height
                Rectangle{
                    Layout.fillWidth: true
                    Layout.preferredHeight: parent.height/9
                    color: "transparent"

                    Text {
                        id: leftHeading
                        text: "Remote Temperature"
                        font.bold: true
                        font.pixelSize: ratioCalc * 15
                        color: "#696969"
                        anchors {
                            top: parent.top
                            topMargin: 5
                        }
                    }

                    Rectangle {
                        id: line1
                        height: 2
                        Layout.alignment: Qt.AlignCenter
                        width: parent.width
                        border.color: "lightgray"
                        radius: 2
                        anchors {
                            top: leftHeading.bottom
                            topMargin: 7
                        }
                    }
                }
                Rectangle {
                    id: gaugeContainer1
                    Layout.preferredHeight: parent.height/2
                    Layout.fillWidth: true
                    color: "transparent"

                    SGCircularGauge{
                        id:remotetempGauge
                        width: 200 * ratioCalc
                        height: 200 * ratioCalc

                        unitTextFontSizeMultiplier: ratioCalc * 2.5
                        tickmarkStepSize: 20
                        unitText: "°c"
                        valueDecimalPlaces: 2
                        anchors.centerIn: parent

                    }
                }
                Rectangle {
                    id: pwmDutyCycle1Container
                    Layout.fillHeight: true
                    Layout.fillWidth: true
                    color: "transparent"
                    SGAlignedLabel {
                        id: pwmDutyCycle1Label
                        target: pwmDutyCycle1
                        text: "PWM Positive \n Duty Cycle (%)"
                        alignment:  SGAlignedLabel.SideTopCenter
                        anchors.centerIn: parent
                        fontSizeMultiplier: ratioCalc
                        font.bold : true
                        horizontalAlignment: Text.AlignHCenter
                        SGComboBox {
                            id: pwmDutyCycle1
                            fontSizeMultiplier: ratioCalc * 0.8
                            onActivated: {
                                platformInterface.set_temp_pwm_remote.update(currentText)

                            }
                            KeyNavigation.tab: conAlerts

                            property var temp_pwm_remote_values: platformInterface.temp_pwm_remote_values.values
                            onTemp_pwm_remote_valuesChanged: {
                                pwmDutyCycle1.model = temp_pwm_remote_values
                            }
                            property var temp_pwm_remote_value: platformInterface.temp_pwm_remote_value.value
                            onTemp_pwm_remote_valueChanged: {
                                for(var i = 0; i < pwmDutyCycle1.model.length; ++i ){
                                    if( pwmDutyCycle1.model[i].toString() === temp_pwm_remote_value)
                                    {
                                        currentIndex = i
                                        return;
                                    }
                                }
                            }


                            property var temp_pwm_remote_state: platformInterface.temp_pwm_remote_state.state
                            onTemp_pwm_remote_stateChanged: {
                                if(temp_pwm_remote_state === "enabled"){
                                    pwmDutyCycle1Container.enabled = true
                                    pwmDutyCycle1Container.opacity = 1.0
                                }
                                else if (temp_pwm_remote_state === "disabled"){
                                    pwmDutyCycle1Container.enabled = false
                                    pwmDutyCycle1Container.opacity = 1.0

                                }
                                else {
                                    pwmDutyCycle1Container.opacity = 0.5
                                    pwmDutyCycle1Container.enabled = false
                                }
                            }
                        }
                    }
                }
            }
            Rectangle{
                id: middleContainer
                width: parent.width/2
                height:  parent.height - 20
                color: "transparent"
                anchors {
                    left: leftContainer.right
                    leftMargin: 10

                }
                ColumnLayout {
                    id: middleSetting
                    width: parent.width
                    height:parent.height
                    spacing: 10

                    Rectangle{
                        Layout.fillWidth: true
                        Layout.preferredHeight: parent.height/9
                        color: "transparent"

                        Text {
                            id: topMiddleHeading
                            text: "Warnings & Information"
                            font.bold: true
                            font.pixelSize: ratioCalc * 15
                            color: "#696969"
                            anchors {
                                top: parent.top
                                topMargin: 5
                            }
                        }

                        Rectangle {
                            id: line2
                            height: 2
                            Layout.alignment: Qt.AlignCenter
                            width: parent.width
                            border.color: "lightgray"
                            radius: 2
                            anchors {
                                top: topMiddleHeading.bottom
                                topMargin: 7
                            }
                        }
                    }

                    Rectangle {
                        Layout.fillHeight: true
                        Layout.fillWidth: true
                        color: "transparent"
                        RowLayout{
                            width: parent.width
                            height:parent.height
                            spacing : 0

                            Rectangle {
                                Layout.fillWidth: true
                                Layout.fillHeight: true
                                color: "transparent"
                                SGAlignedLabel {
                                    id: thermLEDLabel
                                    target: thermLED
                                    font.bold: true
                                    fontSizeMultiplier: ratioCalc
                                    alignment: SGAlignedLabel.SideLeftCenter
                                    anchors.verticalCenter: parent.verticalCenter
                                    SGStatusLight{
                                        id: thermLED
                                        width: 30
                                    }

                                    property var nct72_therm_value: platformInterface.temp_therm_value.value
                                    onNct72_therm_valueChanged: {
                                        if(nct72_therm_value === "0")
                                            thermLED.status = SGStatusLight.Off

                                        else   thermLED.status =SGStatusLight.Red
                                    }

                                    property var nct72_therm_caption: platformInterface.temp_therm_caption.caption
                                    onNct72_therm_captionChanged: {
                                        thermLEDLabel.text = "THERM"
                                    }

                                    property var nct72_therm_state: platformInterface.temp_therm_state.state
                                    onNct72_therm_stateChanged: {
                                        if(nct72_therm_state === "enabled"){
                                            thermLED.enabled = true
                                            thermLED.opacity = 1.0
                                        }
                                        else if (nct72_therm_state === "disabled"){
                                            thermLED.enabled = false
                                            thermLED.opacity = 1.0

                                        }
                                        else {
                                            thermLED.opacity = 0.5
                                            thermLED.enabled = false
                                        }
                                    }
                                }
                            }


                            Rectangle{
                                Layout.fillWidth: true
                                Layout.fillHeight: true
                                SGAlignedLabel {
                                    id: alertAndThermLabel
                                    target: alertAndTherm
                                    font.bold: true
                                    fontSizeMultiplier: ratioCalc
                                    alignment: SGAlignedLabel.SideLeftCenter
                                    anchors.verticalCenter: parent.verticalCenter

                                    SGStatusLight{
                                        id: alertAndTherm
                                        width: 30
                                    }


                                    property var alert_therm2_caption: platformInterface.temp_alert_therm2_caption.caption
                                    onAlert_therm2_captionChanged: {
                                        alertAndThermLabel.text = alert_therm2_caption
                                    }

                                    property var alert_therm2_state: platformInterface.temp_alert_therm2_state.state
                                    onAlert_therm2_stateChanged: {
                                        if(alert_therm2_state === "enabled"){
                                            alertAndTherm.enabled = true
                                        }
                                        else if(alert_therm2_state === "disabled"){
                                            alertAndTherm.enabled = false
                                        }
                                        else {
                                            alertAndTherm.enabled = false
                                            alertAndTherm.opacity = 0.5
                                        }
                                    }
                                    property var alert_therm2_value: platformInterface.temp_alert_therm2_value.value
                                    onAlert_therm2_valueChanged: {
                                        if(alert_therm2_value === "1")
                                            alertAndTherm.status = SGStatusLight.Red
                                        else
                                            alertAndTherm.status = SGStatusLight.Off
                                    }

                                }
                            }

                            Rectangle {
                                id: manufactorIdContainer
                                Layout.fillHeight: true
                                Layout.fillWidth: true
                                color: "transparent"
                                SGAlignedLabel {
                                    id: manufactorIdLabel
                                    target: manufactorId
                                    font.bold: true
                                    alignment: SGAlignedLabel.SideTopLeft
                                    anchors.verticalCenter: parent.verticalCenter
                                    fontSizeMultiplier: ratioCalc
                                    SGInfoBox {
                                        id: manufactorId
                                        height:  25 * ratioCalc
                                        width: 100 * ratioCalc
                                        fontSizeMultiplier: ratioCalc === 0 ? 1.0 : ratioCalc * 0.9
                                        // boxFont.family: Fonts.digitalseven
                                        unitFont.bold: true
                                        boxColor: "#F0F0F0"

                                    }
                                    property var temp_man_id_caption: platformInterface.temp_man_id_caption.caption
                                    onTemp_man_id_captionChanged: {
                                        manufactorIdLabel.text = temp_man_id_caption
                                    }
                                    property var temp_man_id_value: platformInterface.temp_man_id_value.value
                                    onTemp_man_id_valueChanged: {
                                        manufactorId.text = temp_man_id_value
                                    }
                                    property var temp_man_id_state: platformInterface.temp_man_id_state.state
                                    onTemp_man_id_stateChanged: {
                                        if(temp_man_id_state === "enabled"){
                                            manufactorIdContainer.enabled = true
                                            manufactorIdContainer.opacity = 1.0
                                        }
                                        else if (temp_man_id_state === "disabled"){
                                            manufactorIdContainer.enabled = false
                                            manufactorIdContainer.opacity = 1.0

                                        }
                                        else {
                                            manufactorIdContainer.opacity = 0.5
                                            manufactorIdContainer.enabled = false
                                        }
                                    }
                                }
                            }
                        }
                    }

                    Rectangle{
                        Layout.fillWidth: true
                        Layout.preferredHeight: parent.height/9
                        color: "transparent"

                        Text {
                            id: primaryMiddleHeading
                            text: "Primary Settings"
                            font.bold: true
                            font.pixelSize: ratioCalc * 15
                            color: "#696969"
                            anchors {
                                top: parent.top
                                topMargin: 5
                            }
                        }

                        Rectangle {
                            id: line3
                            height: 2
                            Layout.alignment: Qt.AlignCenter
                            width: parent.width
                            border.color: "lightgray"
                            radius: 2
                            anchors {
                                top: primaryMiddleHeading.bottom
                                topMargin: 7
                            }
                        }
                    }

                    Rectangle {
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        color: "transparent"

                        RowLayout{
                            width: parent.width
                            height:parent.height
                            spacing : 0
                            Rectangle {
                                id: modeContainer
                                Layout.fillWidth: true
                                Layout.fillHeight: true
                                color: "transparent"
                                SGAlignedLabel{
                                    id: modeLabel
                                    target: modeRadioButtons
                                    anchors.verticalCenter: parent.verticalCenter
                                    font.bold: true
                                    fontSizeMultiplier: ratioCalc
                                    SGRadioButtonContainer {
                                        id: modeRadioButtons
                                        columns: 1

                                        SGRadioButton {
                                            id: run
                                            text: "Run"
                                            checked: true
                                            fontSizeMultiplier: ratioCalc * 0.8
                                            radioSize:  ratioCalc * 15
                                            onToggled: {
                                                console.log("in checked")

                                                if(checked)
                                                    platformInterface.set_mode_value.update("Run")
                                                else
                                                    platformInterface.set_mode_value.update("Standby")

                                            }
                                        }

                                        SGRadioButton {
                                            id: standby
                                            text: "Standby"
                                            radioSize:  ratioCalc * 15
                                            fontSizeMultiplier: ratioCalc * 0.8
                                            onToggled: {
                                                if(checked)
                                                    platformInterface.set_mode_value.update("Standby")
                                                else
                                                    platformInterface.set_mode_value.update("Run")
                                            }

                                        }
                                    }
                                    property var temp_mode_caption: platformInterface.temp_mode_caption.caption
                                    onTemp_mode_captionChanged: {
                                        modeLabel.text = temp_mode_caption
                                    }

                                    property var temp_mode_value: platformInterface.temp_mode_value.value
                                    onTemp_mode_valueChanged: {
                                        if(temp_mode_value === "Run")
                                            run.checked = true
                                        else standby.checked = true
                                    }


                                    property var temp_mode_state: platformInterface.temp_mode_state.state
                                    onTemp_mode_stateChanged: {
                                        if(temp_mode_state === "enabled"){
                                            modeContainer.enabled = true
                                            modeContainer.opacity = 1.0
                                        }
                                        else if (temp_mode_state === "disabled"){
                                            modeContainer.enabled = false
                                            modeContainer.opacity = 1.0

                                        }
                                        else {
                                            modeContainer.opacity = 0.5
                                            modeContainer.enabled = false
                                        }
                                    }

                                }
                            }
                            Rectangle {
                                id:alertContainer
                                Layout.fillWidth: true
                                Layout.fillHeight: true
                                color: "transparent"
                                SGAlignedLabel{
                                    id: alertLabel
                                    target: alertRadioButtons
                                    font.bold: true
                                    anchors.verticalCenter: parent.verticalCenter
                                    fontSizeMultiplier: ratioCalc
                                    SGRadioButtonContainer {
                                        id: alertRadioButtons
                                        columns: 1

                                        SGRadioButton {
                                            id: alert1
                                            text: "Enabled"
                                            fontSizeMultiplier: ratioCalc * 0.8
                                            radioSize:  ratioCalc * 15
                                            checked: true
                                            onToggled: {
                                                if(checked)
                                                    platformInterface.set_temp_alert.update("Enabled")
                                                else platformInterface.set_temp_alert.update("Masked")
                                            }
                                        }

                                        SGRadioButton {
                                            id: alert2
                                            text: "Masked"
                                            fontSizeMultiplier: ratioCalc * 0.8
                                            radioSize:  ratioCalc * 15
                                            onToggled: {
                                                if(checked)
                                                    platformInterface.set_temp_alert.update("Masked")
                                                else platformInterface.set_temp_alert.update("Enabled")
                                            }

                                        }
                                    }
                                    property var temp_alert_caption: platformInterface.temp_alert_caption.caption
                                    onTemp_alert_captionChanged: {
                                        alertLabel.text = temp_alert_caption
                                    }

                                    property var temp_alert_state: platformInterface.temp_alert_state.state
                                    onTemp_alert_stateChanged: {
                                        if(temp_alert_state === "enabled"){
                                            alertContainer.enabled = true
                                            alertContainer.opacity = 1.0
                                        }
                                        else if (temp_alert_state === "disabled"){
                                            alertContainer.enabled = false
                                            alertContainer.opacity = 1.0
                                        }
                                        else {
                                            alertButton.opacity = 0.5
                                            alertButton.enabled = false
                                        }
                                    }


                                    property var temp_alert_value: platformInterface.temp_alert_value.value
                                    onTemp_alert_valueChanged: {
                                        if(temp_alert_value === "Enabled")
                                            alert1.checked = true
                                        else alert2.checked = true
                                    }
                                }

                            }

                            Rectangle {
                                id: pin6Container
                                Layout.fillWidth: true
                                Layout.fillHeight: true
                                color: "transparent"
                                SGAlignedLabel{
                                    id: pinLabel
                                    target: pinButtons
                                    font.bold: true
                                    anchors.verticalCenter: parent.verticalCenter
                                    fontSizeMultiplier: ratioCalc
                                    SGRadioButtonContainer {
                                        id: pinButtons
                                        columns: 1


                                        SGRadioButton {
                                            id: pin1
                                            text: "ALERT#"
                                            checked: true
                                            fontSizeMultiplier: ratioCalc * 0.8
                                            radioSize:  ratioCalc * 15
                                            onToggled: {
                                                if(checked)
                                                    platformInterface.set_alert_therm2_pin6.update("ALERT#")
                                                else platformInterface.set_alert_therm2_pin6.update("THERM2#")
                                            }
                                        }

                                        SGRadioButton {
                                            id: pin2
                                            text: "THERM2"
                                            fontSizeMultiplier: ratioCalc * 0.8
                                            radioSize:  ratioCalc * 15
                                            onToggled: {
                                                if(checked)
                                                    platformInterface.set_alert_therm2_pin6.update("THERM2#")
                                                else platformInterface.set_alert_therm2_pin6.update("ALERT#")
                                            }

                                        }
                                    }
                                    property var temp_pin6_caption: platformInterface.temp_pin6_caption.caption
                                    onTemp_pin6_captionChanged: {
                                        pinLabel.text = temp_pin6_caption
                                    }

                                    property var temp_pin6_state: platformInterface.temp_pin6_state.state
                                    onTemp_pin6_stateChanged: {
                                        if(temp_pin6_state === "enabled"){
                                            pin6Container.enabled = true
                                            pin6Container.opacity = 1.0
                                        }
                                        else if (temp_pin6_state === "disabled"){
                                            pin6Container.enabled = false
                                            pin6Container.opacity = 1.0

                                        }
                                        else {
                                            pin6Container.opacity = 0.5
                                            pin6Container.enabled = false
                                        }
                                    }

                                    property var temp_pin6_value: platformInterface.temp_pin6_value.value
                                    onTemp_pin6_valueChanged: {
                                        if(temp_pin6_value === "ALERT#")
                                            pin1.checked = true
                                        else pin2.checked = true
                                    }
                                }

                            }
                            Rectangle {
                                id: rangeContainer
                                Layout.fillWidth: true
                                Layout.fillHeight: true
                                color: "transparent"
                                SGAlignedLabel{
                                    id: rangeLabel
                                    target: rangeButtons
                                    font.bold: true
                                    anchors.verticalCenter: parent.verticalCenter
                                    fontSizeMultiplier: ratioCalc
                                    SGRadioButtonContainer {
                                        id: rangeButtons
                                        columns: 1

                                        SGRadioButton {
                                            id: range1
                                            text: "0 to 127˚C "
                                            checked: true
                                            radioSize:  ratioCalc * 15
                                            fontSizeMultiplier: ratioCalc * 0.8
                                            onToggled: {
                                                if(checked)
                                                    platformInterface.set_range_value.update("0_127")
                                                else platformInterface.set_range_value.update("-64_191")
                                            }
                                        }

                                        SGRadioButton {
                                            id: range2
                                            text: "-64 to 191˚C "
                                            radioSize:  ratioCalc * 15
                                            fontSizeMultiplier: ratioCalc * 0.8
                                            onToggled: {
                                                if(checked)
                                                    platformInterface.set_range_value.update("-64_191")
                                                else platformInterface.set_range_value.update("0_127")
                                            }

                                        }
                                    }
                                    property var temp_range_caption: platformInterface.temp_range_caption.caption

                                    onTemp_range_captionChanged: {
                                        rangeLabel.text = temp_range_caption
                                    }

                                    property var temp_range_value: platformInterface.temp_range_value.value
                                    onTemp_range_valueChanged: {
                                        if(temp_range_value === "0_127")
                                            range1.checked = true
                                        else range2.checked = true
                                    }

                                    property var temp_range_state: platformInterface.temp_range_state.state
                                    onTemp_range_stateChanged: {
                                        if(temp_range_state === "enabled"){
                                            rangeContainer.enabled = true
                                            rangeContainer.opacity = 1.0
                                        }
                                        else if (temp_range_state === "disabled"){
                                            rangeContainer.enabled = false
                                            rangeContainer.opacity = 1.0
                                        }
                                        else {
                                            rangeContainer.opacity = 0.5
                                            rangeContainer.enabled = false
                                        }
                                    }

                                }
                            }
                        }

                    }

                    Rectangle {
                        Layout.fillHeight: true
                        Layout.fillWidth: true
                        color: "transparent"
                        RowLayout {
                            width: parent.width
                            height:parent.height
                            spacing : 0

                            Rectangle {
                                Layout.fillWidth: true
                                Layout.fillHeight: true
                                color: "transparent"
                                SGButton {
                                    id:  oneShot
                                    anchors.verticalCenter: parent.verticalCenter
                                    fontSizeMultiplier: ratioCalc
                                    color: checked ? "#353637" : pressed ? "#cfcfcf": hovered ? "#eee" : "#e0e0e0"
                                    hoverEnabled: true
                                    anchors.centerIn: parent

                                    MouseArea {
                                        hoverEnabled: true
                                        anchors.fill: parent
                                        cursorShape: containsMouse ? Qt.PointingHandCursor : Qt.ArrowCursor
                                        onClicked: {
                                            platformInterface.one_shot.update()
                                        }

                                    }
                                    property var temp_one_shot_caption: platformInterface.temp_one_shot_caption.caption
                                    onTemp_one_shot_captionChanged: {
                                        oneShot.text = temp_one_shot_caption
                                    }

                                    property var temp_one_shot_state: platformInterface.temp_one_shot_state.state
                                    onTemp_one_shot_stateChanged: {
                                        if(temp_one_shot_state === "enabled"){
                                            oneShot.enabled = true
                                            oneShot.opacity = 1.0
                                        }
                                        else if (temp_one_shot_state === "disabled"){
                                            oneShot.enabled = false
                                            oneShot.opacity = 1.0

                                        }
                                        else {
                                            oneShot.opacity = 0.5
                                            oneShot.enabled = false
                                        }
                                    }

                                }
                            }


                            Rectangle {
                                id: thermHysContainer
                                Layout.fillHeight: true
                                Layout.fillWidth: true
                                color: "transparent"

                                SGAlignedLabel {
                                    id: thermHysLabel
                                    target: thermHys
                                    fontSizeMultiplier: ratioCalc
                                    font.bold : true
                                    alignment: SGAlignedLabel.SideTopLeft
                                    anchors.centerIn: parent

                                    SGSlider {
                                        id: thermHys
                                        width: thermHysContainer.width
                                        live: false
                                        fontSizeMultiplier: ratioCalc * 0.8
                                        inputBox.validator: DoubleValidator {
                                            top: thermHys.to
                                            bottom: thermHys.from
                                        }
                                        inputBox.enabled: false
                                        inputBox.boxColor: "#F0F0F0"
                                        inputBoxWidth: thermHysContainer.width/6
                                        onUserSet: {
                                            platformInterface.set_therm_hyst_value.update(value.toString())
                                        }
                                    }
                                }
                                property var temp_therm_hyst_caption: platformInterface.temp_therm_hyst_caption.caption
                                onTemp_therm_hyst_captionChanged: {
                                    thermHysLabel.text = temp_therm_hyst_caption
                                }
                                property var temp_therm_hyst_value: platformInterface.temp_therm_hyst_value.value
                                onTemp_therm_hyst_valueChanged: {
                                    thermHys.value = temp_therm_hyst_value
                                }
                                property var temp_therm_hyst_scales: platformInterface.temp_therm_hyst_scales.scales
                                onTemp_therm_hyst_scalesChanged: {
                                    thermHys.to.toText = temp_therm_hyst_scales[0] + "˚C"
                                    thermHys.from.fromText = temp_therm_hyst_scales[1] + "˚C"
                                    thermHys.from = temp_therm_hyst_scales[1]
                                    thermHys.to = temp_therm_hyst_scales[0]
                                    thermHys.stepSize = temp_therm_hyst_scales[2]
                                }


                                property var temp_therm_hyst_state: platformInterface.temp_therm_hyst_state.state
                                onTemp_therm_hyst_stateChanged: {
                                    if(temp_therm_hyst_state === "enabled"){
                                        thermHysContainer.enabled = true
                                        thermHysContainer.opacity = 1.0
                                    }
                                    else if (temp_therm_hyst_state === "disabled"){
                                        thermHysContainer.enabled = false
                                        thermHysContainer.opacity = 1.0

                                    }
                                    else {
                                        thermHysContainer.opacity = 0.5
                                        thermHysContainer.enabled = false
                                    }
                                }

                            }

                        }
                    }

                    Rectangle {
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        color: "transparent"
                        RowLayout{
                            width: parent.width
                            height:parent.height

                            Rectangle{
                                id: conAlertContainer
                                Layout.fillWidth: true
                                Layout.fillHeight: true
                                color: "transparent"

                                SGAlignedLabel {
                                    id: conAlertsLabel
                                    target: conAlerts
                                    alignment:  SGAlignedLabel.SideTopLeft
                                    anchors.centerIn: parent
                                    fontSizeMultiplier: ratioCalc
                                    font.bold : true
                                    SGComboBox {
                                        id: conAlerts
                                        fontSizeMultiplier: ratioCalc * 0.8
                                        KeyNavigation.tab: conInterval

                                        onActivated: {
                                            platformInterface.set_temp_cons_alert.update(currentText)
                                        }
                                    }

                                    property var temp_cons_alert_state: platformInterface.temp_cons_alert_state.state
                                    onTemp_cons_alert_stateChanged: {
                                        if(temp_cons_alert_state === "enabled"){
                                            conAlertContainer.enabled = true
                                        }
                                        else if(temp_cons_alert_state === "disabled"){
                                            conAlertContainer.enabled = false
                                        }
                                        else {
                                            conAlertContainer.enabled = false
                                            conAlertContainer.opacity = 0.5
                                        }
                                    }

                                    property var temp_cons_alert_values : platformInterface.temp_cons_alert_values.values
                                    onTemp_cons_alert_valuesChanged: {
                                        conAlerts.model = temp_cons_alert_values
                                    }

                                    property var temp_cons_alert_value: platformInterface.temp_cons_alert_value.value
                                    onTemp_cons_alert_valueChanged: {
                                        for(var i = 0; i < conAlerts.model.length; ++i) {
                                            if(temp_cons_alert_value === conAlerts.model[i].toString()) {
                                                conAlerts.currentIndex = i
                                            }
                                        }
                                    }
                                    property var temp_cons_alert_caption: platformInterface.temp_cons_alert_caption.caption
                                    onTemp_cons_alert_captionChanged: {
                                        conAlertsLabel.text = temp_cons_alert_caption
                                    }
                                }
                            }
                            Rectangle {
                                id:conIntervalContainer
                                Layout.fillWidth: true
                                Layout.fillHeight: true
                                color: "transparent"
                                SGAlignedLabel {
                                    id: conIntervalsLabel
                                    target: conInterval
                                    alignment:  SGAlignedLabel.SideTopLeft
                                    fontSizeMultiplier: ratioCalc
                                    anchors.centerIn: parent
                                    font.bold : true
                                    SGComboBox {
                                        id: conInterval
                                        fontSizeMultiplier: ratioCalc * 0.8
                                        KeyNavigation.tab: pwmDutyCycle2

                                        onActivated: {
                                            platformInterface.set_temp_conv_rate.update(currentText)
                                        }
                                    }
                                }
                                property var temp_cons_alert_state: platformInterface.temp_cons_alert_state.state
                                onTemp_cons_alert_stateChanged: {
                                    if(temp_cons_alert_state === "enabled"){
                                        conIntervalContainer.enabled = true
                                    }
                                    else if(temp_cons_alert_state === "disabled"){
                                        conIntervalContainer.enabled = false
                                    }
                                    else {
                                        conIntervalContainer.enabled = false
                                        conIntervalContainer.opacity = 0.5
                                    }
                                }

                                property var temp_conv_rate_values : platformInterface.temp_conv_rate_values.values
                                onTemp_conv_rate_valuesChanged: {
                                    conInterval.model = temp_conv_rate_values
                                }

                                property var temp_conv_rate_value: platformInterface.temp_conv_rate_value.value
                                onTemp_conv_rate_valueChanged: {
                                    for(var i = 0; i < conInterval.model.length; ++i) {
                                        if(temp_conv_rate_value === conInterval.model[i].toString()) {
                                            conInterval.currentIndex = i
                                        }
                                    }
                                }
                                property var temp_conv_rate_caption: platformInterface.temp_conv_rate_caption.caption
                                onTemp_conv_rate_captionChanged: {
                                    conIntervalsLabel.text = temp_conv_rate_caption
                                }

                            }
                        }
                    }


                } // end of cloumn
            }

            ColumnLayout {
                id: rightContainer
                width: parent.width/4
                height:  parent.height
                anchors {
                    leftMargin: 5
                    left: middleContainer.right
                }

                Rectangle{
                    Layout.fillWidth: true
                    Layout.preferredHeight: parent.height/9
                    color: "transparent"

                    Text {
                        id: rightHeading
                        text: "Local Temperature"
                        font.bold: true
                        font.pixelSize: ratioCalc * 15
                        color: "#696969"
                        anchors {
                            top: parent.top
                            topMargin: 5
                        }
                    }

                    Rectangle {
                        id: line4
                        height: 2
                        Layout.alignment: Qt.AlignCenter
                        width: parent.width
                        border.color: "lightgray"
                        radius: 2
                        anchors {
                            top: rightHeading.bottom
                            topMargin: 7
                        }
                    }
                }
                Rectangle {
                    id: gauageContainer2
                    Layout.preferredHeight: parent.height/2
                    Layout.fillWidth: true
                    color: "transparent"


                    SGCircularGauge{
                        id: localTempGauge
                        width: 200 * ratioCalc
                        height: 200 * ratioCalc

                        unitTextFontSizeMultiplier: ratioCalc * 2.5
                        tickmarkStepSize: 20
                        unitText: "°c"
                        valueDecimalPlaces: 0
                        anchors.centerIn: parent

                        property var temp_local_value: platformInterface.temp_local_value.value
                        onTemp_local_valueChanged: {
                            localTempGauge.value = temp_local_value
                        }

                        //                        property var temp_local_caption: platformInterface.temp_local_caption.caption
                        //                        onTemp_local_captionChanged: {
                        //                            localTempLabel.text = temp_local_caption
                        //                        }



                        property var temp_local_state: platformInterface.temp_local_state.state
                        onTemp_local_stateChanged: {
                            if(temp_local_state === "enabled"){
                                gauageContainer2.enabled = true
                                gauageContainer2.opacity = 1.0
                            }
                            else if (temp_local_state === "disabled"){
                                gauageContainer2.enabled = false
                                gauageContainer2.opacity = 1.0

                            }
                            else {
                                gauageContainer2.opacity = 0.5
                                gauageContainer2.enabled = false
                            }
                        }

                        property var temp_local_scales: platformInterface.temp_local_scales.scales
                        onTemp_local_scalesChanged: {
                            localTempGauge.maximumValue = temp_local_scales[0]
                            localTempGauge.minimumValue = temp_local_scales[1]
                        }

                    }
                }
                Rectangle {
                    id: pwmDutyCycle2Container
                    Layout.fillHeight: true
                    Layout.fillWidth: true
                    color: "transparent"


                    SGAlignedLabel {
                        id: pwmDutyCycle2Label
                        target: pwmDutyCycle2
                        alignment:  SGAlignedLabel.SideTopCenter
                        text: "PWM Positive \n Duty Cycle (%)"
                        anchors.centerIn: parent
                        fontSizeMultiplier: ratioCalc
                        font.bold : true
                        horizontalAlignment: Text.AlignHCenter
                        SGComboBox {
                            id: pwmDutyCycle2
                            fontSizeMultiplier: ratioCalc * 0.8
                            KeyNavigation.tab: pwmDutyCycle1
                            onActivated: {
                                platformInterface.set_pwm_temp_local_value.update(currentText)

                            }

                            property var temp_pwm_local_values: platformInterface.temp_pwm_local_values.values
                            onTemp_pwm_local_valuesChanged: {
                                pwmDutyCycle2.model = temp_pwm_local_values
                            }
                            property var temp_pwm_local_value: platformInterface.temp_pwm_local_value.value
                            onTemp_pwm_local_valueChanged: {
                                for(var i = 0; i < pwmDutyCycle2.model.length; ++i ){
                                    if( pwmDutyCycle2.model[i].toString() === temp_pwm_local_value)
                                    {
                                        currentIndex = i
                                        return;
                                    }
                                }
                            }

                            property var temp_pwm_local_state: platformInterface.temp_pwm_local_state.state
                            onTemp_pwm_local_stateChanged: {
                                if(temp_pwm_local_state === "enabled"){
                                    pwmDutyCycle2Container.enabled = true
                                    pwmDutyCycle2Container.opacity = 1.0
                                }
                                else if (temp_pwm_local_state === "disabled"){
                                    pwmDutyCycle2Container.enabled = false
                                    pwmDutyCycle2Container.opacity = 1.0

                                }
                                else {
                                    pwmDutyCycle2Container.opacity = 0.5
                                    pwmDutyCycle2Container.enabled = false
                                }
                            }
                        }
                    }
                }
            }
        } //top setting

        Rectangle {
            id: remoteSetting
            width: parent.width/2.2
            height: parent.height - topContainer.height
            color: "transparent"
            anchors {
                left: parent.left
                top: topContainer.bottom
                //topMargin: 5
                leftMargin: 10
                bottom: parent.bottom
                bottomMargin: 10
            }
            ColumnLayout {
                id: setting
                width: parent.width
                height:parent.height


                Rectangle{
                    Layout.fillWidth: true
                    Layout.preferredHeight: parent.height/10
                    color: "transparent"
                    Text {
                        id: bottomLeftHeading
                        text: "Remote Warnings, Limits, & Offset"
                        font.bold: true
                        font.pixelSize: ratioCalc * 15
                        color: "#696969"
                        anchors {
                            top: parent.top
                            topMargin: 5
                        }
                    }

                    Rectangle {
                        id: line5
                        Layout.alignment: Qt.AlignCenter
                        height: 1.2
                        width: parent.width
                        border.color: "lightgray"
                        radius: 2
                        anchors {
                            top: bottomLeftHeading.bottom
                            topMargin: 7
                        }
                    }
                }

                Rectangle {
                    Layout.preferredHeight: parent.height/10
                    Layout.fillWidth: true
                    color: "transparent"
                    RowLayout{
                        width: parent.width
                        height:parent.height
                        Rectangle {
                            id: rthrmContainer
                            Layout.fillHeight: true
                            Layout.fillWidth: true
                            SGAlignedLabel {
                                id: rthrmLabel
                                target: rthrm
                                font.bold: true
                                fontSizeMultiplier: ratioCalc
                                alignment: SGAlignedLabel.SideLeftCenter
                                anchors.centerIn: parent
                                SGStatusLight{
                                    id: rthrm
                                    width: 30
                                }
                                property var temp_rthrm_caption: platformInterface.temp_rthrm_caption.caption
                                onTemp_rthrm_captionChanged: {
                                    rthrmLabel.text = temp_rthrm_caption
                                }

                                property var temp_rthrm_value: platformInterface.temp_rthrm_value.value
                                onTemp_rthrm_valueChanged: {
                                    if(temp_rthrm_value === "0") {
                                        rthrm.status = SGStatusLight.Off
                                    }
                                    else  rthrm.status = SGStatusLight.Red
                                }

                                property var temp_rthrml_state: platformInterface.temp_rthrml_state.state
                                onTemp_rthrml_stateChanged: {
                                    if(temp_rthrml_state === "enabled"){
                                        rthrmContainer.enabled = true
                                        rthrmContainer.opacity = 1.0
                                    }
                                    else if (temp_rthrml_state === "disabled"){
                                        rthrmContainer.enabled = false
                                        rthrmContainer.opacity = 1.0

                                    }
                                    else {
                                        rthrmContainer.opacity = 0.5
                                        rthrm.enabled = false
                                    }
                                }
                            }
                        }




                        Rectangle {
                            id: rlowContainer
                            Layout.fillHeight: true
                            Layout.fillWidth: true
                            color: "transparent"
                            SGAlignedLabel {
                                id: rlowLabel
                                target: rlow
                                font.bold: true
                                fontSizeMultiplier: ratioCalc
                                alignment: SGAlignedLabel.SideLeftCenter
                                anchors.centerIn: parent
                                SGStatusLight{
                                    id: rlow
                                    width: 30
                                }
                            }
                            property var temp_rlow_caption: platformInterface.temp_rlow_caption.caption
                            onTemp_rlow_captionChanged: {
                                rlowLabel.text = temp_rlow_caption
                            }

                            property var temp_rlow_value: platformInterface.temp_rlow_value.value
                            onTemp_rlow_valueChanged: {
                                if(temp_rlow_value ==="0") {
                                    rlow.status = SGStatusLight.Off
                                }
                                else  rlow.status = SGStatusLight.Red
                            }

                            property var temp_rlow_state: platformInterface.temp_rlow_state.state
                            onTemp_rlow_stateChanged: {
                                if(temp_rlow_state === "enabled"){
                                    rlowContainer.enabled = true
                                    rlowContainer.opacity = 1.0
                                }
                                else if (temp_rlow_state === "disabled"){
                                    rlowContainer.enabled = false
                                    rlowContainer.opacity = 1.0
                                }
                                else {
                                    rlowContainer.opacity = 0.5
                                    rlowContainer.enabled = false
                                }
                            }
                        }




                        Rectangle {
                            id: rhighContainer
                            Layout.fillHeight: true
                            Layout.fillWidth: true
                            SGAlignedLabel {
                                id: rhighLabel
                                target: rhigh
                                font.bold: true
                                fontSizeMultiplier: ratioCalc
                                alignment: SGAlignedLabel.SideLeftCenter
                                anchors.centerIn: parent
                                SGStatusLight{
                                    id: rhigh
                                    width: 30
                                }
                            }
                            property var temp_rhigh_caption: platformInterface.temp_rhigh_caption.caption
                            onTemp_rhigh_captionChanged: {
                                rhighLabel.text = temp_rhigh_caption
                            }

                            property var temp_rhigh_value: platformInterface.temp_rhigh_value.value
                            onTemp_rhigh_valueChanged: {
                                if(temp_rhigh_value === "0") {
                                    rhigh.status = SGStatusLight.Off
                                }
                                else  rhigh.status = SGStatusLight.Red
                            }

                            property var temp_rhigh_state: platformInterface.temp_rhigh_state.state
                            onTemp_rhigh_stateChanged: {
                                if(temp_rhigh_state === "enabled"){
                                    rhighContainer.enabled = true
                                    rhighContainer.opacity = 1.0
                                }
                                else if (temp_rhigh_state === "disabled"){
                                    rhighContainer.enabled = false
                                    rhighContainer.opacity = 1.0
                                }
                                else {
                                    rhighContainer.opacity = 0.5
                                    rhighContainer.enabled = false
                                }
                            }
                        }







                        Rectangle {
                            id: openContainer
                            Layout.fillHeight: true
                            Layout.fillWidth: true
                            SGAlignedLabel {
                                id: openLabel
                                target: open
                                font.bold: true
                                fontSizeMultiplier: ratioCalc
                                alignment: SGAlignedLabel.SideLeftCenter
                                anchors.centerIn: parent
                                SGStatusLight{
                                    id: open
                                    width: 30
                                }
                                property var temp_open_caption: platformInterface.temp_open_caption.caption
                                onTemp_open_captionChanged: {
                                    openLabel.text = temp_open_caption
                                }

                                property var temp_open_value: platformInterface.temp_open_value.value
                                onTemp_open_valueChanged: {
                                    if(temp_open_value === "0") {
                                        open.status = SGStatusLight.Off
                                    }
                                    else  open.status = SGStatusLight.Red
                                }

                                property var temp_open_state: platformInterface.temp_open_state.state
                                onTemp_open_stateChanged: {
                                    if(temp_open_state === "enabled"){
                                        openContainer.enabled = true
                                        openContainer.opacity = 1.0
                                    }
                                    else if (temp_open_state === "disabled"){
                                        openContainer.enabled = false
                                        openContainer.opacity = 1.0
                                    }
                                    else {
                                        openContainer.opacity = 0.5
                                        openContainer.enabled = false
                                    }
                                }
                            }
                        }
                    }
                }
                Rectangle {
                    id:lowlimitContainer
                    Layout.fillHeight: true
                    Layout.fillWidth: true
                    color: "transparent"


                    SGAlignedLabel {
                        id: lowlimitLabel
                        target: lowlimit
                        fontSizeMultiplier: ratioCalc
                        font.bold : true
                        alignment: SGAlignedLabel.SideTopLeft
                         anchors.verticalCenter: parent.verticalCenter


                        SGSlider {
                            id: lowlimit
                            width: lowlimitContainer.width/1.2
                            live: false
                            fontSizeMultiplier: ratioCalc * 0.8
                            showInputBox: true
                            showToolTip:true
                            inputBox.enabled: false

                            inputBox.validator: DoubleValidator {
                                top: lowlimit.to
                                bottom: lowlimit.from
                            }
                            inputBoxWidth: lowlimitContainer.width/6
                            inputBox.boxColor: "#F0F0F0"
                            stepSize: 0.25



                            onUserSet: {

                                var number = value.toFixed(2)
                                inputBox.text = number
                                console.log(number.slice(0,number.length -3))
                                console.log(number.slice(-3))

                                platformInterface.set_temp_remote_low_lim.update(number.slice(0,number.length -3))
                                platformInterface.set_temp_remote_low_lim_frac.update("0"+number.slice(-3))


                            }
                        }
                    }
                    property var temp_remote_low_lim_caption: platformInterface.temp_remote_low_lim_caption.caption
                    onTemp_remote_low_lim_captionChanged: {
                        lowlimitLabel.text = temp_remote_low_lim_caption
                    }

                    property var temp_remote_low_lim_value: platformInterface.temp_remote_low_lim_value.value
                    onTemp_remote_low_lim_valueChanged: {
                        lowlimit.value = temp_remote_low_lim_value
                    }

                    property var temp_remote_low_lim_state: platformInterface.temp_remote_low_lim_state.state
                    onTemp_remote_low_lim_stateChanged: {
                        if(temp_remote_low_lim_state === "enabled"){
                            lowlimitContainer.enabled = true
                        }
                        else if(temp_remote_low_lim_state === "disabled"){
                            lowlimitContainer.enabled = false
                        }
                        else {
                            lowlimitContainer.enabled = false
                            lowlimitContainer.opacity = 0.5
                        }
                    }

                    property var temp_remote_low_lim_scales: platformInterface.temp_remote_low_lim_scales.scales
                    onTemp_remote_low_lim_scalesChanged: {
                        lowlimit.toText.text = temp_remote_low_lim_scales[0] + "˚C"
                        lowlimit.fromText.text = temp_remote_low_lim_scales[1] + "˚C"
                        lowlimit.from = temp_remote_low_lim_scales[1]
                        lowlimit.to = temp_remote_low_lim_scales[0]
                        lowlimit.stepSize = temp_remote_low_lim_scales[2]
                    }

                } // end

                Rectangle {
                    Layout.fillHeight: true
                    Layout.fillWidth: true
                    color: "transparent"
                    RowLayout{
                        width: parent.width
                        height:parent.height
                        spacing: 5
                        Rectangle {
                            id:highlimitContainer
                            Layout.fillHeight: true
                            Layout.fillWidth: true

                            SGAlignedLabel {
                                id: highlimitLabel
                                target: highlimit
                                fontSizeMultiplier: ratioCalc
                                font.bold : true
                                alignment: SGAlignedLabel.SideTopLeft
                                anchors.verticalCenter: parent.verticalCenter

                                SGSlider {
                                    id: highlimit
                                    width: highlimitContainer.width/1.2
                                    live: false
                                    fontSizeMultiplier: ratioCalc * 0.8
                                    showInputBox: true
                                    showToolTip:true
                                    inputBox.validator: DoubleValidator {
                                        top: highlimit.to
                                        bottom: highlimit.from
                                    }
                                    inputBox.enabled: false
                                    inputBox.boxColor: "#F0F0F0"
                                    inputBoxWidth: highlimitContainer.width/6
                                    stepSize: 1
                                    onUserSet: {

                                        var number = value.toFixed(2)
                                        inputBox.text = number
                                        console.log(number.slice(0,number.length -3))
                                        console.log(number.slice(-3))

                                        platformInterface.set_temp_remote_high_lim.update(number.slice(0,number.length -3))
                                        platformInterface.set_temp_remote_high_lim_frac.update("0"+number.slice(-3))
                                    }

                                    property var temp_remote_high_lim_caption: platformInterface.temp_remote_high_lim_caption.caption
                                    onTemp_remote_high_lim_captionChanged: {
                                        highlimitLabel.text = temp_remote_high_lim_caption
                                    }

                                    property var temp_remote_high_lim_value: platformInterface.temp_remote_high_lim_value.value
                                    onTemp_remote_high_lim_valueChanged: {
                                        highlimit.value = temp_remote_high_lim_value
                                    }

                                    property var temp_remote_high_lim_state: platformInterface.temp_remote_high_lim_state.state
                                    onTemp_remote_high_lim_stateChanged: {
                                        if(temp_remote_high_lim_state === "enabled"){
                                            highlimitContainer.enabled = true
                                        }
                                        else if(temp_remote_high_lim_state === "disabled"){
                                            highlimitContainer.enabled = false
                                        }
                                        else {
                                            highlimitContainer.enabled = false
                                            highlimitContainer.opacity = 0.5
                                        }
                                    }

                                    property var temp_remote_high_lim_scales: platformInterface.temp_remote_high_lim_scales.scales
                                    onTemp_remote_high_lim_scalesChanged: {
                                        highlimit.toText.text = temp_remote_high_lim_scales[0] + "˚C"
                                        highlimit.fromText.text = temp_remote_high_lim_scales[1] + "˚C"
                                        highlimit.from = temp_remote_high_lim_scales[1]
                                        highlimit.to = temp_remote_high_lim_scales[0]
                                        highlimit.stepSize = temp_remote_high_lim_scales[2]
                                    }
                                }
                            }
                        }
                    }
                }

                Rectangle {
                    id:remoteOffsetContainer
                    Layout.fillHeight: true
                    Layout.fillWidth: true
                    color: "transparent"


                    SGAlignedLabel {
                        id: remoteOffsetLabel
                        target: remoteOffset
                        fontSizeMultiplier: ratioCalc
                        font.bold : true
                        alignment: SGAlignedLabel.SideTopLeft
                        anchors.verticalCenter: parent.verticalCenter

                        SGSlider {
                            id: remoteOffset
                            width: remoteOffsetContainer.width/1.2
                            live: false
                            fontSizeMultiplier: ratioCalc * 0.8
                            showInputBox: true
                            showToolTip:true
                            inputBoxWidth: remoteOffsetContainer.width/6
                            inputBox.validator: DoubleValidator {
                                top: remoteOffset.to
                                bottom: remoteOffset.from
                            }
                            inputBox.enabled: false
                            inputBox.boxColor: "#F0F0F0"
                            stepSize: 1


                            onUserSet: {
                                var number = value.toFixed(2)
                                inputBox.text = number
                                console.log(number.slice(0,number.length -3))
                                console.log(number.slice(-3))
                                platformInterface.set_temp_remote_offset.update(number.slice(0,number.length -3))
                                platformInterface.set_temp_remote_offset_frac.update("0"+number.slice(-3))

                            }


                            property var temp_remote_offset_caption: platformInterface.temp_remote_offset_caption.caption
                            onTemp_remote_offset_captionChanged: {
                                remoteOffsetLabel.text = temp_remote_offset_caption
                            }

                            property var temp_remote_offset_value: platformInterface.temp_remote_offset_value.value
                            onTemp_remote_offset_valueChanged: {
                                remoteOffset.value = temp_remote_offset_value
                            }

                            property var temp_remote_offset_state: platformInterface.temp_remote_offset_state.state
                            onTemp_remote_offset_stateChanged: {
                                if(temp_remote_offset_state === "enabled"){
                                    remoteOffsetContainer.enabled = true
                                }
                                else if(temp_remote_offset_state === "disabled"){
                                    remoteOffsetContainer.enabled = false
                                }
                                else {
                                    remoteOffsetContainer.enabled = false
                                    remoteOffsetContainer.opacity = 0.5
                                }
                            }

                            property var temp_remote_offset_scales: platformInterface.temp_remote_offset_scales.scales
                            onTemp_remote_offset_scalesChanged: {
                                remoteOffset.toText.text = temp_remote_offset_scales[0] + "˚C"
                                remoteOffset.fromText.text = temp_remote_offset_scales[1] + "˚C"
                                remoteOffset.from = temp_remote_offset_scales[1]
                                remoteOffset.to = temp_remote_offset_scales[0]
                                remoteOffset.stepSize = temp_remote_offset_scales[2]
                            }


                        }
                    }
                }

                Rectangle {
                    id:tempRemoteThermLimContainer
                    Layout.fillHeight: true
                    Layout.fillWidth: true
                    color: "transparent"


                    SGAlignedLabel {

                        id: tempRemoteThermLimLabel
                        target: tempRemoteThermLim
                        fontSizeMultiplier: ratioCalc

                        font.bold : true
                        alignment: SGAlignedLabel.SideTopLeft
                         anchors.verticalCenter: parent.verticalCenter


                        SGSlider {
                            id: tempRemoteThermLim
                            width: tempRemoteThermLimContainer.width/1.2
                            live: false
                            fontSizeMultiplier: ratioCalc * 0.8
                            showInputBox: true
                            showToolTip:true
                            inputBox.validator: DoubleValidator {
                                top: tempRemoteThermLim.to
                                bottom: tempRemoteThermLim.from
                            }
                            inputBox.enabled: false
                            inputBox.boxColor: "#F0F0F0"

                            inputBoxWidth: tempRemoteThermLimContainer.width/6

                            onUserSet: platformInterface.set_temp_remote_therm_lim.update(value.toString())
                            property var temp_remote_therm_lim_caption: platformInterface.temp_remote_therm_lim_caption.caption
                            onTemp_remote_therm_lim_captionChanged: {
                                tempRemoteThermLimLabel.text = temp_remote_therm_lim_caption
                            }
                            property var temp_remote_therm_limt_value: platformInterface.temp_remote_therm_limt_value.value
                            onTemp_remote_therm_limt_valueChanged: {
                                tempRemoteThermLim.value = temp_remote_therm_limt_value
                            }
                            property var temp_remote_therm_lim_scales: platformInterface.temp_remote_therm_lim_scales.scales
                            onTemp_remote_therm_lim_scalesChanged: {
                                tempRemoteThermLim.toText.text = temp_remote_therm_lim_scales[0] + "˚C"
                                tempRemoteThermLim.fromText.text = temp_remote_therm_lim_scales[1] + "˚C"
                                tempRemoteThermLim.from = temp_remote_therm_lim_scales[1]
                                tempRemoteThermLim.to = temp_remote_therm_lim_scales[0]
                                tempRemoteThermLim.stepSize = temp_remote_therm_lim_scales[2]
                            }
                        }
                    }
                }


            }
        } // end of remote setting (left bottom)


        Rectangle {
            width: parent.width/2.2
            height: parent.height - topContainer.height
            color: "transparent"
            anchors {
                right: parent.right
                top: topContainer.bottom
                //topMargin: 5
                leftMargin: 10
                bottom: parent.bottom
                bottomMargin: 10
            }

            ColumnLayout {
                id: rightSetting
                width: parent.width
                height:parent.height



                Rectangle{
                    Layout.fillWidth: true
                    Layout.preferredHeight: parent.height/10
                    color: "transparent"
                    Text {
                        id: bottomRightHeading
                        text: "Local Warnings, Limits, & Offset"
                        font.bold: true
                        font.pixelSize: ratioCalc * 15
                        color: "#696969"
                        anchors {
                            top: parent.top
                            topMargin: 5
                        }
                    }

                    Rectangle {
                        id: line6
                        Layout.alignment: Qt.AlignCenter
                        height: 1.2
                        width: parent.width
                        border.color: "lightgray"
                        radius: 2
                        anchors {
                            top: bottomRightHeading.bottom
                            topMargin: 7
                        }
                    }
                }

                Rectangle {
                    Layout.preferredHeight: parent.height/10
                    Layout.fillWidth: true
                    color: "transparent"
                    RowLayout{
                        width: parent.width
                        height:parent.height
                        Rectangle {
                            id: lthrmContainer
                            Layout.fillHeight: true
                            Layout.fillWidth: true
                            SGAlignedLabel {
                                id: lthrmLabel
                                target: lthrm
                                font.bold: true
                                fontSizeMultiplier: ratioCalc
                                alignment: SGAlignedLabel.SideLeftCenter
                                anchors.centerIn: parent
                                SGStatusLight{
                                    id: lthrm
                                    width: 30
                                }

                                property var temp_lthrm_caption: platformInterface.temp_lthrm_caption.caption
                                onTemp_lthrm_captionChanged: {
                                    lthrmLabel.text = temp_lthrm_caption
                                }

                                property var temp_lthrm_value: platformInterface.temp_lthrm_value.value
                                onTemp_lthrm_valueChanged: {
                                    if(temp_lthrm_value === "0") {
                                        lthrm.status = SGStatusLight.Off
                                    }
                                    else  lthrm.status = SGStatusLight.Red
                                }

                                property var temp_lthrm_state: platformInterface.temp_lthrm_state.state
                                onTemp_lthrm_stateChanged: {
                                    if(temp_lthrm_state === "enabled"){
                                        lthrmContainer.enabled = true
                                        lthrmContainer.opacity = 1.0
                                    }
                                    else if (temp_lthrm_state === "disabled"){
                                        lthrmContainer.enabled = false
                                        lthrmContainer.opacity = 1.0
                                    }
                                    else {
                                        lthrmContainer.opacity = 0.5
                                        lthrmContainer.enabled = false
                                    }
                                }


                            }
                        }

                        Rectangle {
                            id: llowContainer
                            Layout.fillHeight: true
                            Layout.fillWidth: true
                            SGAlignedLabel {
                                id: llowLabel
                                target: llow
                                font.bold: true
                                fontSizeMultiplier: ratioCalc
                                alignment: SGAlignedLabel.SideLeftCenter
                                anchors.centerIn: parent
                                SGStatusLight{
                                    id: llow
                                    width: 30
                                }

                                property var temp_llow_caption: platformInterface.temp_llow_caption.caption
                                onTemp_llow_captionChanged: {
                                    llowLabel.text = temp_llow_caption
                                }

                                property var temp_llow_value: platformInterface.temp_llow_value.value
                                onTemp_llow_valueChanged: {
                                    if(temp_llow_value === "0") {
                                        llow.status = SGStatusLight.Off
                                    }
                                    else  llow.status = SGStatusLight.Red
                                }

                                property var temp_llow_state: platformInterface.temp_llow_state.state
                                onTemp_llow_stateChanged: {
                                    if(temp_llow_state === "enabled"){
                                        llowContainer.enabled = true
                                        llowContainer.opacity = 1.0
                                    }
                                    else if (temp_llow_state === "disabled"){
                                        llowContainer.enabled = false
                                        llowContainer.opacity = 1.0
                                    }
                                    else {
                                        llowContainer.opacity = 0.5
                                        llowContainer.enabled = false
                                    }
                                }
                            }
                        }

                        Rectangle {
                            id: lhighContainer
                            Layout.fillHeight: true
                            Layout.fillWidth: true
                            SGAlignedLabel {
                                id: lhighLabel
                                target: lhigh
                                font.bold: true
                                fontSizeMultiplier: ratioCalc
                                alignment: SGAlignedLabel.SideLeftCenter
                                anchors.centerIn: parent
                                SGStatusLight{
                                    id: lhigh
                                    width: 30
                                }

                                property var temp_lhigh_caption: platformInterface.temp_lhigh.caption
                                onTemp_lhigh_captionChanged: {
                                    lhighLabel.text = temp_lhigh_caption
                                }

                                property var temp_lhigh_value: platformInterface.temp_lhigh_value.value
                                onTemp_lhigh_valueChanged: {
                                    if(temp_lhigh_value === "0") {
                                        lhigh.status = SGStatusLight.Off
                                    }
                                    else  lhigh.status = SGStatusLight.Red
                                }

                                property var temp_lhigh_state: platformInterface.temp_lhigh_state.state
                                onTemp_lhigh_stateChanged: {
                                    if(temp_lhigh_state === "enabled"){
                                        lhighContainer.enabled = true
                                        lhighContainer.opacity = 1.0
                                    }
                                    else if (temp_lhigh_state === "disabled"){
                                        lhighContainer.enabled = false
                                        lhighContainer.opacity = 1.0
                                    }
                                    else {
                                        lhighContainer.opacity = 0.5
                                        lhighContainer.enabled = false
                                    }
                                }


                            }
                        }
                    }
                }
                Rectangle {
                    id:locallowlimitContainer
                    Layout.fillHeight: true
                    Layout.fillWidth: true
                    color: "transparent"


                    SGAlignedLabel {
                        id: locallowlimitLabel
                        target: locallowlimit
                        fontSizeMultiplier: ratioCalc
                        font.bold : true
                        alignment: SGAlignedLabel.SideTopLeft
                        anchors.verticalCenter: parent.verticalCenter

                        SGSlider {
                            id: locallowlimit
                            width: locallowlimitContainer.width/1.2
                            live: false
                            fontSizeMultiplier: ratioCalc * 0.8
                            showInputBox: true
                            showToolTip:true
                            inputBox.validator: DoubleValidator {
                                top: locallowlimit.to
                                bottom: locallowlimit.from
                            }
                            inputBox.enabled: false
                            inputBox.boxColor: "#F0F0F0"
                            inputBoxWidth: locallowlimitContainer.width/6
                            onUserSet: {
                                platformInterface.set_temp_local_low_lim.update(value.toString())
                            }

                            property var temp_local_low_lim_caption: platformInterface.temp_local_low_lim_caption.caption
                            onTemp_local_low_lim_captionChanged: {
                                locallowlimitLabel.text = temp_local_low_lim_caption
                            }
                            property var temp_local_low_lim_value: platformInterface.temp_local_low_lim_value.value
                            onTemp_local_low_lim_valueChanged: {
                                locallowlimit.value = temp_local_low_lim_value
                            }
                            property var temp_local_low_lim_scales: platformInterface.temp_local_low_lim_scales.scales
                            onTemp_local_low_lim_scalesChanged: {
                                locallowlimit.toText.text = temp_local_low_lim_scales[0] + "˚C"
                                locallowlimit.fromText.text = temp_local_low_lim_scales[1] + "˚C"
                                locallowlimit.from = temp_local_low_lim_scales[1]
                                locallowlimit.to = temp_local_low_lim_scales[0]
                                locallowlimit.stepSize = temp_local_low_lim_scales[2]

                            }

                            property var temp_local_low_lim_state: platformInterface.temp_local_low_lim_state.state
                            onTemp_local_low_lim_stateChanged: {
                                if(temp_local_low_lim_state === "enabled"){
                                    locallowlimitContainer.enabled = true
                                    locallowlimitContainer.opacity = 1.0
                                }
                                else if (temp_local_low_lim_state === "disabled"){
                                    locallowlimitContainer.enabled = false
                                    locallowlimitContainer.opacity = 1.0
                                }
                                else {
                                    console.log(temp_local_low_lim_state)
                                    locallowlimitContainer.opacity = 0.5
                                    locallowlimitContainer.enabled = false
                                }
                            }
                        }
                    }

                }
                Rectangle {
                    id:localHighlimitContainer
                    Layout.fillHeight: true
                    Layout.fillWidth: true
                    color: "transparent"

                    SGAlignedLabel {
                        id: localHighlimitLabel
                        target: locaHighlimit
                        fontSizeMultiplier: ratioCalc
                        font.bold : true
                        alignment: SGAlignedLabel.SideTopLeft
                        anchors.verticalCenter: parent.verticalCenter
                        SGSlider {
                            id: locaHighlimit
                            width: localHighlimitContainer.width/1.2
                            live: false
                            fontSizeMultiplier: ratioCalc * 0.8
                            showInputBox: true
                            showToolTip:true
                            inputBox.validator: DoubleValidator {
                                top: locaHighlimit.to
                                bottom: locaHighlimit.from
                            }
                            inputBox.enabled: false
                            inputBox.boxColor: "#F0F0F0"
                            inputBoxWidth: localHighlimitContainer.width/6



                            onUserSet:  platformInterface.set_temp_local_high_lim.update(value.toString())


                            property var temp_local_high_lim_caption: platformInterface.temp_local_high_lim_caption.caption
                            onTemp_local_high_lim_captionChanged: {
                                localHighlimitLabel.text = temp_local_high_lim_caption
                            }
                            property var temp_local_high_lim_value: platformInterface.temp_local_high_lim_value.value
                            onTemp_local_high_lim_valueChanged: {
                                locaHighlimit.value = temp_local_high_lim_value
                            }
                            property var temp_local_high_lim_scales: platformInterface.temp_local_high_lim_scales.scales
                            onTemp_local_high_lim_scalesChanged: {
                                locaHighlimit.toText.text = temp_local_high_lim_scales[0] + "˚C"
                                locaHighlimit.fromText.text = temp_local_high_lim_scales[1] + "˚C"
                                locaHighlimit.from = temp_local_high_lim_scales[1]
                                locaHighlimit.to = temp_local_high_lim_scales[0]
                                locaHighlimit.stepSize = temp_local_high_lim_scales[2]
                            }

                            property var temp_local_high_lim_state: platformInterface.temp_local_high_lim_state.state
                            onTemp_local_high_lim_stateChanged: {
                                if(temp_local_high_lim_state === "enabled"){
                                    localHighlimitContainer.enabled = true
                                    localHighlimitContainer.opacity = 1.0
                                }
                                else if (temp_local_high_lim_state === "disabled"){
                                    localHighlimitContainer.enabled = false
                                    localHighlimitContainer.opacity = 1.0
                                }
                                else {
                                    localHighlimitContainer.opacity = 0.5
                                    localHighlimitContainer.enabled = false
                                }
                            }
                        }

                    }
                }
                Rectangle {
                    id:localThermlimitContainer
                    Layout.fillHeight: true
                    Layout.fillWidth: true
                    color: "transparent"


                    SGAlignedLabel {
                        id: localThermlimitLabel
                        target: localThermlimit
                        fontSizeMultiplier: ratioCalc
                        font.bold : true
                        alignment: SGAlignedLabel.SideTopLeft
                        anchors.verticalCenter: parent.verticalCenter

                        SGSlider {
                            id: localThermlimit
                            width: localThermlimitContainer.width/1.2
                            live: false
                            fontSizeMultiplier: ratioCalc * 0.8
                            showInputBox: true
                            showToolTip:true
                            inputBox.validator: DoubleValidator {
                                top: localThermlimit.to
                                bottom: localThermlimit.from
                            }
                            inputBox.enabled: false
                            inputBox.boxColor: "#F0F0F0"
                            inputBoxWidth: localThermlimitContainer.width/6

                            onUserSet:  platformInterface.set_temp_local_therm_lim.update(value.toString())

                            property var temp_local_therm_lim_caption: platformInterface.temp_local_therm_lim_caption.caption
                            onTemp_local_therm_lim_captionChanged: {
                                localThermlimitLabel.text = temp_local_therm_lim_caption
                            }
                            property var temp_local_therm_lim_value: platformInterface.temp_local_therm_lim_value.value
                            onTemp_local_therm_lim_valueChanged: {
                                localThermlimit.value = temp_local_therm_lim_value
                            }
                            property var temp_local_therm_lim_scales: platformInterface.temp_local_therm_lim_scales.scales
                            onTemp_local_therm_lim_scalesChanged: {
                                localThermlimit.toText.text = temp_local_therm_lim_scales[0] + "˚C"
                                localThermlimit.fromText.text = temp_local_therm_lim_scales[1] + "˚C"
                                localThermlimit.from = temp_local_therm_lim_scales[1]
                                localThermlimit.to = temp_local_therm_lim_scales[0]
                                localThermlimit.stepSize = temp_local_therm_lim_scales[2]
                            }

                            property var temp_local_therm_lim_state: platformInterface.temp_local_therm_lim_state.state
                            onTemp_local_therm_lim_stateChanged: {
                                if(temp_local_therm_lim_state === "enabled"){
                                    localThermlimitContainer.enabled = true
                                    localThermlimitContainer.opacity = 1.0
                                }
                                else if (temp_local_therm_lim_state === "disabled"){
                                    localThermlimitContainer.enabled = false
                                    localThermlimitContainer.opacity = 1.0
                                }
                                else {
                                    localThermlimitContainer.opacity = 0.5
                                    localThermlimitContainer.enabled = false
                                }
                            }
                        }
                    }
                }
                Rectangle {
                    Layout.fillHeight: true
                    Layout.fillWidth: true
                    color: "transparent"
                }

            }

        }

    }
}
