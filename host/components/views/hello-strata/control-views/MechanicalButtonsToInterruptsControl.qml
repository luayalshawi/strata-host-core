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
    property real factor: Math.max(1,(hideHeader ? 0.6 : 1) * Math.min(root.height/minimumHeight,root.width/minimumWidth))
    property real lightSizeValue: 25*factor

    // notification
    property var sw1: platformInterface.mechanical_buttons_noti_sw1
    property var sw2: platformInterface.mechanical_buttons_noti_sw2
    property var sw3: platformInterface.mechanical_buttons_noti_sw3
    property var sw4: platformInterface.mechanical_buttons_noti_sw4

    Component.onCompleted: {
        if (hideHeader) {
            Help.registerTarget(buttons, "The status of the buttons on the board will show here. The LED for SW1, SW2 is lit when the button is released. The LED for SW3, SW4 is lit when the button is being pressed.", 0, "helloStrata_ButtonsInterrupts_Help")
        }
    }

    onSw1Changed: {
        led1.status = sw1.value ? SGStatusLight.Green : SGStatusLight.Off
    }

    onSw2Changed: {
        led2.status = sw2.value ? SGStatusLight.Green : SGStatusLight.Off
    }

    onSw3Changed: {
        led3.status = sw3.value ? SGStatusLight.Green : SGStatusLight.Off
    }

    onSw4Changed: {
        led4.status = sw4.value ? SGStatusLight.Green : SGStatusLight.Off
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
                text: "<b>" + qsTr("Mechanical Buttons to Interrupts") + "</b>"
                font.pixelSize: 14*factor
                color:"black"
                Layout.fillWidth: true
                Layout.alignment: Qt.AlignLeft
                Layout.margins: defaultMargin * factor
                wrapMode: Text.WordWrap
            }

            Button {
                id: btn
                text: qsTr("Maximize")
                Layout.preferredHeight: btnText.contentHeight+6*factor
                Layout.preferredWidth: btnText.contentWidth+20*factor
                Layout.alignment: Qt.AlignRight
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
            Layout.maximumWidth: root.width * 0.6
            Layout.alignment: Qt.AlignHCenter
            ColumnLayout {
                anchors.centerIn: parent
                spacing: defaultMargin * factor
                RowLayout {
                    id: buttons
                    Layout.alignment: Qt.AlignHCenter
                    spacing: defaultMargin * factor
                    SGAlignedLabel {
                        target: led1
                        text: "<b>" + qsTr("SW1") + "</b>"
                        fontSizeMultiplier: factor
                        alignment: SGAlignedLabel.SideTopCenter
                        SGStatusLight {
                            id: led1
                            width: lightSizeValue * factor
                        }
                    }
                    SGAlignedLabel {
                        target: led2
                        text: "<b>" + qsTr("SW2") + "</b>"
                        fontSizeMultiplier: factor
                        alignment: SGAlignedLabel.SideTopCenter
                        SGStatusLight {
                            id: led2
                            width: lightSizeValue * factor
                        }
                    }
                    SGAlignedLabel {
                        target: led3
                        text: "<b>" + qsTr("SW3") + "</b>"
                        fontSizeMultiplier: factor
                        alignment: SGAlignedLabel.SideTopCenter
                        SGStatusLight {
                            id: led3
                            width: lightSizeValue * factor
                        }
                    }
                    SGAlignedLabel {
                        target: led4
                        text: "<b>" + qsTr("SW4") + "</b>"
                        fontSizeMultiplier: factor
                        alignment: SGAlignedLabel.SideTopCenter
                        SGStatusLight {
                            id: led4
                            width: lightSizeValue * factor
                        }
                    }
                }
                Image {
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    Layout.alignment: Qt.AlignHCenter
                    Layout.maximumWidth: (lightSizeValue * 4 + defaultMargin * 3) * factor
                    Layout.maximumHeight: (lightSizeValue + 12) * factor
                    fillMode: Image.PreserveAspectFit
                    source: "Images/helpImage_interrupt.png"
                }
            }
        }
    }
}
