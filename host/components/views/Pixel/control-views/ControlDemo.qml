import QtQuick 2.9
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.7
import tech.strata.sgwidgets 0.9

import "qrc:/js/help_layout_manager.js" as Help

Rectangle {

    id: controldemo
    //    anchors.fill: parent
    width: parent.width
    height: parent.height
    color:"black"
    DemoPattern1 {
        id:demoLEDPattern1
    }
    DemoPattern2 {
        id:demoLEDPattern2
    }
    DemoPattern3 {
        id:demoLEDPattern3
    }
    DemoPattern5 {
        id:demoLEDPattern5
    }

    function send_demo_state(mode_state, led_num_state, repeat_state, time_state, intensity_state){
        platformInterface.pxn_demo_setting.update(mode_state,led_num_state,repeat_state,time_state,intensity_state)

        if (platformInterface.star_demo === true && platformInterface.demo_led_num_1 === true){
            demoLEDPattern1.led_all_off()
            demoLEDPattern1.demo_star1()

        }else if (platformInterface.star_demo === true && platformInterface.demo_led_num_2 === true){
            demoLEDPattern1.led_all_off()
            demoLEDPattern1.demo_star2()

        }else if (platformInterface.star_demo === true && platformInterface.demo_led_num_3 === true){
            demoLEDPattern1.led_all_off()
            demoLEDPattern1.demo_star3()

        }else if (platformInterface.star_demo === true && platformInterface.demo_led_num_4 === true){
            demoLEDPattern1.led_all_off()
            demoLEDPattern1.demo_star4()

        }else if (platformInterface.star_demo === true && platformInterface.demo_led_num_5 === true){
            demoLEDPattern1.led_all_off()
            demoLEDPattern1.demo_star5()

        }else if (platformInterface.curtain_demo === true && platformInterface.demo_led_num_1 === true){
            demoLEDPattern2.led_all_off()
            demoLEDPattern2.demo_cirtain1()

        }else if (platformInterface.curtain_demo === true && platformInterface.demo_led_num_2 === true){
            demoLEDPattern2.led_all_off()
            demoLEDPattern2.demo_cirtain2()

        }else if (platformInterface.curtain_demo === true && platformInterface.demo_led_num_3 === true){
            demoLEDPattern2.led_all_off()
            demoLEDPattern2.demo_cirtain3()

        }else if (platformInterface.curtain_demo === true && platformInterface.demo_led_num_4 === true){
            demoLEDPattern2.led_all_off()
            demoLEDPattern2.demo_cirtain4()

        }else if (platformInterface.curtain_demo === true && platformInterface.demo_led_num_5 === true){
            demoLEDPattern2.led_all_off()
            demoLEDPattern2.demo_cirtain5()

        }else if (platformInterface.bhall_demo === true && platformInterface.demo_led_num_1 === true){
            demoLEDPattern3.led_all_on()
            demoLEDPattern3.demo_bhall1()

        }else if (platformInterface.bhall_demo === true && platformInterface.demo_led_num_2 === true){
            demoLEDPattern3.led_all_on()
            demoLEDPattern3.demo_bhall2()

        }else if (platformInterface.bhall_demo === true && platformInterface.demo_led_num_3 === true){
            demoLEDPattern3.led_all_on()
            demoLEDPattern3.demo_bhall3()

        }else if (platformInterface.bhall_demo === true && platformInterface.demo_led_num_4 === true){
            demoLEDPattern3.led_all_on()
            demoLEDPattern3.demo_bhall4()

        }else if (platformInterface.bhall_demo === true && platformInterface.demo_led_num_5 === true){
            demoLEDPattern3.led_all_on()
            demoLEDPattern3.demo_bhall5()

        }
    }

    function set_all_led_state(dim_var){
        demoLEDPattern3.led_all_on()
        platformInterface.pxn_datasend_all.update((100-dim_var).toFixed(1))
    }

    function set_led_bar_state(bar_val){
        var set_Vale = bar_val.toFixed(0)
        platformInterface.pxn_led_position.update(set_Vale)

        if (set_Vale === '1'){
            platformInterface.curatin_position1 = true
        }else if (set_Vale === '2'){
            platformInterface.curatin_position2 = true
        }else if (set_Vale === '3'){
            platformInterface.curatin_position3 = true
        }else if (set_Vale === '4'){
            platformInterface.curatin_position4 = true
        }else if (set_Vale === '5'){
            platformInterface.curatin_position5 = true
        }else if (set_Vale === '6'){
            platformInterface.curatin_position6 = true
        }else if (set_Vale === '7'){
            platformInterface.curatin_position7 = true
        }else if (set_Vale === '8'){
            platformInterface.curatin_position8 = true
        }else if (set_Vale === '9'){
            platformInterface.curatin_position9 = true
        }else if (set_Vale === '10'){
            platformInterface.curatin_position10 = true
        }else if (set_Vale === '11'){
            platformInterface.curatin_position11 = true
        }else if (set_Vale === '12'){
            platformInterface.curatin_position12 = true
        }

    }

    property bool check_demo_led11_state: platformInterface.demo_led11_state
    onCheck_demo_led11_stateChanged: {
        if (check_demo_led11_state === true)
            sgStatusLight11.status = "green"
        else sgStatusLight11.status = "off"
    }

    property bool check_demo_led12_state: platformInterface.demo_led12_state
    onCheck_demo_led12_stateChanged: {
        if (check_demo_led12_state === true)
            sgStatusLight12.status = "green"
        else sgStatusLight12.status = "off"
    }

    property bool check_demo_led13_state: platformInterface.demo_led13_state
    onCheck_demo_led13_stateChanged: {
        if (check_demo_led13_state === true)
            sgStatusLight13.status = "green"
        else sgStatusLight13.status = "off"
    }

    property bool check_demo_led14_state: platformInterface.demo_led14_state
    onCheck_demo_led14_stateChanged: {
        if (check_demo_led14_state === true)
            sgStatusLight14.status = "green"
        else sgStatusLight14.status = "off"
    }

    property bool check_demo_led15_state: platformInterface.demo_led15_state
    onCheck_demo_led15_stateChanged: {
        if (check_demo_led15_state === true)
            sgStatusLight15.status = "green"
        else sgStatusLight15.status = "off"
    }

    property bool check_demo_led16_state: platformInterface.demo_led16_state
    onCheck_demo_led16_stateChanged: {
        if (check_demo_led16_state === true)
            sgStatusLight16.status = "green"
        else sgStatusLight16.status = "off"
    }

    property bool check_demo_led17_state: platformInterface.demo_led17_state
    onCheck_demo_led17_stateChanged: {
        if (check_demo_led17_state === true)
            sgStatusLight17.status = "green"
        else sgStatusLight17.status = "off"
    }

    property bool check_demo_led18_state: platformInterface.demo_led18_state
    onCheck_demo_led18_stateChanged: {
        if (check_demo_led18_state === true)
            sgStatusLight18.status = "green"
        else sgStatusLight18.status = "off"
    }

    property bool check_demo_led19_state: platformInterface.demo_led19_state
    onCheck_demo_led19_stateChanged: {
        if (check_demo_led19_state === true)
            sgStatusLight19.status = "green"
        else sgStatusLight19.status = "off"
    }

    property bool check_demo_led1A_state: platformInterface.demo_led1A_state
    onCheck_demo_led1A_stateChanged: {
        if (check_demo_led1A_state === true)
            sgStatusLight1A.status = "green"
        else sgStatusLight1A.status = "off"
    }

    property bool check_demo_led1B_state: platformInterface.demo_led1B_state
    onCheck_demo_led1B_stateChanged: {
        if (check_demo_led1B_state === true)
            sgStatusLight1B.status = "green"
        else sgStatusLight1B.status = "off"
    }

    property bool check_demo_led1C_state: platformInterface.demo_led1C_state
    onCheck_demo_led1C_stateChanged: {
        if (check_demo_led1C_state === true)
            sgStatusLight1C.status = "green"
        else sgStatusLight1C.status = "off"
    }

    property bool check_demo_led21_state: platformInterface.demo_led21_state
    onCheck_demo_led21_stateChanged: {
        if (check_demo_led21_state === true)
            sgStatusLight21.status = "green"
        else sgStatusLight21.status = "off"
    }

    property bool check_demo_led22_state: platformInterface.demo_led22_state
    onCheck_demo_led22_stateChanged: {
        if (check_demo_led22_state === true)
            sgStatusLight22.status = "green"
        else sgStatusLight22.status = "off"
    }

    property bool check_demo_led23_state: platformInterface.demo_led23_state
    onCheck_demo_led23_stateChanged: {
        if (check_demo_led23_state === true)
            sgStatusLight23.status = "green"
        else sgStatusLight23.status = "off"
    }

    property bool check_demo_led24_state: platformInterface.demo_led24_state
    onCheck_demo_led24_stateChanged: {
        if (check_demo_led24_state === true)
            sgStatusLight24.status = "green"
        else sgStatusLight24.status = "off"
    }

    property bool check_demo_led25_state: platformInterface.demo_led25_state
    onCheck_demo_led25_stateChanged: {
        if (check_demo_led25_state === true)
            sgStatusLight25.status = "green"
        else sgStatusLight25.status = "off"
    }

    property bool check_demo_led26_state: platformInterface.demo_led26_state
    onCheck_demo_led26_stateChanged: {
        if (check_demo_led26_state === true)
            sgStatusLight26.status = "green"
        else sgStatusLight26.status = "off"
    }

    property bool check_demo_led27_state: platformInterface.demo_led27_state
    onCheck_demo_led27_stateChanged: {
        if (check_demo_led27_state === true)
            sgStatusLight27.status = "green"
        else sgStatusLight27.status = "off"
    }

    property bool check_demo_led28_state: platformInterface.demo_led28_state
    onCheck_demo_led28_stateChanged: {
        if (check_demo_led28_state === true)
            sgStatusLight28.status = "green"
        else sgStatusLight28.status = "off"
    }

    property bool check_demo_led29_state: platformInterface.demo_led29_state
    onCheck_demo_led29_stateChanged: {
        if (check_demo_led29_state === true)
            sgStatusLight29.status = "green"
        else sgStatusLight29.status = "off"
    }

    property bool check_demo_led2A_state: platformInterface.demo_led2A_state
    onCheck_demo_led2A_stateChanged: {
        if (check_demo_led2A_state === true)
            sgStatusLight2A.status = "green"
        else sgStatusLight2A.status = "off"
    }

    property bool check_demo_led2B_state: platformInterface.demo_led2B_state
    onCheck_demo_led2B_stateChanged: {
        if (check_demo_led2B_state === true)
            sgStatusLight2B.status = "green"
        else sgStatusLight2B.status = "off"
    }

    property bool check_demo_led2C_state: platformInterface.demo_led2C_state
    onCheck_demo_led2C_stateChanged: {
        if (check_demo_led2C_state === true)
            sgStatusLight2C.status = "green"
        else sgStatusLight2C.status = "off"
    }

    property bool check_demo_led31_state: platformInterface.demo_led31_state
    onCheck_demo_led31_stateChanged: {
        if (check_demo_led31_state === true)
            sgStatusLight31.status = "green"
        else sgStatusLight31.status = "off"
    }

    property bool check_demo_led32_state: platformInterface.demo_led32_state
    onCheck_demo_led32_stateChanged: {
        if (check_demo_led32_state === true)
            sgStatusLight32.status = "green"
        else sgStatusLight32.status = "off"
    }

    property bool check_demo_led33_state: platformInterface.demo_led33_state
    onCheck_demo_led33_stateChanged: {
        if (check_demo_led33_state === true)
            sgStatusLight33.status = "green"
        else sgStatusLight33.status = "off"
    }

    property bool check_demo_led34_state: platformInterface.demo_led34_state
    onCheck_demo_led34_stateChanged: {
        if (check_demo_led34_state === true)
            sgStatusLight34.status = "green"
        else sgStatusLight34.status = "off"
    }

    property bool check_demo_led35_state: platformInterface.demo_led35_state
    onCheck_demo_led35_stateChanged: {
        if (check_demo_led35_state === true)
            sgStatusLight35.status = "green"
        else sgStatusLight35.status = "off"
    }

    property bool check_demo_led36_state: platformInterface.demo_led36_state
    onCheck_demo_led36_stateChanged: {
        if (check_demo_led36_state === true)
            sgStatusLight36.status = "green"
        else sgStatusLight36.status = "off"
    }

    property bool check_demo_led37_state: platformInterface.demo_led37_state
    onCheck_demo_led37_stateChanged: {
        if (check_demo_led37_state === true)
            sgStatusLight37.status = "green"
        else sgStatusLight37.status = "off"
    }

    property bool check_demo_led38_state: platformInterface.demo_led38_state
    onCheck_demo_led38_stateChanged: {
        if (check_demo_led38_state === true)
            sgStatusLight38.status = "green"
        else sgStatusLight38.status = "off"
    }

    property bool check_demo_led39_state: platformInterface.demo_led39_state
    onCheck_demo_led39_stateChanged: {
        if (check_demo_led39_state === true)
            sgStatusLight39.status = "green"
        else sgStatusLight39.status = "off"
    }

    property bool check_demo_led3A_state: platformInterface.demo_led3A_state
    onCheck_demo_led3A_stateChanged: {
        if (check_demo_led3A_state === true)
            sgStatusLight3A.status = "green"
        else sgStatusLight3A.status = "off"
    }

    property bool check_demo_led3B_state: platformInterface.demo_led3B_state
    onCheck_demo_led3B_stateChanged: {
        if (check_demo_led3B_state === true)
            sgStatusLight3B.status = "green"
        else sgStatusLight3B.status = "off"
    }

    property bool check_demo_led3C_state: platformInterface.demo_led3C_state
    onCheck_demo_led3C_stateChanged: {
        if (check_demo_led3C_state === true)
            sgStatusLight3C.status = "green"
        else sgStatusLight3C.status = "off"
    }

    property bool check_curatin_position1_state: platformInterface.curatin_position1
    onCheck_curatin_position1_stateChanged: {
        if (check_curatin_position1_state === true){
            demoLEDPattern1.led_all_off()
            demoLEDPattern5.position_1()
            demoLEDPattern5.clear_state_exp1()
        }
    }

    property bool check_curatin_position2_state: platformInterface.curatin_position2
    onCheck_curatin_position2_stateChanged: {
        if (check_curatin_position2_state === true){
            demoLEDPattern1.led_all_off()
            demoLEDPattern5.position_2()
            demoLEDPattern5.clear_state_exp2()
        }
    }

    property bool check_curatin_position3_state: platformInterface.curatin_position3
    onCheck_curatin_position3_stateChanged: {
        if (check_curatin_position3_state === true){
            demoLEDPattern1.led_all_off()
            demoLEDPattern5.position_3()
            demoLEDPattern5.clear_state_exp3()
        }
    }

    property bool check_curatin_position4_state: platformInterface.curatin_position4
    onCheck_curatin_position4_stateChanged: {
        if (check_curatin_position4_state === true){
            demoLEDPattern1.led_all_off()
            demoLEDPattern5.position_4()
            demoLEDPattern5.clear_state_exp4()
        }
    }

    property bool check_curatin_position5_state: platformInterface.curatin_position5
    onCheck_curatin_position5_stateChanged: {
        if (check_curatin_position5_state === true){
            demoLEDPattern1.led_all_off()
            demoLEDPattern5.position_5()
            demoLEDPattern5.clear_state_exp5()
        }
    }

    property bool check_curatin_position6_state: platformInterface.curatin_position6
    onCheck_curatin_position6_stateChanged: {
        if (check_curatin_position6_state === true){
            demoLEDPattern1.led_all_off()
            demoLEDPattern5.position_6()
            demoLEDPattern5.clear_state_exp6()
        }
    }

    property bool check_curatin_position7_state: platformInterface.curatin_position7
    onCheck_curatin_position7_stateChanged: {
        if (check_curatin_position7_state === true){
            demoLEDPattern1.led_all_off()
            demoLEDPattern5.position_7()
            demoLEDPattern5.clear_state_exp7()
        }
    }

    property bool check_curatin_position8_state: platformInterface.curatin_position8
    onCheck_curatin_position8_stateChanged: {
        if (check_curatin_position8_state === true){
            demoLEDPattern1.led_all_off()
            demoLEDPattern5.position_8()
            demoLEDPattern5.clear_state_exp8()
        }
    }

    property bool check_curatin_position9_state: platformInterface.curatin_position9
    onCheck_curatin_position9_stateChanged: {
        if (check_curatin_position9_state === true){
            demoLEDPattern1.led_all_off()
            demoLEDPattern5.position_9()
            demoLEDPattern5.clear_state_exp9()
        }
    }

    property bool check_curatin_position10_state: platformInterface.curatin_position10
    onCheck_curatin_position10_stateChanged: {
        if (check_curatin_position10_state === true){
            demoLEDPattern1.led_all_off()
            demoLEDPattern5.position_10()
            demoLEDPattern5.clear_state_exp10()
        }
    }

    property bool check_curatin_position11_state: platformInterface.curatin_position11
    onCheck_curatin_position11_stateChanged: {
        if (check_curatin_position11_state === true){
            demoLEDPattern1.led_all_off()
            demoLEDPattern5.position_11()
            demoLEDPattern5.clear_state_exp11()
        }
    }

    property bool check_curatin_position12_state: platformInterface.curatin_position12
    onCheck_curatin_position12_stateChanged: {
        if (check_curatin_position12_state === true){
            demoLEDPattern1.led_all_off()
            demoLEDPattern5.position_12()
            demoLEDPattern5.clear_state_exp12()
        }
    }

    Rectangle{
        id:title
        width: parent.width/3
        height: parent.height/11
        anchors{
            top: parent.top
            horizontalCenter: parent.horizontalCenter
        }
        color:"black"
        Text {
            text: "Pixel Dimming Control - Demo"
            font.pixelSize: 25
            anchors.fill:parent
            color: "white"
            horizontalAlignment: Text.AlignHCenter
        }
    }

    RowLayout{
        anchors.fill: parent
        anchors.top: title.bottom

        Rectangle{
            Layout.preferredWidth: parent.width/2.5
            Layout.preferredHeight: parent.height-250
            color: "black"

            ColumnLayout{
                anchors.fill: parent

                Rectangle {
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    color: "black"

                    SGSegmentedButtonStrip{
                        id: segmentedButtons1
                        anchors.centerIn: parent

                        label: "Pxel Pattern:"          // Default: "" (will not appear if not entered)
                        labelLeft: false                // Default: true (true: label on left, false: label on top)
                        textColor: "white"              // Default: "white"
                        activeTextColor: "#C400FE"        // Default: "white"
                        activeColor: "#999"             // Default: "#999"
                        inactiveColor: "dimgray"           // Default: "#ddd"

                        segmentedButtons: GridLayout {

                            columnSpacing: 2

                            SGSegmentedButton{
                                text: qsTr("Star")
                                checked: true  // Sets default checked button when exclusive
                                onClicked: {
                                    platformInterface.star_demo = true
                                    platformInterface.curtain_demo = false
                                    platformInterface.bhall_demo = false
                                    platformInterface.mix_demo = false
                                    send_demo_state((segmentedButtons1.index+1),(segmentedButtons2.index+1),(segmentedButtons3.index+3),sgSlider1.value,(100-sgSlider2.value))
                                }
                            }

                            SGSegmentedButton{
                                text: qsTr("Curtain")
                                onClicked: {
                                    platformInterface.star_demo = false
                                    platformInterface.curtain_demo = true
                                    platformInterface.bhall_demo = false
                                    platformInterface.mix_demo = false                              
                                    send_demo_state((segmentedButtons1.index+1),(segmentedButtons2.index+1),(segmentedButtons3.index+3),sgSlider1.value,(100-sgSlider2.value))
                                }
                            }

                            SGSegmentedButton{
                                text: qsTr("B.Hall")
                                onClicked: {
                                    platformInterface.star_demo = false
                                    platformInterface.curtain_demo = false
                                    platformInterface.bhall_demo = true
                                    platformInterface.mix_demo = false
                                    send_demo_state((segmentedButtons1.index+1),(segmentedButtons2.index+1),(segmentedButtons3.index+3),sgSlider1.value,(100-sgSlider2.value))
                                }
                            }

                            SGSegmentedButton{
                                text: qsTr("Mix")
                                onClicked: {
                                    platformInterface.star_demo = false
                                    platformInterface.curtain_demo = false
                                    platformInterface.bhall_demo = false
                                    platformInterface.mix_demo = true
                                    send_demo_state((segmentedButtons1.index+1),(segmentedButtons2.index+1),(segmentedButtons3.index+3),sgSlider1.value,(100-sgSlider2.value))
                                }
                            }
                        }
                    }
                }

                Rectangle {
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    color: "black"

                    SGSegmentedButtonStrip{
                        id: segmentedButtons2
                        anchors.centerIn: parent

                        label: "Pxel bit:"                 // Default: "" (will not appear if not entered)
                        labelLeft: false                // Default: true (true: label on left, false: label on top)
                        textColor: "white"              // Default: "white"
                        activeTextColor: "#C400FE"        // Default: "white"
                        activeColor: "#999"             // Default: "#999"
                        inactiveColor: "dimgray"           // Default: "#ddd"


                        segmentedButtons: GridLayout {
                            columnSpacing: 2

                            SGSegmentedButton{
                                text: qsTr("1")
                                checked: true  // Sets default checked button when exclusive
                                onClicked: {
                                    platformInterface.demo_led_num_1 = true
                                    platformInterface.demo_led_num_2 = false
                                    platformInterface.demo_led_num_3 = false
                                    platformInterface.demo_led_num_4 = false
                                    platformInterface.demo_led_num_5 = false
                                    send_demo_state((segmentedButtons1.index+1),(segmentedButtons2.index+1),(segmentedButtons3.index+3),sgSlider1.value,(100-sgSlider2.value))
                                }
                            }

                            SGSegmentedButton{
                                text: qsTr("2")
                                onClicked: {
                                    platformInterface.demo_led_num_1 = false
                                    platformInterface.demo_led_num_2 = true
                                    platformInterface.demo_led_num_3 = false
                                    platformInterface.demo_led_num_4 = false
                                    platformInterface.demo_led_num_5 = false
                                    send_demo_state((segmentedButtons1.index+1),(segmentedButtons2.index+1),(segmentedButtons3.index+3),sgSlider1.value,(100-sgSlider2.value))
                                }
                            }

                            SGSegmentedButton{
                                text: qsTr("3")
                                onClicked: {
                                    platformInterface.demo_led_num_1 = false
                                    platformInterface.demo_led_num_2 = false
                                    platformInterface.demo_led_num_3 = true
                                    platformInterface.demo_led_num_4 = false
                                    platformInterface.demo_led_num_5 = false
                                    send_demo_state((segmentedButtons1.index+1),(segmentedButtons2.index+1),(segmentedButtons3.index+3),sgSlider1.value,(100-sgSlider2.value))
                                }
                            }

                            SGSegmentedButton{
                                text: qsTr("4")
                                onClicked: {
                                    platformInterface.demo_led_num_1 = false
                                    platformInterface.demo_led_num_2 = false
                                    platformInterface.demo_led_num_3 = false
                                    platformInterface.demo_led_num_4 = true
                                    platformInterface.demo_led_num_5 = false
                                    send_demo_state((segmentedButtons1.index+1),(segmentedButtons2.index+1),(segmentedButtons3.index+3),sgSlider1.value,(100-sgSlider2.value))
                                }
                            }

                            SGSegmentedButton{
                                text: qsTr("5")
                                onClicked: {
                                    platformInterface.demo_led_num_1 = false
                                    platformInterface.demo_led_num_2 = false
                                    platformInterface.demo_led_num_3 = false
                                    platformInterface.demo_led_num_4 = false
                                    platformInterface.demo_led_num_5 = true
                                    send_demo_state((segmentedButtons1.index+1),(segmentedButtons2.index+1),(segmentedButtons3.index+3),sgSlider1.value,(100-sgSlider2.value))
                                }
                            }
                        }
                    }
                }

                Rectangle {
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    color: "black"

                    SGSegmentedButtonStrip{
                        id: segmentedButtons3
                        anchors.centerIn: parent

                        label: "Demo repeat counts:"                 // Default: "" (will not appear if not entered)
                        labelLeft: false                // Default: true (true: label on left, false: label on top)
                        textColor: "white"              // Default: "white"
                        activeTextColor: "#C400FE"        // Default: "white"
                        activeColor: "#999"             // Default: "#999"
                        inactiveColor: "dimgray"           // Default: "#ddd"


                        segmentedButtons: GridLayout {
                            columnSpacing: 2

                            SGSegmentedButton{
                                text: qsTr("3")
                                checked: true  // Sets default checked button when exclusive
                                onClicked: {
                                    platformInterface.demo_count_1 = true
                                    platformInterface.demo_count_2 = false
                                    platformInterface.demo_count_3 = false
                                    platformInterface.demo_count_4 = false
                                    platformInterface.demo_count_5 = false
                                    send_demo_state((segmentedButtons1.index+1),(segmentedButtons2.index+1),(segmentedButtons3.index+3),sgSlider1.value,(100-sgSlider2.value))
                                }
                            }

                            SGSegmentedButton{
                                text: qsTr("4")
                                onClicked: {
                                    platformInterface.demo_count_1 = false
                                    platformInterface.demo_count_2 = true
                                    platformInterface.demo_count_3 = false
                                    platformInterface.demo_count_4 = false
                                    platformInterface.demo_count_5 = false
                                    send_demo_state((segmentedButtons1.index+1),(segmentedButtons2.index+1),(segmentedButtons3.index+3),sgSlider1.value,(100-sgSlider2.value))
                                }
                            }

                            SGSegmentedButton{
                                text: qsTr("5")
                                onClicked: {
                                    platformInterface.demo_count_1 = false
                                    platformInterface.demo_count_2 = false
                                    platformInterface.demo_count_3 = true
                                    platformInterface.demo_count_4 = false
                                    platformInterface.demo_count_5 = false
                                    send_demo_state((segmentedButtons1.index+1),(segmentedButtons2.index+1),(segmentedButtons3.index+3),sgSlider1.value,(100-sgSlider2.value))
                                }
                            }

                            SGSegmentedButton{
                                text: qsTr("6")
                                onClicked: {
                                    platformInterface.demo_count_1 = false
                                    platformInterface.demo_count_2 = false
                                    platformInterface.demo_count_3 = false
                                    platformInterface.demo_count_4 = true
                                    platformInterface.demo_count_5 = false
                                    send_demo_state((segmentedButtons1.index+1),(segmentedButtons2.index+1),(segmentedButtons3.index+3),sgSlider1.value,(100-sgSlider2.value))
                                }
                            }

                            SGSegmentedButton{
                                text: qsTr("7")
                                onClicked: {
                                    platformInterface.demo_count_1 = false
                                    platformInterface.demo_count_2 = false
                                    platformInterface.demo_count_3 = false
                                    platformInterface.demo_count_4 = false
                                    platformInterface.demo_count_5 = true
                                    send_demo_state((segmentedButtons1.index+1),(segmentedButtons2.index+1),(segmentedButtons3.index+3),sgSlider1.value,(100-sgSlider2.value))
                                }
                            }
                        }
                    }
                }

                Rectangle {
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    color: "black"
                    SGSlideCustomize{
                        id:sgSlider1
                        anchors.centerIn: parent
                        label: "<b>Transition Time (mSec)</b>"          // Default: "" (if not entered, label will not appear)
                        textColor: "white"           // Default: "black"
                        labelLeft: false             // Default: true
                        Layout.fillHeight: true
                        width: parent.width/2
                        stepSize: 1                // Default: 1.0
                        value: 50                        // Default: average of from and to
                        from: 1                      // Default: 0.0
                        to: 100                    // Default: 100.0
                        startLabel: "1"              // Default: from
                        endLabel: "100"            // Default: to
                        showToolTip: false            // Default: true
                        toolTipDecimalPlaces: 0      // Default: 0
                        grooveColor: "#ddd"          // Default: "#dddddd"
                        grooveFillColor: "#C400FE"    // Default: "#888888"
                        live: false                  // Default: false (will only send valueChanged signal when slider is released)
                        labelTopAligned: false       // Default: false (only applies to label on left of slider, decides vertical centering of label)
                        inputBox: true               // Default: true

                        onSlider_valueChanged: {
                            send_demo_state((segmentedButtons1.index+1),(segmentedButtons2.index+1),(segmentedButtons3.index+3),sgSlider1.value,(100-sgSlider2.value))
                            // e.g. function send_demo_state(mode_state, led_num_state, time_state, intensity_state)
                            //                            delay(sgSlider1.value)
                        }
                    }
                }

                Rectangle {
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    color: "black"
                    SGSlideCustomize{
                        id:sgSlider2
                        anchors.centerIn: parent
                        label: "<b>Intensity (%)</b>"          // Default: "" (if not entered, label will not appear)
                        textColor: "white"           // Default: "black"
                        labelLeft: false             // Default: true
                        Layout.fillHeight: true
                        width: parent.width/2
                        stepSize: 1                // Default: 1.0
                        value: 50                  // Default: average of from and to
                        from: 0                      // Default: 0.0
                        to: 100                    // Default: 100.0
                        startLabel: "0"              // Default: from
                        endLabel: "100"            // Default: to
                        showToolTip: false            // Default: true
                        toolTipDecimalPlaces: 0      // Default: 0
                        grooveColor: "#ddd"          // Default: "#dddddd"
                        grooveFillColor: "#C400FE"// Default: "#888888"
                        live: false                  // Default: false (will only send valueChanged signal when slider is released)
                        labelTopAligned: false       // Default: false (only applies to label on left of slider, decides vertical centering of label)
                        inputBox: true               // Default: true

                        onSlider_valueChanged: {
                            send_demo_state((segmentedButtons1.index+1),(segmentedButtons2.index+1),(segmentedButtons3.index+3),sgSlider1.value,(100-sgSlider2.value))
                        }
                    }
                }

            }
        }


        Rectangle{
            id:rec2
            Layout.preferredWidth: parent.width/2.6
            Layout.preferredHeight: parent.height/1.5
            color: "transparent"
            //            color: "black"

            RowLayout{
                id: array1
                width: parent.width
                height:parent.height/6
                spacing: 2


                Text {
                    text: "Array-1"
                    font.pixelSize:15
                    color: "white"
                    Layout.alignment: Qt.AlignCenter
                }

                SGStatusLight{
                    id: sgStatusLight11
                    label: "<b>D1:</b>" // Default: "" (if not entered, label will not appear)
                    labelLeft: false        // Default: true
                    lightSize: 30        // Default: 50
                    textColor: "white"      // Default: "black"
                    Layout.alignment: Qt.AlignHCenter
                }

                SGStatusLight{
                    id: sgStatusLight12
                    label: "<b>D2:</b>" // Default: "" (if not entered, label will not appear)
                    labelLeft: false        // Default: true
                    lightSize: 30          // Default: 50
                    textColor: "white"      // Default: "black"
                    Layout.alignment: Qt.AlignHCenter
                }

                SGStatusLight{
                    id: sgStatusLight13
                    label: "<b>D3:</b>" // Default: "" (if not entered, label will not appear)
                    labelLeft: false        // Default: true
                    lightSize: 30          // Default: 50
                    textColor: "white"      // Default: "black"
                    Layout.alignment: Qt.AlignHCenter
                }

                SGStatusLight{
                    id: sgStatusLight14
                    label: "<b>D4:</b>" // Default: "" (if not entered, label will not appear)
                    labelLeft: false        // Default: true
                    lightSize: 30          // Default: 50
                    textColor: "white"      // Default: "black"
                    Layout.alignment: Qt.AlignHCenter
                }

                SGStatusLight{
                    id: sgStatusLight15
                    label: "<b>D5:</b>" // Default: "" (if not entered, label will not appear)
                    labelLeft: false        // Default: true
                    lightSize: 30          // Default: 50
                    textColor: "white"      // Default: "black"
                    Layout.alignment: Qt.AlignHCenter
                }

                SGStatusLight{
                    id: sgStatusLight16
                    label: "<b>D6:</b>" // Default: "" (if not entered, label will not appear)
                    labelLeft: false        // Default: true
                    lightSize: 30          // Default: 50
                    textColor: "white"      // Default: "black"
                    Layout.alignment: Qt.AlignHCenter
                }

                SGStatusLight{
                    id: sgStatusLight17
                    label: "<b>D7:</b>" // Default: "" (if not entered, label will not appear)
                    labelLeft: false        // Default: true
                    lightSize: 30          // Default: 50
                    textColor: "white"      // Default: "black"
                    Layout.alignment: Qt.AlignHCenter
                }

                SGStatusLight{
                    id: sgStatusLight18
                    label: "<b>D8:</b>" // Default: "" (if not entered, label will not appear)
                    labelLeft: false        // Default: true
                    lightSize: 30          // Default: 50
                    textColor: "white"      // Default: "black"
                    Layout.alignment: Qt.AlignHCenter
                }

                SGStatusLight{
                    id: sgStatusLight19
                    label: "<b>D9:</b>" // Default: "" (if not entered, label will not appear)
                    labelLeft: false        // Default: true
                    lightSize: 30          // Default: 50
                    textColor: "white"      // Default: "black"
                    Layout.alignment: Qt.AlignHCenter
                }

                SGStatusLight{
                    id: sgStatusLight1A
                    label: "<b>D10:</b>" // Default: "" (if not entered, label will not appear)
                    labelLeft: false        // Default: true
                    lightSize: 30          // Default: 50
                    textColor: "white"      // Default: "black"
                    Layout.alignment: Qt.AlignHCenter
                }

                SGStatusLight{
                    id: sgStatusLight1B
                    label: "<b>D11:</b>" // Default: "" (if not entered, label will not appear)
                    labelLeft: false        // Default: true
                    lightSize: 30          // Default: 50
                    textColor: "white"      // Default: "black"
                    Layout.alignment: Qt.AlignHCenter
                }

                SGStatusLight{
                    id: sgStatusLight1C
                    label: "<b>D12:</b>" // Default: "" (if not entered, label will not appear)
                    labelLeft: false        // Default: true
                    lightSize: 30          // Default: 50
                    textColor: "white"      // Default: "black"
                    Layout.alignment: Qt.AlignHCenter
                }
            }

            RowLayout{
                id: array2
                width: parent.width
                height:parent.height/6
                spacing: 2


                anchors.top: array1.bottom

                Text {
                    text: "Array-2"
                    font.pixelSize:15
                    color: "white"
                    Layout.alignment: Qt.AlignCenter
                }

                SGStatusLight{
                    id: sgStatusLight21
                    label: "<b>D1:</b>" // Default: "" (if not entered, label will not appear)
                    labelLeft: false        // Default: true
                    lightSize: 30        // Default: 50
                    textColor: "white"      // Default: "black"
                    Layout.alignment: Qt.AlignHCenter
                }

                SGStatusLight{
                    id: sgStatusLight22
                    label: "<b>D2:</b>" // Default: "" (if not entered, label will not appear)
                    labelLeft: false        // Default: true
                    lightSize: 30          // Default: 50
                    textColor: "white"      // Default: "black"
                    Layout.alignment: Qt.AlignHCenter
                }

                SGStatusLight{
                    id: sgStatusLight23
                    label: "<b>D3:</b>" // Default: "" (if not entered, label will not appear)
                    labelLeft: false        // Default: true
                    lightSize: 30          // Default: 50
                    textColor: "white"      // Default: "black"
                    Layout.alignment: Qt.AlignHCenter
                }

                SGStatusLight{
                    id: sgStatusLight24
                    label: "<b>D4:</b>" // Default: "" (if not entered, label will not appear)
                    labelLeft: false        // Default: true
                    lightSize: 30          // Default: 50
                    textColor: "white"      // Default: "black"
                    Layout.alignment: Qt.AlignHCenter
                }

                SGStatusLight{
                    id: sgStatusLight25
                    label: "<b>D5:</b>" // Default: "" (if not entered, label will not appear)
                    labelLeft: false        // Default: true
                    lightSize: 30          // Default: 50
                    textColor: "white"      // Default: "black"
                    Layout.alignment: Qt.AlignHCenter
                }

                SGStatusLight{
                    id: sgStatusLight26
                    label: "<b>D6:</b>" // Default: "" (if not entered, label will not appear)
                    labelLeft: false        // Default: true
                    lightSize: 30          // Default: 50
                    textColor: "white"      // Default: "black"
                    Layout.alignment: Qt.AlignHCenter
                }

                SGStatusLight{
                    id: sgStatusLight27
                    label: "<b>D7:</b>" // Default: "" (if not entered, label will not appear)
                    labelLeft: false        // Default: true
                    lightSize: 30          // Default: 50
                    textColor: "white"      // Default: "black"
                    Layout.alignment: Qt.AlignHCenter
                }

                SGStatusLight{
                    id: sgStatusLight28
                    label: "<b>D8:</b>" // Default: "" (if not entered, label will not appear)
                    labelLeft: false        // Default: true
                    lightSize: 30          // Default: 50
                    textColor: "white"      // Default: "black"
                    Layout.alignment: Qt.AlignHCenter
                }

                SGStatusLight{
                    id: sgStatusLight29
                    label: "<b>D9:</b>" // Default: "" (if not entered, label will not appear)
                    labelLeft: false        // Default: true
                    lightSize: 30          // Default: 50
                    textColor: "white"      // Default: "black"
                    Layout.alignment: Qt.AlignHCenter
                }

                SGStatusLight{
                    id: sgStatusLight2A
                    label: "<b>10:</b>" // Default: "" (if not entered, label will not appear)
                    labelLeft: false        // Default: true
                    lightSize: 30          // Default: 50
                    textColor: "white"      // Default: "black"
                    Layout.alignment: Qt.AlignHCenter
                }

                SGStatusLight{
                    id: sgStatusLight2B
                    label: "<b>D11:</b>" // Default: "" (if not entered, label will not appear)
                    labelLeft: false        // Default: true
                    lightSize: 30          // Default: 50
                    textColor: "white"      // Default: "black"
                    Layout.alignment: Qt.AlignHCenter
                }

                SGStatusLight{
                    id: sgStatusLight2C
                    label: "<b>D12:</b>" // Default: "" (if not entered, label will not appear)
                    labelLeft: false        // Default: true
                    lightSize: 30          // Default: 50
                    textColor: "white"      // Default: "black"
                    Layout.alignment: Qt.AlignHCenter
                }
            }

            RowLayout{
                id: array3
                width: parent.width
                height:parent.height/6
                spacing: 2

                anchors.top: array2.bottom

                Text {
                    text: "Array-3"
                    font.pixelSize:15
                    color: "white"
                    Layout.alignment: Qt.AlignCenter
                }

                SGStatusLight{
                    id: sgStatusLight31
                    label: "<b>D1:</b>" // Default: "" (if not entered, label will not appear)
                    labelLeft: false        // Default: true
                    lightSize: 30        // Default: 50
                    textColor: "white"      // Default: "black"
                    Layout.alignment: Qt.AlignHCenter
                }

                SGStatusLight{
                    id: sgStatusLight32
                    label: "<b>D2:</b>" // Default: "" (if not entered, label will not appear)
                    labelLeft: false        // Default: true
                    lightSize: 30          // Default: 50
                    textColor: "white"      // Default: "black"
                    Layout.alignment: Qt.AlignHCenter
                }

                SGStatusLight{
                    id: sgStatusLight33
                    label: "<b>D3:</b>" // Default: "" (if not entered, label will not appear)
                    labelLeft: false        // Default: true
                    lightSize: 30          // Default: 50
                    textColor: "white"      // Default: "black"
                    Layout.alignment: Qt.AlignHCenter
                }

                SGStatusLight{
                    id: sgStatusLight34
                    label: "<b>D4:</b>" // Default: "" (if not entered, label will not appear)
                    labelLeft: false        // Default: true
                    lightSize: 30          // Default: 50
                    textColor: "white"      // Default: "black"
                    Layout.alignment: Qt.AlignHCenter
                }

                SGStatusLight{
                    id: sgStatusLight35
                    label: "<b>D5:</b>" // Default: "" (if not entered, label will not appear)
                    labelLeft: false        // Default: true
                    lightSize: 30          // Default: 50
                    textColor: "white"      // Default: "black"
                    Layout.alignment: Qt.AlignHCenter
                }

                SGStatusLight{
                    id: sgStatusLight36
                    label: "<b>D6:</b>" // Default: "" (if not entered, label will not appear)
                    labelLeft: false        // Default: true
                    lightSize: 30          // Default: 50
                    textColor: "white"      // Default: "black"
                    Layout.alignment: Qt.AlignHCenter
                }

                SGStatusLight{
                    id: sgStatusLight37
                    label: "<b>D7:</b>" // Default: "" (if not entered, label will not appear)
                    labelLeft: false        // Default: true
                    lightSize: 30          // Default: 50
                    textColor: "white"      // Default: "black"
                    Layout.alignment: Qt.AlignHCenter
                }

                SGStatusLight{
                    id: sgStatusLight38
                    label: "<b>D8:</b>" // Default: "" (if not entered, label will not appear)
                    labelLeft: false        // Default: true
                    lightSize: 30          // Default: 50
                    textColor: "white"      // Default: "black"
                    Layout.alignment: Qt.AlignHCenter
                }

                SGStatusLight{
                    id: sgStatusLight39
                    label: "<b>D9:</b>" // Default: "" (if not entered, label will not appear)
                    labelLeft: false        // Default: true
                    lightSize: 30          // Default: 50
                    textColor: "white"      // Default: "black"
                    Layout.alignment: Qt.AlignHCenter
                }

                SGStatusLight{
                    id: sgStatusLight3A
                    label: "<b>D10:</b>" // Default: "" (if not entered, label will not appear)
                    labelLeft: false        // Default: true
                    lightSize: 30          // Default: 50
                    textColor: "white"      // Default: "black"
                    Layout.alignment: Qt.AlignHCenter
                }

                SGStatusLight{
                    id: sgStatusLight3B
                    label: "<b>D11:</b>" // Default: "" (if not entered, label will not appear)
                    labelLeft: false        // Default: true
                    lightSize: 30          // Default: 50
                    textColor: "white"      // Default: "black"
                    Layout.alignment: Qt.AlignHCenter
                }

                SGStatusLight{
                    id: sgStatusLight3C
                    label: "<b>D12:</b>" // Default: "" (if not entered, label will not appear)
                    labelLeft: false        // Default: true
                    lightSize: 30          // Default: 50
                    textColor: "white"      // Default: "black"
                    Layout.alignment: Qt.AlignHCenter
                }
            }

            RowLayout{
                id: array4
                width: parent.width
                height:parent.height/4
                spacing: 2

                anchors.top: array3.bottom

                Rectangle {
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    color: "black"
                    SGSlideCustomize{
                        id:sgSlider3
                        anchors.centerIn: parent
                        label: "<b>ALL LED Intensity Control</b>"          // Default: "" (if not entered, label will not appear)
                        textColor: "white"           // Default: "black"
                        labelLeft: false             // Default: true
                        Layout.fillHeight: true
                        width: parent.width/2
                        stepSize: 0.1                // Default: 1.0
                        value: 50                        // Default: average of from and to
                        from: 0                      // Default: 0.0
                        to: 100                    // Default: 100.0
                        startLabel: "0"              // Default: from
                        endLabel: "100"            // Default: to
                        showToolTip: false            // Default: true
                        toolTipDecimalPlaces: 0      // Default: 0
                        grooveColor: "#ddd"          // Default: "#dddddd"
                        grooveFillColor: "#00FF40"    // Default: "#888888"
                        live: false                  // Default: false (will only send valueChanged signal when slider is released)
                        labelTopAligned: false       // Default: false (only applies to label on left of slider, decides vertical centering of label)
                        inputBox: true               // Default: true

                        onSlider_valueChanged: {
                            set_all_led_state(sgSlider3.value)
                        }
                    }
                }
            }

            RowLayout{
                id: array5
                width: parent.width
                height:parent.height/4
                spacing: 2

                anchors.top: array4.bottom

                Rectangle {
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    color: "black"
                    SGSlideCustomize{
                        id:sgSlider4
                        anchors.centerIn: parent
                        label: "<b>Curtain Control</b>"          // Default: "" (if not entered, label will not appear)
                        textColor: "white"           // Default: "black"
                        labelLeft: false             // Default: true
                        Layout.fillHeight: true
                        width: parent.width/2
                        stepSize: 0.1                // Default: 1.0
                        value: 0                        // Default: average of from and to
                        from: 1                      // Default: 0.0
                        to: 12                    // Default: 100.0
                        startLabel: "Left"              // Default: from
                        endLabel: "Right"            // Default: to
                        showToolTip: false            // Default: true
                        toolTipDecimalPlaces: 0      // Default: 0
                        grooveColor: "#ddd"          // Default: "#dddddd"
                        grooveFillColor: "#00FF40"    // Default: "#888888"
                        live: false                  // Default: false (will only send valueChanged signal when slider is released)
                        labelTopAligned: false       // Default: false (only applies to label on left of slider, decides vertical centering of label)
                        inputBox: false               // Default: true

                        onSlider_valueChanged: {
                            set_led_bar_state(sgSlider4.value)
                        }
                    }
                }
            }
        }
    }
}
