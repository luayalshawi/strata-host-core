import QtQuick 2.12
import QtQuick.Window 2.12
import QtQuick.Controls 2.12

import tech.strata.sgwidgets 1.0
import tech.strata.fonts 1.0

Window {
    visible: true
    width: 640
    height: 480
    title: qsTr("SGSwitch Demo")

    SGSwitch {
        id: sgSwitch

        // Optional Configuration:
        label: "<b>Switch:</b>"         // Default: "" (if not entered, label will not appear)
        labelLeft: false                // Default: true
        checkedLabel: "Switch On"       // Default: "" (if not entered, label will not appear)
        uncheckedLabel: "Switch Off"    // Default: "" (if not entered, label will not appear)
        labelsInside: true              // Default: true
        switchWidth: 84                 // Default: 52 (change for long custom checkedLabels when labelsInside)
        switchHeight: 26                // Default: 26
        textColor: "black"              // Default: "black"
        handleColor: "white"            // Default: "white"
        grooveColor: "#ccc"             // Default: "#ccc"
        grooveFillColor: "#0cf"         // Default: "#0cf"

        // Usable Signals:
        onCheckedChanged: console.log("Checked toggled")
        onReleased: console.log("Switch released")
        onCanceled: console.log("Switch canceled")
        onClicked: console.log("Switch clicked")
        onPress: console.log("Switch pressed")
        onPressAndHold: console.log("Switch pressed and held")
    }
}