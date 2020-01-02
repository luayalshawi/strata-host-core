#include "CommandValidator.h"
#include <rapidjson/writer.h>
#include <gtest/gtest.h>

class CommandValidatorTest : public testing::Test
{
public:
    void printJsonDoc(rapidjson::Document &doc);

protected:
    void SetUp() override
    {
    }

    virtual void TearDown() override
    {
    }
};

void CommandValidatorTest::printJsonDoc(rapidjson::Document &doc)    {
    // print the doc
    rapidjson::StringBuffer buffer;
    rapidjson::Writer<rapidjson::StringBuffer> writer(buffer);
    doc.Accept(writer);
    std::cout << buffer.GetString() << std::endl;
}

TEST_F(CommandValidatorTest, updateFWResTest)
{
    std::string testCommand;
    rapidjson::Document doc;

    // Valid test commands
    testCommand = R"(
        {
            "notification":{
                "value":"update_firmware",
                "payload":{
                    "status":"ok"
                }
            }
        })";
    EXPECT_TRUE(CommandValidator::isValidUpdateFW(testCommand, doc));

    testCommand = R"(
        {
            "notification":{
                "value":"update_firmware",
                "payload":{
                    "status":"failed"
                }
            }
        })";
    EXPECT_TRUE(CommandValidator::isValidUpdateFW(testCommand, doc));

    testCommand = R"(
        {
            "notification":{
                "value":"update_firmware",
                "payload":{
                    "status":"invalid FIB state"
                }
            }
        })";
    EXPECT_TRUE(CommandValidator::isValidUpdateFW(testCommand, doc));


    // Invalid test commands
    testCommand = R"(
        {
            "notification":{
                "value":"update_firm",
                "payload":{
                    "status":"ok"
                }
            }
        })";
    EXPECT_FALSE(CommandValidator::isValidUpdateFW(testCommand, doc));

    testCommand = R"(
        {
            "notification":{
                "value":"update_firmware",
                "payload":{
                    "status": 56465
                }
            }
        })";
    EXPECT_FALSE(CommandValidator::isValidUpdateFW(testCommand, doc));

    testCommand = R"(
        {
            "notification":{
                "value":"update_firmware",
                "payload":{
                }
            }
        })";
    EXPECT_FALSE(CommandValidator::isValidUpdateFW(testCommand, doc));
}

TEST_F(CommandValidatorTest, flashFWResTest)
{
    std::string testCommand;
    rapidjson::Document doc;
    
    // valid test commands
    testCommand = R"(
        {
            "notification":{
                "value":"flash_firmware",
                "payload":{
                    "status":"ok"
                }
            }
        })";
    EXPECT_TRUE(CommandValidator::isValidFlashFW(testCommand, doc));

    testCommand = R"(
        {
            "notification":{
                "value":"flash_firmware",
                "payload":{
                    "status":"some error"
                }
            }
        })";
    EXPECT_TRUE(CommandValidator::isValidFlashFW(testCommand, doc));

    // Invalid test commands
    testCommand = R"(
        {
            "notification":{
                "value":"flash_firmre",
                "payload":{
                    "status":"ok"
                }
            }
        })";
    EXPECT_FALSE(CommandValidator::isValidFlashFW(testCommand, doc));

    testCommand = R"(
        {
            "notification":{
                "value":"flash_firmware",
                "payload":{
                }
            }
        })";
    EXPECT_FALSE(CommandValidator::isValidFlashFW(testCommand, doc));

        testCommand = R"(
        {
            "notification":{
                "value":"flash_firmware",
                "payload":{
                    "status": -1
                }
            }
        })";
    EXPECT_FALSE(CommandValidator::isValidFlashFW(testCommand, doc));
}

