import QtQuick 2.7
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.3
import QtGraphicalEffects 1.0
import QtQuick.Controls.Styles 1.4
import QtQuick.Extras 1.4
import Fonts 1.0
//import tech.spyglass. 1.0
import "qrc:/js/navigation_control.js" as NavigationControl
import "qrc:/js/help_layout_manager.js" as Help

Rectangle {
    id: controlNavigation
    anchors {
        fill: parent
    }

    PlatformInterface {
        id: platformInterface
    }

    Component.onCompleted: {
        Help.registerTarget(navTabs, "Using these two tabs, you may select between running the NL7SZ97 or the NL7SZ58 multifunction gates.", 0)
    }

    Component.onDestruction: {
        Help.reset()
    }

    TabBar {
        id: navTabs
        anchors {
            top: parent.top
            left: parent.left
            right: parent.right
        }

        TabButton {
            id: basicButton
            text: qsTr("NL7SZ97")
            onClicked: {
//                platformInterface.off_led.update()
                controlContainer.currentIndex = 0
                console.log("in view one")
                partOne.visible = true
                partTwo.visible = false
                partOne.resetToIndex0();
//                platformInterface.mux_97.update();
            }
        }

        TabButton {
            id: advancedButton
            text: qsTr("NL7SZ58")
            onClicked: {
                platformInterface.off_97_led.update()
                controlContainer.currentIndex = 1
                console.log("in view two")
                partOne.visible = false
                partTwo.visible = true
                partTwo.resetToIndex0()
                platformInterface.nand.update()
            }
        }
    }

    ScrollView {
        id: scrollView
        anchors {
            top: navTabs.bottom
            bottom: parent.bottom
            right: parent.right
            left: parent.left
        }

        onWidthChanged: {
            if (width < 1200) {
                ScrollBar.horizontal.policy = ScrollBar.AlwaysOn
            } else {
                ScrollBar.horizontal.policy = ScrollBar.AlwaysOff
            }
        }

        onHeightChanged: {
            if (height < 725) {
                ScrollBar.vertical.policy = ScrollBar.AlwaysOn
            } else {
                ScrollBar.vertical.policy = ScrollBar.AlwaysOff
            }
        }

        Flickable {
            id: controlContainer

            property int currentIndex: 0

            boundsBehavior: Flickable.StopAtBounds
            contentWidth: 1200
            contentHeight: 725
            anchors {
                fill: parent
            }
            clip: true

            PartOne {
                id: partOne
                visible: true
            }

            PartTwo {
                id: partTwo
                visible: false
            }
        }
    }

    Text {
        id: helpIcon
        anchors {
            right: scrollView.right
            top: scrollView.top
            margins: 20
        }
        text: "\ue808"
        color: helpMouse.containsMouse ? "lightgrey" : "grey"
        font {
            family: Fonts.sgicons
            pixelSize: 40
        }

        MouseArea {
            id: helpMouse
            anchors {
                fill: helpIcon
            }
            onClicked: {
                navTabs.currentIndex = 0
                basicButton.clicked()
                Help.startHelpTour()
            }
            hoverEnabled: true
        }
    }
}

