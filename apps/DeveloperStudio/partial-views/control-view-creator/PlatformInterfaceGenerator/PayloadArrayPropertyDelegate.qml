import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.12

Rectangle {

    //    Layout.preferredHeight: 10
    //    Layout.preferredWidth: 10
    //    Layout.preferredHeight:arrayPropertyContainer.implicitHeight
    //    Layout.preferredWidth: arrayPropertyContainer.implicitWidth

    implicitHeight: arrayPropertyContainer.implicitHeight
    implicitWidth: arrayPropertyContainer.implicitWidth
    Layout.leftMargin: 20
    Layout.rightMargin: 20

    property int indexNum
    property int modelIndex

    color: (indexNum === 6) || (indexNum === 4) ? "white" : "transparent"

    ColumnLayout {
        id: arrayPropertyContainer
        spacing: 5

        property ListModel parentListModel: model.parent
        property ListModel subArrayListModel: model.array
        property ListModel subObjectListModel: model.object

        RowLayout {
            id: arrayRowLayout
            // anchors.fill: parent
            Layout.preferredHeight: 30
            Layout.leftMargin: 20
            Layout.fillHeight: true
            spacing: 5

            RoundButton {
                Layout.preferredHeight: 15
                Layout.preferredWidth: 15
                padding: 0
                hoverEnabled: true
                visible: arrayPropertyContainer.parentListModel.count > 1

                icon {
                    source: "qrc:/sgimages/times.svg"
                    color: removeItemMouseArea.containsMouse ? Qt.darker("#D10000", 1.25) : "#D10000"
                    height: 7
                    width: 7
                    name: "add"
                }

                Accessible.name: "Remove item from array"
                Accessible.role: Accessible.Button
                Accessible.onPressAction: {
                    removeItemMouseArea.clicked()
                }

                MouseArea {
                    id: removeItemMouseArea
                    anchors.fill: parent
                    hoverEnabled: true
                    cursorShape: containsMouse ? Qt.PointingHandCursor : Qt.ArrowCursor
                    onClicked: {
                        if (cmdNotifName.text !== "") {
                            unsavedChanges = true
                        }
                        arrayPropertyContainer.parentListModel.remove(modelIndex)
                    }
                }
            }

            Text {
                text: "[Index " + modelIndex + "] Element type: "
                Layout.alignment: Qt.AlignVCenter
                Layout.preferredWidth: 150
                verticalAlignment: Text.AlignVCenter
            }

            TypeSelectorComboBox {
                id: propertyType
                Component.onCompleted: {
                    if (indexSelected === -1) {
                        currentIndex = getIndexOfType(type)
                        indexSelected = currentIndex
                    } else {
                        currentIndex = indexSelected
                    }
                    indexNum = currentIndex
                }

                onActivated: {
                    if (indexSelected === index) {
                        return
                    }
                    unsavedChanges = true

                    type = payloadContainer.changePropertyType(index, arrayPropertyContainer.subObjectListModel, arrayPropertyContainer.subArrayListModel)
                    indexSelected = index
                    indexNum = indexSelected

                }
            }
        }

        /*****************************************
    * This Repeater corresponds to the elements in a property of type "array"
    *****************************************/
        Repeater {
            id: subArrayRepeater
            model: arrayPropertyContainer.subArrayListModel

            delegate: Component {
                Loader {
                    Layout.leftMargin: 20

                    source: "./PayloadArrayPropertyDelegate.qml"
                    onStatusChanged: {
                        if (status === Loader.Ready) {
                            item.modelIndex = Qt.binding(() => index)
                        }
                    }
                }
            }
        }

        /*****************************************
    * This Repeater corresponds to the elements in a property of type "object"
    *****************************************/
        Repeater {
            id: subObjectRepeater
            model: arrayPropertyContainer.subObjectListModel

            delegate: Component {
                Loader {
                    Layout.leftMargin: 20

                    source: "./PayloadObjectPropertyDelegate.qml"
                    onStatusChanged: {
                        if (status === Loader.Ready) {
                            item.modelIndex = Qt.binding(() => index)
                        }
                    }
                }
            }
        }

        Button {
            id: addPropertyButton
            text: "Add Item To Array"
            Layout.alignment: Qt.AlignHCenter
            visible: modelIndex === arrayPropertyContainer.parentListModel.count - 1

            Accessible.name: addPropertyButton.text
            Accessible.role: Accessible.Button
            Accessible.onPressAction: {
                addPropertyButtonMouseArea.clicked()
            }

            MouseArea {
                id: addPropertyButtonMouseArea
                anchors.fill: parent
                hoverEnabled: true
                cursorShape: Qt.PointingHandCursor

                onClicked: {
                    arrayPropertyContainer.parentListModel.append({"type": sdsModel.platformInterfaceGenerator.TYPE_INT, "indexSelected": 0, "array": [], "object": [], "parent": arrayPropertyContainer.parentListModel})
                    commandsListView.contentY += 40
                    console.log("test", indexIs, index)
                }
            }
        }
    }
}

