import QtQuick 2.12
import tech.strata.sgwidgets 1.0

import "../../"

LayoutContainer {

    // pass through all properties
    property real fontSizeMultiplier: 1.0
    property alias text: infoObject.text
    property alias horizontalAlignment: infoObject.horizontalAlignment
    property alias placeholderText: infoObject.placeholderText
    property alias readOnly: infoObject.readOnly
    property alias boxColor: infoObject.boxColor

    SGInfoBox {
        id: infoObject
        fontSizeMultiplier: parent.fontSizeMultiplier
    }
}

