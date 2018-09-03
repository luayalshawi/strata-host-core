.pragma library
.import "qrc:/js/navigation_control.js" as NavigationControl

var isInitialized = false
var platformListModel
var coreInterface
var documentManager

function initialize (newModel, newCoreInterface, newDocumentManager) {
    isInitialized = true
    platformListModel = newModel
    coreInterface = newCoreInterface
    documentManager = newDocumentManager
}

function populatePlatforms(platform_list_json) {
    var autoSelectEnabled = true
    var autoSelectedPlatform = null
    var autoSelectedIndex = 0

    // Map out UUID->platform name
    // Lookup table
    //  platform_id -> local qml directory holding interface
    //to enable a new board UI to be shown, this list has to be edited to include the exact UUID for the boad.
    //the other half of the map will be the name of the directory that will be used to show the initial screen (e.g. usb-pd/Control.qml)
    var uuid_map = {
        "P2.2017.1.1.0.0.cbde0519-0f42-4431-a379-caee4a1494af" : "usb-pd",
        //"P2.2017.1.1.0.0.cbde0519-0f42-4431-a379-caee4a1494af" : "motor-vortex",
        "P2.2018.1.1.0.0.c9060ff8-5c5e-4295-b95a-d857ee9a3671" : "bubu",
        "motorvortex1" : "motor-vortex",
        "SEC.2018.004.1.1.0.2.20180710161919.1bfacee3-fb60-471d-98f8-fe597bb222cd" : "usb-pd-multiport",
        "SEC.2018.004.1.0.1.0.20180717143337.6828783d-b672-4fd5-b66b-370a41c035d2" : "usb-pd-multiport",    //david ralley's new board
        "P2.2018.0.0.0.0.00000000-0000-0000-0000-000000000000" : "usb-pd-multiport",
        "SEC.2017.038.0.0.0.0.20190816120000.cbde0519-0f42-4431-a379-caee4a1494af": "usb-pd-multiport"
    }

    platformListModel.clear()
    platformListModel.append({ "text" : "Select a Platform..." })
    // Parse JSON
    try {
        console.log("populatePlaforms: ", platform_list_json)
        var platform_list = JSON.parse(platform_list_json)
        console.log("number of platforms in list:",platform_list.list.length);

        for (var i = 0; i < platform_list.list.length; i ++){
            // Extract platform verbose name and UUID
            var platform_info = {
                "text" : platform_list.list[i].verbose,
                "verbose" : platform_list.list[i].verbose,
                "name" : uuid_map[platform_list.list[i].uuid],
                "connection" : platform_list.list[i].connection,
                "uuid"  :   platform_list.list[i].uuid
            }

            // Append text to state the type of Connection
            if(platform_info.connection === "remote"){
                platform_info.text += " (Remote)"
            }
            else if (platform_info.connection === "view"){
                platform_info.text += " (View-only)"
            }
            else if (platform_info.connection === "connected"){
                platform_info.text += " (Connected)"
                // copy "connected" platform; Note: this will auto select the last listed "connected" platform
                console.log("autoconnect =",platform_info.text);
                autoSelectedPlatform = platform_info
                autoSelectedIndex = i+1 //+1 due to default "select a platform entry"
            } else {
                console.log("unknown connection type for ",platform_info.text," ",platform_info.connection);
            }

            // Add to the model
            platformListModel.append(platform_info)
        }
    }
    catch(err) {
        console.log("CoreInterface error:", err.toString())
        platformListModel.clear()
        platformListModel.append({ "text" : "Select a Platform..." })
        platformListModel.append({ "text" : "No Platforms Available" } )
    }

    // Auto Select "connected" platform
    if ( autoSelectEnabled && autoSelectedPlatform) {
        console.log("Auto selecting connected platform: ", autoSelectedPlatform.name)
        sendSelection( autoSelectedIndex )


        // For Demo purposes only; Immediately go to control
//        var data = { platform_name: autoSelectedPlatform.name}
//        coreInterface.sendSelectedPlatform(autoSelectedPlatform.uuid, autoSelectedPlatform.connection)
//        NavigationControl.updateState(NavigationControl.events.NEW_PLATFORM_CONNECTED_EVENT,data)
//        platformListModel.currentIndex = autoSelectedIndex
//        platformListModel.selectedConnection = "connected"
    }
    else if ( autoSelectEnabled == false){
        console.log("Auto selecting disabled.")
    }
}

function sendSelection (currentIndex) {
    platformListModel.currentIndex = currentIndex
    platformListModel.selectedConnection = ""
    /*
        Determine action depending on what type of 'connection' is used
    */
    NavigationControl.updateState(NavigationControl.events.PLATFORM_DISCONNECTED_EVENT, null)
    var disconnect_json = {"hcs::cmd":"disconnect_platform"}
    console.log("disonnecting the platform")
    coreInterface.sendCommand(JSON.stringify(disconnect_json))

    var connection = platformListModel.get(currentIndex).connection
    var data = { platform_name: platformListModel.get(currentIndex).name}

    // Clear all documents for contents
    documentManager.clearDocumentSets();

    if (connection === "view") {
        platformListModel.selectedConnection = "view"
        // Go offline-mode
        NavigationControl.updateState(NavigationControl.events.OFFLINE_MODE_EVENT, data)
        coreInterface.sendSelectedPlatform(platformListModel.get(currentIndex).uuid,platformListModel.get(currentIndex).connection)
        if (!NavigationControl.flipable_parent_.flipped) {
            NavigationControl.updateState(NavigationControl.events.TOGGLE_CONTROL_CONTENT)
        }
    }
    else if (connection === "connected"){
        platformListModel.selectedConnection = "connected"
        NavigationControl.updateState(NavigationControl.events.NEW_PLATFORM_CONNECTED_EVENT,data)
        coreInterface.sendSelectedPlatform(platformListModel.get(currentIndex).uuid,platformListModel.get(currentIndex).connection)
        if (NavigationControl.flipable_parent_.flipped) {
            NavigationControl.updateState(NavigationControl.events.TOGGLE_CONTROL_CONTENT)
        }
    }
    else if (connection === "remote"){
        platformListModel.selectedConnection = "remote"
        NavigationControl.updateState(NavigationControl.events.NEW_PLATFORM_CONNECTED_EVENT,data)
        // Call coreinterface connect()
        coreInterface.sendSelectedPlatform(platformListModel.get(currentIndex).uuid,platformListModel.get(currentIndex).connection)
        if (NavigationControl.flipable_parent_.flipped) {
            NavigationControl.updateState(NavigationControl.events.TOGGLE_CONTROL_CONTENT)
        }
    } else {
        if (NavigationControl.flipable_parent_.flipped) {
            NavigationControl.updateState(NavigationControl.events.TOGGLE_CONTROL_CONTENT)
        }
    }
}