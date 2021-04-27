#include "PlatformManager.h"
#include "PlatformManagerConstants.h"
#include "logging/LoggingQtCategories.h"

#include <Serial/SerialDeviceScanner.h>
#include <Mock/MockDeviceScanner.h>

namespace strata {

using device::Device;
using platform::Platform;
using platform::PlatformPtr;
using device::scanner::DeviceScanner;
using device::scanner::DeviceScannerPtr;
using device::scanner::MockDeviceScanner;
using device::scanner::SerialDeviceScanner;

namespace operation = platform::operation;

PlatformManager::PlatformManager(bool requireFwInfoResponse, bool keepDevicesOpen, bool handleIdentify) :
    platformOperations_(true, true),
    reqFwInfoResp_(requireFwInfoResponse),
    keepDevicesOpen_(keepDevicesOpen),
    handleIdentify_(handleIdentify)
{ }

PlatformManager::~PlatformManager() {
    // stop all operations here to avoid capturing signals later which could crash
    platformOperations_.stopAllOperations();

    QList<Device::Type> scannerTypes = scanners_.keys();
    foreach(auto scannerType, scannerTypes) {
        deinit(scannerType);
    }
}

void PlatformManager::init(Device::Type scannerType) {
    if (scanners_.contains(scannerType)) {
        return; // already initialized
    }

    DeviceScannerPtr scanner;

    switch(scannerType) {
    case Device::Type::SerialDevice: {
        scanner = std::make_shared<SerialDeviceScanner>();
    } break;
    case Device::Type::MockDevice: {
        scanner = std::make_shared<MockDeviceScanner>();
    } break;
    default: {
        qCCritical(logCategoryPlatformManager) << "Invalid DeviceScanner type:" << scannerType;
        return;
    }
    }

    scanners_.insert(scannerType, scanner);

    qCDebug(logCategoryPlatformManager) << "Created DeviceScanner with type:" << scannerType;

    connect(scanner.get(), &DeviceScanner::deviceDetected, this, &PlatformManager::handleDeviceDetected);
    connect(scanner.get(), &DeviceScanner::deviceLost, this, &PlatformManager::handleDeviceLost);

    scanner->init();
}

void PlatformManager::deinit(Device::Type scannerType) {
    auto iter = scanners_.find(scannerType);
    if (iter == scanners_.end()) {
        return; // scanner not found
    }

    iter.value()->deinit(); // all devices will be reported as lost

    scanners_.erase(iter);

    qCDebug(logCategoryPlatformManager) << "Erased DeviceScanner with type:" << scannerType;
}

bool PlatformManager::disconnectPlatform(const QByteArray& deviceId, std::chrono::milliseconds disconnectDuration) {
    auto it = openedPlatforms_.constFind(deviceId);
    if (it != openedPlatforms_.constEnd()) {
        qCDebug(logCategoryPlatformManager).noquote().nospace() << "Going to disconnect platform, deviceId: " << deviceId << ", duration: " << disconnectDuration.count();
        it.value()->close(disconnectDuration, DEVICE_CHECK_INTERVAL);
        return true;
    }
    return false;
}

bool PlatformManager::reconnectPlatform(const QByteArray& deviceId) {
    auto it = closedPlatforms_.constFind(deviceId);
    if (it != closedPlatforms_.constEnd()) {
        qCDebug(logCategoryPlatformManager).noquote() << "Going to reconnect platform, deviceId:" << deviceId;
        it.value()->open(DEVICE_CHECK_INTERVAL);
        return true;
    }
    return false;
}

PlatformPtr PlatformManager::getPlatform(const QByteArray& deviceId, bool open, bool closed) {
    if ((open == true) && (closed == false)) {
        return openedPlatforms_.value(deviceId);
    } else if ((open == false) && (closed == true)) {
        return closedPlatforms_.value(deviceId);
    } else if ((open == true) && (closed == true)) {
        auto openIter = openedPlatforms_.constFind(deviceId);
        if (openIter != openedPlatforms_.constEnd()) {
            return openIter.value();
        }
        auto closedIter = closedPlatforms_.constFind(deviceId);
        if (closedIter != closedPlatforms_.constEnd()) {
            return closedIter.value();
        }
    }

    return PlatformPtr();
}

QList<PlatformPtr> PlatformManager::getPlatforms(bool open, bool closed) {
    if ((open == true) && (closed == false)) {
        return openedPlatforms_.values();
    } else if ((open == false) && (closed == true)) {
        return closedPlatforms_.values();
    } else if ((open == true) && (closed == true)) {
        return openedPlatforms_.values() + closedPlatforms_.values();
    } else {
        return QList<PlatformPtr>();
    }
}

QList<QByteArray> PlatformManager::getDeviceIds(bool open, bool closed) {
    if ((open == true) && (closed == false)) {
        return openedPlatforms_.keys();
    } else if ((open == false) && (closed == true)) {
        return closedPlatforms_.keys();
    } else if ((open == true) && (closed == true)) {
        return openedPlatforms_.keys() + closedPlatforms_.keys();
    } else {
        return QList<QByteArray>();
    }
}

DeviceScannerPtr PlatformManager::getScanner(Device::Type scannerType) {
    return scanners_.value(scannerType);
}

void PlatformManager::handleDeviceDetected(PlatformPtr platform) {
    if (platform == nullptr) {
        qCCritical(logCategoryPlatformManager) << "Received corrupt platform pointer:" << platform;
        return;
    }

    const QByteArray deviceId = platform->deviceId();

    qCInfo(logCategoryPlatformManager).nospace().noquote() << "Platform detected: deviceId: " << deviceId << ", Type: " << platform->deviceType();

    if ((openedPlatforms_.contains(deviceId) == false) &&
        (closedPlatforms_.contains(deviceId) == false)) {
        // add first to closedPlatforms_ and when open() succeeds, add to openedPlatforms_
        closedPlatforms_.insert(deviceId, platform);

        connect(platform.get(), &Platform::opened, this, &PlatformManager::handlePlatformOpened, Qt::QueuedConnection);
        connect(platform.get(), &Platform::aboutToClose, this, &PlatformManager::handlePlatformAboutToClose, Qt::QueuedConnection);
        connect(platform.get(), &Platform::closed, this, &PlatformManager::handlePlatformClosed, Qt::QueuedConnection);
        connect(platform.get(), &Platform::recognized, this, &PlatformManager::handlePlatformRecognized, Qt::QueuedConnection);
        connect(platform.get(), &Platform::platformIdChanged, this, &PlatformManager::handlePlatformIdChanged, Qt::QueuedConnection);
        connect(platform.get(), &Platform::deviceError, this, &PlatformManager::handleDeviceError, Qt::QueuedConnection);

        platform->open(DEVICE_CHECK_INTERVAL);
    } else {
        qCCritical(logCategoryPlatformManager) << "Unable to add platform to maps, device Id already exists";
    }
}

void PlatformManager::handleDeviceLost(QByteArray deviceId) {
    qCInfo(logCategoryPlatformManager).noquote() << "Platform lost: deviceId:" << deviceId;

    auto openIter = openedPlatforms_.find(deviceId);
    if (openIter != openedPlatforms_.end()) {
        openIter.value()->close();
        disconnect(openIter.value().get(), nullptr, this, nullptr);
        openedPlatforms_.erase(openIter);
        return;
    }

    auto closedIter = closedPlatforms_.find(deviceId);
    if (closedIter != closedPlatforms_.end()) {
        closedIter.value()->abortReconnect();
        disconnect(closedIter.value().get(), nullptr, this, nullptr);
        closedPlatforms_.erase(closedIter);
        return;
    }

    qCWarning(logCategoryPlatformManager).noquote() << "Unable to erase platform from maps, device Id does not exists:" << deviceId;
}

void PlatformManager::handlePlatformOpened(QByteArray deviceId) {
    auto closedIter = closedPlatforms_.find(deviceId);
    if (closedIter != closedPlatforms_.end()) {
        PlatformPtr platformPtr = closedIter.value();
        closedPlatforms_.erase(closedIter);
        openedPlatforms_.insert(deviceId, platformPtr);
        qCInfo(logCategoryPlatformManager).noquote() << "Platform open, deviceId:" << deviceId;

        emit platformAdded(deviceId);

        startPlatformOperations(platformPtr);
    } else if (openedPlatforms_.contains(deviceId)) {
        qCDebug(logCategoryPlatformManager).noquote() << "Platform already open, deviceId:" << deviceId;
    } else {
        qCWarning(logCategoryPlatformManager).noquote() << "Unable to move to openedPlatforms_, device Id does not exists:" << deviceId;
    }
}

void PlatformManager::handlePlatformAboutToClose(QByteArray deviceId) {
    qCDebug(logCategoryPlatformManager).noquote() << "Platform about to close, deviceId:" << deviceId;

    platformOperations_.stopOperation(deviceId);

    emit platformAboutToClose(deviceId);
}

void PlatformManager::handlePlatformClosed(QByteArray deviceId) {
    auto openIter = openedPlatforms_.find(deviceId);
    if (openIter != openedPlatforms_.end()) {
        PlatformPtr platformPtr = openIter.value();
        openedPlatforms_.erase(openIter);
        closedPlatforms_.insert(deviceId, platformPtr);
        qCInfo(logCategoryPlatformManager).noquote() << "Platform closed, deviceId:" << deviceId;
        emit platformRemoved(deviceId);
    } else if (closedPlatforms_.contains(deviceId)) {
        qCDebug(logCategoryPlatformManager).noquote() << "Platform already closed, deviceId:" << deviceId;
    } else {
        qCWarning(logCategoryPlatformManager).noquote() << "Unable to move to closedPlatforms_, device Id does not exists:" << deviceId;
    }
}

void PlatformManager::handlePlatformRecognized(QByteArray deviceId, bool isRecognized) {
    qCDebug(logCategoryPlatformManager).noquote().nospace() << "Platform recognized: " << isRecognized << ", deviceId: " << deviceId;

    emit platformRecognized(deviceId, isRecognized);

    if (isRecognized == false && keepDevicesOpen_ == false) {
        qCInfo(logCategoryPlatformManager).noquote()
            << "Platform was not recognized, going to release communication channel, deviceId:" << deviceId;
        disconnectPlatform(deviceId);
    }
}

void PlatformManager::handlePlatformIdChanged(QByteArray deviceId) {
    auto iter = openedPlatforms_.constFind(deviceId);
    if (iter != openedPlatforms_.constEnd()) {
        qCDebug(logCategoryPlatformManager).noquote() << "Platform Id changed, going to Identify, deviceId:" << deviceId;
        startPlatformOperations(iter.value());
    } else if (closedPlatforms_.contains(deviceId)) {
        qCDebug(logCategoryPlatformManager).noquote() << "Platform Id changed, but unable to Identify (platform closed), deviceId:" << deviceId;
    } else {
        qCWarning(logCategoryPlatformManager).noquote() << "Platform Id changed, but unable to Identify, device Id does not exists:" << deviceId;
    }
}

void PlatformManager::handleDeviceError(QByteArray deviceId, Device::ErrorCode errCode, QString errStr) {
    switch (errCode) {
    case Device::ErrorCode::NoError: {
    } break;
    case Device::ErrorCode::DeviceBusy:
    case Device::ErrorCode::DeviceFailedToOpen: {
        // no need to handle these
        // qCDebug(logCategoryPlatformManager).nospace() << "Platform warning received: deviceId: " << deviceId << ", code: " << errCode << ", message: " << errStr;
    } break;
    case Device::ErrorCode::DeviceDisconnected: {
        qCWarning(logCategoryPlatformManager).nospace() << "Platform was disconnected: deviceId: " << deviceId << ", code: " << errCode << ", message: " << errStr;
        disconnectPlatform(deviceId);
    } break;
    case Device::ErrorCode::DeviceError: {
        qCCritical(logCategoryPlatformManager).nospace() << "Platform error received: deviceId: " << deviceId << ", code: " << errCode << ", message: " << errStr;
        disconnectPlatform(deviceId);
    } break;
    default: break;
    }
}

void PlatformManager::startPlatformOperations(const PlatformPtr& platform) {
    if (handleIdentify_) {
        platformOperations_.Identify(platform, reqFwInfoResp_, GET_FW_INFO_MAX_RETRIES, IDENTIFY_LAUNCH_DELAY);
    }
}

}  // namespace