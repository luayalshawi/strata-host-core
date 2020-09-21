#include <Device/Operations/StartApplication.h>
#include "Commands/include/DeviceCommands.h"
#include "DeviceOperationsConstants.h"

namespace strata::device::operation {

using command::CmdStartApplication;
using command::CmdRequestPlatformId;
using command::CmdGetFirmwareInfo;

StartApplication::StartApplication(const device::DevicePtr& device) :
    BaseDeviceOperation(device, Type::StartApplication)
{
    // BaseDeviceOperation member device_ must be used as a parameter for commands!
    commandList_.emplace_back(std::make_unique<CmdStartApplication>(device_));
    commandList_.emplace_back(std::make_unique<CmdRequestPlatformId>(device_, MAX_PLATFORM_ID_RETRIES));
    commandList_.emplace_back(std::make_unique<CmdGetFirmwareInfo>(device_, false));
}

}  // namespace