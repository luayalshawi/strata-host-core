import QtQuick 2.9
import QtQuick.Controls 2.2

Rectangle {
    id: root

    signal applied(string value)

    property string label: ""
    property bool labelLeft: true
    property string input: ""
    property real infoBoxWidth: 50
    property color textColor: "#000"
    property color infoBoxColor: "#eee"
    property color infoBoxBorderColor: "#cccccc"
    property real infoBoxBorderWidth: 1
    property bool realNumberValidation: false
    property bool enabled: true
    property string buttonText: "Submit"

    implicitHeight: labelLeft ? inputButtonContainer.height : labelText.height + inputButtonContainer.height + inputButtonContainer.anchors.topMargin
    implicitWidth: labelLeft ? labelText.width + inputButtonContainer.width + inputButtonContainer.anchors.leftMargin :
                               Math.max(inputButtonContainer.width, labelText.width)

    Text {
        id: labelText
        text: label
        width: contentWidth
        height: root.label === "" ? 0 : root.labelLeft ? infoContainer.height : contentHeight
        topPadding: root.label === "" ? 0 : root.labelLeft ? (Math.max(infoContainer.height, applyButton.height) - contentHeight) / 2 : 0
        bottomPadding: topPadding
        color: root.textColor
        opacity: root.enabled ? 1 : 0.5
    }

    Rectangle {
        id: inputButtonContainer
        width: infoContainer.width + applyButton.width + applyButton.anchors.leftMargin
        height: Math.max(infoContainer.height, applyButton.height)

        anchors {
            left: root.labelLeft ? labelText.right : labelText.left
            top: root.labelLeft ? labelText.top : labelText.bottom
            leftMargin: root.label === "" ? 0 : root.labelLeft ? 10 : 0
            topMargin: root.label === "" ? 0 : root.labelLeft ? 0 : 5
        }

        Rectangle {
            id: infoContainer
            height: 30
            width: root.infoBoxWidth
            color: root.infoBoxColor
            radius: 2
            border {
                color: root.infoBoxBorderColor
                width: root.infoBoxBorderWidth
            }
            anchors {
                left: inputButtonContainer.left
                verticalCenter: inputButtonContainer.verticalCenter
            }
            clip: true

            TextInput {
                id: infoText
                padding: 10
                anchors {
                    right: parent.right
                    verticalCenter: parent.verticalCenter
                    left: parent.left
                }
                text: input
                selectByMouse: true
                readOnly: false
                font.family: "Courier" // Monospaced font for better text width uniformity
                horizontalAlignment: TextInput.AlignRight
                validator: realNumberValidation ? realNumberValidator : null
                onAccepted: root.applied(infoText.text)
                enabled: root.enabled
                color: root.textColor
                opacity: root.enabled ? 1 : 0.5

                RegExpValidator {
                    id: realNumberValidator
                    regExp: /[-+]?([0-9]*\.[0-9]+|[0-9]+)/
                }
            }
        }

        Button {
            id: applyButton
            text: root.buttonText
            anchors {
                left: infoContainer.right
                leftMargin: 10
                verticalCenter: infoContainer.verticalCenter
            }
            onClicked: root.applied(infoText.text)
            enabled: root.enabled
        }
    }
}