TEST_F(CommandValidatorTest, getFWInfoResTest)
{
    std::string testCommand;
    rapidjson::Document doc;

    // Valid test commands
    testCommand = R"(
        {
            "notification": {
                "value":"get_firmware_info",
                "payload": {
                    "bootloader": {
                        "version":"158.58.54",
                        "build-date":"2018-04-01",
                        "checksum": "dsfdsf"
                    },
                    "application": {
                        "version":"1.1.1",
                        "build-date":"2018-04-01",
                        "checksum": 232332
                    }
                }
            }
        })";
    EXPECT_TRUE(CommandValidator::isValidGetFWInfo(testCommand, doc));

    // Invalid test commands
    testCommand = R"(
        {
            "notification": {
                "value":"get_firmware_info",
                "payload": {
                    "bootloader": {
                        "version": 1.1.1,
                        "build-date":"2018-4-1",
                        "checksum": ""
                    },
                    "application": {
                        "version":"1.1.1",
                        "build-date":"2018-04-01",
                        "checksum": ""
                    }
                }
            }
        })";
    EXPECT_FALSE(CommandValidator::isValidGetFWInfo(testCommand, doc));

    testCommand = R"(
        {
            "notification": {
                "value":"get_firmware_info",
                "payload": {
                    "bootloader": {
                        "version":"a.a.a",
                        "build-date": 20180410,
                        "checksum": ""
                    },
                    "application": {
                        "version":"213",
                        "build-date":"2018-04-01",
                        "checksum": ""
                    }
                }
            }
        })";
    EXPECT_FALSE(CommandValidator::isValidGetFWInfo(testCommand, doc));

    testCommand = R"(
        {
            "notification": {
                "value":"get_firmware_info",
                "payload": {
                    "bootloader": {
                        "version":"1.1.1",
                        "build-date":"2018-04-01"
                    },
                    "application": {
                        "version":"1.1.1",
                        "build-date":"20180401",
                        "checksum": ""
                    }
                }
            }
        })";
    EXPECT_FALSE(CommandValidator::isValidGetFWInfo(testCommand, doc));
}

TEST_F(CommandValidatorTest, setPlatformIdResTest)
{
    std::string testCommand;
    rapidjson::Document doc;

    // Valid testing commands
    testCommand = R"(
        {
            "notification":{
                "value":"set_platform_id",
                "payload":{
                    "status": "OK"
                }
            }
        })";
    EXPECT_TRUE(CommandValidator::isValidSetPlatformId(testCommand, doc));

    testCommand = R"(
        {
            "notification":{
                "value":"set_platform_id",
                "payload":{
                    "status": "Else"
                }
            }
        })";
    EXPECT_TRUE(CommandValidator::isValidSetPlatformId(testCommand, doc));

    // Invalid testing commands
    testCommand = R"(
        {
            "notification":{
                "value":"set_plat",
                "payload":{
                    "status": "OK"
                }
            }
        })";
    EXPECT_FALSE(CommandValidator::isValidSetPlatformId(testCommand, doc));

    testCommand = R"(
        {
            "notification":{
                "value":"set_platform_id",
                "payload":{

                }
            }
        })";
    EXPECT_FALSE(CommandValidator::isValidSetPlatformId(testCommand, doc));
}

TEST_F(CommandValidatorTest, notificationTest)
{
    std::string testCommand;
    rapidjson::Document doc;

    // Valid test commands
    testCommand = R"({"notification":{"value":"platform_id","payload":{"name":"Hello Strata","platform_id":"126","class_id":"226","count":0,"platform_id_version":"2.0"}}})";
    EXPECT_TRUE(CommandValidator::isValidNotification(testCommand, doc));

    testCommand = R"({"notification":{"value":"pot","payload":{"volts":2.83,"bits":3220}}})";
    EXPECT_TRUE(CommandValidator::isValidNotification(testCommand, doc));

    testCommand = R"({"notification":{"value":"pot","payload":{}}})";
    EXPECT_TRUE(CommandValidator::isValidNotification(testCommand, doc));

    testCommand = R"({"notification":{"value":"pot","payload":{"volts":2.83}}})";
    EXPECT_TRUE(CommandValidator::isValidNotification(testCommand, doc));

    testCommand = R"({"notification":{"payload":{"volts":2.83,"bits":3220}}})";
    EXPECT_FALSE(CommandValidator::isValidNotification(testCommand, doc));

    testCommand = R"({"notification":{"value":"pot"}})";
    EXPECT_FALSE(CommandValidator::isValidNotification(testCommand, doc));

    testCommand = R"({"value":"pot","payload":{"volts":2.83,"bits":3220}})";
    EXPECT_FALSE(CommandValidator::isValidNotification(testCommand, doc));
}

