import QtQuick 2.9
import QtQuick.Controls 2.2
import QtQuick.Window 2.3
import "qrc:/js/core_platform_interface.js" as CorePlatformInterface


Item {
    id: platformInterface

    // -------------------
    // Notification Messages
    //
    // define and document incoming notification messages
    //  the properties of the message must match with the UI elements using them
    //  document all messages to clearly indicate to the UI layer proper names

    // @notification get_sensor_type
    // @description: read values
    //


    //------New notification implemented of Temp and commands
    property var set_temp_pwm_remote:({
                                          "cmd" : "temp_pwm_remote",
                                          "payload": {
                                              "value": "80"
                                          },
                                          update: function (value) {
                                              this.set(value)
                                              CorePlatformInterface.send(this)
                                          },
                                          set: function (value) {
                                              this.payload.value = value;
                                          },
                                          send: function () { CorePlatformInterface.send(this) },
                                          show: function () { CorePlatformInterface.show(this) }
                                      })

    property var one_shot: ({
                                "cmd":"temp_one_shot",
                                update: function () {
                                    CorePlatformInterface.send(this)
                                },
                                send: function () { CorePlatformInterface.send(this) },
                                show: function () { CorePlatformInterface.show(this) }
                            })

    property var set_mode_value:({
                                     "cmd" : "temp_mode",
                                     "payload": {
                                         "value": "Run"
                                     },
                                     update: function (value) {
                                         this.set(value)
                                         CorePlatformInterface.send(this)
                                     },
                                     set: function (value) {
                                         this.payload.value = value;
                                     },
                                     send: function () { CorePlatformInterface.send(this) },
                                     show: function () { CorePlatformInterface.show(this) }
                                 })


    property var set_temp_alert:({
                                     "cmd" : "temp_alert",
                                     "payload": {
                                         "value": "Enabled"
                                     },
                                     update: function (value) {
                                         this.set(value)
                                         CorePlatformInterface.send(this)
                                     },
                                     set: function (value) {
                                         this.payload.value = value;
                                     },
                                     send: function () { CorePlatformInterface.send(this) },
                                     show: function () { CorePlatformInterface.show(this) }
                                 })

    property var set_alert_therm2_pin6:({
                                            "cmd" : "temp_pin6",
                                            "payload": {
                                                "value": "THERM2#"
                                            },
                                            update: function (value) {
                                                this.set(value)
                                                CorePlatformInterface.send(this)
                                            },
                                            set: function (value) {
                                                this.payload.value = value;
                                            },
                                            send: function () { CorePlatformInterface.send(this) },
                                            show: function () { CorePlatformInterface.show(this) }
                                        })

    property var set_range_value:({
                                      "cmd" : "temp_range",
                                      "payload": {
                                          "value": "0_127"
                                      },
                                      update: function (value) {
                                          this.set(value)
                                          CorePlatformInterface.send(this)
                                      },
                                      set: function (value) {
                                          this.payload.value = value;
                                      },
                                      send: function () { CorePlatformInterface.send(this) },
                                      show: function () { CorePlatformInterface.show(this) }
                                  })


    property var set_temp_cons_alert: ({
                                           "cmd":"temp_cons_alert",
                                           "payload": {
                                               "value":"2"
                                           },
                                           update: function (value) {
                                               this.set(value)
                                               CorePlatformInterface.send(this)
                                           },
                                           set: function (value) {
                                               this.payload.value = value;
                                           },
                                           show: function () { CorePlatformInterface.show(this) }
                                       })

    property var set_temp_conv_rate:({
                                         "cmd" : "temp_conv_rate",
                                         "payload": {
                                             "value":"62.5 ms"
                                         },
                                         update: function (value) {
                                             this.set(value)
                                             CorePlatformInterface.send(this)
                                         },
                                         set: function (value) {
                                             this.payload.value = value;
                                         },
                                         send: function () { CorePlatformInterface.send(this) },
                                         show: function () { CorePlatformInterface.show(this) }
                                     })

    property var set_therm_hyst_value: ({
                                            "cmd":"temp_therm_hyst",
                                            "payload": {
                                                "value":"5"
                                            },
                                            update: function (value) {
                                                this.set(value)
                                                CorePlatformInterface.send(this)
                                            },
                                            set: function (value) {
                                                this.payload.value = value;
                                            },
                                            show: function () { CorePlatformInterface.show(this) }
                                        })

    property var set_pwm_temp_local_value:({
                                               "cmd" : "temp_pwm_local",
                                               "payload": {
                                                   "value": "80"
                                               },
                                               update: function (value) {
                                                   this.set(value)
                                                   CorePlatformInterface.send(this)
                                               },
                                               set: function (value) {
                                                   this.payload.value = value;
                                               },
                                               send: function () { CorePlatformInterface.send(this) },
                                               show: function () { CorePlatformInterface.show(this) }
                                           })

    property var set_temp_remote_low_lim:({
                                              "cmd" : "temp_remote_low_lim",
                                              "payload": {
                                                  "value":"-55"
                                              },
                                              update: function (value) {
                                                  this.set(value)
                                                  CorePlatformInterface.send(this)
                                              },
                                              set: function (value) {
                                                  this.payload.value = value;
                                              },
                                              send: function () { CorePlatformInterface.send(this) },
                                              show: function () { CorePlatformInterface.show(this) }
                                          })

    property var set_temp_remote_low_lim_frac:({
                                                   "cmd" : "temp_remote_low_lim_frac",
                                                   "payload": {
                                                       "value":"0.25"
                                                   },
                                                   update: function (value) {
                                                       this.set(value)
                                                       CorePlatformInterface.send(this)
                                                   },
                                                   set: function (value) {
                                                       this.payload.value = value;
                                                   },
                                                   send: function () { CorePlatformInterface.send(this) },
                                                   show: function () { CorePlatformInterface.show(this) }
                                               })

    //New Remote high limit
    property var set_temp_remote_high_lim:({
                                               "cmd" : "temp_remote_high_lim",
                                               "payload": {
                                                   "value":"100"
                                               },
                                               update: function (value) {
                                                   this.set(value)
                                                   CorePlatformInterface.send(this)
                                               },
                                               set: function (value) {
                                                   this.payload.value = value;
                                               },
                                               send: function () { CorePlatformInterface.send(this) },
                                               show: function () { CorePlatformInterface.show(this) }
                                           })

    property var set_temp_remote_high_lim_frac:({
                                                    "cmd" : "temp_remote_high_lim_frac",
                                                    "payload": {
                                                        "value":"0.25"
                                                    },
                                                    update: function (value) {
                                                        this.set(value)
                                                        CorePlatformInterface.send(this)
                                                    },
                                                    set: function (value) {
                                                        this.payload.value = value;
                                                    },
                                                    send: function () { CorePlatformInterface.send(this) },
                                                    show: function () { CorePlatformInterface.show(this) }
                                                })

    property var set_temp_remote_offset: ({
                                              "cmd":"temp_remote_offset",
                                              "payload": {
                                                  "value":"-10"
                                              },
                                              update: function (value) {
                                                  this.set(value)
                                                  CorePlatformInterface.send(this)
                                              },
                                              set: function (value) {
                                                  this.payload.value = value;
                                              },
                                              show: function () { CorePlatformInterface.show(this) }
                                          })

    property var set_temp_remote_offset_frac: ({
                                                   "cmd":"temp_remote_offset_frac",
                                                   "payload": {
                                                       "value":"0.25"
                                                   },
                                                   update: function (value) {
                                                       this.set(value)
                                                       CorePlatformInterface.send(this)
                                                   },
                                                   set: function (value) {
                                                       this.payload.value = value;
                                                   },
                                                   show: function () { CorePlatformInterface.show(this) }
                                               })


    property var set_temp_remote_therm_lim: ({
                                                 "cmd":"temp_remote_therm_lim",
                                                 "payload": {
                                                     "value":"50"
                                                 },
                                                 update: function (value) {
                                                     this.set(value)
                                                     CorePlatformInterface.send(this)
                                                 },
                                                 set: function (value) {
                                                     this.payload.value = value;
                                                 },
                                                 show: function () { CorePlatformInterface.show(this) }
                                             })

    property var set_temp_local_low_lim:({
                                             "cmd" : "temp_local_low_lim",
                                             "payload": {
                                                 "value":"-55"
                                             },
                                             update: function (value) {
                                                 this.set(value)
                                                 CorePlatformInterface.send(this)
                                             },
                                             set: function (value) {
                                                 this.payload.value = value;
                                             },
                                             send: function () { CorePlatformInterface.send(this) },
                                             show: function () { CorePlatformInterface.show(this) }
                                         })

    property var set_temp_local_high_lim:({
                                              "cmd" : "temp_local_high_lim",
                                              "payload": {
                                                  "value":"95"
                                              },
                                              update: function (value) {
                                                  this.set(value)
                                                  CorePlatformInterface.send(this)
                                              },
                                              set: function (value) {
                                                  this.payload.value = value;
                                              },
                                              send: function () { CorePlatformInterface.send(this) },
                                              show: function () { CorePlatformInterface.show(this) }
                                          })

    property var set_temp_local_therm_lim: ({
                                                "cmd":"temp_local_therm_lim",
                                                "payload": {
                                                    "value":"40"
                                                },
                                                update: function (value) {
                                                    this.set(value)
                                                    CorePlatformInterface.send(this)
                                                },
                                                set: function (value) {
                                                    this.payload.value = value;
                                                },
                                                show: function () { CorePlatformInterface.show(this) }
                                            })



    property var temp_remote: {
        "caption":"Remote Temp",
        "value":"0",
        "state":"disabled",
        "values":[],
        "scales":["200","-70","0.25"]
    }

    property var temp_remote_value: {
        "value":"0"
    }

    property var temp_remote_caption: {
        "caption":"Remote Temp"
    }

    property var temp_remote_state: {
        "state":"disabled"
    }

    property var temp_remote_scales: {
        "scales":["200","-70","0.25"]
    }

    property var temp_pwm_remote: {
        "caption":"PWM Positive Duty Cycle (%)",
        "value":"40",
        "state":"enabled",
        "values":["0","10","20","30","40","50","60","70","80","90","100"],
        "scales":[]
    }

    property var temp_pwm_remote_caption: {
        "caption":"PWM Positive Duty Cycle (%)"
    }

    property var temp_pwm_remote_value: {
        "value":"40"
    }

    property var temp_pwm_remote_state: {
        "state":"enabled"
    }

    property var temp_pwm_remote_values: {
        "values":["0","10","20","30","40","50","60","70","80","90","100"]
    }



    property var temp_one_shot: {
        "caption":"One-shot",
        "value":"",
        "state":"disabled_and_grayed_out",
        "values":[],
        "scales":[]
    }

    property var temp_one_shot_caption: {
        "caption":"One-shot"
    }


    property var temp_one_shot_state: {
        "state":"disabled_and_grayed_out"
    }

    property var temp_busy: {
        "caption":"BUSY",
        "value":"0",
        "state":"disabled",
        "values":[],
        "scales":[]
    }

    property var temp_busy_caption: {
        "caption":"BUSY"
    }

    property var temp_busy_value: {
        "value":"0"
    }

    property var temp_busy_state: {
        "state":"disabled"
    }



    property var temp_therm: {
        "caption":"THERM",
        "value":"0",
        "state":"disabled",
        "values":[],
        "scales":[]
    }

    property var temp_therm_caption: {
        "caption":"THERM"
    }

    property var temp_therm_value: {
        "value":"0"
    }

    property var temp_therm_state: {
        "state":"disabled"
    }



    property var temp_alert_therm2: {
        "caption":"ALERT",
        "value":"0",
        "state":"disabled",
        "values":["ALERT","THERM2"],
        "scales":[]
    }


    property var temp_alert_therm2_caption: {
        "caption":"ALERT"
    }

    property var temp_alert_therm2_value: {
        "value":"0"
    }

    property var temp_alert_therm2_state: {
        "state":"enabled"
    }

    property var temp_mode: {
        "caption":"Mode",
        "value":"Run",
        "state":"enabled",
        "values":["Run","Standby"],
        "scales":[]
    }

    property var temp_mode_caption: {
        "caption":"Mode"
    }

    property var temp_mode_value: {
        "value":"Run"
    }

    property var temp_mode_state: {
        "state":"enabled"
    }

    property var temp_alert: {
        "caption":"Alert",
        "value":"Enabled",
        "state":"enabled",
        "values":["Enabled","Masked"],
        "scales":[]
    }

    property var temp_alert_caption: {
        "caption":"Alert"
    }

    property var temp_alert_value: {
        "value":"Enabled"
    }

    property var temp_alert_state: {
        "state":"enabled"
    }

    property var temp_pin6: {
        "caption":"Pin 6",
        "value":"ALERT#",
        "state":"enabled",
        "values":["ALERT#","THERM2#"],
        "scales":[]
    }


    property var temp_pin6_caption: {
        "caption":"Pin 6"
    }

    property var temp_pin6_value: {
        "value":"ALERT#"
    }

    property var temp_pin6_state: {
        "state":"enabled"
    }

    property var temp_range: {
        "caption":"Range",
        "value":"0_127",
        "state":"enabled",
        "values":[],
        "scales":[]
    }

    property var temp_range_caption: {
        "caption":"Range"
    }

    property var temp_range_value: {
        "value":"0_127"
    }

    property var temp_range_state: {
        "state":"enabled"
    }

    property var temp_cons_alert: {
        "caption":"Consecutive ALERTs",
        "value":"1",
        "state":"enabled",
        "values":["1","2","3","4"],
        "scales":[]
    }

    property var temp_cons_alert_caption: {
        "caption":"Consecutive ALERTs"
    }

    property var temp_cons_alert_value: {
        "value":"1"
    }

    property var temp_cons_alert_state: {
        "state":"enabled"
    }

    property var temp_cons_alert_values: {
        "values":["1","2","3","4"]
    }


    property var temp_conv_rate: {
        "caption":"Conversion Rate",
        "value":"62.5 ms",
        "state":"enabled",
        "values":["16 s","8 s","4 s","2 s","1 s","500 ms","250 ms","125 ms","62.5 ms","31.25 ms","15.5 ms"],
        "scales":[]
    }


    property var temp_conv_rate_caption: {
        "caption":"Conversion Rate"
    }

    property var temp_conv_rate_value: {
        "value":"62.5 ms"
    }

    property var temp_conv_rate_state: {
        "state":"enabled"
    }

    property var temp_conv_rate_values: {
        "values":["16 s","8 s","4 s","2 s","1 s","500 ms","250 ms","125 ms","62.5 ms","31.25 ms","15.5 ms"]
    }

    property var temp_man_id: {
        "caption":"Manufacturer ID",
        "value":"0x41",
        "state":"disabled",
        "values":[],
        "scales":[]
    }

    property var temp_man_id_caption: {
        "caption":"Manufacturer ID"
    }

    property var temp_man_id_value: {
        "value":"0x41"
    }

    property var temp_man_id_state: {
        "state":"disabled"
    }

    property var temp_therm_hyst: {
        "caption":"THERM Hysteresis",
        "value":"10",
        "state":"enabled",
        "values":[],
        "scales":["255","0","1"]
    }

    property var temp_therm_hyst_caption: {
        "caption":"THERM Hysteresis"
    }

    property var temp_therm_hyst_value: {
        "value":"10"
    }

    property var temp_therm_hyst_state: {
        "state":"enabled"
    }

    property var temp_therm_hyst_scales: {
        "scales":["255","0","1"]
    }


    property var temp_local: {
        "caption":"Local Temp",
        "value":"0",
        "state":"disabled",
        "values":[],
        "scales":["200","-70","0.25"]
    }

    property var temp_local_value: {
        "value":"0"
    }

    property var temp_local_caption: {
        "caption":"Local Temp"
    }

    property var temp_local_state: {
        "state":"disabled"
    }

    property var temp_local_scales: {
        "scales":["200","-70","0.25"]
    }

    property var temp_pwm_local: {
        "caption":"PWM Positive Duty Cycle (%)",
        "value":"40",
        "state":"enabled",
        "values":["0","10","20","30","40","50","60","70","80","90","100"],
        "scales":[]
    }

    property var temp_pwm_local_caption: {
        "caption":"PWM Positive Duty Cycle (%)"
    }

    property var temp_pwm_local_value: {
        "value":"40"
    }

    property var temp_pwm_local_state: {
        "state":"enabled"
    }

    property var temp_pwm_local_values: {
        "values":["0","10","20","30","40","50","60","70","80","90","100"]
    }

    property var temp_rthrm: {
        "caption":"THERM",
        "value":"0",
        "state":"disabled",
        "values":[],
        "scales":[]
    }


    property var temp_rthrm_caption: {
        "caption":"THERM"
    }

    property var temp_rthrm_value: {
        "value":"0"
    }

    property var temp_rthrml_state: {
        "state":"disabled"
    }

    property var temp_rlow: {
        "caption":"RLOW",
        "value":"0",
        "state":"disabled",
        "values":[],
        "scales":[]
    }

    property var temp_rlow_caption: {
        "caption":"RLOW"
    }

    property var temp_rlow_value: {
        "value":"0"
    }

    property var temp_rlow_state: {
        "state":"disabled"
    }


    property var temp_rhigh: {
        "caption":"RHIGH",
        "value":"0",
        "state":"disabled",
        "values":[],
        "scales":[0.00,0.00,0.00]
    }

    property var temp_rhigh_caption: {
        "caption":"RHIGH"
    }

    property var temp_rhigh_value: {
        "value":"0"
    }

    property var temp_rhigh_state: {
        "state":"disabled"
    }

    property var temp_open: {
        "caption":"OPEN",
        "value":"0",
        "state":"disabled",
        "values":[],
        "scales":[]
    }

    property var temp_open_caption: {
        "caption":"OPEN"
    }

    property var temp_open_value: {
        "value":"0"
    }

    property var temp_open_state: {
        "state":"disabled"
    }

    property var temp_remote_low_lim: {
        "caption":"Remote Low Limit",
        "value":"0",
        "state":"enabled",
        "values":[],
        "scales":["127","0","0.25"]
    }

    property var temp_remote_low_lim_caption: {
        "caption":"Remote Low Limit"
    }

    property var temp_remote_low_lim_value: {
        "value":"0"
    }

    property var temp_remote_low_lim_state: {
        "state":"enabled"
    }


    property var temp_remote_low_lim_scales: {
        "scales":["127","0","0.25"]
    }

    property var temp_remote_low_lim_frac: {
        "caption":"",
        "value":"0.00",
        "state":"enabled",
        "values":["0.00","0.25","0.50","0.75"],
        "scales":[]
    }

    property var temp_remote_low_lim_frac_value: {
        "value":"0.00"
    }

    property var temp_remote_low_lim_frac_state: {
        "state":"enabled"
    }


    property var temp_remote_low_lim_frac_values: {
        "values":["0.00","0.25","0.50","0.75"]
    }

    property var temp_remote_high_lim: {
        "caption":"Remote High Limit",
        "value":"85",
        "state":"enabled",
        "values":[],
        "scales":["127","0","0.25"]
    }

    property var temp_remote_high_lim_caption: {
        "caption":"Remote High Limit"
    }

    property var temp_remote_high_lim_value: {
        "value":"85"
    }

    property var temp_remote_high_lim_state: {
        "state":"enabled"
    }
    property var temp_remote_high_lim_scales: {
        "scales":["127","0","0.25"]
    }

    property var temp_remote_high_lim_frac: {
        "caption":"",
        "value":"0.00",
        "state":"enabled",
        "values":["0.00","0.25","0.50","0.75"],
        "scales":[]
    }

    property var temp_remote_high_lim_frac_value: {
        "value":"0.00"
    }

    property var temp_remote_high_lim_frac_state: {
        "state":"enabled"
    }


    property var temp_remote_high_lim_frac_values: {
        "values":["0.00","0.25","0.50","0.75"]
    }

    property var temp_remote_offset: {
        "caption":"Remote Offset",
        "value":"0",
        "state":"enabled",
        "values":[],
        "scales":["127.75","-128","0.25"]
    }

    property var temp_remote_offset_caption: {
        "caption":"Remote Offset"
    }

    property var temp_remote_offset_value: {
        "value":"0"
    }

    property var temp_remote_offset_state: {
        "state":"enabled"
    }


    property var temp_remote_offset_scales: {
        "scales":["127.75","-128","0.25"]
    }

    property var temp_remote_offset_frac: {
        "caption":"",
        "value":"0.00",
        "state":"enabled",
        "values":["0.00","0.25","0.50","0.75"],
        "scales":[]
    }

    property var temp_remote_offset_frac_value: {
        "value":"0.00"
    }

    property var temp_remote_offset_frac_state: {
        "state":"enabled"
    }


    property var temp_remote_offset_frac_values: {
        "values":["0.00","0.25","0.50","0.75"]
    }


    property var temp_remote_therm_lim: {
        "caption":"Remote THERM Limit",
        "value":"108",
        "state":"enabled",
        "values":[],
        "scales":["255","0","1"]
    }

    property var temp_remote_therm_lim_caption: {
        "caption":"Remote THERM Limit"
    }

    property var temp_remote_therm_limt_value: {
        "value":"108"
    }

    property var temp_remote_therm_lim_state: {
        "state":"enabled"
    }


    property var temp_remote_therm_lim_scales: {
        "scales":["255","0","1"]
    }

    property var temp_lthrm: {
        "caption":"LTHRM",
        "value":"0",
        "state":"disabled",
        "values":[],
        "scales":[]
    }

    property var temp_lthrm_caption: {
        "caption":"LTHRM"
    }

    property var temp_lthrm_value: {
        "value":"0"
    }

    property var temp_lthrm_state: {
        "state":"disabled"
    }

    property var temp_llow: {
        "caption":"LLOW",
        "value":"0",
        "state":"disabled",
        "values":[],
        "scales":[]
    }

    property var temp_llow_caption: {
        "caption":"LLOW"
    }

    property var temp_llow_value: {
        "value":"0"
    }

    property var temp_llow_state: {
        "state":"disabled"
    }


    property var temp_lhigh: {
        "caption":"LHIGH",
        "value":"0",
        "state":"disabled",
        "values":[],
        "scales":[]
    }

    property var temp_lhigh_caption: {
        "caption":"LHIGH"
    }

    property var temp_lhigh_value: {
        "value":"0"
    }

    property var temp_lhigh_state: {
        "state":"disabled"
    }

    property var temp_local_low_lim: {
        "caption":"Local Low Limit",
        "value":"0",
        "state":"enabled",
        "values":[],
        "scales":["127","0","0.25"]
    }


    property var temp_local_low_lim_caption: {
        "caption":"Local Low Limit"
    }

    property var temp_local_low_lim_value: {
        "value":"0"
    }

    property var temp_local_low_lim_state: {
        "state":"enabled"
    }


    property var temp_local_low_lim_scales: {
        "scales":["127","0","0.25"]
    }

    property var temp_local_high_lim: {
        "caption": "Local High Limit",
        "value":"85",
        "state":"enabled",
        "values":[],
        "scales":["127","0","0.25"]
    }

    property var temp_local_high_lim_caption: {
        "caption":"Local High Limit"
    }

    property var temp_local_high_lim_value: {
        "value":"85"
    }

    property var temp_local_high_lim_state: {
        "state":"enabled"
    }


    property var temp_local_high_lim_scales: {
        "scales":["127","0","0.25"]
    }

    property var temp_local_therm_lim: {
        "caption":"Local THERM Limit",
        "value":"85",
        "state":"enabled",
        "values":[],
        "scales":["255","0","1"]
    }

    property var temp_local_therm_lim_caption: {
        "caption":"Local THERM Limit"
    }

    property var temp_local_therm_lim_value: {
        "value":"85"
    }

    property var temp_local_therm_lim_state: {
        "state":"enabled"
    }


    property var temp_local_therm_lim_scales: {
        "scales":["255","0","1"]
    }

    //---------------------------


    //Light Sensor Commands

    //Periodic notification that returns Lux value for gauge
    property var light: {
        "caption":"Lux (lx)",
        "value":"0",
        "state":"disabled",
        "values":[],
        "scales":["65536","0","1"]
    }



    property var light_caption: {
        "caption":"Lux (lx)"
    }

    property var light_value: {
        "value" : "0"
    }

    property var light_state: {
        "state" : "disabled"
    }

    property var light_scales: {
        "scales":["65536","0","1"]
    }







    property var light_manual_integ: {
        "caption": "Manual Integration",
        "value":"Stop",
        "state":"disabled_and_grayed_out",
        "values":["Start","Stop"],
        "scales":[]
    }


    property var light_manual_integ_caption: {
        "caption":"Manual Integration"
    }

    property var light_manual_integ_value: {
        "value": "Stop"
    }

    property var light_manual_integ_state: {
        "state":"disabled_and_grayed_out"
    }

    property var light_manual_integ_values: {
        "values":["Start","Stop"]
    }


    property var light_status: {
        "caption":"Status",
        "value":"Active",
        "state":"enabled",
        "values":["Active","Sleep"],
        "scales":[]
    }

    property var light_status_caption: {
        "caption":"Status"
    }

    property var light_status_value: {
        "value":"Active"
    }

    property var light_status_state: {
        "state":"enabled"
    }

    property var light_status_values: {
        "values":["Active","Sleep"]
    }


    property var light_integ_time: {
        "caption":"Integration Time",
        "value":"200ms",
        "state":"disabled_and_grayed_out",
        "values":["12.5ms","100ms","200ms","Manual"],
        "scales":[]
    }

    property var light_integ_time_caption: {
        "caption":"Integration Time"
    }

    property var light_integ_time_value: {
        "value":"200ms"
    }

    property var light_integ_time_state: {
        "state":"enabled"
    }

    property var light_integ_time_values: {
        "values":["12.5ms","100ms","200ms","Manual"]
    }

    property var light_gain: {
        "caption":"Gain",
        "value":"8",
        "state":"enabled",
        "values":["0.25","1","2","8"],
        "scales":[]
    }

    property var light_gain_caption: {
        "caption":"Gain"
    }

    property var light_gain_value: {
        "value" : "8"
    }

    property var light_gain_state: {
        "state" : "enabled"
    }

    property var light_gain_values: {
        "values":["0.25","1","2","8"]
    }

    property var light_sensitivity: {
        "caption":"Sensitivity (%)",
        "value":"98.412697",
        "state":"enabled",
        "values":[],
        "scales":["150","66.7","0"]
    }

    property var light_sensitivity_caption: {
        "caption":"Sensitivity (%)"
    }

    property var light_sensitivity_value: {
        "value" : "98.41"
    }

    property var light_sensitivity_state: {
        "state" : "enabled"
    }

    property var light_sensitivity_scales: {
        "scales":["150","66.7","0"]
    }


    property var set_light_status: ({
                                        "cmd" : "light_status",
                                        "payload": {
                                            "value": false
                                        },
                                        update: function (value) {
                                            this.set(value)
                                            CorePlatformInterface.send(this)
                                        },
                                        set: function (value) {
                                            this.payload.value = value;
                                        },
                                        send: function () { CorePlatformInterface.send(this) },
                                        show: function () { CorePlatformInterface.show(this) }
                                    })

    property var set_light_sensitivity: ({
                                             "cmd" : "light_sensitivity",
                                             "payload": {
                                                 "value": 100
                                             },
                                             update: function (value) {
                                                 this.set(value)
                                                 CorePlatformInterface.send(this)
                                             },
                                             set: function (value) {
                                                 this.payload.value = value;
                                             },
                                             send: function () { CorePlatformInterface.send(this) },
                                             show: function () { CorePlatformInterface.show(this) }
                                         })
    property var set_light_gain: ({
                                      "cmd" : "light_gain",
                                      "payload": {
                                          "value":"1"
                                      },
                                      update: function (value) {
                                          this.set(value)
                                          CorePlatformInterface.send(this)
                                      },
                                      set: function (value) {
                                          this.payload.value = value;
                                      },
                                      send: function () { CorePlatformInterface.send(this) },
                                      show: function () { CorePlatformInterface.show(this) }
                                  })

    property var set_light_integ_time: ({
                                            "cmd" : "light_integ_time",
                                            "payload": {
                                                "value":"12.5ms"
                                            },
                                            update: function (value) {
                                                this.set(value)
                                                CorePlatformInterface.send(this)
                                            },
                                            set: function (value) {
                                                this.payload.value = value;
                                            },
                                            send: function () { CorePlatformInterface.send(this) },
                                            show: function () { CorePlatformInterface.show(this) }
                                        })


    property var set_light_manual_integ: ({
                                              "cmd" : "light_manual_integ",
                                              "payload": {
                                                  "value":false
                                              },
                                              update: function (value) {
                                                  this.set(value)
                                                  CorePlatformInterface.send(this)
                                              },
                                              set: function (value) {
                                                  this.payload.value = value;
                                              },
                                              send: function () { CorePlatformInterface.send(this) },
                                              show: function () { CorePlatformInterface.show(this) }
                                          })






    //----------------------------------LC717A10AR Notification
    property var touch_register_cin: {
        "act":[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],
        "data":[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],
        "err":[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0]
    }

    property var default_touch_register_cin: {
        "act":[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],
        "data":[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],
        "err":[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0]
    }





    //New Notification for touch
    property var touch_cin: {
        "act":[0,0,0,0,0,0,0,0],
        "data":[0,0,0,0,0,0,0,0],
        "err":[0,0,0,0,0,0,0,0]
    }

    property var default_touch_cin: {
        "act":[0,0,0,0,0,0,0,0],
        "data":[0,0,0,0,0,0,0,0],
        "err":[0,0,0,0,0,0,0,0]
    }


    property var touch_hw_reset_value: {
        "value" : "1"
    }

    property var touch_reset: ({
                                   "cmd":"touch_hw_reset",
                                   update: function () {
                                       CorePlatformInterface.send(this)
                                   },
                                   send: function () { CorePlatformInterface.send(this) },
                                   show: function () { CorePlatformInterface.show(this) }
                               })

    //New Proximity Notification & Command
    property var proximity_cin: {
        "act":[0,0,0,0],
        "data":[0,0,0,0],
        "err":[0,0,0,0]
    }

    property var default_proximity_cin: {
        "act":[0,0,0,0],
        "data":[0,0,0,0],
        "err":[0,0,0,0]
    }







    //OLD commands
    // TO SYNCHRONIZE THE SPEED ON ALL THE VIEW DO THE FOLLOWING:
    // EXAMPLE: platformInterface.enabled

    //    property var set_sensor_type:({
    //                                      "cmd" : "set_sensor_type",
    //                                      "payload": {
    //                                          "sensor": ""
    //                                      },
    //                                      update: function (sensor) {
    //                                          this.set(sensor)
    //                                          CorePlatformInterface.send(this)
    //                                      },
    //                                      set: function (sensor) {
    //                                          this.payload.sensor = sensor;
    //                                      },
    //                                      send: function () { CorePlatformInterface.send(this) },
    //                                      show: function () { CorePlatformInterface.show(this) }

    //                                  })

    //    property var get_sensor_type_mode: ({

    //                                            "cmd":"get_sensor_type",
    //                                            update: function () {
    //                                                CorePlatformInterface.send(this)
    //                                            },
    //                                            send: function () { CorePlatformInterface.send(this) },
    //                                            show: function () { CorePlatformInterface.show(this) }
    //                                        })

    //    property var reset_touch_mode: ({

    //                                        "cmd":"lc717a10ar_reset",
    //                                        update: function () {
    //                                            CorePlatformInterface.send(this)
    //                                        },
    //                                        send: function () { CorePlatformInterface.send(this) },
    //                                        show: function () { CorePlatformInterface.show(this) }
    //                                    })


    //    property var get_light_lux: ({

    //                                     "cmd":"lv0104cs_get_light",
    //                                     update: function () {
    //                                         CorePlatformInterface.send(this)
    //                                     },
    //                                     send: function () { CorePlatformInterface.send(this) },
    //                                     show: function () { CorePlatformInterface.show(this) }
    //                                 })



    //    property var set_pwm_temp_ext: ({
    //                                        "cmd": "nct72_set_pwm_temp_ext",
    //                                        "payload": {
    //                                            "duty": 80,
    //                                            "period": 0.001
    //                                        },

    //                                        update: function (duty) {
    //                                            this.set(duty)
    //                                            CorePlatformInterface.send(this)
    //                                        },
    //                                        set: function (duty) {
    //                                            this.payload.duty = duty;
    //                                        },
    //                                        send: function () { CorePlatformInterface.send(this) },
    //                                        show: function () { CorePlatformInterface.show(this) }

    //                                    })

    //    //    property var get_nct72_config: ({
    //    //                                        "cmd":"nct72_get_config",
    //    //                                        update: function () {
    //    //                                            CorePlatformInterface.send(this)
    //    //                                        },
    //    //                                        send: function () { CorePlatformInterface.send(this) },
    //    //                                        show: function () { CorePlatformInterface.show(this) }

    //    //                                    })

    //    property var get_nct72_status: ({
    //                                        "cmd":"nct72_get_status",
    //                                        update: function () {
    //                                            CorePlatformInterface.send(this)
    //                                        },
    //                                        send: function () { CorePlatformInterface.send(this) },
    //                                        show: function () { CorePlatformInterface.show(this) }

    //                                    })

    //    property var set_pwm_temp_int: ({
    //                                        "cmd": "nct72_set_pwm_temp_int",
    //                                        "payload": {
    //                                            "duty": 80,
    //                                            "period": 0.001
    //                                        },

    //                                        update: function (duty) {
    //                                            this.set(duty)
    //                                            CorePlatformInterface.send(this)
    //                                        },
    //                                        set: function (duty) {
    //                                            this.payload.duty = duty;
    //                                        },
    //                                        send: function () { CorePlatformInterface.send(this) },
    //                                        show: function () { CorePlatformInterface.show(this) }


    //                                    })
    //    property var set_config_range: ({
    //                                        "cmd": "nct72_set_config_range",
    //                                        "payload": {
    //                                            "value":""
    //                                        },

    //                                        update: function (value) {
    //                                            this.set(value)
    //                                            CorePlatformInterface.send(this)
    //                                        },
    //                                        set: function (value) {
    //                                            this.payload.value = value;
    //                                        },
    //                                        send: function () { CorePlatformInterface.send(this) },
    //                                        show: function () { CorePlatformInterface.show(this) }
    //                                    })



    //    property var lv0104cs_setup_measurement: ({
    //                                                  "cmd": "lv0104cs_setup_measurement",
    //                                                  "payload": {
    //                                                      "mode":"",
    //                                                      "gain":"",
    //                                                      "integ":"",
    //                                                      "manual":""
    //                                                  },
    //                                                  update: function (mode,gain,integ,manual) {
    //                                                      this.set(mode,gain,integ,manual)
    //                                                      CorePlatformInterface.send(this)
    //                                                  },
    //                                                  set: function (mode,gain,integ,manual) {
    //                                                      this.payload.mode = mode;
    //                                                      this.payload.gain = gain;
    //                                                      this.payload.integ = integ;
    //                                                      this.payload.manual = manual;
    //                                                  },
    //                                                  send: function () { CorePlatformInterface.send(this) },
    //                                                  show: function () { CorePlatformInterface.show(this) }

    //                                              })



    //    property var set_config_alert_therm2 : ({
    //                                                "cmd": "nct72_set_config_alert_therm2",
    //                                                "payload": {
    //                                                    "value":""
    //                                                },

    //                                                update: function (value) {
    //                                                    this.set(value)
    //                                                    CorePlatformInterface.send(this)
    //                                                },
    //                                                set: function (value) {
    //                                                    this.payload.value = value;
    //                                                },
    //                                                send: function () { CorePlatformInterface.send(this) },
    //                                                show: function () { CorePlatformInterface.show(this) }
    //                                            })

    //    property var set_config_run_stop : ({
    //                                            "cmd": "nct72_set_config_run_stop",
    //                                            "payload": {
    //                                                "value":""
    //                                            },

    //                                            update: function (value) {
    //                                                this.set(value)
    //                                                CorePlatformInterface.send(this)
    //                                            },
    //                                            set: function (value) {
    //                                                this.payload.value = value;
    //                                            },
    //                                            send: function () { CorePlatformInterface.send(this) },
    //                                            show: function () { CorePlatformInterface.show(this) }
    //                                        })
    //    property var set_config_alert : ({
    //                                         "cmd": "nct72_set_config_alert",
    //                                         "payload": {
    //                                             "value":""
    //                                         },

    //                                         update: function (value) {
    //                                             this.set(value)
    //                                             CorePlatformInterface.send(this)
    //                                         },
    //                                         set: function (value) {
    //                                             this.payload.value = value;
    //                                         },
    //                                         send: function () { CorePlatformInterface.send(this) },
    //                                         show: function () { CorePlatformInterface.show(this) }
    //                                     })

    //Conversion rate
    //    property var set_conv_rate : ({
    //                                      "cmd": "nct72_set_conv_rate",
    //                                      "payload": {
    //                                          "value":""
    //                                      },

    //                                      update: function (value) {
    //                                          this.set(value)
    //                                          CorePlatformInterface.send(this)
    //                                      },
    //                                      set: function (value) {
    //                                          this.payload.value = value;
    //                                      },
    //                                      send: function () { CorePlatformInterface.send(this) },
    //                                      show: function () { CorePlatformInterface.show(this) }
    //                                  })

    //    property var get_conv_rate: ({
    //                                     "cmd":"nct72_get_conv_rate",
    //                                     update: function () {
    //                                         CorePlatformInterface.send(this)
    //                                     },
    //                                     send: function () { CorePlatformInterface.send(this) },
    //                                     show: function () { CorePlatformInterface.show(this) }

    //                                 })
    //    property var get_ext_low_lim: ({
    //                                       "cmd":"nct72_get_ext_low_lim",
    //                                       update: function () {
    //                                           CorePlatformInterface.send(this)
    //                                       },
    //                                       send: function () { CorePlatformInterface.send(this) },
    //                                       show: function () { CorePlatformInterface.show(this) }
    //                                   })
    //    property var set_ext_low_lim_integer: ({
    //                                               "cmd":"nct72_set_ext_low_lim_integer",
    //                                               "payload": {
    //                                                   "value":""
    //                                               },

    //                                               update: function (value) {
    //                                                   this.set(value)
    //                                                   CorePlatformInterface.send(this)
    //                                               },
    //                                               set: function (value) {
    //                                                   this.payload.value = value;
    //                                               },
    //                                               send: function () { CorePlatformInterface.send(this) },
    //                                               show: function () { CorePlatformInterface.show(this) }
    //                                           })
    //    property var set_ext_low_lim_fraction: ({
    //                                                "cmd":"nct72_set_ext_low_lim_fraction",
    //                                                "payload": {
    //                                                    "value":""
    //                                                },

    //                                                update: function (value) {
    //                                                    this.set(value)
    //                                                    CorePlatformInterface.send(this)
    //                                                },
    //                                                set: function (value) {
    //                                                    this.payload.value = value;
    //                                                },
    //                                                send: function () { CorePlatformInterface.send(this) },
    //                                                show: function () { CorePlatformInterface.show(this) }
    //                                            })

    //// external high limit get
    //    property var get_ext_high_lim: ({
    //                                        "cmd":"nct72_get_ext_high_lim",
    //                                        update: function () {
    //                                            CorePlatformInterface.send(this)
    //                                        },
    //                                        send: function () { CorePlatformInterface.send(this) },
    //                                        show: function () { CorePlatformInterface.show(this) }
    //                                    })
    //    property var set_ext_high_lim_integer: ({
    //                                                "cmd":"nct72_set_ext_high_lim_integer",
    //                                                "payload": {
    //                                                    "value":""
    //                                                },

    //                                                update: function (value) {
    //                                                    this.set(value)
    //                                                    CorePlatformInterface.send(this)
    //                                                },
    //                                                set: function (value) {
    //                                                    this.payload.value = value;
    //                                                },
    //                                                send: function () { CorePlatformInterface.send(this) },
    //                                                show: function () { CorePlatformInterface.show(this) }
    //                                            })
    //    property var set_ext_high_lim_fraction: ({
    //                                                 "cmd":"nct72_set_ext_high_lim_fraction",
    //                                                 "payload": {
    //                                                     "value":""
    //                                                 },

    //                                                 update: function (value) {
    //                                                     this.set(value)
    //                                                     CorePlatformInterface.send(this)
    //                                                 },
    //                                                 set: function (value) {
    //                                                     this.payload.value = value;
    //                                                 },
    //                                                 send: function () { CorePlatformInterface.send(this) },
    //                                                 show: function () { CorePlatformInterface.show(this) }
    //                                             })



    //Consecutive ALERTs
    //    property var get_cons_alert: ({
    //                                      "cmd":"nct72_get_cons_alert",
    //                                      update: function () {
    //                                          CorePlatformInterface.send(this)
    //                                      },
    //                                      send: function () { CorePlatformInterface.send(this) },
    //                                      show: function () { CorePlatformInterface.show(this) }
    //                                  })

    //    property var set_ext_low_lim: ({
    //                                       "cmd":"nct72_set_cons_alert",
    //                                       "payload": {
    //                                           "value":""
    //                                       },
    //                                       update: function (value) {
    //                                           this.set(value)
    //                                           CorePlatformInterface.send(this)
    //                                       },
    //                                       set: function (value) {
    //                                           this.payload.value = value;
    //                                       },
    //                                       show: function () { CorePlatformInterface.show(this) }
    //                                   })

    //    //Manufacturers ID
    //    property var get_man_id: ({
    //                                  "cmd":"nct72_get_man_id",
    //                                  update: function () {
    //                                      CorePlatformInterface.send(this)
    //                                  },
    //                                  send: function () { CorePlatformInterface.send(this) },
    //                                  show: function () { CorePlatformInterface.show(this) }
    //                              })


    //Hysteresis
    //    property var get_therm_hyst: ({
    //                                      "cmd":"nct72_get_therm_hyst",
    //                                      update: function () {
    //                                          CorePlatformInterface.send(this)
    //                                      },
    //                                      send: function () { CorePlatformInterface.send(this) },
    //                                      show: function () { CorePlatformInterface.show(this) }
    //                                  })


    //    property var set_therm_hyst: ({
    //                                      "cmd":"nct72_set_therm_hyst",
    //                                      "payload": {
    //                                          "value":""
    //                                      },
    //                                      update: function (value) {
    //                                          this.set(value)
    //                                          CorePlatformInterface.send(this)
    //                                      },
    //                                      set: function (value) {
    //                                          this.payload.value = value;
    //                                      },
    //                                      show: function () { CorePlatformInterface.show(this) }
    //                                  })
    //    //Remote and Local THERM Limits
    //    property var get_therm_limits: ({
    //                                        "cmd":"nct72_get_therm_limits",
    //                                        update: function () {
    //                                            CorePlatformInterface.send(this)
    //                                        },
    //                                        send: function () { CorePlatformInterface.send(this) },
    //                                        show: function () { CorePlatformInterface.show(this) }
    //                                    })

    //    property var set_ext_therm_limit: ({
    //                                           "cmd":"nct72_set_ext_therm_limit",
    //                                           "payload": {
    //                                               "value":""
    //                                           },
    //                                           update: function (value) {
    //                                               this.set(value)
    //                                               CorePlatformInterface.send(this)
    //                                           },
    //                                           set: function (value) {
    //                                               this.payload.value = value;
    //                                           },
    //                                           show: function () { CorePlatformInterface.show(this) }
    //                                       })
    //    property var set_int_therm_limit: ({
    //                                           "cmd":"nct72_set_int_therm_limit",
    //                                           "payload": {
    //                                               "value":""
    //                                           },
    //                                           update: function (value) {
    //                                               this.set(value)
    //                                               CorePlatformInterface.send(this)
    //                                           },
    //                                           set: function (value) {
    //                                               this.payload.value = value;
    //                                           },
    //                                           show: function () { CorePlatformInterface.show(this) }
    //                                       })

    //Remote Offset
    //    property var get_ext_offset: ({
    //                                      "cmd":"nct72_get_ext_offset",
    //                                      update: function () {
    //                                          CorePlatformInterface.send(this)
    //                                      },
    //                                      send: function () { CorePlatformInterface.send(this) },
    //                                      show: function () { CorePlatformInterface.show(this) }
    //                                  })




    //    //One-shot






    //----------------------------------LC717A10AR ----------Commands

    property var set_touch_mode_value: ({
                                            "cmd":"touch_mode",
                                            "payload": {
                                                "value":"Interval"
                                            },
                                            update: function (value) {
                                                this.set(value)
                                                CorePlatformInterface.send(this)
                                            },
                                            set: function (value) {
                                                this.payload.value = value;
                                            },
                                            show: function () { CorePlatformInterface.show(this) }
                                        })

    property var set_touch_average_count_value: ({
                                                     "cmd":"touch_average_count",
                                                     "payload": {
                                                         "value":"128"
                                                     },
                                                     update: function (value) {
                                                         this.set(value)
                                                         CorePlatformInterface.send(this)
                                                     },
                                                     set: function (value) {
                                                         this.payload.value = value;
                                                     },
                                                     show: function () { CorePlatformInterface.show(this) }
                                                 })

    property var set_touch_filter_parameter1_value: ({
                                                         "cmd":"touch_filter_parameter1",
                                                         "payload": {
                                                             "value":"12"
                                                         },
                                                         update: function (value) {
                                                             this.set(value)
                                                             CorePlatformInterface.send(this)
                                                         },
                                                         set: function (value) {
                                                             this.payload.value = value;
                                                         },
                                                         show: function () { CorePlatformInterface.show(this) }
                                                     })

    property var set_touch_filter_parameter2_value: ({
                                                         "cmd":"touch_filter_parameter2",
                                                         "payload": {
                                                             "value":"0"
                                                         },
                                                         update: function (value) {
                                                             this.set(value)
                                                             CorePlatformInterface.send(this)
                                                         },
                                                         set: function (value) {
                                                             this.payload.value = value;
                                                         },
                                                         show: function () { CorePlatformInterface.show(this) }
                                                     })

    property var set_touch_dct1_value: ({
                                            "cmd":"touch_dct1",
                                            "payload": {
                                                "value":"1"
                                            },
                                            update: function (value) {
                                                this.set(value)
                                                CorePlatformInterface.send(this)
                                            },
                                            set: function (value) {
                                                this.payload.value = value;
                                            },
                                            show: function () { CorePlatformInterface.show(this) }
                                        })
    property var set_touch_dct2_value: ({
                                            "cmd":"touch_dct2",
                                            "payload": {
                                                "value":"1"
                                            },
                                            update: function (value) {
                                                this.set(value)
                                                CorePlatformInterface.send(this)
                                            },
                                            set: function (value) {
                                                this.payload.value = value;
                                            },
                                            show: function () { CorePlatformInterface.show(this) }
                                        })

    property var set_touch_sival_value: ({
                                             "cmd":"touch_sival",
                                             "payload": {
                                                 "value":"5"
                                             },
                                             update: function (value) {
                                                 this.set(value)
                                                 CorePlatformInterface.send(this)
                                             },
                                             set: function (value) {
                                                 this.payload.value = value;
                                             },
                                             show: function () { CorePlatformInterface.show(this) }
                                         })

    property var set_touch_lival_value: ({
                                             "cmd":"touch_lival",
                                             "payload": {
                                                 "value":"100"
                                             },
                                             update: function (value) {
                                                 this.set(value)
                                                 CorePlatformInterface.send(this)
                                             },
                                             set: function (value) {
                                                 this.payload.value = value;
                                             },
                                             show: function () { CorePlatformInterface.show(this) }
                                         })

    property var set_touch_dc_plus_value: ({
                                               "cmd":"touch_dc_plus",
                                               "payload": {
                                                   "value":"5"
                                               },
                                               update: function (value) {
                                                   this.set(value)
                                                   CorePlatformInterface.send(this)
                                               },
                                               set: function (value) {
                                                   this.payload.value = value;
                                               },
                                               show: function () { CorePlatformInterface.show(this) }
                                           })

    property var set_touch_dc_minus_value: ({
                                                "cmd":"touch_dc_minus",
                                                "payload": {
                                                    "value":"5"
                                                },
                                                update: function (value) {
                                                    this.set(value)
                                                    CorePlatformInterface.send(this)
                                                },
                                                set: function (value) {
                                                    this.payload.value = value;
                                                },
                                                show: function () { CorePlatformInterface.show(this) }
                                            })

    property var set_touch_si_dc_cyc: ({
                                           "cmd":"touch_si_dc_cyc",
                                           "payload": {
                                               "value":"5"
                                           },
                                           update: function (value) {
                                               this.set(value)
                                               CorePlatformInterface.send(this)
                                           },
                                           set: function (value) {
                                               this.payload.value = value;
                                           },
                                           show: function () { CorePlatformInterface.show(this) }
                                       })

    property var set_touch_sc_cdac_value: ({
                                               "cmd":"touch_sc_cdac",
                                               "payload": {
                                                   "value":"1"
                                               },
                                               update: function (value) {
                                                   this.set(value)
                                                   CorePlatformInterface.send(this)
                                               },
                                               set: function (value) {
                                                   this.payload.value = value;
                                               },
                                               show: function () { CorePlatformInterface.show(this) }
                                           })

    property var set_touch_dc_mode_value: ({
                                               "cmd":"touch_dc_mode",
                                               "payload": {
                                                   "value":"Threshold"
                                               },
                                               update: function (value) {
                                                   this.set(value)
                                                   CorePlatformInterface.send(this)
                                               },
                                               set: function (value) {
                                                   this.payload.value = value;
                                               },
                                               show: function () { CorePlatformInterface.show(this) }
                                           })

    property var set_touch_off_thres_mode_value: ({
                                                      "cmd":"touch_off_thres_mode",
                                                      "payload": {
                                                          "value":"0"
                                                      },
                                                      update: function (value) {
                                                          this.set(value)
                                                          CorePlatformInterface.send(this)
                                                      },
                                                      set: function (value) {
                                                          this.payload.value = value;
                                                      },
                                                      show: function () { CorePlatformInterface.show(this) }
                                                  })

    property var set_touch_cref0_7_value: ({
                                               "cmd":"touch_cref0_7",
                                               "payload": {
                                                   "value":"CREF+CADD"
                                               },
                                               update: function (value) {
                                                   this.set(value)
                                                   CorePlatformInterface.send(this)
                                               },
                                               set: function (value) {
                                                   this.payload.value = value;
                                               },
                                               show: function () { CorePlatformInterface.show(this) }
                                           })

    property var set_touch_cref8_15_value: ({
                                                "cmd":"touch_cref8_15",
                                                "payload": {
                                                    "value":"CREF+CADD"
                                                },
                                                update: function (value) {
                                                    this.set(value)
                                                    CorePlatformInterface.send(this)
                                                },
                                                set: function (value) {
                                                    this.payload.value = value;
                                                },
                                                show: function () { CorePlatformInterface.show(this) }
                                            })

    property var set_touch_li_start_value: ({
                                                "cmd":"touch_li_start",
                                                "payload": {
                                                    "value":"0"
                                                },
                                                update: function (value) {
                                                    this.set(value)
                                                    CorePlatformInterface.send(this)
                                                },
                                                set: function (value) {
                                                    this.payload.value = value;
                                                },
                                                show: function () { CorePlatformInterface.show(this) }
                                            })

    property var set_touch_first_gain0_7_value: ({
                                                     "cmd":"touch_first_gain0_7",
                                                     "payload": {
                                                         "value":"1600"
                                                     },
                                                     update: function (value) {
                                                         this.set(value)
                                                         CorePlatformInterface.send(this)
                                                     },
                                                     set: function (value) {
                                                         this.payload.value = value;
                                                     },
                                                     show: function () { CorePlatformInterface.show(this) }
                                                 })

    property var set_touch_first_gain8_15_value: ({
                                                      "cmd":"touch_first_gain8_15",
                                                      "payload": {
                                                          "value":"1600"
                                                      },
                                                      update: function (value) {
                                                          this.set(value)
                                                          CorePlatformInterface.send(this)
                                                      },
                                                      set: function (value) {
                                                          this.payload.value = value;
                                                      },
                                                      show: function () { CorePlatformInterface.show(this) }
                                                  })

    property var touch_second_gain_value: ({
                                               "cmd":"touch_second_gain",
                                               "payload": {
                                                   "cin":0,
                                                   "gain":1
                                               },
                                               update: function (cin,gain) {
                                                   this.set(cin,gain)
                                                   CorePlatformInterface.send(this)
                                               },
                                               set: function (cin,gain) {
                                                   this.payload.cin = cin
                                                   this.payload.gain = gain
                                               },
                                               send: function () { CorePlatformInterface.send(this) },
                                               show: function () { CorePlatformInterface.show(this) }
                                           })

    property var touch_cin_thres_value: ({
                                             "cmd":"touch_cin_thres",
                                             "payload": {
                                                 "cin":0,
                                                 "thres":1
                                             },
                                             update: function (cin,thres) {
                                                 this.set(cin,thres)
                                                 CorePlatformInterface.send(this)
                                             },
                                             set: function (cin,thres) {
                                                 this.payload.cin = cin
                                                 this.payload.thres = thres
                                             },
                                             send: function () { CorePlatformInterface.send(this) },
                                             show: function () { CorePlatformInterface.show(this) }
                                         })

    property var touch_cin_en_value: ({
                                          "cmd":"touch_cin_en",
                                          "payload": {
                                              "cin":0,
                                              "enable":1
                                          },
                                          update: function (cin,enable) {
                                              this.set(cin,enable)
                                              CorePlatformInterface.send(this)
                                          },
                                          set: function (cin,enable) {
                                              this.payload.cin = cin
                                              this.payload.enable = enable
                                          },
                                          send: function () { CorePlatformInterface.send(this) },
                                          show: function () { CorePlatformInterface.show(this) }
                                      })

    property var touch_export_registers_value: ({
                                                    "cmd":"touch_export_registers",
                                                    update: function () {
                                                        CorePlatformInterface.send(this)
                                                    },
                                                    send: function () { CorePlatformInterface.send(this) },
                                                    show: function () { CorePlatformInterface.show(this) }
                                                })

    property var touch_sw_reset_value: ({
                                            "cmd":"touch_sw_reset",

                                            update: function () {
                                                CorePlatformInterface.send(this)
                                            },
                                            send: function () { CorePlatformInterface.send(this) },
                                            show: function () { CorePlatformInterface.show(this) }
                                        })

    //    property var touch_hw_reset_value: ({
    //                                            "cmd":"touch_hw_reset",

    //                                            update: function () {
    //                                                CorePlatformInterface.send(this)
    //                                            },
    //                                            send: function () { CorePlatformInterface.send(this) },
    //                                            show: function () { CorePlatformInterface.show(this) }
    //                                        })

    property var touch_wakeup_value: ({
                                          "cmd":"touch_wakeup",
                                          update: function () {
                                              CorePlatformInterface.send(this)
                                          },
                                          send: function () { CorePlatformInterface.send(this) },
                                          show: function () { CorePlatformInterface.show(this) }
                                      })


    //----------------------------------LC717A10AR ----------Notifications

    property var default_touch_mode: {
        "caption":"Mode",
        "value":"Interval",
        "state":"enabled",
        "values":["Interval","Sleep"],
        "scales":[]
    }


    property var touch_mode_caption: {
        "caption":"Mode"
    }

    property var touch_mode_value: {
        "value":"Interval"
    }

    property var touch_mode_state: {
        "state":"enabled"
    }

    property var touch_mode_values: {
        "values":["Interval","Sleep"]
    }

    property var default_touch_average_count: {
        "caption":"Average Count",
        "value":"128",
        "state":"enabled",
        "values":["8","16","32","64","128"],
        "scales":[]
    }

    property var touch_average_count_caption: {
        "caption":"Average Count"
    }

    property var touch_average_count_value: {
        "value":"128"
    }

    property var touch_average_count_state: {
        "state":"enabled"
    }

    property var touch_average_count_values: {
        "values":["8","16","32","64","128"]
    }



    property var default_touch_filter_parameter1: {
        "caption":"Filter Parameter 1",
        "value":"12",
        "state":"enabled",
        "values":["0","1","2","3","4","5","6","7","8","9","10","11","12","13","14","15"],
        "scales":[]
    }


    property var touch_filter_parameter1_caption: {
        "caption":"Filter Parameter 1"
    }

    property var touch_filter_parameter1_value: {
        "value":"12"
    }

    property var touch_filter_parameter1_state: {
        "state":"enabled"
    }

    property var touch_filter_parameter1_values: {
        "values":["0","1","2","3","4","5","6","7","8","9","10","11","12","13","14","15"]
    }

    property var default_touch_filter_parameter2: {
        "caption":"Filter Parameter 2",
        "value":"0",
        "state":"enabled",
        "values":["0","1","2","3","4","5","6","7","8","9","10","11","12","13","14","15"],
        "scales":[]
    }

    property var touch_filter_parameter2_caption: {
        "caption":"Filter Parameter 2"
    }


    property var touch_filter_parameter2_value: {
        "value":"0"
    }

    property var touch_filter_parameter2_state: {
        "state":"enabled"
    }

    property var touch_filter_parameter2_values: {
        "values":["0","1","2","3","4","5","6","7","8","9","10","11","12","13","14","15"]
    }

    //    property var touch_dct1: {
    //        "caption":"Debounce Count (Off to On)",
    //        "value":"1",
    //        "state":"enabled",
    //        "values":[],
    //        "scales":["255","0","1"]
    //    }

    property var touch_dct1_caption: {
        "caption":"Debounce Count (Off to On)"
    }

    property var touch_dct1_value: {
        "value":"1"
    }

    property var touch_dct1_state: {
        "state":"enabled"
    }

    property var touch_dct1_scales: {
        "scales":["255","0","1"]
    }

    //    property var touch_dct2: {
    //        "caption":"Debounce Count (On to Off)",
    //        "value":"1",
    //        "state":"enabled",
    //        "values":[],
    //        "scales":["255","0","1"]
    //    }

    property var touch_dct2_caption: {
        "caption":"Debounce Count (On to Off)"
    }

    property var touch_dct2_value: {
        "value":"1"
    }

    property var touch_dct2_state:{
        "state":"enabled"
    }

    property var touch_dct2_scales: {
        "scales":["255","0","1"]
    }


    //    property var touch_sival: {
    //        "caption":"Short Interval Time (ms)",
    //        "value":"5",
    //        "state":"enabled",
    //        "values":[],
    //        "scales":["255","0","1"]
    //    }

    property var touch_sival_caption: {
        "caption":"Short Interval Time (ms)"
    }

    property var touch_sival_value: {
        "value":"5"
    }

    property var touch_sival_state:{
        "state":"enabled"
    }

    property var touch_sival_scales: {
        "scales":["255","0","1"]
    }




    //    property var touch_lival: {
    //        "caption":"Long Interval Time (ms)",
    //        "value":"100",
    //        "state":"enabled",
    //        "values":[],
    //        "scales":["355","0","1"]
    //    }


    property var touch_lival_caption: {
        "caption":"Long Interval Time (ms)"
    }

    property var touch_lival_value: {
        "value":"100"
    }

    property var touch_lival_state:{
        "state":"enabled"
    }

    property var touch_lival_scales: {
        "scales":["355","0","1"]
    }
    //    property var touch_si_dc_cyc: {
    //        "caption":"Short Interval Dyn Off Cal Cycles",
    //        "value":"4",
    //        "state":"enabled",
    //        "values":[],
    //        "scales":["355","0","1"]
    //    }

    property var touch_si_dc_cyc_caption: {
        "caption":"Short Interval Dyn Off Cal Cycles"
    }

    property var touch_si_dc_cycl_value: {
        "value":"4"
    }

    property var touch_si_dc_cyc_state:{
        "state":"enabled"
    }

    property var touch_si_dc_cyc_scales: {
        "scales":["355","0","1"]
    }

    //    property var touch_dc_plus: {
    //        "caption":"Dyn Off Cal Count Plus",
    //        "value":"1",
    //        "state":"enabled",
    //        "values":[],
    //        "scales":["255","0","1"]
    //    }

    property var touch_dc_plus_caption: {
        "caption":"Dyn Off Cal Count Plus"
    }

    property var touch_dc_plus_value: {
        "value":"1"
    }

    property var touch_dc_plus_state:{
        "state":"enabled"
    }

    property var touch_dc_plus_scales: {
        "scales":["255","0","1"]
    }

    //    property var touch_dc_minus: {
    //        "caption":"Dyn Off Cal Count Minus",
    //        "value":"1",
    //        "state":"enabled",
    //        "values":[],
    //        "scales":["255","0","1"]
    //    }

    property var touch_dc_minus_caption: {
        "caption":"Dyn Off Cal Count Minus"
    }

    property var touch_dc_minus_value: {
        "value":"1"
    }

    property var touch_dc_minus_state:{
        "state":"enabled"
    }

    property var touch_dc_minus_scales: {
        "scales":["255","0","1"]
    }


    //    property var touch_sc_cdac: {
    //        "caption":"Static Calibration CDAC (pF)",
    //        "value":"2",
    //        "state":"enabled",
    //        "values":["1","2","4"],
    //        "scales":[]
    //    }

    property var touch_sc_cdacs_caption: {
        "caption":"Static Calibration CDAC (pF)"
    }

    property var touch_sc_cdac_value: {
        "value":"2"
    }

    property var touch_sc_cdac_state:{
        "state":"enabled"
    }

    property var touch_sc_cdac_values: {
        "values":["1","2","4"]
    }


    //    property var touch_dc_mode: {
    //        "caption":"Dyn Off Cal Mode",
    //        "value":"Threshold",
    //        "state":"enabled",
    //        "values":["Threshold","Enabled"],
    //        "scales":[]
    //    }

    property var touch_dc_mode_caption: {
        "caption":"Dyn Off Cal Mode"
    }

    property var touch_dc_mode_value: {
        "value":"Threshold"
    }

    property var touch_dc_mode_state:{
        "state":"enabled"
    }

    property var touch_dc_mode_values: {
        "values":["Threshold","Enabled"]
    }


    //    property var touch_off_thres_mode: {
    //        "caption":"Offset Threshold",
    //        "value":"0.5 Peak",
    //        "state":"enabled",
    //        "values":["0.5 Peak","0.75 Peak"],
    //        "scales":[]
    //    }

    property var touch_off_thres_mode_caption: {
        "caption":"Offset Threshold"
    }

    property var touch_off_thres_mode_value: {
        "value":"0.5 Peak"
    }

    property var touch_off_thres_mode_state:{
        "state":"enabled"
    }

    property var touch_off_thres_mode_values: {
        "values":["0.5 Peak","0.75 Peak"]
    }


    //    property var touch_cref0_7: {
    //        "caption":"CIN0-7 CREF",
    //        "value":"CREF+CADD",
    //        "state":"enabled",
    //        "values":["CREF+CADD","CREF"],
    //        "scales":[]
    //    }


    property var touch_cref0_7_caption: {
        "caption":"CIN0-7 CREF"
    }

    property var touch_cref0_7_value: {
        "value":"CREF+CADD"
    }

    property var touch_cref0_7_state:{
        "state":"enabled"
    }

    property var touch_cref0_7_values: {
        "values":["CREF+CADD","CREF"]
    }

    //    property var touch_cref8_15: {
    //        "caption":"CIN8-15 CREF",
    //        "value":"CREF",
    //        "state":"enabled",
    //        "values":["CREF+CADD","CREF"],
    //        "scales":[]
    //    }

    property var touch_cref8_15_caption: {
        "caption":"CIN8-15 CREF"
    }

    property var touch_cref8_15_value: {
        "value":"CREF"
    }

    property var touch_cref8_15_state:{
        "state":"enabled"
    }

    property var touch_cref8_157_values: {
        "values":["CREF+CADD","CREF"]
    }


    //    property var touch_li_start: {
    //        "caption":"Long Interval Start Intervals",
    //        "value":"24",
    //        "state":"enabled",
    //        "values":[],
    //        "scales":["1020","0","4"]
    //    }
    property var touch_li_start_caption: {
        "caption":"Long Interval Start Intervals"
    }

    property var touch_li_start_value: {
        "value":"24"
    }

    property var touch_li_start_state:{
        "state":"enabled"
    }

    property var touch_li_start_scales: {
        "scales":["1020","0","4"]
    }

    property var default_touch_first_gain0_7: {
        "caption":"CIN0-7 1st Gain (fF)",
        "value":"200",
        "state":"enabled",
        "values":["1600Min","1500","1400","1300","1200","1100","1000","900","800","700","600","500","400","300","200","100Max"],
        "scales":[]
    }

    property var touch_first_gain0_7_caption: {
        "caption":"Sensors 0-7 1st Gain (fF)"
    }

    property var touch_first_gain0_7_value: {
        "value":"200"
    }

    property var touch_first_gain0_7_state:{
        "state":"enabled"
    }

    property var touch_first_gain0_7_values: {
        "values":["1600Min","1500","1400","1300","1200","1100","1000","900","800","700","600","500","400","300","200","100Max"]
    }


    property var default_touch_first_gain8_15: {
        "caption":"CIN8-15 1st Gain (fF)",
        "value":"200",
        "state":"enabled",
        "values":["1600Min","1500","1400","1300","1200","1100","1000","900","800","700","600","500","400","300","200","100Max"],
        "scales":[]
    }

    property var touch_first_gain8_15_caption: {
        "caption":"Sensors 8-15 1st Gain (fF)"
    }

    property var touch_first_gain8_15_value: {
        "value":"200"
    }

    property var touch_first_gain8_15_state:{
        "state":"enabled"
    }

    property var touch_first_gain8_15_values: {
        "values":["1600Min","1500","1400","1300","1200","1100","1000","900","800","700","600","500","400","300","200","100Max"]
    }

    property var default_touch_second_gain: {
        "caption":"2nd Gain",
        "value":"",
        "state":"enabled",
        "values":["2","2","2","2","2","2","2","2","2","2","2","2","5","5","5","5"],
        "scales":[]
    }

    property var touch_second_gain_state:{
        "state":"enabled"
    }

    property var touch_second_gain_values: {
        "values":["2","2","2","2","2","2","2","2","2","2","2","2","5","5","5","5"]
    }

    property var default_touch_cin_thres: {
        "caption":"Threshold",
        "value":"",
        "state":"enabled",
        "values":["50","50","50","50","50","50","50","50","50","50","50","50","3","3","3","3"],
        "scales":["127","1","1"]
    }


    property var touch_cin_thres_state:{
        "state":"enabled"
    }

    property var touch_cin_thres_values: {
        "values":["50","50","50","50","50","50","50","50","50","50","50","50","3","3","3","3"]
    }

    property var default_touch_cin_en: {
        "caption":"Gain",
        "value":"",
        "state":"enabled",
        "values":["1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1"],
        "scales":[]
    }

    property var touch_cin_en_values: {
        "values":["1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1"]
    }


    property var default_touch_calerr: {
        "caption":"CALERR",
        "value":"0",
        "state":"disabled",
        "values":[],
        "scales":[]
    }

    property var touch_calerr_caption: {
        "caption":"CALERR"
    }

    property var touch_calerr_value: {
        "value":"0"
    }

    property var touch_calerr_state: {
        "state":"disabled"
    }

    property var default_touch_syserr: {
        "caption":"SYSERR",
        "value":"0",
        "state":"disabled",
        "values":[],
        "scales":[]
    }



    property var touch_syserr_caption: {
        "caption":"SYSERR"
    }

    property var touch_syserr_value: {
        "value":"0"
    }

    property var touch_syserr_state: {
        "state":"disabled"
    }

    //New sensor Type

    property var set_sensor_type:({
                                      "cmd" : "sensor",
                                      "payload": {
                                          "value": ""
                                      },
                                      update: function (value) {
                                          this.set(value)
                                          CorePlatformInterface.send(this)
                                      },
                                      set: function (value) {
                                          this.payload.value = value;
                                      },
                                      send: function () { CorePlatformInterface.send(this) },
                                      show: function () { CorePlatformInterface.show(this) }

                                  })


    property var sensor_value: {
        "value": "touch"
    }





    // -------------------------------------------------------------------
    // Connect to CoreInterface notification signals
    //
    Connections {
        target: coreInterface
        onNotification: {
            CorePlatformInterface.data_source_handler(payload)
        }
    }

    property var conv_noti
    property var conv_alert_noti
    property var therm_hyst
    property var therm_ext
    property var therm_int
    // DEBUG Window for testing motor vortex UI without a platform
    Window {
        id: debug
        visible: true
        width: 200
        height: 400

        Button {
            id: button1
            //   anchors { top: button1.bottom }
            text: "send sensor"
            onClicked: {

                CorePlatformInterface.data_source_handler('{
                                    "value":"sensor_value",
                                    "payload":{
                                                "value": "invalid"

                                               }
                                             }')
            }
        }
    }
    //        Button {
    //            id: button2
    //            anchors { top: button1.bottom }
    //            text: "send ext low lim"
    //            onClicked: {
    //                platformInterface.get_ext_low_lim.update()
    //                //                CorePlatformInterface.data_source_handler('{
    //                //                            "value":"nct72_get_ext_low_lim",
    //                //                            "payload":{
    //                //                                        "integer": ' + Math.random() + ' ,
    //                //                                        "fraction": "' + Math.random() + '"
    //                //                                       }
    //                //                                     }')

    //            }
    //        }
    //        Button {
    //            id: button3
    //            anchors { top: button2.bottom }
    //            text: "send conv alert"
    //            onClicked: {
    //                platformInterface.get_cons_alert.update()
    //                var items = ["1","2","3","4"]
    //                var value = items[Math.floor(Math.random()*items.length)]
    //                conv_alert_noti = value
    //                CorePlatformInterface.data_source_handler('{
    //                                "value":"nct72_get_cons_alert",
    //                                "payload":{
    //                                            "cons_alert:" '+ (value) +'
    //                                           }
    //                                         }')

    //            }
    //        }
    //        Button {
    //            id: button4
    //            anchors { top: button3.bottom }
    //            text: "get manufacturers ID "
    //            onClicked: {
    //                platformInterface.get_man_id.update()
    //            }
    //        }
    //        Button {
    //            id: button5
    //            anchors { top: button4.bottom }
    //            text: "get Therm Hyst "
    //            onClicked: {
    //                platformInterface.get_therm_hyst.update()
    //                var value = Math.random() * 256
    //                therm_hyst = parseInt(value)
    //                CorePlatformInterface.data_source_handler('{
    //                                "value":"nct72_get_therm_hyst",
    //                                "payload":{
    //                                            "hyst:" '+therm_hyst+'
    //                                           }
    //                                         }')

    //            }
    //        }
    //        Button {
    //            id: button6
    //            anchors { top: button5.bottom }
    //            text: "get Therm ext "
    //            onClicked: {
    //                platformInterface.get_therm_limits.update()
    //                var value_ext = Math.random() * 256
    //                var value_int = Math.random() * 256
    //                therm_ext = parseInt(value_ext)
    //                therm_int = parseInt(value_int)
    //                CorePlatformInterface.data_source_handler('{
    //                                "value":"nct72_get_therm_limits",
    //                                "payload":{
    //                                            "external:" '+value_ext+',
    //                                            "internal:" '+value_int+'

    //                                           }
    //                                         }')

    //            }
    //        }
    //        Button {
    //            id: button7
    //            anchors { top: button6.bottom }
    //            text: "get config "
    //            onClicked: {
    //                platformInterface.get_nct72_config.update()


    //            }
    //        }



    // }
    //        Button {
    //            anchors { top: button2.bottom }
    //            text: "send"
    //            onClicked: {
    //                CorePlatformInterface.data_source_handler('{
    //                            "value":"read_temperature_sensor",
    //                            "payload":{
    //                                     "temperature": '+ (Math.random()*100).toFixed(0) +'
    //                            }
    //                    }
    //            ')
    //            }
    //        }
    //   }


}
