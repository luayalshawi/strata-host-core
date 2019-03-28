import QtQuick 2.9
import QtQuick.Controls 2.3
import QtQuick.Layouts 1.3
import Fonts 1.0
import QtGraphicalEffects 1.0

Popup {
    id: profilePopup
    width: Math.max(container.width * 0.8, 600)
    height: Math.max(container.parent.windowHeight * 0.5, 350)
    modal: true
    focus: true
    padding: 0
    closePolicy: Popup.CloseOnEscape | Popup.CloseOnPressOutsideParent

    DropShadow {
        width: profilePopup.width
        height: profilePopup.height
        horizontalOffset: 1
        verticalOffset: 3
        radius: 15.0
        samples: 30
        color: "#cc000000"
        source: profilePopup.background
        z: -1
        cached: true
    }

    Item {
        id: popupContainer
        width: profilePopup.width
        height: profilePopup.height
        clip: true

        Image {
            id: background
            source: "qrc:/images/login-background.svg"
            height: 1080
            width: 1920
            x: (popupContainer.width - width)/2
            y: (popupContainer.height - height)/2
        }

        Rectangle {
            id: title
            height: 30
            width: popupContainer.width
            anchors {
                top: popupContainer.top
            }
            color: "lightgrey"

            Label {
                id: profileTitle
                anchors {
                    left: title.left
                    leftMargin: 10
                    verticalCenter: title.verticalCenter
                }
                text: "About Strata"
                font {
                    family: Fonts.franklinGothicBold
                }
                color: "black"
            }

            Text {
                id: close_profile
                text: "\ue805"
                color: close_profile_hover.containsMouse ? "#eee" : "white"
                font {
                    family: Fonts.sgicons
                    pixelSize: 20
                }
                anchors {
                    right: title.right
                    verticalCenter: title.verticalCenter
                    rightMargin: 10
                }

                MouseArea {
                    id: close_profile_hover
                    anchors {
                        fill: close_profile
                    }
                    onClicked: profilePopup.close()
                    hoverEnabled: true
                    cursorShape: Qt.PointingHandCursor
                }
            }
        }

        Item {
            id: content
            anchors {
                top: title.bottom
                bottom: popupContainer.bottom
                right: popupContainer.right
                left: popupContainer.left
            }

            clip: true

            Item {
                id: contentContainer
                width: Math.max(popupContainer.width, 600)
                height: mainColumn.childrenRect.height
                anchors {
                    verticalCenter: content.verticalCenter
                }

                clip: true

                Column {
                    id: mainColumn
                    spacing: 30
                    width: contentContainer.width - 30
                    anchors {
                        horizontalCenter: contentContainer.horizontalCenter
                        verticalCenter: contentContainer.verticalCenter
                    }

                    Row {
                        id: logoContainer
                        height: 200
                        anchors {
                            horizontalCenter: mainColumn.horizontalCenter
                        }

                        Image {
                            id: strataLogo
                            source: "qrc:/images/strata-logo.svg"
                            sourceSize.height: logoContainer.height
                            fillMode: Image.PreserveAspectFit
                        }

                        Image {
                            id: onsemiLogo
                            source: "qrc:/images/on-semi-logo-horiz.svg"
                            sourceSize.height: logoContainer.height/2
                            fillMode: Image.PreserveAspectFit
                            anchors {
                                verticalCenter: strataLogo.verticalCenter
                            }
                        }
                    }

                    Rectangle {
                        id: aboutTextContainer
                        width: mainColumn.width - 200
                        height: aboutText.contentHeight + 40
                        color: "#eee"
                        anchors {
                            horizontalCenter: mainColumn.horizontalCenter
                        }

                        TextEdit {
                            id: aboutText
                            anchors {
                                left: aboutTextContainer.left
                                right: aboutTextContainer.right
                                top: aboutTextContainer.top
                                margins: 20
                            }
                            // versionNumber is set in main.qml in mainWindow at top
                            text: "<b>" + versionNumber + "</b><br><br>Designed by engineers for engineers to securely deliver software & information, efficiently bringing you the focused info you need, nothing you don’t."
                            wrapMode: TextEdit.Wrap
                            horizontalAlignment: Text.AlignHCenter
                            textFormat: TextEdit.RichText
                        }
                    }

//                    Rectangle {
//                        id: nameContainer
//                        width: mainColumn.width
//                        height: Math.max(hardwareText.contentHeight + 40, softwareText.contentHeight + 40)
//                        color: "#eee"

//                        Row {
//                            id:namesRow
//                            anchors {
//                                top: nameContainer.top
//                                topMargin: 20
//                                horizontalCenter: nameContainer.horizontalCenter
//                            }

//                        TextEdit {
//                            id: hardwareText
//                            width: (nameContainer.width/2)-20
//                            text: "<b>Hardware Team:</b><br><br>Ed Osburn<br>Lorem ipsum<br>dolor sit amet<br>consectetur adipiscing<br>elit. Aenean id<br>dapibus purus.<br>Aliquam nibh velit,<br>volutpat et consequat<br>id, feugiat nec diam.<br>Mauris arcu nibh,<br>vulputate eu iaculis<br>ac, convallis vitae<br>nunc. Morbi ac<br>sodales ante,<br>sed accumsan<br>orci. Fusce vitae<br>neque quis nibh<br>vestibulum suscipit<br>in nec mauris."
//                            wrapMode: TextEdit.Wrap
//                            textFormat: TextEdit.RichText
//                        }

//                        TextEdit {
//                            id: softwareText
//                            width: (nameContainer.width/2)-20
//                            text: "<b>Software Team:</b><br><br>Ian Cain<br>Lorem ipsum<br>dolor sit amet<br>consectetur adipiscing<br>elit. Aenean id<br>dapibus purus.<br>Aliquam nibh velit,<br>volutpat et consequat<br>id, feugiat nec diam.<br>Mauris arcu nibh,<br>vulputate eu iaculis<br>ac, convallis vitae<br>nunc. Morbi ac<br>sodales ante,<br>sed accumsan<br>orci. Fusce vitae<br>neque quis nibh<br>vestibulum suscipit<br>in nec mauris."
//                            wrapMode: TextEdit.Wrap
//                            textFormat: TextEdit.RichText
//                        }
//                        }

//                    }
                }
            }
        }
    }
}