TEST_F(CommandValidatorTest, ackTest)
{
    std::string testCommand;
    rapidjson::Document doc;

    // valid testing commands
    testCommand = R"({"ack":"request_platform_id","payload":{"return_value":true,"return_string":"command valid"}})";
    EXPECT_TRUE(CommandValidator::isValidAck(testCommand, doc));

    testCommand = R"({"ack":"request_platform_id","payload":{"return_value":"true","return_string":"command valid"}})";
    EXPECT_FALSE(CommandValidator::isValidAck(testCommand, doc));

    testCommand = R"({"ack":"request_platform_id","payload":{}})";
    EXPECT_FALSE(CommandValidator::isValidAck(testCommand, doc));

    testCommand = R"({"ack":"request_platform_id","payload":{"return_string":"command valid"}})";
    EXPECT_FALSE(CommandValidator::isValidAck(testCommand, doc));

    testCommand = R"({"ack":"request_platform_id"})";
    EXPECT_FALSE(CommandValidator::isValidAck(testCommand, doc));

    testCommand = R"({"ack":"request_platform_id","payload":{"return_value":"true","return_string":"command valid"}})";
    EXPECT_FALSE(CommandValidator::isValidAck(testCommand, doc));
}

TEST_F(CommandValidatorTest, sampleTest)
{
    std::string testCommand;
    rapidjson::Document doc;

    testCommand = R"(
        {  
            "notification":{  
                "value":"platform_id",
                "payload":{  
                    "name":"WaterHeater",
                    "platform_id":"101",
                    "class_id":"201",
                    "count":1,
                    "platform_id_version":"2.0"
                }
            }
        }
    )";
    EXPECT_TRUE(CommandValidator::isValidRequestPlatorfmIdResponse(testCommand, doc));

    testCommand = R"(
        {  
            "notification":{  
                "value":"platform_id",
                "payload":{  
                    "name":"WaterHeater",
                    "platform_id": 101,
                    "class_id":"201",
                    "count":1,
                    "platform_id_version":"2.0"
                }
            }
        }
    )";
    EXPECT_FALSE(CommandValidator::isValidRequestPlatorfmIdResponse(testCommand, doc));
}

TEST_F(CommandValidatorTest, requestPlatorfmIdResponseTest)
{
    std::string testCommand;
    rapidjson::Document doc;

    // valid test commands
    testCommand = R"(
        {  
            "notification":{  
                "value":"platform_id",
                "payload":{  
                    "name":"WaterHeater",
                    "platform_id":"101",
                    "class_id":"201",
                    "count":1,
                    "platform_id_version":"2.0"
                }
            }
        }
    )";
    EXPECT_TRUE(CommandValidator::isValidRequestPlatorfmIdResponse(testCommand, doc));

    testCommand = R"(
        {
            "notification":{
                "value":"platform_id",
                "payload":{
                        "verbose_name":"ON WaterHeater",
                        "verbose_name_error":"error_data_corrupted",
                        "platform_id":"SEC.2018.0.0.0.0.00000000-0000-0000-0000-000000000000",
                        "platform_id_error":"not_flashed"
                }
            }
        }
    )";
    EXPECT_TRUE(CommandValidator::isValidRequestPlatorfmIdResponse(testCommand, doc));

    // Invalid test command
    testCommand = R"(
        {  
            "notification":{  
                "value":"platform_id",
                "payload":{  
                    "name":"WaterHeater",
                    "platform_id":101,
                    "class_id":"201",
                    "count":1,
                    "platform_id_version":"2.0"
                }
            }
        }
    )";
    EXPECT_FALSE(CommandValidator::isValidRequestPlatorfmIdResponse(testCommand, doc));

    testCommand = R"(
        {  
            "notification":{  
                "value":"platform",
                "payload":{  
                    "name":"WaterHeater",
                    "platform_id":"101",
                    "class_id":"201",
                    "count":1,
                    "platform_id_version":"2.0"
                }
            }
        }
    )";
    EXPECT_FALSE(CommandValidator::isValidRequestPlatorfmIdResponse(testCommand, doc));
}

