import QtQuick 2.9
import QtQuick.Controls 2.2
import QtQuick.Window 2.3
import "qrc:/js/core_platform_interface.js" as CorePlatformInterface

Item {
    id: platformInterface

    // -------------------------------------------------------------------
    // UI Control States
    //
    // EXAMPLE:
    //    1) Create control state:
    //          property bool _motor_running_control: false
    //
    //    2) Control in UI is bound to _motor_running_control so it will follow
    //       the state, but can also set it. Like so:
    //          checked: platformInterface._motor_running_control
    //          onCheckedChanged: platformInterface._motor_running_control = checked
    //
    //    3) This state can optionally be sent as a command when controls set it:
    //          on_Motor_running_controlChanged: {
    //              motor_running_command.update(_motor_running_control)
    //          }
    //
    //  Can also synchronize control state across multiple UI views;
    //  just bind all controls to this state as in #2 above.
    //
    //  ** All internal property names for PlatformInterface must avoid name
    //  ** collisions with notification/cmd message properties.
    //  **    Use Naming Convention: 'property var _name'

    // @control_state: _motor_running_control
    // @description: set by notification and UI control sends command
    //
    property bool _motor_running_control: false
    on_Motor_running_controlChanged: {
        motor_running_command.update(_motor_running_control)
    }

    // @control_state: _motor_speed
    // @description: set by notification (read-only; control does not send command)
    //
    property real _motor_speed: 0



    // -------------------------------------------------------------------
    // Incoming Notification Messages
    //
    // Define and document incoming notification messages here.
    //
    // The property name *must* match the associated notification value.
    // Sets UI Control State when changed.

    // @notification: motor_running_notification
    // @description: update motor running status
    //
    property var motor_running_notification : {
        "running": false
    }
    onMotor_running_notificationChanged: {
        _motor_running_control = motor_running_notification.running
    }

    // @notification: motor_speed_notification
    // @description: update motor speed
    //
    property var motor_speed_notification : {
        "speed": 0
    }
    onMotor_speed_notificationChanged: {
        _motor_speed = motor_speed_notification.speed
    }



    // -------------------------------------------------------------------
    // Outgoing Commands
    //
    // Define and document platform commands here.
    //
    // Built-in functions:
    //   update(): sets properties and sends command in one call
    //   set():    can set single or multiple properties before sending to platform
    //   send():   sends current command
    //   show():   console logs current command and properties

    // @command: motor_running_command
    // @description: sends motor running command to platform
    //
    property var set_enable_1: ({
                                    "cmd" : "set_enable_1",
                                    "payload": {
                                        "enable": " ",
                                    },

                                    // Update will set and send in one shot
                                    update: function (enable) {
                                        this.set(enable)
                                        CorePlatformInterface.send(this)
                                    },
                                    // Set can set single or multiple properties before sending to platform
                                    set: function (enable) {
                                        this.payload.enable = enable;
                                    },

                                    send: function () { CorePlatformInterface.send(this) },
                                    show: function () { CorePlatformInterface.show(this) }

                                })

    property var set_enable_2: ({
                                    "cmd" : "set_enable_2",
                                    "payload": {
                                        "enable": " ",
                                    },

                                    // Update will set and send in one shot
                                    update: function (enable) {
                                        this.set(enable)
                                        CorePlatformInterface.send(this)
                                    },
                                    // Set can set single or multiple properties before sending to platform
                                    set: function (enable) {
                                        this.payload.enable = enable;
                                    },

                                    send: function () { CorePlatformInterface.send(this) },
                                    show: function () { CorePlatformInterface.show(this) }

                                })

    property var set_SR_1: ({
                                "cmd" : "set_SR_1",
                                "payload": {
                                    "slew_rate": "slow",
                                },

                                // Update will set and send in one shot
                                update: function (slew_rate) {
                                    this.set(slew_rate)
                                    CorePlatformInterface.send(this)
                                },
                                // Set can set single or multiple properties before sending to platform
                                set: function (slew_rate) {
                                    this.payload.slew_rate = slew_rate;
                                },

                                send: function () { CorePlatformInterface.send(this) },
                                show: function () { CorePlatformInterface.show(this) }

                            })

    property var set_SR_2: ({
                                "cmd" : "set_SR_2",
                                "payload": {
                                    "slew_rate": "slow",
                                },

                                // Update will set and send in one shot
                                update: function (slew_rate) {
                                    this.set(slew_rate)
                                    CorePlatformInterface.send(this)
                                },
                                // Set can set single or multiple properties before sending to platform
                                set: function (slew_rate) {
                                    this.payload.slew_rate = slew_rate;
                                },

                                send: function () { CorePlatformInterface.send(this) },
                                show: function () { CorePlatformInterface.show(this) }

                            })

    property var set_ilim_1: ({
                                  "cmd" : "set_ilim_1",
                                  "payload": {
                                      "ilim": "55",
                                  },

                                  // Update will set and send in one shot
                                  update: function (ilim) {
                                      this.set(ilim)
                                      CorePlatformInterface.send(this)
                                  },
                                  // Set can set single or multiple properties before sending to platform
                                  set: function (ilim) {
                                      this.payload.ilim = ilim;
                                  },

                                  send: function () { CorePlatformInterface.send(this) },
                                  show: function () { CorePlatformInterface.show(this) }

                              })

    property var set_ilim_2: ({
                                  "cmd" : "set_ilim_2",
                                  "payload": {
                                      "ilim": "55",
                                  },

                                  // Update will set and send in one shot
                                  update: function (ilim) {
                                      this.set(ilim)
                                      CorePlatformInterface.send(this)
                                  },
                                  // Set can set single or multiple properties before sending to platform
                                  set: function (ilim) {
                                      this.payload.ilim = ilim;
                                  },

                                  send: function () { CorePlatformInterface.send(this) },
                                  show: function () { CorePlatformInterface.show(this) }

                              })

    property var sc_on: ({ "cmd" : "sc_on",
                             update: function () {
                                 CorePlatformInterface.send(this)
                             },
                             send: function () { CorePlatformInterface.send(this) },
                             show: function () { CorePlatformInterface.show(this) }

                         })

    // -------------------------------------------------------------------
    // Listens to message notifications coming from CoreInterface.cpp
    // Forward messages to core_platform_interface.js to process

    Connections {
        target: coreInterface
        onNotification: {
            CorePlatformInterface.data_source_handler(payload)
        }
    }
}
