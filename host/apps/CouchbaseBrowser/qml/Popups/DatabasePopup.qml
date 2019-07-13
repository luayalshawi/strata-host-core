import QtQuick 2.0
import QtQuick.Layouts 1.12
import QtQuick.Controls 2.12
import QtQuick.Window 2.12
import QtQuick.Dialogs 1.3
import Qt.labs.platform 1.0
import "../Components"
import "../Images"

Window {
    id: root
    width: 500
    height: 500
    visible: false
    flags: Qt.Tool

    signal submit()

    property alias folderPath: selectFolderField.userInput
    property alias filename: filenameContainer.userInput
    property alias popupStatus: statusBar

    function validate() {
        if (selectFolderField.isEmpty() || filenameContainer.isEmpty()) {
            statusBar.message = "Please supply all requested information"
            statusBar.backgroundColor = "red"
        }            
        else submit()
    }

    Rectangle {
        anchors.fill: parent
        color: "#393e46"
        border {
            width: 2
            color: "#b55400"
        }
        StatusBar {
            id: statusBar
            anchors.bottom: parent.bottom
            width: parent.width
            height: 25
        }
        ColumnLayout {
            spacing: 1
            width: parent.width - 10
            height: parent.height / 2
            anchors {
                horizontalCenter: parent.horizontalCenter
                verticalCenter: parent.verticalCenter
            }
            Rectangle {
                Layout.preferredHeight: 30
                Layout.preferredWidth: parent.width / 2
                Layout.alignment: Qt.AlignHCenter + Qt.AlignTop
                color: "transparent"
                UserInputBox {
                    id: selectFolderField
                    height: 30
                    width: parent.width
                    label: "Folder:"
                }
                Button {
                    height: 30
                    width: 40
                    anchors.left: parent.right
                    background: Rectangle {
                        color: "transparent"
                    }
                    onClicked: folderDialog.visible = true
                    Image {
                        id: folderImage
                        anchors.fill: parent
                        anchors.centerIn: parent
                        source: "../Images/openFolderIcon.png"
                        fillMode: Image.PreserveAspectFit
                    }
                }
            }
            UserInputBox {
                id: filenameContainer
                Layout.preferredHeight: 30
                Layout.preferredWidth: parent.width / 2
                Layout.alignment: Qt.AlignHCenter
                label: "Filename:"
            }
            Button {
                id: submitButton
                Layout.preferredHeight: 35
                Layout.preferredWidth: 100
                Layout.alignment: Qt.AlignHCenter
                text: "Submit"
                onClicked: validate()
            }
        }
        FolderDialog {
            id: folderDialog
            onAccepted: selectFolderField.userInput = folderDialog.folder
        }
    }
}
