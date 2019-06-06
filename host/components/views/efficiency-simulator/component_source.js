.pragma library

// internal private state
var last_MOSFET = "";

// move to service to populate data in future
function getComponent(id) {
//    console.log("Component::getComponent", id);
    for ( var i=0; i < components.length; i++ ) {
        if ( components[i].component_id === id ) {
            return components[i];
        }
    }
}

function loadComponentIdsIntoModel(type, model) {
    for ( var i=0; i < components.length; i++ ) {
        if (components[i].type === type){
            model.append({ "component_id": components[i].component_id } )
        }
    }
}

function loadComponentsIntoModel(type, model) {
    for ( var i=0; i < components.length; i++ ) {
        if (components[i].type === type){
            model.append(components[i])
        }
    }
}

// will be populated via service rest call in the future
var components = [
            {
                "type": "MOSFET",
                "component_id": "NTMFS4C05",
                "RDSon45": 4,
                "Coss": 1215,
                "Qgd": 5,
                "Qgs": 6,
                "Vth": 1.7,
                "SDDiodeForwardVoltage": 0.77,
                "Transconductance": 68,
                "InternalRgin": 0.69,
                "ThermalResistance": 48.6,
                "RDSonTemperatureCoefficient": 0.0049,
                "RDSon10": 2.7,
                "measuredQrr": 30.2,
                "ForwardConductingCurrentInMeasuringQrr": 30,
                "QrrCharacterizationVoltage": 15,
                "Qg45": 14,
                "Qg10": 30,
                "IDMax": 50,
                "LowSideMOSFETOnlyOrBoth": "both",
                "Packgage": "so-8fl"
            },
            {
                "type": "MOSFET",
                "component_id": "NTMFS4C06",
                "RDSon45": 4.8,
                "Coss": 841,
                "Qgd": 4,
                "Qgs": 4.7,
                "Vth": 1.7,
                "SDDiodeForwardVoltage": 0.8,
                "Transconductance": 58,
                "InternalRgin": 1,
                "ThermalResistance": 49,
                "RDSonTemperatureCoefficient": 0.0052,
                "RDSon10": 3.2,
                "measuredQrr": 22,
                "ForwardConductingCurrentInMeasuringQrr": 30,
                "QrrCharacterizationVoltage": 15,
                "Qg45": 11.6,
                "Qg10": 26,
                "IDMax": 69,
                "LowSideMOSFETOnlyOrBoth": "both",
                "Packgage": "so-8fl"
            },
            {
                "type": "MOSFET",
                "component_id": "NTMFS4C08",
                "RDSon45": 6.8,
                "Coss": 702,
                "Qgd": 3.3,
                "Qgs": 3.5,
                "Vth": 1.7,
                "SDDiodeForwardVoltage": 0.79,
                "Transconductance": 42,
                "InternalRgin": 1,
                "ThermalResistance": 49.8,
                "RDSonTemperatureCoefficient": 0.0047,
                "RDSon10": 4.6,
                "measuredQrr": 15.3,
                "ForwardConductingCurrentInMeasuringQrr": 30,
                "QrrCharacterizationVoltage": 15,
                "Qg45": 8.4,
                "Qg10": 18.2,
                "IDMax": 50,
                "LowSideMOSFETOnlyOrBoth": "both",
                "Packgage": "so-8fl"
            },
            {
                "type": "MOSFET",
                "component_id": "NTMFS4C09",
                "RDSon45": 6.8,
                "Coss": 610,
                "Qgd": 5.4,
                "Qgs": 3.4,
                "Vth": 1.7,
                "SDDiodeForwardVoltage": 0.79,
                "Transconductance": 50,
                "InternalRgin": 1,
                "ThermalResistance": 49.8,
                "RDSonTemperatureCoefficient": 0.0052,
                "RDSon10": 4.6,
                "measuredQrr": 15,
                "ForwardConductingCurrentInMeasuringQrr": 30,
                "QrrCharacterizationVoltage": 15,
                "Qg45": 10.9,
                "Qg10": 22.2,
                "IDMax": 52,
                "LowSideMOSFETOnlyOrBoth": "both",
                "Packgage": "so-8fl"
            },
            {
                "type": "MOSFET",
                "component_id": "NTMFS4C10",
                "RDSon45": 8.9,
                "Coss": 574,
                "Qgd": 3.7,
                "Qgs": 2.7,
                "Vth": 1.7,
                "SDDiodeForwardVoltage": 0.8,
                "Transconductance": 43,
                "InternalRgin": 0.68,
                "ThermalResistance": 50.3,
                "RDSonTemperatureCoefficient": 0.0046,
                "RDSon10": 5.8,
                "measuredQrr": 13.7,
                "ForwardConductingCurrentInMeasuringQrr": 30,
                "QrrCharacterizationVoltage": 15,
                "Qg45": 9.8,
                "Qg10": 18.9,
                "IDMax": 50,
                "LowSideMOSFETOnlyOrBoth": "both",
                "Packgage": "so-8fl"
            },
            {
                "type": "MOSFET",
                "component_id": "NTMFS4C13",
                "RDSon45": 11.4,
                "Coss": 443,
                "Qgd": 3.7,
                "Qgs": 2.9,
                "Vth": 1.7,
                "SDDiodeForwardVoltage": 0.82,
                "Transconductance": 40,
                "InternalRgin": 1,
                "ThermalResistance": 50.8,
                "RDSonTemperatureCoefficient": 0.0048,
                "RDSon10": 7.3,
                "measuredQrr": 9.7,
                "ForwardConductingCurrentInMeasuringQrr": 30,
                "QrrCharacterizationVoltage": 15,
                "Qg45": 7.8,
                "Qg10": 15.2,
                "IDMax": 50,
                "LowSideMOSFETOnlyOrBoth": "both",
                "Packgage": "so-8fl"
            },
            {
                "type": "MOSFET",
                "component_id": "NTTFS4C05",
                "RDSon45": 4.1,
                "Coss": 1224,
                "Qgd": 5.5,
                "Qgs": 5.2,
                "Vth": 1.75,
                "SDDiodeForwardVoltage": 0.77,
                "Transconductance": 68,
                "InternalRgin": 1,
                "ThermalResistance": 57.8,
                "RDSonTemperatureCoefficient": 0.005,
                "RDSon10": 2.9,
                "measuredQrr": 34.4,
                "ForwardConductingCurrentInMeasuringQrr": 30,
                "QrrCharacterizationVoltage": 15,
                "Qg45": 14.5,
                "Qg10": 31,
                "IDMax": 75,
                "LowSideMOSFETOnlyOrBoth": "both",
                "Packgage": "u-8FL"
            },
            {
                "type": "MOSFET",
                "component_id": "NTTFS4C10",
                "RDSon45": 8.8,
                "Coss": 574,
                "Qgd": 6.1,
                "Qgs": 2.6,
                "Vth": 1.75,
                "SDDiodeForwardVoltage": 0.8,
                "Transconductance": 43,
                "InternalRgin": 1,
                "ThermalResistance": 59.9,
                "RDSonTemperatureCoefficient": 0.0046,
                "RDSon10": 5.9,
                "measuredQrr": 8.3,
                "ForwardConductingCurrentInMeasuringQrr": 30,
                "QrrCharacterizationVoltage": 15,
                "Qg45": 10.1,
                "Qg10": 19.3,
                "IDMax": 44,
                "LowSideMOSFETOnlyOrBoth": "both",
                "Packgage": "u-8FL"
            },
            {
                "type": "MOSFET",
                "component_id": "NTTFS4C25",
                "RDSon45": 21,
                "Coss": 295,
                "Qgd": 2.7,
                "Qgs": 1.7,
                "Vth": 1.75,
                "SDDiodeForwardVoltage": 0.87,
                "Transconductance": 23,
                "InternalRgin": 1,
                "ThermalResistance": 76.7,
                "RDSonTemperatureCoefficient": 0.0046,
                "RDSon10": 13,
                "measuredQrr": 5.7,
                "ForwardConductingCurrentInMeasuringQrr": 30,
                "QrrCharacterizationVoltage": 15,
                "Qg45": 5.1,
                "Qg10": 10.3,
                "IDMax": 27,
                "LowSideMOSFETOnlyOrBoth": "both",
                "Packgage": "u-8FL"
            },
            {
                "type": "MOSFET",
                "component_id": "NTMFS4C35",
                "RDSon45": 3.4,
                "Coss": 1097,
                "Qgd": 5.5,
                "Qgs": 6.5,
                "Vth": 1.75,
                "SDDiodeForwardVoltage": 0.8,
                "Transconductance": 50,
                "InternalRgin": 1,
                "ThermalResistance": 48.3,
                "RDSonTemperatureCoefficient": 0.0048,
                "RDSon10": 2.6,
                "measuredQrr": 30,
                "ForwardConductingCurrentInMeasuringQrr": 30,
                "QrrCharacterizationVoltage": 15,
                "Qg45": 15,
                "Qg10": 32.5,
                "IDMax": 80,
                "LowSideMOSFETOnlyOrBoth": "both",
                "Packgage": "so-8fl"
            },
            {
                "type": "MOSFET",
                "component_id": "NTTFS4C06",
                "RDSon45": 4.9,
                "Coss": 841,
                "Qgd": 4,
                "Qgs": 4.7,
                "Vth": 1.75,
                "SDDiodeForwardVoltage": 0.8,
                "Transconductance": 58,
                "InternalRgin": 1,
                "ThermalResistance": 58,
                "RDSonTemperatureCoefficient": 0.0052,
                "RDSon10": 3.4,
                "measuredQrr": 22,
                "ForwardConductingCurrentInMeasuringQrr": 30,
                "QrrCharacterizationVoltage": 15,
                "Qg45": 11.6,
                "Qg10": 26,
                "IDMax": 67,
                "LowSideMOSFETOnlyOrBoth": "low",
                "Packgage": "u-8FL"
            },
            {
                "type": "MOSFET",
                "component_id": "NTTFS4C13",
                "RDSon45": 11.2,
                "Coss": 443,
                "Qgd": 3.7,
                "Qgs": 2.9,
                "Vth": 1.75,
                "SDDiodeForwardVoltage": 0.82,
                "Transconductance": 40,
                "InternalRgin": 1,
                "ThermalResistance": 60.8,
                "RDSonTemperatureCoefficient": 0.0048,
                "RDSon10": 7.5,
                "measuredQrr": 9.7,
                "ForwardConductingCurrentInMeasuringQrr": 30,
                "QrrCharacterizationVoltage": 15,
                "Qg45": 7.8,
                "Qg10": 15.2,
                "IDMax": 38,
                "LowSideMOSFETOnlyOrBoth": "both",
                "Packgage": "u-8FL"
            },
            {
                "type": "MOSFET",
                "component_id": "NTTFS4C08",
                "RDSon45": 7.2,
                "Coss": 702,
                "Qgd": 3.3,
                "Qgs": 3.5,
                "Vth": 1.75,
                "SDDiodeForwardVoltage": 0.79,
                "Transconductance": 42,
                "InternalRgin": 1,
                "ThermalResistance": 58.8,
                "RDSonTemperatureCoefficient": 0.0046,
                "RDSon10": 4.7,
                "measuredQrr": 15.3,
                "ForwardConductingCurrentInMeasuringQrr": 30,
                "QrrCharacterizationVoltage": 15,
                "Qg45": 8.4,
                "Qg10": 18.2,
                "IDMax": 52,
                "LowSideMOSFETOnlyOrBoth": "both",
                "Packgage": "u-8FL"
            },
            {
                "type": "MOSFET",
                "component_id": "NVTFS4C05",
                "RDSon45": 4.1,
                "Coss": 1224,
                "Qgd": 5.5,
                "Qgs": 5.2,
                "Vth": 1.75,
                "SDDiodeForwardVoltage": 0.77,
                "Transconductance": 68,
                "InternalRgin": 1,
                "ThermalResistance": 47,
                "RDSonTemperatureCoefficient": 0.0053,
                "RDSon10": 2.9,
                "measuredQrr": 34.4,
                "ForwardConductingCurrentInMeasuringQrr": 30,
                "QrrCharacterizationVoltage": 15,
                "Qg45": 14.5,
                "Qg10": 31,
                "IDMax": 102,
                "LowSideMOSFETOnlyOrBoth": "low",
                "Packgage": "u-8FL"
            },
            {
                "type": "MOSFET",
                "component_id": "NVTFS4C10",
                "RDSon45": 8.8,
                "Coss": 574,
                "Qgd": 6.1,
                "Qgs": 2.6,
                "Vth": 1.75,
                "SDDiodeForwardVoltage": 0.8,
                "Transconductance": 43,
                "InternalRgin": 1,
                "ThermalResistance": 50,
                "RDSonTemperatureCoefficient": 0.005,
                "RDSon10": 5.9,
                "measuredQrr": 8.3,
                "ForwardConductingCurrentInMeasuringQrr": 30,
                "QrrCharacterizationVoltage": 15,
                "Qg45": 10.1,
                "Qg10": 19.3,
                "IDMax": 47,
                "LowSideMOSFETOnlyOrBoth": "both",
                "Packgage": "u-8FL"
            },
            {
                "type": "MOSFET",
                "component_id": "NVTFS4C25",
                "RDSon45": 21,
                "Coss": 295,
                "Qgd": 2.7,
                "Qgs": 1.7,
                "Vth": 1.75,
                "SDDiodeForwardVoltage": 0.87,
                "Transconductance": 23,
                "InternalRgin": 1,
                "ThermalResistance": 50,
                "RDSonTemperatureCoefficient": 0.0049,
                "RDSon10": 13,
                "measuredQrr": 5.7,
                "ForwardConductingCurrentInMeasuringQrr": 30,
                "QrrCharacterizationVoltage": 15,
                "Qg45": 5.1,
                "Qg10": 10.3,
                "IDMax": 22,
                "LowSideMOSFETOnlyOrBoth": "both",
                "Packgage": "u-8FL"
            },
            {
                "type": "MOSFET",
                "component_id": "NTTFS4H07N",
                "RDSon45": 5.8,
                "Coss": 525,
                "Qgd": 1.26,
                "Qgs": 2.5,
                "Vth": 1.6,
                "SDDiodeForwardVoltage": 0.78,
                "Transconductance": 49,
                "InternalRgin": 1,
                "ThermalResistance": 47.3,
                "RDSonTemperatureCoefficient": 0.0048,
                "RDSon10": 3.8,
                "measuredQrr": 8,
                "ForwardConductingCurrentInMeasuringQrr": 10,
                "QrrCharacterizationVoltage": 15,
                "Qg45": 5.7,
                "Qg10": 12.4,
                "IDMax": 66,
                "LowSideMOSFETOnlyOrBoth": "both",
                "Packgage": "u-8FL"
            },
            {
                "type": "MOSFET",
                "component_id": "NTTFS4H05N",
                "RDSon45": 3.8,
                "Coss": 835,
                "Qgd": 1.88,
                "Qgs": 3.6,
                "Vth": 1.65,
                "SDDiodeForwardVoltage": 0.78,
                "Transconductance": 69,
                "InternalRgin": 1,
                "ThermalResistance": 47,
                "RDSonTemperatureCoefficient": 0.0054,
                "RDSon10": 2.5,
                "measuredQrr": 20,
                "ForwardConductingCurrentInMeasuringQrr": 10,
                "QrrCharacterizationVoltage": 15,
                "Qg45": 8.7,
                "Qg10": 18.9,
                "IDMax": 94,
                "LowSideMOSFETOnlyOrBoth": "both",
                "Packgage": "u-8FL"
            },
            {
                "type": "MOSFET",
                "component_id": "NTMFS4H02N",
                "RDSon45": 1.7,
                "Coss": 1814,
                "Qgd": 4.2,
                "Qgs": 7.2,
                "Vth": 1.65,
                "SDDiodeForwardVoltage": 0.75,
                "Transconductance": 84,
                "InternalRgin": 1,
                "ThermalResistance": 40,
                "RDSonTemperatureCoefficient": 0.0048,
                "RDSon10": 1.1,
                "measuredQrr": 51,
                "ForwardConductingCurrentInMeasuringQrr": 30,
                "QrrCharacterizationVoltage": 15,
                "Qg45": 18,
                "Qg10": 38.5,
                "IDMax": 193,
                "LowSideMOSFETOnlyOrBoth": "low",
                "Packgage": "so-8fl"
            },
            {
                "type": "MOSFET",
                "component_id": "NTMFS4H02NF",
                "RDSon45": 1.6,
                "Coss": 1644,
                "Qgd": 4.3,
                "Qgs": 7.5,
                "Vth": 1.65,
                "SDDiodeForwardVoltage": 0.38,
                "Transconductance": 84,
                "InternalRgin": 1,
                "ThermalResistance": 40,
                "RDSonTemperatureCoefficient": 0.0048,
                "RDSon10": 1.1,
                "measuredQrr": 30,
                "ForwardConductingCurrentInMeasuringQrr": 30,
                "QrrCharacterizationVoltage": 15,
                "Qg45": 18.7,
                "Qg10": 40.9,
                "IDMax": 193,
                "LowSideMOSFETOnlyOrBoth": "low",
                "Packgage": "so-8fl"
            },
            {
                "type": "MOSFET",
                "component_id": "NTMFS4H01N",
                "RDSon45": 0.76,
                "Coss": 3718,
                "Qgd": 8.5,
                "Qgs": 14,
                "Vth": 1.65,
                "SDDiodeForwardVoltage": 0.75,
                "Transconductance": 101,
                "InternalRgin": 1.2,
                "ThermalResistance": 38.9,
                "RDSonTemperatureCoefficient": 0.0048,
                "RDSon10": 0.6,
                "measuredQrr": 90,
                "ForwardConductingCurrentInMeasuringQrr": 30,
                "QrrCharacterizationVoltage": 15,
                "Qg45": 39,
                "Qg10": 85,
                "IDMax": 334,
                "LowSideMOSFETOnlyOrBoth": "low",
                "Packgage": "so-8fl"
            },
            {
                "type": "MOSFET",
                "component_id": "NTMFS4H01NF",
                "RDSon45": 0.79,
                "Coss": 3416,
                "Qgd": 8,
                "Qgs": 11.8,
                "Vth": 1.65,
                "SDDiodeForwardVoltage": 0.35,
                "Transconductance": 101,
                "InternalRgin": 1.3,
                "ThermalResistance": 38.9,
                "RDSonTemperatureCoefficient": 0.0048,
                "RDSon10": 0.6,
                "measuredQrr": 90,
                "ForwardConductingCurrentInMeasuringQrr": 30,
                "QrrCharacterizationVoltage": 15,
                "Qg45": 37.8,
                "Qg10": 82,
                "IDMax": 334,
                "LowSideMOSFETOnlyOrBoth": "low",
                "Packgage": "so-8fl"
            },
            {
                "type": "MOSFET",
                "component_id": "NTMFS4H013NF",
                "RDSon45": 1.1,
                "Coss": 2537,
                "Qgd": 5.8,
                "Qgs": 10.7,
                "Vth": 1.65,
                "SDDiodeForwardVoltage": 0.38,
                "Transconductance": 119,
                "InternalRgin": 1,
                "ThermalResistance": 40,
                "RDSonTemperatureCoefficient": 0.0053,
                "RDSon10": 0.7,
                "measuredQrr": 66,
                "ForwardConductingCurrentInMeasuringQrr": 30,
                "QrrCharacterizationVoltage": 15,
                "Qg45": 26,
                "Qg10": 56,
                "IDMax": 43,
                "LowSideMOSFETOnlyOrBoth": "low",
                "Packgage": "so-8fl"
            },
            {
                "type": "MOSFET",
                "component_id": "NTMFS5C404NL",
                "RDSon45": 0.85,
                "Coss": 4538,
                "Qgd": 23.8,
                "Qgs": 27.8,
                "Vth": 1.6,
                "SDDiodeForwardVoltage": 0.7,
                "Transconductance": 270,
                "InternalRgin": 1.2,
                "ThermalResistance": 39,
                "RDSonTemperatureCoefficient": 0.0076,
                "RDSon10": 0.6,
                "measuredQrr": 190,
                "ForwardConductingCurrentInMeasuringQrr": 50,
                "QrrCharacterizationVoltage": 15,
                "Qg45": 81,
                "Qg10": 181,
                "IDMax": 339,
                "LowSideMOSFETOnlyOrBoth": "both",
                "Packgage": "so-8fl"
            },
            {
                "type": "MOSFET",
                "component_id": "NTMFS5C410NL",
                "RDSon45": 1,
                "Coss": 4156,
                "Qgd": 22,
                "Qgs": 21.4,
                "Vth": 1.6,
                "SDDiodeForwardVoltage": 0.73,
                "Transconductance": 190,
                "InternalRgin": 1.2,
                "ThermalResistance": 39,
                "RDSonTemperatureCoefficient": 0.0056,
                "RDSon10": 0.7,
                "measuredQrr": 126,
                "ForwardConductingCurrentInMeasuringQrr": 50,
                "QrrCharacterizationVoltage": 15,
                "Qg45": 66,
                "Qg10": 143,
                "IDMax": 302,
                "LowSideMOSFETOnlyOrBoth": "both",
                "Packgage": "so-8fl"
            },
            {
                "type": "MOSFET",
                "component_id": "NTMFS5C442NL",
                "RDSon45": 3.2,
                "Coss": 1100,
                "Qgd": 6.7,
                "Qgs": 9.8,
                "Vth": 1.6,
                "SDDiodeForwardVoltage": 0.85,
                "Transconductance": 116,
                "InternalRgin": 1.2,
                "ThermalResistance": 41,
                "RDSonTemperatureCoefficient": 0.0056,
                "RDSon10": 2.2,
                "measuredQrr": 40,
                "ForwardConductingCurrentInMeasuringQrr": 50,
                "QrrCharacterizationVoltage": 15,
                "Qg45": 23,
                "Qg10": 50,
                "IDMax": 121,
                "LowSideMOSFETOnlyOrBoth": "both",
                "Packgage": "so-8fl"
            },
            {
                "type": "MOSFET",
                "component_id": "NTMFS5C604NL",
                "RDSon45": 1.25,
                "Coss": 3750,
                "Qgd": 12.7,
                "Qgs": 21.4,
                "Vth": 1.6,
                "SDDiodeForwardVoltage": 0.78,
                "Transconductance": 180,
                "InternalRgin": 1.8,
                "ThermalResistance": 39,
                "RDSonTemperatureCoefficient": 0.0064,
                "RDSon10": 0.9,
                "measuredQrr": 190,
                "ForwardConductingCurrentInMeasuringQrr": 50,
                "QrrCharacterizationVoltage": 15,
                "Qg45": 52,
                "Qg10": 120,
                "IDMax": 276,
                "LowSideMOSFETOnlyOrBoth": "both",
                "Packgage": "so-8fl"
            },
            {
                "type": "MOSFET",
                "component_id": "NTMFS5C612NL",
                "RDSon45": 1.65,
                "Coss": 2953,
                "Qgd": 10.9,
                "Qgs": 17.1,
                "Vth": 1.6,
                "SDDiodeForwardVoltage": 0.78,
                "Transconductance": 151,
                "InternalRgin": 1.6,
                "ThermalResistance": 39,
                "RDSonTemperatureCoefficient": 0.0064,
                "RDSon10": 1.2,
                "measuredQrr": 105,
                "ForwardConductingCurrentInMeasuringQrr": 50,
                "QrrCharacterizationVoltage": 15,
                "Qg45": 41,
                "Qg10": 91,
                "IDMax": 226,
                "LowSideMOSFETOnlyOrBoth": "both",
                "Packgage": "so-8fl"
            },
            {
                "type": "MOSFET",
                "component_id": "NTMFS5C646NL",
                "RDSon45": 5,
                "Coss": 900,
                "Qgd": 5.1,
                "Qgs": 5.6,
                "Vth": 1.6,
                "SDDiodeForwardVoltage": 0.88,
                "Transconductance": 105,
                "InternalRgin": 1.5,
                "ThermalResistance": 41,
                "RDSonTemperatureCoefficient": 0.0064,
                "RDSon10": 3.8,
                "measuredQrr": 32,
                "ForwardConductingCurrentInMeasuringQrr": 50,
                "QrrCharacterizationVoltage": 15,
                "Qg45": 15.7,
                "Qg10": 33.7,
                "IDMax": 89,
                "LowSideMOSFETOnlyOrBoth": "both",
                "Packgage": "so-8fl"
            },
            {
                "type": "driver",
                "component_id": "NCP5911",
                "MaximDriverVoltage": 6.5,
                "SourcingResistance": 0.9,
                "SinkingResistance": 0.7,
                "RiseDelayTime": 30,
                "FallDelayTime": 15,
                "ExternalGateResistance": 0,
                "QuiescentCurrent": 1,
            },
            {
                "type": "driver",
                "component_id": "NCP5901",
                "MaximDriverVoltage": 15,
                "SourcingResistance": 2,
                "SinkingResistance": 1,
                "RiseDelayTime": 27,
                "FallDelayTime": 20,
                "ExternalGateResistance": 0,
                "QuiescentCurrent": 2
            },
            {
                "type": "driver",
                "component_id": "NCP5359A",
                "MaximDriverVoltage": 15,
                "SourcingResistance": 2,
                "SinkingResistance": 1,
                "RiseDelayTime": 20,
                "FallDelayTime": 20,
                "ExternalGateResistance": 0,
                "QuiescentCurrent": 5,
            },
            {
                "type": "driver",
                "component_id": "NCP3418",
                "MaximDriverVoltage": 15,
                "SourcingResistance": 1.8,
                "SinkingResistance": 1,
                "RiseDelayTime": 30,
                "FallDelayTime": 25,
                "ExternalGateResistance": 0,
                "QuiescentCurrent": 0
            },
            {
                "type": "driver",
                "component_id": "NCP81151",
                "MaximDriverVoltage": 5.5,
                "SourcingResistance": 0.9,
                "SinkingResistance": 0.7,
                "RiseDelayTime": 25,
                "FallDelayTime": 20,
                "ExternalGateResistance": 0,
                "QuiescentCurrent": 1
            },
            {
                "type": "driver",
                "component_id": "NCP81161",
                "MaximDriverVoltage": 15,
                "SourcingResistance": 1.9,
                "SinkingResistance": 1,
                "RiseDelayTime": 20,
                "FallDelayTime": 20,
                "ExternalGateResistance": 0,
                "QuiescentCurrent": 2
            }
        ]