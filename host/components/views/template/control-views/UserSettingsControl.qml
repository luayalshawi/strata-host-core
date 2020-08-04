import QtQuick 2.12
import QtQuick.Layouts 1.12
import QtQuick.Controls 2.12

import tech.strata.sgwidgets 1.0
import tech.strata.sgwidgets 0.9 as Widget09
import "qrc:/js/help_layout_manager.js" as Help

Rectangle {
    id: container

    color: "#DDA"

    Column {
        id: basicSettingsControl

        width: parent.width / 2 - verticalDivider.width

        anchors {
            left: parent.left
            leftMargin: 10
        }

        spacing: 3

        // This example will place te settings in basicSliders.json. This is in the AppData path for this Application
        property string configFileName: "basicSliders.json"

        Component.onCompleted: {
           loadSettings()
        }

        Component.onDestruction: {
            saveSettings()
        }

        // Saves the current slider position configuration
        function saveSettings() {
            let config = {
                sliders: {
                    slider1: slider1.value,
                    slider2: slider2.value,
                    slider3: slider3.value
                }
            };
            sgUserSettings.writeFile(configFileName, config);
        }

        // Loads the slider position configuration if it exists
        function loadSettings() {
            let config = sgUserSettings.readFile(configFileName)
            if (config.hasOwnProperty('sliders')) {
                slider1.value = config.sliders.slider1
                slider2.value = config.sliders.slider2
                slider3.value = config.sliders.slider3
            }
        }

        SGText {
            text: "Basic"
            fontSizeMultiplier: 3.0
        }

        SGText {
            width: parent.width - 10
            text: "This example demonstrates how to save and load user configuration information without the user's involvement. These slider values will automatically be saved each time the user performs an action on the slider. Also, the last saved configuration will be automatically loaded next time the app is launched."
            wrapMode: Text.WordWrap
        }

        Row {
            spacing: 10

            SGAlignedLabel{
                id: sliderLabel1
                target: slider1
                text: "Slider 1"
                fontSizeMultiplier: 1.3

                SGSlider {
                    id: slider1

                    height: 300
                    from: -10
                    to: 10
                    orientation: Qt.Vertical
                    onPressedChanged: {
                        if (!pressed) {
                            basicSettingsControl.saveSettings()
                        }
                    }
                }
            }
            SGAlignedLabel{
                id: sliderLabel2
                target: slider2
                text: "Slider 2"
                fontSizeMultiplier: 1.3

                SGSlider {
                    id: slider2

                    height: 300
                    from: -10
                    to: 10
                    orientation: Qt.Vertical
                    onPressedChanged: {
                        if (!pressed) {
                            basicSettingsControl.saveSettings()
                        }
                    }
                }
            }
            SGAlignedLabel{
                id: sliderLabel3
                target: slider3
                text: "Slider 3"
                fontSizeMultiplier: 1.3

                SGSlider {
                    id: slider3

                    height: 300
                    from: -10
                    to: 10
                    orientation: Qt.Vertical
                    onPressedChanged: {
                        if (!pressed) {
                            basicSettingsControl.saveSettings()
                        }
                    }
                }
            }
        }

    }

    Rectangle {
        id: verticalDivider

        anchors {
            centerIn: parent
            bottom: parent.bottom
        }

        color: "#cecece"
        width: 1
        height: parent.height
    }

    Column {
        id: advancedSettingsControl

        width: parent.width / 2 - verticalDivider.width

        anchors {
            left: parent.horizontalCenter
            leftMargin: 10
        }

        spacing: 5

        property string subdirName: "advancedSettings"

        // save settings to a file with name <settingsName>
        function saveSettings(settingsName) {
            sgUserSettings.writeFile(`${settingsName}.json`,
                                     {
                                         "sliderValue": slider.value,
                                         "sliderEnabled": editEnabledCheckBox.checked
                                     },
                                     advancedSettingsControl.subdirName
            );
        }

        // load the slider enabled and slider value config from a saved setting
        function loadSettings() {
            let config = sgUserSettings.readFile(comboBoxDemo.filesInDir[comboBoxDemo.currentIndex], advancedSettingsControl.subdirName)
            demoLabel.enabled = config.sliderEnabled
            editEnabledCheckBox.checked = config.sliderEnabled
            slider.value = config.sliderValue
        }

        SGText {
            text: "Advanced"
            fontSizeMultiplier: 3.0
        }

        SGText {
            width: parent.width - 10
            text: "This advanced example allows the user to name, load, and delete a configuration. This type of control can be used in situations where the user might want to have multiple saved configurations to choose from."
            wrapMode: Text.WordWrap
        }

        SGAlignedLabel{
            id: demoLabel
            target: slider
            text: "Default Slider"
            fontSizeMultiplier: 1.3
            enabled: editEnabledCheckBox.checked

            SGSlider {
                id: slider

                enabled: editEnabledCheckBox.enabled
                width: 400
                from: -10
                to: 10

                onValueChanged: console.info("Slider value is now:", value)  // Signals on any value change (both user and programmatic changes)
                onUserSet: console.info("Slider set by user to:", value)     // Signals when user sets value (affected by live)
            }
        }

        SGCheckBox {
            id: editEnabledCheckBox
            text: "Slider enabled"
            checked: true
            onCheckStateChanged: {
                slider.enabled = checked
                demoLabel.enabled = checked
            }
        }

        Row {
            spacing: 3

            SGTextField {
                id: saveSettingsTF
                placeholderText: "Configuration Name"
            }

            SGButton {
                text: "Save Configuration"

                onClicked: {
                    if (saveSettingsTF.displayText.length > 0) {
                        advancedSettingsControl.saveSettings(saveSettingsTF.displayText)
                        comboBoxDemo.updateList();
                        saveSettingsTF.text = "";
                    }
                }
            }
        }

    }
    Row {
        anchors {
            bottom: container.bottom
            bottomMargin: 10
            left: container.horizontalCenter
            leftMargin: 10
        }

        spacing: 3

        SGComboBox {
            id: comboBoxDemo

            width: saveSettingsTF.width
            height: saveSettingsTF.height

            placeholderText: "Select Configuration"
            dividers: true
            model: filesInDir.length > 0 ? filesInDir.map((file) => getFileNameFromFile(file)) : [];

            // This variable stores a list of paths for each file found in the base output directory for the current platform
            property var filesInDir: sgUserSettings.listFilesInDirectory(advancedSettingsControl.subdirName);
            property var configSelected

            onModelChanged: {
                console.info("model changed: ", model);
            }

            function getFileNameFromFile(file) {
                return file.slice(0, file.lastIndexOf('.'));
            }

            function updateList() {
                filesInDir = sgUserSettings.listFilesInDirectory(advancedSettingsControl.subdirName);
                model = filesInDir.map((file) => getFileNameFromFile(file));
            }
        }

        SGButton {
            text: "Load"

            onClicked: {
                if (comboBoxDemo.currentIndex >= 0) {
                    advancedSettingsControl.loadSettings()
                }

                // To rename a file: sgUserSettings.renameFile(<oldFileName>, <newFileName>)
            }
        }

        SGButton {
            text: "Delete"
            color: "#BE1403"

            onClicked: {
                sgUserSettings.deleteFile(comboBoxDemo.currentText + '.json', advancedSettingsControl.subdirName);
                comboBoxDemo.updateList()
            }
        }
    }


}
