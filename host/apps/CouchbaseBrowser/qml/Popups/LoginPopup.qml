import QtQuick 2.0
import QtQuick.Layouts 1.12
import QtQuick.Controls 2.12
import QtQuick.Window 2.12
import QtQuick.Dialogs 1.3
import "../Components"

Window {
    id: root
    maximumHeight: 450
    minimumHeight: 450
    maximumWidth: 400
    minimumWidth: 400
    flags: Qt.Tool
    visible: true

    signal start()
    onClosing: { // This is not a bug
        loginContainer.visible = true
        selectChannelsContainer.visible = false
    }

    property alias url: urlField.userInput
    property alias username: usernameField.userInput
    property alias password: passwordField.userInput
    property string listenType: "pull"
    property alias channels: selectChannelsContainer.channels
    property int radioBtnSize: 30


    Rectangle {
        id: container
        height: parent.height - statusBar.height
        width: parent.width
        color: "#393e46"
        border {
            width: 2
            color: "#b55400"
        }
        ColumnLayout {
            id: loginContainer
            visible: true
            spacing: 15
            width: parent.width - 10
            height: parent.height - 130
            anchors.centerIn: parent

            UserInputBox {
                id: urlField
                Layout.preferredHeight: 30
                Layout.preferredWidth: parent.width / 2
                Layout.alignment: Qt.AlignHCenter
                label: "URL (required)"
            }
            UserInputBox {
                id: usernameField
                Layout.preferredHeight: 30
                Layout.preferredWidth: parent.width / 2
                Layout.alignment: Qt.AlignHCenter
                label: "Username"
            }
            UserInputBox {
                id: passwordField
                Layout.preferredHeight: 30
                Layout.preferredWidth: parent.width / 2
                Layout.alignment: Qt.AlignHCenter
                label: "Password"
                isPassword: true

            }

            GridLayout {
                id: selectorContainer
                Layout.preferredHeight: 30
                Layout.preferredWidth: parent.width / 2
                Layout.alignment: Qt.AlignHCenter
                rows: 2
                columns: 3

                RadioButton {
                    id: pushButton
                    height: radioBtnSize
                    width: radioBtnSize
                    Layout.alignment: Qt.AlignCenter
                    onClicked: rep_type = "push"
                }
                RadioButton {
                    id: pullButton
                    height: radioBtnSize
                    width: radioBtnSize
                    Layout.alignment: Qt.AlignCenter
                    checked: true
                    onClicked: rep_type = "pull"
                }
                RadioButton {
                    id: pushAndPullButton
                    height: radioBtnSize
                    width: radioBtnSize
                    Layout.alignment: Qt.AlignCenter
                    onClicked: rep_type = "pushpull"
                }

                Label {
                    text: "Push"
                    color: "#eee"
                    Layout.alignment: Qt.AlignCenter
                }
                Label {
                    text: "Pull"
                    color: "#eee"
                    Layout.alignment: Qt.AlignCenter
                }
                Label {
                    text: "Both"
                    color: "#eee"
                    Layout.alignment: Qt.AlignCenter
                }
            }
            RowLayout {
                spacing: 5
                Layout.maximumHeight: 30
                Layout.maximumWidth: parent.width - 50
                Layout.alignment: Qt.AlignHCenter
                Button {
                    Layout.fillHeight: true
                    Layout.preferredWidth: (parent.width-5) / 2
                    text: "All channels"
                    onClicked: warningPopup.visible = true
                    enabled: url.length !== 0
                }
                Button {
                    Layout.fillHeight: true
                    Layout.preferredWidth: (parent.width-5) / 2
                    text: "Choose channels"
                    onClicked: {
                        loginContainer.visible = false
                        selectChannelsContainer.visible = true
                    }
                    enabled: url.length !== 0
                }
            }
        }

        ChannelSelector{
            id: selectChannelsContainer
            visible: false
            height: parent.height - 130
            width: parent.width/2
            anchors.centerIn: parent
            onSubmit: warningPopup.visible = true
        }
    }
    StatusBar {
        id: statusBar
        anchors.top: container.bottom
        width: parent.width
        height: 25
    }

    WarningPopup {
        id: warningPopup
        onAllow: {
            close()
            start()
        }
        onDeny: close()
    }
}
