# Automated collateral download testing
#
# Python 3

import sys, json, os.path, hashlib, time
try:
    import zmq
except ImportError:
    print("\nZeroMQ library for Python is required, visit https://zeromq.org/languages/python/ for instructions.\nExiting.\n")
    sys.exit(-1)
if len(sys.argv) != 3:
    print("\nError: incorrect number of arguments provided.\nInvoke from Powershell script 'hcs-collateral-download-testing.ps1',")
    print("or directly as:\n'python hcs-collateral-download-test.py <APPDATA\HCS DIRECTORY> <HCS ENDPOINT>'.")
    print("Example:\n'python hcs-collateral-download-test.py C:\\Users\\<USER>\\AppData\\Roaming\\ON Semiconductor\\hcs tcp://127.0.0.1:5563'.\nExiting.\n")
    sys.exit(-1)

def flushSocketReceive():
    "Flush/clear this script's end of the socket"
    while True:
        try:
            socket.recv()
        except:
            break

def sendToHcsAndWait(message_to_HCS):
    "Send notification to HCS through ZMQ and wait for response"
    # This function will quit the script if it fails
    # Response is converted to JSON object
    flushSocketReceive()
    socket.send_string(message_to_HCS)
    try:
        message_from_HCS = socket.recv()
    except zmq.Again:
        print("\nNo response received, is HCS running?\nExiting.\n")
        sys.exit(-1)
    if not message_from_HCS:
        print("\nError: received empty or invalid response from HCS, exiting.")
        sys.exit(-1)
    try:
        message_from_HCS = json.loads(message_from_HCS)
    except ValueError:
        print("\nError: received empty or invalid response from HCS, exiting.")
        sys.exit(-1)
    return message_from_HCS

def generateDownloadFilesCommand(class_id, download_list):
    "Compose the hcs::cmd download_files JSON command"
    cmd = {}
    cmd['hcs::cmd'] = "download_files"
    payload = {}
    payload['destination_dir'] = os.path.join(hcs_directory, "documents", "views", class_id)
    files = []
    for file in download_list:
        files.append(file["uri"])
    payload['files'] = files
    cmd['payload'] = payload
    return json.dumps(cmd)

def getFileMD5Hash(file_abspath):
    "Calculate the MD5 hash of the given file"
    # Assumes given file exists (previously checked)
    with open(filepath, 'rb') as file_md5_check:
        return hashlib.md5(file_md5_check.read()).hexdigest()

hcs_directory = sys.argv[1]
hcs_endpoint = sys.argv[2]

# Open socket and connect it to HCS
context = zmq.Context()
socket = context.socket(zmq.DEALER)
socket.connect(hcs_endpoint)
socket.RCVTIMEO = 10000 # HCS reply timeout (in milliseconds)

# Send register_client command to HCS
print("\nSending 1st notification (REGISTER CLIENT)")
socket.send_string('{"cmd":"register_client"}')

# Send connect_data_source command to HCS
print("\nSending 2nd notification (CONNECT DATA SOURCE)")
socket.send_string('{"db::cmd":"connect_data_source","db::payload":{"type":"document"}}')

# Send dynamic_platform_list command to HCS, retrieve reply
print("\nSending 3rd notification (DYNAMIC PLATFORM LIST)", end = '')
message = sendToHcsAndWait('{"hcs::cmd":"dynamic_platform_list","payload":{}}')
platform_list = message["hcs::notification"]["list"]
print(", received reply with " + str(len(platform_list)) + " platforms.")

# Start main loop over each platform
total_failed_tests = 0
for platform in platform_list:
    platform_failed_tests = 0
    print("\n" + 80 * "#" + "\n\nSending HCS notification for platform " + str(platform["class_id"]), end = '')
    message_to_HCS = '{"cmd":"platform_select","payload":{"platform_uuid":"' + str(platform["class_id"]) + '"}}'
    message_from_HCS = sendToHcsAndWait(message_to_HCS)
    try:
        file_list = message_from_HCS["cloud::notification"]["documents"]
        view_list = [file for file in file_list if file["category"] == "view"]
        download_list = [file for file in file_list if file["category"] == "download"]
    except KeyError:
        print("\nError: received empty or invalid response from HCS.\nLast response from HCS:\n\n" + json.dumps(message_from_HCS, indent=4) + "\n\nExiting.")
        sys.exit(-1)
    print(", received reply with " + str(len(file_list)) + " files to be automatically downloaded (" +
        str(len(view_list)) + " views, " + str(len(download_list)) + " downloads).\n\nDownloading files and verifying...\n")
    js = generateDownloadFilesCommand(str(platform["class_id"]), download_list)
    socket.send_string(js)
    time.sleep(len(download_list))
    for file in file_list:
        filepath = file["uri"] if os.path.isabs(file["uri"]) else os.path.join(hcs_directory, "documents", "views", str(platform["class_id"]), file["prettyname"])
        if os.path.isfile(filepath): # File found where expected - perform MD5 check
            with open(filepath, 'rb') as file_md5_check:
                calculated_md5 = hashlib.md5(file_md5_check.read()).hexdigest()
                if calculated_md5 != file["md5"]: # MD5 check failed
                    print("\nTest failed, MD5 check unsuccessful for file:\n" + filepath)
                    platform_failed_tests += 1
                    total_failed_tests += 1
        else: # File not found where expected
            print("\nTest failed, file not found:\n" + filepath)
            platform_failed_tests += 1
            total_failed_tests += 1
    if platform_failed_tests < 1:
        print("\nAll tests PASSED for platform " + str(platform["class_id"]) + ".")
    else:
        print("\nWARNING:\nA total of " + str(platform_failed_tests) + " unsuccessful test cases were found for this platform.")
if total_failed_tests < 1:
    print("\nAll tests PASSED for all platforms.\n")
else:
    print("\nWARNING:\nA total of " + str(total_failed_tests) + " unsuccessful test cases were found between all platforms.")