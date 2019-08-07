import QtQuick 2.12
import QtQuick.Layouts 1.12
import QtQuick.Controls 2.12

import tech.strata.sgwidgets 1.0

import "qrc:/js/help_layout_manager.js" as Help

Rectangle {
    id: root

    property real minimumHeight
    property real minimumWidth

    signal zoom

    property real defaultMargin: 20
    property real defaultPadding: 20
    property real factor: Math.max(1,(hideHeader ? 0.8 : 1) * Math.min(root.height/minimumHeight,root.width/minimumWidth))

    // UI state
    property real freq: platformInterface.pwm_led_ui_freq
    property real duty: platformInterface.pwm_led_ui_duty
    property real volt: platformInterface.dac_led_ui_volt

    Component.onCompleted: {
        if (!hideHeader) {
            Help.registerTarget(root, "Each box represents the box on the silkscreen.\nExcept the \"DAC to LED\" and \"PWM to LED\" are combined.", 2, "helloStrataHelp")
        }
        else {
            Help.registerTarget(dacSlider, "This will set the DAC output voltage to the LED. 2V is the maximum output.", 0, "helloStrata_DACPWMToLED_Help")
            Help.registerTarget(pwmSlider, "This slider will set the duty cycle of the PWM signal going to the LED.", 1, "helloStrata_DACPWMToLED_Help")
            Help.registerTarget(freqBox, "The entry box sets the frequency. Hit 'enter' or 'tab' to set the register.", 2, "helloStrata_DACPWMToLED_Help")
        }
    }

    onFreqChanged: {
        freqBox.text = freq.toString()
    }

    onDutyChanged: {
        pwmSlider.value = duty
    }

    onVoltChanged: {
        dacSlider.value = volt
    }

    // hide in tab view
    property bool hideHeader: false
    onHideHeaderChanged: {
        if (hideHeader) {
            header.visible = false
            border.width = 0
        }
        else {
            header.visible = true
            border.width = 1
        }
    }

    border {
        width: 1
        color: "lightgrey"
    }

    ColumnLayout {
        id: container
        anchors.fill:parent
        spacing: 0

        RowLayout {
            id: header
            Layout.alignment: Qt.AlignTop

            Text {
                id: name
                text: "<b>" + qsTr("DAC to LED and PWM to LED") + "</b>"
                font.pixelSize: 14*factor
                color:"black"
                Layout.fillWidth: true
                Layout.alignment: Qt.AlignLeft | Qt.AlignVCenter
                Layout.margins: defaultMargin * factor
                wrapMode: Text.WordWrap
            }

            Button {
                id: btn
                text: qsTr("Maximize")
                Layout.preferredHeight: btnText.contentHeight+6*factor
                Layout.preferredWidth: btnText.contentWidth+20*factor
                Layout.alignment: Qt.AlignRight | Qt.AlignVCenter
                Layout.margins: defaultMargin * factor

                contentItem: Text {
                    id: btnText
                    text: btn.text
                    font.pixelSize: 10*factor
                    color: "black"
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                }

                onClicked: zoom()
            }
        }

        Item {
            id: content
            Layout.fillHeight: true
            Layout.fillWidth: true
            Layout.maximumWidth: hideHeader ? 0.8 * root.width : root.width - defaultPadding * 2
            Layout.alignment: Qt.AlignCenter

            ColumnLayout {
                anchors.centerIn: parent
                spacing: 10 * factor
                SGAlignedLabel {
                    target: dacSlider
                    text:"<b>DAC</b>"
                    fontSizeMultiplier: factor
                    SGSlider {
                        id: dacSlider
                        textColor: "black"
                        stepSize: 0.001
                        from: 0
                        to: 2
                        startLabel: "0"
                        endLabel: "2 V"
                        toolTipDecimalPlaces: 3
                        width: content.width
                        fontSizeMultiplier: factor
                        onUserSet: {
                            platformInterface.dac_led_ui_volt = value
                            platformInterface.dac_led_set_voltage.update(value)
                        }
                    }
                }
                SGAlignedLabel {
                    target: pwmSlider
                    text:"<b>" + qsTr("PWM Positive Duty Cycle (%)") + "</b>"
                    fontSizeMultiplier: factor
                    SGSlider {
                        id: pwmSlider
                        textColor: "black"
                        stepSize: 0.01
                        from: 0
                        to: 100
                        startLabel: "0"
                        endLabel: "100 %"
                        toolTipDecimalPlaces: 2
                        width: content.width
                        fontSizeMultiplier: factor
                        onUserSet: {
                            platformInterface.pwm_led_ui_duty = value
                            platformInterface.pwm_led_set_duty.update(value/100)
                        }
                    }
                }

                SGAlignedLabel {
                    target: freqBox
                    text: "<b>" + qsTr("PWM Frequency") + "</b>"
                    fontSizeMultiplier: factor
                    SGInfoBox {
                        id: freqBox
                        readOnly: false
                        height: 30 * factor
                        width: 130 * factor
                        unit: "kHz"
                        text: root.freq.toString()
                        fontSizeMultiplier: factor
                        placeholderText: "0.001 - 1000"
                        validator: DoubleValidator {
                            bottom: 0.001
                            top: 1000
                        }
                        onEditingFinished: {
                            if (acceptableInput) {
                                platformInterface.pwm_led_ui_freq = Number(text)
                                platformInterface.pwm_led_set_freq.update(Number(text))
                            }
                        }
                        onAccepted: platformInterface.pwm_led_set_freq.update(Number(text))
                        KeyNavigation.tab: root
                    }
                }
            }
        }
    }
}
