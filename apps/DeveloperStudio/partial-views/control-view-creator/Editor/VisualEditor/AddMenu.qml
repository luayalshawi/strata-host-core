import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.12
import QtGraphicalEffects 1.0

Popup {
    id: addPop
    y: parent.height
    background: Rectangle { }
    padding: 0

    ColumnLayout {
        spacing: 1

        Repeater {
            model: ListModel {

                ListElement {
                    text: "Button"
                    controlUrl: ":/tech/strata/sglayout.1.0/widgets/Button/Button.txt"
                }

                ListElement {
                    text: "ButtonStrip"
                    controlUrl: ":/tech/strata/sglayout.1.0/widgets/ButtonStrip/SGButtonStrip.txt"
                }

                ListElement {
                    text: "CircularGauge"
                    controlUrl: ":/tech/strata/sglayout.1.0/widgets/CircularGauge/SGCircularGauge.txt"
                }

                ListElement {
                    text: "ComboBox"
                    controlUrl: ":/tech/strata/sglayout.1.0/widgets/ComboBox/SGComboBox.txt"
                }

                ListElement {
                    text: "Divider"
                    controlUrl: ":/tech/strata/sglayout.1.0/widgets/Divider/Divider.txt"
                }

                ListElement {
                    text: "Graph"
                    controlUrl: ":/tech/strata/sglayout.1.0/widgets/Graph/SGGraph.txt"
                }

                ListElement {
                    text: "Icon"
                    controlUrl: ":/tech/strata/sglayout.1.0/widgets/SGIcon/SGIcon.txt"
                }

                ListElement {
                    text: "InfoBox"
                    controlUrl: ":/tech/strata/sglayout.1.0/widgets/InfoBox/SGInfoBox.txt"
                }

                ListElement {
                    text: "RadioButtons"
                    controlUrl: ":/tech/strata/sglayout.1.0/widgets/RadioButtons/SGRadioButtons.txt"
                }

                ListElement {
                    text: "Rectangle"
                    controlUrl: ":/tech/strata/sglayout.1.0/widgets/Rectangle/Rectangle.txt"
                }

                ListElement {
                    text: "Slider"
                    controlUrl: ":/tech/strata/sglayout.1.0/widgets/Slider/SGSlider.txt"
                }

                ListElement {
                    text: "StatusLight"
                    controlUrl: ":/tech/strata/sglayout.1.0/widgets/StatusLight/SGStatusLight.txt"
                }

                ListElement {
                    text: "StatusLogBox"
                    controlUrl: ":/tech/strata/sglayout.1.0/widgets/StatusLogBox/SGStatusLogBox.txt"
                }

                ListElement {
                    text: "Switch"
                    controlUrl: ":/tech/strata/sglayout.1.0/widgets/Switch/SGSwitch.txt"
                }

                ListElement {
                    text: "Text"
                    controlUrl: ":/tech/strata/sglayout.1.0/widgets/Text/Text.txt"
                }
            }

            delegate: Button {
                text: model.text
                Layout.preferredHeight: 20
                Layout.preferredWidth: 110

                onClicked: {
                    visualEditor.functions.addControl(model.controlUrl)
                    addPop.close()
                }
            }
        }
    }
}
