#ifndef CMD_GET_FIRMWARE_INFO_H
#define CMD_GET_FIRMWARE_INFO_H

#include "BaseDeviceCommand.h"

namespace strata {

class CmdGetFirmwareInfo : public BaseDeviceCommand {
public:
    CmdGetFirmwareInfo(const SerialDevicePtr& device, bool requireResponse);
    QByteArray message() override;
    bool processNotification(rapidjson::Document& doc) override;
    void onTimeout() override;
private:
    bool requireResponse_;
};

}  // namespace

#endif