TEST_F(CommandValidatorTest, isValidJsonTest)
{
    std::string testCommand;
    rapidjson::Document doc;

    // valid test commands
    testCommand = R"(
        {  
            "notification":{  
                "value":"platform_id",
                "payload":{  
                    "name":"WaterHeater",
                    "platform_id":"101",
                    "class_id":"201",
                    "count":1,
                    "platform_id_version":"2.0"
                }
            }
        }
    )";
    EXPECT_TRUE(CommandValidator::isValidJson(testCommand, doc));

    testCommand = R"(
        {
            "notification":{
                "value":"platform_id",
                "payload":{}
            }
        }
    )";
    EXPECT_TRUE(CommandValidator::isValidJson(testCommand, doc));

    // Invalid test command
    testCommand = R"(
        {  
            "notification":{  
                "value":"platform_id",
                "payload":{  
                    "name":"WaterHeater",
                    "platform_id":"10a",
                    "class_id":"201",
                    "count":1,
                    "platform_id_version":"2.0"
                }
        }
    )";
    EXPECT_FALSE(CommandValidator::isValidJson(testCommand, doc));

    testCommand = R"(
        {  
            "notification":{  
                "value":"platform_id",
                "payload":{  
                    "name":"WaterHeater",
                    "platform_id":101,
                    "class_id":"201",
                    "count":1,
                    "platform_id_version"
                }
            }
        }
    )";
    EXPECT_FALSE(CommandValidator::isValidJson(testCommand, doc));

    testCommand = R"(
        {  
            "notification":{  
                "value":"platform",
                "payload":{  
                    "name":"WaterHeater",
                    "platform_id":"101",
                    "class_id":"201",
                    "count":1,
                    "platform_id_version":"2.0",
                }
            }
        }
    )";
    EXPECT_FALSE(CommandValidator::isValidJson(testCommand, doc));
}

TEST_F(CommandValidatorTest, isValidCmdTest)
{
    std::string testCommand;
    rapidjson::Document doc;

    // valid test commands
    testCommand = R"({"cmd":"nl7sz58_write_io","payload":{"a":1, "b":0, "c":1}})";
    EXPECT_TRUE(CommandValidator::isValidCmdCommand(testCommand, doc));

    testCommand = R"({"cmd":"nl7sz58_nand"})";
    EXPECT_TRUE(CommandValidator::isValidCmdCommand(testCommand, doc));

    // Invalid test commands
    testCommand = R"({"cmd":"nl7sz58_write_io","payload":["a", "b", "c"]})";
    EXPECT_FALSE(CommandValidator::isValidCmdCommand(testCommand, doc));

    testCommand = R"({"cmd":"nl7sz58_write_io","payload":"string"})";
    EXPECT_FALSE(CommandValidator::isValidCmdCommand(testCommand, doc));

    testCommand = R"("cmd":{"nl7sz58_nand":6})";
    EXPECT_FALSE(CommandValidator::isValidCmdCommand(testCommand, doc));
}

