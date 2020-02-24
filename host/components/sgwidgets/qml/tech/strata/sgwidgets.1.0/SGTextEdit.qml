import QtQuick 2.12
import tech.strata.sgwidgets 1.0 as SGWidgets

TextEdit {
    id: control

    property real fontSizeMultiplier: 1.0

    font.pixelSize: SGWidgets.SGSettings.fontPixelSize * fontSizeMultiplier
}
