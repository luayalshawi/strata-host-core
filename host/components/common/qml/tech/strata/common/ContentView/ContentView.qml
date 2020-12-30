import QtQuick 2.9
import QtQuick.Controls 2.3
import "content-views"

import tech.strata.fonts 1.0
import tech.strata.sgwidgets 0.9
import "qrc:/js/help_layout_manager.js" as Help

Rectangle {
    id: view
    anchors {
        fill: parent
    }

    property string class_id: ""
    property var classDocuments: null
    property var fakeHelpDocuments: null
    property var pdfAccordionState
    property var datasheetAccordionState
    property var downloadAccordionState
    property var currentDocumentCategory : false
    property string categoryOpened: "platform documents"
    signal finished()

    property int totalDocuments: classDocuments.pdfListModel.count + classDocuments.datasheetListModel.count + classDocuments.downloadDocumentListModel.count
    onTotalDocumentsChanged: {
        if(helpIcon.class_id === "help_docs_demo" ) {
            pdfViewer.url = "qrc:/tech/strata/common/ContentView/images/" + classDocuments.pdfListModel.getFirstUri()
        }
        else {
            if (classDocuments.pdfListModel.count > 0) {
                pdfViewer.url = "file://localhost/" + classDocuments.pdfListModel.getFirstUri()
            } else if (classDocuments.datasheetListModel.count > 0) {
                pdfViewer.url = classDocuments.datasheetListModel.getFirstUri()
            } else {
                pdfViewer.url = ""
            }
        }

        if (classDocuments.downloadDocumentListModel.count > 0){
            empty.hasDownloads = true
        }

        if (totalDocuments > 0) {
            navigationSidebar.state = "open"
        } else {
            navigationSidebar.state = "close"
        }
    }

    onVisibleChanged: {
        if(!visible) {
            pdfAccordionState = ""
            datasheetAccordionState = ""
            downloadAccordionState = ""
            currentDocumentCategory = false
        }
    }

    HelpButton{
        id: helpIcon
        height: 30
        width: 30
        anchors {
            right: view.right
            bottom: view.bottom
            margins: 40
        }
        z: 2
    }

    Connections {
        target: Help.utility
        onTour_runningChanged: {
            if(tour_running === false) {
                helpIcon.class_id = view.class_id
                classDocuments = sdsModel.documentManager.getClassDocuments(view.class_id)
                accordion.contentItem.children[0].open = pdfAccordionState
                accordion.contentItem.children[1].open = datasheetAccordionState
                accordion.contentItem.children[2].open = downloadAccordionState
                currentDocumentCategory = true
            }
        }
    }

    Component.onCompleted: {
        classDocuments = sdsModel.documentManager.getClassDocuments(view.class_id)
        helpIcon.class_id = view.class_id
        Help.registerTarget(accordion.contentItem.children[0],"Use this menu to select platform-specific documents for viewing.",0,"contentViewHelp")
        Help.registerTarget(accordion.contentItem.children[1],"This menu includes part-specific datasheets for viewing.",1,"contentViewHelp")
        Help.registerTarget(accordion.contentItem.children[2],"Select and download files related to this platform here.",2,"contentViewHelp")
        Help.registerTarget(pdfViewerContainer,"This pane displays the documents selected from the left menu.",3,"contentViewHelp")
    }

    Connections {
        target: classDocuments
        onErrorStringChanged: {
            if (classDocuments.errorString.length > 0) {
                pdfViewer.url = ""
                loadingImage.currentFrame = 0
            }
        }
    }

    Connections {
        target: Help.utility
        onInternal_tour_indexChanged: {
            if(Help.current_tour_targets[index]["target"] === accordion.contentItem.children[0]){
                if(!accordion.contentItem.children[0].open) {
                    accordion.contentItem.children[0].open = true
                }
                //                else {
                //                   accordion.contentItem.children[0].open = false
                //                   accordion.contentItem.children[0].open = true
                //                }
            }
            if(Help.current_tour_targets[index]["target"] === accordion.contentItem.children[1]){
                accordion.contentItem.children[1].open = true
            }
            else {
                accordion.contentItem.children[1].open = false
            }
            if(Help.current_tour_targets[index]["target"] === accordion.contentItem.children[2]){
                accordion.contentItem.children[2].open = true
            }
            else {
                accordion.contentItem.children[2].open = false
            }
        }
    }

    Rectangle {
        id: divider
        height: 1
        anchors {
            bottom: contentContainer.top
            left: contentContainer.left
            right: contentContainer.right
        }

        color: "#888"
    }

    Item {
        id: contentContainer
        anchors {
            top: divider.bottom
            right: view.right
            left: view.left
            bottom: view.bottom
        }

        Rectangle {
            id: navigationSidebar
            color: Qt.darker("#666")
            anchors {
                left: contentContainer.left
                top: contentContainer.top
                bottom: contentContainer.bottom
            }
            width: 0
            visible: false

            states: [
                // default state is "", width:0, visible:false
                State {
                    name: "open"
                    PropertyChanges {
                        target: navigationSidebar
                        visible: true
                        width: 300
                    }
                },
                State {
                    name: "close"
                    PropertyChanges {
                        target: navigationSidebar
                        visible: false
                    }
                }
            ]

            SGAccordion {
                id: accordion
                anchors {
                    fill: parent
                }

                // Optional Configuration:
                openCloseTime: 80           // Default: 80 (how fast the sliders pop open)
                statusIcon: "\u25B2"        // Default: "\u25B2" (triangle char)
                contentsColor: Qt.darker("#555")
                textOpenColor: "#fff"
                textClosedColor: "#ccc"
                headerOpenColor: "#666"
                headerClosedColor: "#484848"
                dividerColor: "grey"
                exclusive: false

                accordionItems: Column {
                    SGAccordionItem {
                        id: pdfAccordion
                        title: "Platform Documents"
                        contents: Documents {
                            model: classDocuments.pdfListModel
                        }
                        open: pdfAccordion.visible
                        visible: classDocuments.pdfListModel.count > 0

                        onOpenChanged: {
                            if(open){
                                pdfAccordion.openContent.start();
                            } else {
                                pdfAccordion.closeContent.start();
                            }
                        }

                        onAnimationCompleted: {
                            if (helpIcon.class_id === "help_docs_demo" && Help.tour_running) {
                                Help.liveResize()
                            }
                        }

                        onHeightChanged: {
                            if (helpIcon.class_id === "help_docs_demo" && Help.current_tour_targets[Help.internal_tour_index]["target"] === pdfAccordion && Help.tour_running) {
                                Help.liveResize()
                            }
                        }
                    }

                    SGAccordionItem {
                        id: datasheetAccordion
                        title: "Part Datasheets"
                        contents: Datasheets {
                            model: classDocuments.datasheetListModel
                        }
                        open: !pdfAccordion.visible && datasheetAccordion.visible
                        visible: classDocuments.datasheetListModel.count > 0

                        onOpenChanged: {
                            if(open){
                                datasheetAccordion.openContent.start();
                            } else {
                                datasheetAccordion.closeContent.start();
                            }
                        }

                        onAnimationCompleted: {
                            if (helpIcon.class_id === "help_docs_demo" && Help.tour_running) {
                                Help.liveResize()
                            }
                        }
                    }

                    SGAccordionItem {
                        id: downloadAccordion
                        title: "Downloads"
                        contents: Downloads {
                            model: classDocuments.downloadDocumentListModel

                        }
                        open: !pdfAccordion.visible && !datasheetAccordion.visible && downloadAccordion.visible
                        visible: classDocuments.downloadDocumentListModel.count > 0

                        onOpenChanged: {
                            if(open){
                                downloadAccordion.openContent.start();
                            } else {
                                downloadAccordion.closeContent.start();
                            }
                        }

                        onAnimationCompleted: {
                            if (helpIcon.class_id === "help_docs_demo" && Help.tour_running) {
                                Help.liveResize()
                            }
                        }
                    }
                }
            }
        }

        Rectangle {
            id: sidebarControl
            width: 20 + rightDivider.width
            anchors {
                left: navigationSidebar.right
                top: contentContainer.top
                bottom: contentContainer.bottom
            }
            color: controlMouse.containsMouse ? "#444" : "#333"

            Rectangle {
                id: rightDivider
                width: 1
                anchors {
                    top: sidebarControl.top
                    bottom: sidebarControl.bottom
                    right: sidebarControl.right
                }
                color: "#33b13b"
            }

            SGIcon {
                id: control
                anchors {
                    centerIn: sidebarControl
                }
                iconColor: "white"
                source: "images/angle-right-solid.svg"
                height: 30
                width: 30
                rotation: navigationSidebar.visible ? 180 : 0
            }

            MouseArea {
                id: controlMouse
                anchors {
                    fill: sidebarControl
                }
                onClicked: {
                    if (navigationSidebar.state === "open") {
                        navigationSidebar.state = "close"
                    } else {
                        navigationSidebar.state = "open"
                    }
                }

                hoverEnabled: true
                cursorShape: Qt.PointingHandCursor
            }
        }

        SGPdfViewer {
            id: pdfViewer
            anchors {
                left: sidebarControl.right
                right: contentContainer.right
                top: contentContainer.top
                bottom: contentContainer.bottom
            }

            url: ""

            Item {
                id: pdfViewerContainer
                width: parent.width
                height: parent.height - 250
                anchors {
                    top: pdfViewer.top
                    topMargin: 10
                }
            }
        }

        EmptyDocuments {
            id: empty
            visible: pdfViewer.url === "" && loading.visible === false
            anchors {
                left: sidebarControl.right
                right: contentContainer.right
                top: contentContainer.top
                bottom: contentContainer.bottom
            }
        }
    }

    Item {
        id: loading
        anchors {
            fill: view
        }

        visible: loadingText.text.length

        Rectangle {
            color: "#222"
            opacity: .5
            anchors {
                fill: parent
            }
        }

        AnimatedImage {
            id: loadingImage
            source: "images/docLoading.gif"
            anchors {
                centerIn: loading
                verticalCenterOffset: -height/4
            }
            playing: classDocuments.loading
            height: 200
            width: 200
        }

        Text {
            id: loadingText
            color: "#fff"
            anchors {
                top: loadingImage.bottom
                horizontalCenter: loading.horizontalCenter
            }
            font {
                pixelSize: 30
                family:  Fonts.franklinGothicBold
            }
            text: {
                if (classDocuments.errorString.length > 0) {
                    return "Error: " + classDocuments.errorString
                }

                if (classDocuments.loading) {
                    return "Downloading\n" + classDocuments.loadingProgressPercentage + "% completed"
                }

                return ""
            }

            width: 500
            wrapMode: Text.Wrap
            horizontalAlignment: Text.AlignHCenter
        }

        MouseArea {
            anchors { fill: loading }
            hoverEnabled: true
            preventStealing: true
            propagateComposedEvents: false
        }
    }
}