TEST_F(CommandValidatorTest, isValidStrataCommandTest)
{
    std::string testCommand;
    rapidjson::Document doc;

    // Valid test commands
    testCommand = R"({"notification": {"value":"get_firmware_info","payload": {"bootloader": {"version":"158.58.54","build-date":"2018-04-01","checksum": "dsfdsf"},"application": {"version":"1.1.1","build-date":"2018-04-01","checksum": 232332}}}})";
    EXPECT_TRUE(CommandValidator::isValidStrataCommand(testCommand, doc));

    testCommand = R"({  "notification":{  "value":"platform_id","payload":{  "name":"WaterHeater","platform_id":"101","class_id":"201","count":1,"platform_id_version":"2.0"}}})";
    EXPECT_TRUE(CommandValidator::isValidStrataCommand(testCommand, doc));

    testCommand = R"({"notification":{"value":"platform_id","payload":{}}})";
    EXPECT_TRUE(CommandValidator::isValidStrataCommand(testCommand, doc));

    testCommand = R"({"notification":{"value":"platform_id","payload":{"name":"Hello Strata","platform_id":"126","class_id":"226","count":0,"platform_id_version":"2.0"}}})";
    EXPECT_TRUE(CommandValidator::isValidStrataCommand(testCommand, doc));

    testCommand = R"({"notification":{"value":"pot","payload":{"volts":2.83,"bits":3220}}})";
    EXPECT_TRUE(CommandValidator::isValidStrataCommand(testCommand, doc));

    testCommand = R"({"notification":{"value":"pot","payload":{}}})";
    EXPECT_TRUE(CommandValidator::isValidStrataCommand(testCommand, doc));

    testCommand = R"({"notification":{"value":"pot","payload":{"volts":2.83}}})";
    EXPECT_TRUE(CommandValidator::isValidStrataCommand(testCommand, doc));

    testCommand = R"({"notification":{"value":"flash_firmware","payload":{"status":"ok"}}})";
    EXPECT_TRUE(CommandValidator::isValidStrataCommand(testCommand, doc));

    testCommand = R"({"notification":{"value":"flash_firmware","payload":{"status":"some error"}}})";
    EXPECT_TRUE(CommandValidator::isValidStrataCommand(testCommand, doc));

    testCommand = R"({"ack":"request_platform_id","payload":{"return_value":true,"return_string":"command valid"}})";
    EXPECT_TRUE(CommandValidator::isValidStrataCommand(testCommand, doc));

    testCommand = R"({"notification":{"value":"update_firmware","payload":{"status":"ok"}}})";
    EXPECT_TRUE(CommandValidator::isValidStrataCommand(testCommand, doc));

    testCommand = R"({"notification":{"value":"update_firmware","payload":{"status":"failed"}}})";
    EXPECT_TRUE(CommandValidator::isValidStrataCommand(testCommand, doc));

    testCommand = R"({"notification":{"value":"update_firmware","payload":{"status":"invalid FIB state"}}})";
    EXPECT_TRUE(CommandValidator::isValidStrataCommand(testCommand, doc));

    testCommand = R"({  "notification":{  "value":"platform_id","payload":{  "name":"WaterHeater","platform_id":"101","class_id":"201","count":1,"platform_id_version":"2.0"}}})";
    EXPECT_TRUE(CommandValidator::isValidStrataCommand(testCommand, doc));

    testCommand = R"({"notification":{"value":"platform_id","payload":{"verbose_name":"ON WaterHeater","verbose_name_error":"error_data_corrupted","platform_id":"SEC.2018.0.0.0.0.00000000-0000-0000-0000-000000000000","platform_id_error":"not_flashed"}}})";
    EXPECT_TRUE(CommandValidator::isValidStrataCommand(testCommand, doc));

    testCommand = R"({"cmd":"nl7sz58_write_io","payload":{"a":1, "b":0, "c":1}})";
    EXPECT_TRUE(CommandValidator::isValidStrataCommand(testCommand, doc));

    testCommand = R"({"cmd":"nl7sz58_nand"})";
    EXPECT_TRUE(CommandValidator::isValidStrataCommand(testCommand, doc));

    // Invalid test commands
    testCommand = R"({"cmd":"nl7sz58_write_io","payload":["a", "b", "c"]})";
    EXPECT_FALSE(CommandValidator::isValidStrataCommand(testCommand, doc));

    testCommand = R"({"cmd":"nl7sz58_write_io","payload":"string"})";
    EXPECT_FALSE(CommandValidator::isValidStrataCommand(testCommand, doc));

    testCommand = R"("cmd":{"nl7sz58_nand":6})";
    EXPECT_FALSE(CommandValidator::isValidStrataCommand(testCommand, doc));

    testCommand = R"({"notification": {"value":"get_firmware_info","payload": {"bootloader": {"version": 1.1.1,"build-date":"2018-4-1","checksum": ""},"application": {"version":"1.1.1","build-date":"2018-04-01","checksum": ""}}}})";
    EXPECT_FALSE(CommandValidator::isValidStrataCommand(testCommand, doc));

    testCommand = R"({  "notification":{  "value":"platform_id","payload":{  "name":"WaterHeater","platform_id":"10a","class_id":"201","count":1,"platform_id_version":"2.0"}})";
    EXPECT_FALSE(CommandValidator::isValidStrataCommand(testCommand, doc));

    testCommand = R"({"notification":{"value":"platform_id","payload":{"name":"WaterHeater","platform_id":101,"class_id":"201","count":1,"platform_id_version"}}})";
    EXPECT_FALSE(CommandValidator::isValidStrataCommand(testCommand, doc));

    testCommand = R"({"notification":{"value":"platform","payload":{"name":"WaterHeater","platform_id":"101","class_id":"201","count":1,"platform_id_version":"2.0",}}})";
    EXPECT_FALSE(CommandValidator::isValidStrataCommand(testCommand, doc));

    testCommand = R"({  "notification":{  "value":"platform_id","payload":{  "name":"WaterHeater","platform_id":101,"class_id":"201","count":1,"platform_id_version":"2.0"}})";
    EXPECT_FALSE(CommandValidator::isValidStrataCommand(testCommand, doc));

    testCommand = R"({"notification":{"payload":{"volts":2.83,"bits":3220}}})";
    EXPECT_FALSE(CommandValidator::isValidStrataCommand(testCommand, doc));

    testCommand = R"({"notification":{"value":"pot"}})";
    EXPECT_FALSE(CommandValidator::isValidStrataCommand(testCommand, doc));

    testCommand = R"({"value":"pot","payload":{"volts":2.83,"bits":3220}})";
    EXPECT_FALSE(CommandValidator::isValidStrataCommand(testCommand, doc));

    testCommand = R"({"ack":"request_platform_id","payload":{"return_value":"true","return_string":"command valid"}})";
    EXPECT_FALSE(CommandValidator::isValidStrataCommand(testCommand, doc));

    testCommand = R"({"ack":"request_platform_id","payload":{}})";
    EXPECT_FALSE(CommandValidator::isValidStrataCommand(testCommand, doc));

    testCommand = R"({"ack":"request_platform_id","payload":{"return_string":"command valid"}})";
    EXPECT_FALSE(CommandValidator::isValidStrataCommand(testCommand, doc));

    testCommand = R"({"ack":"request_platform_id"})";
    EXPECT_FALSE(CommandValidator::isValidStrataCommand(testCommand, doc));

    testCommand = R"({"ack":"request_platform_id","payload":{"return_value":"true","return_string":"command valid"}})";
    EXPECT_FALSE(CommandValidator::isValidStrataCommand(testCommand, doc));
}

int main(int argc, char** argv)
{
    testing::InitGoogleTest(&argc, argv);
    return RUN_ALL_TESTS();
}