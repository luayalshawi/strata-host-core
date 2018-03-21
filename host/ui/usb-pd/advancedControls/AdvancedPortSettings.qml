import QtQuick 2.7
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.3
import QtGraphicalEffects 1.0

//-----------------------------------------------
//  Port  settings
//-----------------------------------------------
Rectangle{
    id:portSettings
    property int fullHeight:310
    property int collapsedHeight:60
    property var portName:"Port n"
    property var portNumber:0
    property var minimumVoltage: 4.95
    property var minimumAdvertisedVoltage: 5.0
    property var maximumAdvertisedVoltage: 20.0

    property color enabledTextFieldBackgroundColor: "#838484"
    property color disabledTextFieldBackgroundColor: "#33FFFFFF"

    property color enabledTextFieldTextColor: "white"
    property color disabledTextFieldTextColor: "grey"

    property double outputVoltage: 0;
    property double targetVoltage: 0;
    property double portCurrent: 0;
    property double portTemperature: 0;
    property double portPower: 0;
    property double portNegotiatedContractVoltage:0;
    property double portNegotiatedContractAmperage:0;
    property string portMaximumPower:"";

    property double voltage1: 0;
    property double voltage2: 0;
    property double voltage3: 0;
    property double voltage4: 0;
    property double voltage5: 0;
    property double voltage6: 0;
    property double voltage7: 0;


    // Values are being Signalled from ImplementationInterfaceBinding.cpp
    Connections {
        target: implementationInterfaceBinding

        // output voltage
        onPortOutputVoltageChanged: {
            if( portNumber === port ) {
                portSettings.outputVoltage = value;
            }
        }

        // target voltage
        onPortTargetVoltageChanged: {

            if( portNumber === port ) {
                portSettings.targetVoltage = value;
            }
        }

        // port current
        onPortCurrentChanged: {
            if( portNumber === port ) {
                portSettings.portCurrent = value;
            }
        }

        // port temperature
        onPortTemperatureChanged: {
            if( portNumber === port ) {
                portSettings.portTemperature = value;
            }
        }

        // port power
        onPortPowerChanged: {
            if( portNumber === port ) {
                portSettings.portPower = value;
            }
        }

        onPortNegotiatedContractChanged:{
            if( portNumber === port ) {
                portSettings.portNegotiatedContractVoltage = voltage;
                portSettings.portNegotiatedContractAmperage = maxCurrent;
            }
        }

        onPortNegotiatedVoltageChanged:{
            if( portNumber === port ) {
                portSettings.portNegotiatedContractVoltage = voltage;
            }
        }

        onPortNegotiatedCurrentChanged:{
            if( portNumber === port ) {
                portSettings.portNegotiatedContractAmperage = current;
            }
        }

        onPortMaximumPowerChanged:{
            if( portNumber === port ) {
                portSettings.portMaximumPower = parseInt(watts);
            }
        }

        onPortAdvertisedVoltagesChanged:{
            if (portNumber === port){
                portSettings.voltage1 = voltage1;
                portSettings.voltage2 = voltage2;
                portSettings.voltage3 = voltage3;
                portSettings.voltage4 = voltage4;
                portSettings.voltage5 = voltage5;
                portSettings.voltage6 = voltage6;
                portSettings.voltage7 = voltage7;
            }
        }
    }

    Layout.preferredWidth  : grid.prefWidth(this)
    Layout.preferredHeight : portSettings.fullHeight
    color: "black"

    Component.onCompleted: {
        portvoltage1Slider.value = (voltage1 > 0) ?voltage1 : minimumVoltage;
        portvoltage2Slider.value = (voltage2 > 0) ?voltage2 : minimumVoltage;
        portvoltage3Slider.value = (voltage3 > 0) ?voltage3 : minimumVoltage;
        portvoltage4Slider.value = (voltage4 > 0) ?voltage4 : minimumVoltage;
        portvoltage5Slider.value = (voltage5 > 0) ?voltage5 : minimumVoltage;
        portvoltage6Slider.value = (voltage6 > 0) ?voltage6 : minimumVoltage;
        portvoltage7Slider.value = (voltage7 > 0) ?voltage7 : minimumVoltage;
    }

    SequentialAnimation{
        id: collapsePortSettings

        PropertyAnimation{
            targets: [portMaxPowerText,portMaxPowerCombo, portMaxPowerUnitText,
                cableCompensationGroup, maxCurrentText,
            maxCurrentTextInputRect, maxCurrentUnitText, maxCurrentSlider, portAdvertizedVoltagesGroup]
            property:"opacity"
            to: 0
            duration:500
        }
        NumberAnimation{
            target: portSettings;
            property: "Layout.preferredHeight";
            to: portSettings.collapsedHeight;
            duration: settings.collapseAnimationSpeed;
        }
    }

    SequentialAnimation{
        id: expandPortSettings

        NumberAnimation {
            target: portSettings
            property: "Layout.preferredHeight";
            to: portSettings.fullHeight;
            duration: settings.collapseAnimationSpeed;
        }
        PropertyAnimation{
            targets: [portMaxPowerText,portMaxPowerCombo, portMaxPowerUnitText,
                cableCompensationGroup, maxCurrentText,
            maxCurrentTextInputRect, maxCurrentUnitText, maxCurrentSlider, portAdvertizedVoltagesGroup]

            property:"opacity"
            to: 1.0
            duration:500
        }

    }



    Button{
        id: portSettingsDisclosureButton
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.leftMargin: 0
        anchors.topMargin: 20
        height: 20
        width: 20
        checkable: true
        checked: true
        background: Rectangle {
            color: "black"
        }


        Image{
            id:portDisclosureButtonImage
            anchors.left:parent.left
            anchors.leftMargin: 3
            anchors.top:parent.top
            height:10
            width:14
            source:"../images/icons/showLessIcon.svg"

            transform: Rotation {
                id: rotatePortButtonImage
                origin.x: portDisclosureButtonImage.width/2;
                origin.y: portDisclosureButtonImage.height/2;
                axis { x: 0; y: 0; z: 1 }
            }

            NumberAnimation {
                id:collapsePortDisclosureIcon
                running: false
                loops: 1
                target: rotatePortButtonImage;
                property: "angle";
                from: 0; to: 180;
                duration: 1000;
            }

            NumberAnimation {
                id:expandPortDisclosureIcon
                running: false
                loops: 1
                target: rotatePortButtonImage;
                property: "angle";
                from: 180; to: 0;
                duration: 1000;
            }
        }

        onClicked:{
            if (checked == true){
                expandPortSettings.start();
                expandPortDisclosureIcon.start();
                }
            else{
                collapsePortSettings.start();
                collapsePortDisclosureIcon.start();
              }
        }

    }

    Label{
        id: portSettingsLabel
        text: parent.portName + " Settings"
        font.family: "Helvetica"
        font.pointSize: mediumFontSize
        color: "#D8D8D8"
        anchors.left:parent.left
        anchors.top:parent.top
        anchors.leftMargin: 20//parent.width/20
        anchors.topMargin: 20//parent.height/20
    }

    Rectangle{
        id: portSettingsSeparator
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.leftMargin: parent.width/20
        anchors.rightMargin: parent.width/20
        anchors.top: portSettingsLabel.bottom
        anchors.topMargin: portSettingsLabel.height
        height: 1
        color:"#CCCCCC"
    }

    Text{
        id:portMaxPowerText
        text:"Maximum power output:"
        font.family: "helvetica"
        font.pointSize: smallFontSize
        horizontalAlignment: Text.AlignRight
        color: "#D8D8D8"
        anchors.right:parent.right
        anchors.rightMargin: parent.width*.6
        anchors.top: portSettingsSeparator.bottom
        anchors.topMargin: 15
    }

    PopUpMenu{
        id: portMaxPowerCombo
        model: ["15","27", "36", "45","60","100"]
        backgroundColor: popupMenuBackgroundColor
        anchors.left:portMaxPowerText.right
        anchors.leftMargin: 10
        anchors.verticalCenter: portMaxPowerText.verticalCenter

        currentIndex: portMaxPowerCombo.find(portSettings.portMaximumPower)

        onActivated: {
            implementationInterfaceBinding.setMaximumPortPower(portNumber,parseInt(portMaxPowerCombo.currentText))
        }

        Connections {
            target: implementationInterfaceBinding
            onPortMaximumPowerChanged:{
                if( portNumber === port ) {
                    portMaxPowerCombo.currentIndex = portMaxPowerCombo.find(parseInt(watts))
                }
            }
        }

    }


    Text{
        id:portMaxPowerUnitText
        text:"W"
        font.family: "helvetica"
        font.pointSize: smallFontSize
        color: "#D8D8D8"
        anchors.left:portMaxPowerCombo.right
        anchors.leftMargin: 5
        anchors.verticalCenter: portMaxPowerText.verticalCenter

    }

    Text{
        id:maxCurrentText
        text:"Current limit:"
        font.family: "helvetica"
        font.pointSize: smallFontSize
        horizontalAlignment: Text.AlignRight
        color: "#D8D8D8"
        anchors.right:parent.right
        anchors.rightMargin: parent.width*.6
        anchors.top: portMaxPowerText.bottom
        anchors.topMargin: 10
    }
    Rectangle{
         id: maxCurrentTextInputRect
         color: textEditFieldBackgroundColor
         anchors.left:maxCurrentText.right
         anchors.leftMargin: 10
         anchors.verticalCenter: maxCurrentText.verticalCenter
         height:15
         width:25

        TextField{
            id:maxCurrentTextInput
            anchors.fill: parent
            anchors.leftMargin: 2
            anchors.topMargin: 5

            horizontalAlignment: Qt.AlignLeft

            font.family: "helvetica"
            font.pointSize: smallFontSize
            color:enabled ? enabledTextColor : disabledTextColor
            text: maxCurrentSlider.value
            validator: DoubleValidator {bottom:3; top:7.5; decimals:1}
            background: Rectangle {
                color:"transparent"
            }
            onEditingFinished:{
                maxCurrentSlider.value= text
                implementationInterfaceBinding.setPortMaximumCurrent(portNumber, Math.round (maxCurrentSlider.value *10)/10)
              }
        }
    }

    Text{
        id:maxCurrentUnitText
        text:"A"
        font.family: "helvetica"
        font.pointSize: smallFontSize
        color: "#D8D8D8"
        anchors.left:maxCurrentTextInputRect.right
        anchors.leftMargin: 5
        anchors.verticalCenter: maxCurrentText.verticalCenter

    }

    AdvancedSlider{
        id:maxCurrentSlider
        anchors.left:maxCurrentUnitText.right
        anchors.leftMargin: 5
        anchors.right:parent.right
        anchors.rightMargin: 30
        anchors.verticalCenter: maxCurrentText.verticalCenter
        height:10
        from: 3
        to:7.5
        value:0
        stepSize: .5

        onPressedChanged: {
            if (!pressed){
                implementationInterfaceBinding.setPortMaximumCurrent(portNumber, Math.round (maxCurrentSlider.value *10)/10)
            }
        }

        onValueChanged: {
            maxCurrentTextInput.text = Math.round (maxCurrentSlider.value *10)/10
        }

        Connections {
            target: implementationInterfaceBinding
            onPortOverCurrentChanged:{
                if( portNumber === port ) {
                    maxCurrentSlider.value = max_current
                }
            }
        }

    }

    Rectangle{
        id:cableCompensationGroup
        color:"#33FFFFFF"
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.leftMargin: 20
        anchors.rightMargin: 20
        anchors.top: maxCurrentText.bottom
        anchors.topMargin: 10
        height: 50

        Text{
            id:portCableCompensationText
            text:"For every cable loss of:"
            font.family: "helvetica"
            font.pointSize: smallFontSize
            horizontalAlignment: Text.AlignRight
            color: "#D8D8D8"
            anchors.right:parent.right
            anchors.rightMargin: parent.width*.6
            anchors.top: cableCompensationGroup.top
            anchors.topMargin: 10

        }

        Rectangle{
            id: portCableCompensationTextInputRect
            color: textEditFieldBackgroundColor
            anchors.left:portCableCompensationText.right
            anchors.leftMargin: 5
            anchors.verticalCenter: portCableCompensationText.verticalCenter
            height:15
            width:30

            TextField{
                id:portCableCompensationTextInput
                anchors.fill: parent
                anchors.leftMargin: 2
                anchors.topMargin: 5

                horizontalAlignment: Qt.AlignLeft

                font.family: "helvetica"
                font.pointSize: smallFontSize
                color:enabled ? enabledTextColor : disabledTextColor
                text: portCableCompensationSlider.value
                validator: DoubleValidator {bottom:.25; top:2; decimals:1}
                background: Rectangle {
                    color:"transparent"
                }
                onEditingFinished:{
                    portCableCompensationSlider.value= text
                    implementationInterfaceBinding.setCableCompensation(portNumber, portCableCompensationSlider.value, voltageCompensationSlider.value)
                  }
            }
        }


        Text{
            id:portCableCompensationUnitText
            text:"A"
            font.family: "helvetica"
            font.pointSize: smallFontSize
            color: "#D8D8D8"
            anchors.left:portCableCompensationTextInputRect.right
            anchors.leftMargin: 5
            anchors.verticalCenter: portCableCompensationText.verticalCenter

        }

        AdvancedSlider{
            id:portCableCompensationSlider
            anchors.left:portCableCompensationUnitText.right
            anchors.leftMargin: 5
            anchors.right:parent.right
            anchors.rightMargin: 10
            anchors.verticalCenter: portCableCompensationText.verticalCenter
            height:10
            from: .25
            to:2
            value:.25
            stepSize: 0.0

            onValueChanged: {
                portCableCompensationTextInput.text = Math.round (portCableCompensationSlider.value *100)/100
            }
            onPressedChanged: {
                if (!pressed){
                    implementationInterfaceBinding.setCableCompensation(portNumber, portCableCompensationSlider.value, voltageCompensationSlider.value)

                }
            }
        }

        Text{
            id:voltageCompensationText
            text:"Bias output by:"
            font.family: "helvetica"
            font.pointSize: smallFontSize
            horizontalAlignment: Text.AlignRight
            color: "#D8D8D8"
            anchors.right:parent.right
            anchors.rightMargin: parent.width*.6
            anchors.top: portCableCompensationText.bottom
            anchors.topMargin: 10
        }
        Rectangle{
            id: voltageCompensationTextInputRect
            color: textEditFieldBackgroundColor
            anchors.left:voltageCompensationText.right
            anchors.leftMargin: 5
            anchors.verticalCenter: voltageCompensationText.verticalCenter
            height:15
            width:30

            TextField{
                id:voltageCompensationTextInput
                anchors.fill: parent
                anchors.leftMargin: 2
                anchors.topMargin: 5

                horizontalAlignment: Qt.AlignLeft

                font.family: "helvetica"
                font.pointSize: smallFontSize
                color:enabled ? enabledTextColor : disabledTextColor
                text: voltageCompensationSlider.value
                validator: IntValidator {bottom:0; top:200;}
                background: Rectangle {
                    color:"transparent"
                }
                onEditingFinished:{
                    voltageCompensationSlider.value= text
                    implementationInterfaceBinding.setCableCompensation(portNumber, portCableCompensationSlider.value, voltageCompensationSlider.value)
                  }
            }
        }

        Text{
            id:voltageCompensationUnitText
            text:"mV"
            font.family: "helvetica"
            font.pointSize: smallFontSize
            color: "#D8D8D8"
            anchors.left:voltageCompensationTextInputRect.right
            anchors.leftMargin: 5
            anchors.verticalCenter: voltageCompensationText.verticalCenter

        }

        AdvancedSlider{
            id:voltageCompensationSlider
            anchors.left:voltageCompensationUnitText.right
            anchors.leftMargin: 5
            anchors.right:parent.right
            anchors.rightMargin: 10
            anchors.verticalCenter: voltageCompensationText.verticalCenter
            height:10
            from: 0
            to:200
            value:0
            stepSize: 50.0

            onValueChanged: {
                voltageCompensationTextInput.text = voltageCompensationSlider.value
            }
            onPressedChanged: {
                if (!pressed){
                    implementationInterfaceBinding.setCableCompensation(portNumber, portCableCompensationSlider.value, voltageCompensationSlider.value)

                }
            }
        }
    }





    //-----------------------------------------------
    //  advertized voltages group
    //-----------------------------------------------
    Rectangle{
        id:portAdvertizedVoltagesGroup
        color:"black"//"#33FFFFFF"
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.leftMargin: 20
        anchors.rightMargin: 20
        anchors.top: cableCompensationGroup.bottom
        anchors.topMargin: 10
        height: 150
        Text{
            id:portAdvertizedVoltagesLabel
            text:"Advertised Voltages:"
            font.family: "helvetica"
            font.pointSize: smallFontSize
            color: enabled ? enabledTextColor : disabledTextColor
            anchors.right:parent.right
            anchors.rightMargin: parent.width*.6
            anchors.top: parent.top
            anchors.topMargin: 0
        }
        Rectangle{
             id: portvoltage1TextInputRect
             color: enabled ? enabledTextFieldBackgroundColor : disabledTextFieldBackgroundColor
             anchors.left:portAdvertizedVoltagesLabel.right
             anchors.leftMargin: 5
             anchors.verticalCenter: portAdvertizedVoltagesLabel.verticalCenter
             height:15
             width:25

            TextField{
                id:portvoltage1TextInput
                anchors.fill: parent
                anchors.leftMargin: 2
                anchors.topMargin: 5

                horizontalAlignment: Qt.AlignLeft

                font.family: "helvetica"
                font.pointSize: smallFontSize
                color:enabled ? enabledTextColor : disabledTextColor
                placeholderText:"NA"
                validator: DoubleValidator{bottom:minimumAdvertisedVoltage; top:maximumAdvertisedVoltage; decimals:1}
                text: portvoltage1Slider.value
                background: Rectangle {
                    color:"transparent"
                }
                onEditingFinished:{
                    portvoltage1Slider.value= text
                  }

            }
        }

        Text{
            id:portvoltage1UnitText
            text:"V"
            font.family: "helvetica"
            font.pointSize: smallFontSize
            color: enabled ? enabledTextColor : disabledTextColor
            anchors.left:portvoltage1TextInputRect.right
            anchors.leftMargin: 5
            anchors.verticalCenter: portAdvertizedVoltagesLabel.verticalCenter

        }
        AdvancedSlider{
            id:portvoltage1Slider
            anchors.left:portvoltage1UnitText.right
            anchors.leftMargin: 5
            anchors.right:parent.right
            anchors.rightMargin: 10
            anchors.verticalCenter: portAdvertizedVoltagesLabel.verticalCenter
            height:10
            from: minimumVoltage
            to:maximumAdvertisedVoltage
            stepSize: 0.0

            onValueChanged: {
                portvoltage1TextInput.text = Math.round (portvoltage1Slider.value *10)/10
                if (portvoltage1Slider.value < minimumAdvertisedVoltage){
                    portvoltage1TextInput.enabled = false;
                    portvoltage1TextInput.text = "NA";
                    portvoltage1UnitText.enabled = false;
                    }
                else{
                    portvoltage1TextInput.enabled = true;
                    portvoltage1UnitText.enabled = true;
                }
            }
            Connections {
                target: implementationInterfaceBinding
                onPortAdvertisedVoltagesChanged:{
                    if( portNumber === port ) {
                        portvoltage1Slider.value = voltage1
                        //console.log ("setting portVoltage1Slider to:", portvoltage1Slider.value)
                    }
                }
            }
        }


        Rectangle{
             id: portvoltage2TextInputRect
             color: enabled ? enabledTextFieldBackgroundColor : disabledTextFieldBackgroundColor
             anchors.left:portAdvertizedVoltagesLabel.right
             anchors.leftMargin: 5
             anchors.top: portvoltage1TextInputRect.bottom
             anchors.topMargin: 5
             height:15
             width:25

            TextField{
                id:portvoltage2TextInput
                anchors.fill: parent
                anchors.leftMargin: 2
                anchors.topMargin: 5

                horizontalAlignment: Qt.AlignLeft

                font.family: "helvetica"
                font.pointSize: smallFontSize
                color:enabled ? enabledTextColor : disabledTextColor
                placeholderText:"NA"
                text: portvoltage2Slider.value
                validator: DoubleValidator{bottom:minimumAdvertisedVoltage; top:maximumAdvertisedVoltage; decimals:1}
                background: Rectangle {
                    color:"transparent"
                }
                onEditingFinished:{
                    portvoltage2Slider.value= text
                  }
            }
        }

        Text{
            id:portvoltage2UnitText
            text:"V"
            font.family: "helvetica"
            font.pointSize: smallFontSize
            color: enabled ? enabledTextColor : disabledTextColor
            anchors.left:portvoltage2TextInputRect.right
            anchors.leftMargin: 5
            anchors.verticalCenter: portvoltage2TextInputRect.verticalCenter

        }

        AdvancedSlider{
            id:portvoltage2Slider
            anchors.left:portvoltage2UnitText.right
            anchors.leftMargin: 5
            anchors.right:parent.right
            anchors.rightMargin: 10
            anchors.verticalCenter: portvoltage2TextInputRect.verticalCenter
            height:10
            from: minimumVoltage
            to:maximumAdvertisedVoltage
            stepSize: 0.0

            onValueChanged: {
                portvoltage2TextInput.text = Math.round (portvoltage2Slider.value *10)/10
                if (portvoltage2Slider.value < minimumAdvertisedVoltage){
                    portvoltage2TextInput.enabled = false;
                    portvoltage2TextInput.text = "NA";
                    portvoltage2UnitText.enabled = false;
                    }
                else{
                    portvoltage2TextInput.enabled = true;
                    portvoltage2UnitText.enabled = true;
                }
            }
            Connections {
                target: implementationInterfaceBinding
                onPortAdvertisedVoltagesChanged:{
                    if( portNumber === port ) {
                        portvoltage2Slider.value = voltage2
                    }
                }
            }
        }


        Rectangle{
             id: portvoltage3TextInputRect
             color: enabled ? enabledTextFieldBackgroundColor : disabledTextFieldBackgroundColor
             anchors.left:portAdvertizedVoltagesLabel.right
             anchors.leftMargin: 5
             anchors.top: portvoltage2TextInputRect.bottom
             anchors.topMargin: 5
             height:15
             width:25

            TextField{
                id:portvoltage3TextInput
                anchors.fill: parent
                anchors.leftMargin: 2
                anchors.topMargin: 5

                horizontalAlignment: Qt.AlignLeft

                font.family: "helvetica"
                font.pointSize: smallFontSize
                color:enabled ? enabledTextColor : disabledTextColor
                placeholderText:"NA"
                text: portvoltage3Slider.value
                validator: DoubleValidator{bottom:minimumAdvertisedVoltage; top:maximumAdvertisedVoltage; decimals:1}
                background: Rectangle {
                    color:"transparent"
                }
                onEditingFinished:{
                    portvoltage3Slider.value= text
                  }
            }
        }



        Text{
            id:portvoltage3UnitText
            text:"V"
            font.family: "helvetica"
            font.pointSize: smallFontSize
            color: enabled ? enabledTextColor : disabledTextColor
            anchors.left:portvoltage3TextInputRect.right
            anchors.leftMargin: 5
            anchors.verticalCenter: portvoltage3TextInputRect.verticalCenter

        }

        AdvancedSlider{
            id:portvoltage3Slider
            anchors.left:portvoltage3UnitText.right
            anchors.leftMargin: 5
            anchors.right:parent.right
            anchors.rightMargin: 10
            anchors.verticalCenter: portvoltage3TextInputRect.verticalCenter
            height:10
            from: minimumVoltage
            to:maximumAdvertisedVoltage
            stepSize: 0.0

            onValueChanged: {
                portvoltage3TextInput.text = Math.round (portvoltage3Slider.value *10)/10
                if (portvoltage3Slider.value < minimumAdvertisedVoltage){
                    portvoltage3TextInput.enabled = false;
                    portvoltage3TextInput.text = "NA";
                    portvoltage3UnitText.enabled = false;
                    }
                else{
                    portvoltage3TextInput.enabled = true;
                    portvoltage3UnitText.enabled = true;
                }
            }
            Connections {
                target: implementationInterfaceBinding
                onPortAdvertisedVoltagesChanged:{
                    if( portNumber === port ) {
                        portvoltage3Slider.value = voltage3
                    }
                }
            }
        }


        Rectangle{
             id: portvoltage4TextInputRect
             color: enabled ? enabledTextFieldBackgroundColor : disabledTextFieldBackgroundColor
             anchors.left:portAdvertizedVoltagesLabel.right
             anchors.leftMargin: 5
             anchors.top: portvoltage3TextInputRect.bottom
             anchors.topMargin: 5
             height:15
             width:25

            TextField{
                id:portvoltage4TextInput
                anchors.fill: parent
                anchors.leftMargin: 2
                anchors.topMargin: 5

                horizontalAlignment: Qt.AlignLeft

                font.family: "helvetica"
                font.pointSize: smallFontSize
                color:enabled ? enabledTextColor : disabledTextColor
                placeholderText:"NA"
                text: portvoltage4Slider.value
                validator: DoubleValidator{bottom:minimumAdvertisedVoltage; top:maximumAdvertisedVoltage; decimals:1}
                background: Rectangle {
                    color:"transparent"
                }
                onEditingFinished:{
                    portvoltage4Slider.value= text
                  }
            }
        }

        Text{
            id:portvoltage4UnitText
            text:"V"
            font.family: "helvetica"
            font.pointSize: smallFontSize
            color: enabled ? enabledTextColor : disabledTextColor
            anchors.left:portvoltage4TextInputRect.right
            anchors.leftMargin: 5
            anchors.verticalCenter: portvoltage4TextInputRect.verticalCenter

        }

        AdvancedSlider{
            id:portvoltage4Slider
            anchors.left:portvoltage4UnitText.right
            anchors.leftMargin: 5
            anchors.right:parent.right
            anchors.rightMargin: 10
            anchors.verticalCenter: portvoltage4TextInputRect.verticalCenter
            height:10
            from: minimumVoltage
            to:maximumAdvertisedVoltage
            stepSize: 0.0

            onValueChanged: {
                portvoltage4TextInput.text = Math.round (portvoltage4Slider.value *10)/10
                if (portvoltage4Slider.value < minimumAdvertisedVoltage){
                    portvoltage4TextInput.enabled = false;
                    portvoltage4TextInput.text = "NA";
                    portvoltage4UnitText.enabled = false;
                    }
                else{
                    portvoltage4TextInput.enabled = true;
                    portvoltage4UnitText.enabled = true;
                }
            }
            Connections {
                target: implementationInterfaceBinding
                onPortAdvertisedVoltagesChanged:{
                    if( portNumber === port ) {
                        portvoltage4Slider.value = voltage4
                    }
                }
            }
        }


        Rectangle{
             id: portvoltage5TextInputRect
             color: enabled ? enabledTextFieldBackgroundColor : disabledTextFieldBackgroundColor
             anchors.left:portAdvertizedVoltagesLabel.right
             anchors.leftMargin: 5
             anchors.top: portvoltage4TextInputRect.bottom
             anchors.topMargin: 5
             height:15
             width:25

            TextField{
                id:portvoltage5TextInput
                anchors.fill: parent
                anchors.leftMargin: 2
                anchors.topMargin: 5

                horizontalAlignment: Qt.AlignLeft

                font.family: "helvetica"
                font.pointSize: smallFontSize
                color:enabled ? enabledTextColor : disabledTextColor
                placeholderText:"NA"
                text: portvoltage5Slider.value
                validator: DoubleValidator{bottom:minimumAdvertisedVoltage; top:maximumAdvertisedVoltage; decimals:1}
                background: Rectangle {
                    color:"transparent"
                }
                onEditingFinished:{
                    portvoltage5Slider.value= text
                  }
            }
        }


        Text{
            id:portvoltage5UnitText
            text:"V"
            font.family: "helvetica"
            font.pointSize: smallFontSize
            color: enabled ? enabledTextColor : disabledTextColor
            anchors.left:portvoltage5TextInputRect.right
            anchors.leftMargin: 5
            anchors.verticalCenter: portvoltage5TextInputRect.verticalCenter

        }

        AdvancedSlider{
            id:portvoltage5Slider
            anchors.left:portvoltage5UnitText.right
            anchors.leftMargin: 5
            anchors.right:parent.right
            anchors.rightMargin: 10
            anchors.verticalCenter: portvoltage5TextInputRect.verticalCenter
            height:10
            from: minimumVoltage
            to:maximumAdvertisedVoltage
            stepSize: 0.0

            onValueChanged: {
                portvoltage5TextInput.text = Math.round (portvoltage5Slider.value *10)/10
                if (portvoltage5Slider.value < minimumAdvertisedVoltage){
                    portvoltage5TextInput.enabled = false;
                    portvoltage5TextInput.text = "NA";
                    portvoltage5UnitText.enabled = false;
                    }
                else{
                    portvoltage5TextInput.enabled = true;
                    portvoltage5UnitText.enabled = true;
                }
            }
            Connections {
                target: implementationInterfaceBinding
                onPortAdvertisedVoltagesChanged:{
                    if( portNumber === port ) {
                        portvoltage5Slider.value = voltage5
                    }
                }
            }
        }


        Rectangle{
             id: portvoltage6TextInputRect
             color: enabled ? enabledTextFieldBackgroundColor : disabledTextFieldBackgroundColor
             anchors.left:portAdvertizedVoltagesLabel.right
             anchors.leftMargin: 5
             anchors.top: portvoltage5TextInputRect.bottom
             anchors.topMargin: 5
             height:15
             width:25

            TextField{
                id:portvoltage6TextInput
                anchors.fill: parent
                anchors.leftMargin: 2
                anchors.topMargin: 5

                horizontalAlignment: Qt.AlignLeft

                font.family: "helvetica"
                font.pointSize: smallFontSize
                color:enabled ? enabledTextColor : disabledTextColor
                placeholderText:"NA"
                text: portvoltage6Slider.value
                validator: DoubleValidator{bottom:minimumAdvertisedVoltage; top:maximumAdvertisedVoltage; decimals:1}
                background: Rectangle {
                    color:"transparent"
                }
                onEditingFinished:{
                    portvoltage6Slider.value= text
                  }
            }
        }


        Text{
            id:portvoltage6UnitText
            text:"V"
            font.family: "helvetica"
            font.pointSize: smallFontSize
            color: enabled ? enabledTextColor : disabledTextColor
            anchors.left:portvoltage6TextInputRect.right
            anchors.leftMargin: 5
            anchors.verticalCenter: portvoltage6TextInputRect.verticalCenter

        }

        AdvancedSlider{
            id:portvoltage6Slider
            anchors.left:portvoltage6UnitText.right
            anchors.leftMargin: 5
            anchors.right:parent.right
            anchors.rightMargin: 10
            anchors.verticalCenter: portvoltage6TextInputRect.verticalCenter
            height:10
            from: minimumVoltage
            to:maximumAdvertisedVoltage
            stepSize: 0.0

            onValueChanged: {
                portvoltage6TextInput.text = Math.round (portvoltage6Slider.value *10)/10
                if (portvoltage6Slider.value < minimumAdvertisedVoltage){
                    portvoltage6TextInput.enabled = false;
                    portvoltage6TextInput.text = "NA";
                    portvoltage6UnitText.enabled = false;
                    }
                else{
                    portvoltage6TextInput.enabled = true;
                    portvoltage6UnitText.enabled = true;
                }
            }
            Connections {
                target: implementationInterfaceBinding
                onPortAdvertisedVoltagesChanged:{
                    if( portNumber === port ) {
                        portvoltage6Slider.value = voltage6
                    }
                }
            }
        }


        Rectangle{
             id: portvoltage7TextInputRect
             color: enabled ? enabledTextFieldBackgroundColor : disabledTextFieldBackgroundColor
             anchors.left:portAdvertizedVoltagesLabel.right
             anchors.leftMargin: 5
             anchors.top: portvoltage6TextInputRect.bottom
             anchors.topMargin: 5
             height:15
             width:25

            TextField{
                id:portvoltage7TextInput
                anchors.fill: parent
                anchors.leftMargin: 2
                anchors.topMargin: 5

                horizontalAlignment: Qt.AlignLeft

                font.family: "helvetica"
                font.pointSize: smallFontSize
                color:enabled ? enabledTextColor : disabledTextColor
                placeholderText:"NA"
                text: portvoltage7Slider.value
                validator: DoubleValidator{bottom:minimumAdvertisedVoltage; top:maximumAdvertisedVoltage; decimals:1}
                background: Rectangle {
                    color:"transparent"
                }
                onEditingFinished:{
                    portvoltage7Slider.value= text
                  }
            }
        }

        Text{
            id:portvoltage7UnitText
            text:"V"
            font.family: "helvetica"
            font.pointSize: smallFontSize
            color: enabled ? enabledTextColor : disabledTextColor
            anchors.left:portvoltage7TextInputRect.right
            anchors.leftMargin: 5
            anchors.verticalCenter: portvoltage7TextInputRect.verticalCenter

        }

        AdvancedSlider{
            id:portvoltage7Slider
            anchors.left:portvoltage7UnitText.right
            anchors.leftMargin: 5
            anchors.right:parent.right
            anchors.rightMargin: 10
            anchors.verticalCenter: portvoltage7TextInputRect.verticalCenter
            height:10
            from: minimumVoltage
            to:maximumAdvertisedVoltage
            stepSize: 0.0

            onValueChanged: {
                portvoltage7TextInput.text = Math.round (portvoltage7Slider.value *10)/10
                if (portvoltage7Slider.value < minimumAdvertisedVoltage){
                    portvoltage7TextInput.enabled = false;
                    portvoltage7TextInput.text = "NA";
                    portvoltage7UnitText.enabled = false;
                    }
                else{
                    portvoltage7TextInput.enabled = true;
                    portvoltage7UnitText.enabled = true;
                }
            }
            Connections {
                target: implementationInterfaceBinding
                onPortAdvertisedVoltagesChanged:{
                    if( portNumber === port ) {
                        portvoltage7Slider.value = voltage7
                    }
                }
            }
        }


    }
}
