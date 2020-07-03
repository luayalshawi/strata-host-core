#include <QJsonDocument>
#include <QJsonObject>
#include <QJsonArray>

#include "BoardController.h"
#include "Dispatcher.h"
#include "logging/LoggingQtCategories.h"
#include "JsonStrings.h"

using strata::BoardManager;
using strata::device::Device;
using strata::device::DevicePtr;
using strata::device::DeviceProperties;

BoardController::BoardController() {
    connect(&boardManager_, &BoardManager::boardReady, this, &BoardController::newConnection);
    connect(&boardManager_, &BoardManager::boardDisconnected, this, &BoardController::closeConnection);
}

void BoardController::initialize() {
    boardManager_.init(false);
}

bool BoardController::sendMessage(const int deviceId, const QByteArray& message) {
    auto it = boards_.constFind(deviceId);
    if (it == boards_.constEnd()) {
        qCWarning(logCategoryHcsBoard).noquote() << "Cannot send message, board was not found." << logDeviceId(deviceId);
        return false;
    }
    qCDebug(logCategoryHcsBoard).noquote() << "Sending message to board." << logDeviceId(deviceId);
    it.value().device->sendMessage(message);
    return true;
}

void BoardController::newConnection(int deviceId, bool recognized) {
    if (recognized) {
        DevicePtr device = boardManager_.device(deviceId);
        if (device == nullptr) {
            return;
        }

        connect(device.get(), &Device::msgFromDevice, this, &BoardController::messageFromBoard);
        boards_.insert(deviceId, Board(device));

        QString classId = getClassId(deviceId);
        QString platformId = getPlatformId(deviceId);

        qCInfo(logCategoryHcsBoard).noquote() << "Connected new board." << logDeviceId(deviceId);

        emit boardConnected(classId, platformId);
    } else {
        qCWarning(logCategoryHcsBoard).noquote() << "Connected unknown (unrecognized) board." << logDeviceId(deviceId);
    }
}

void BoardController::closeConnection(int deviceId)
{
    auto it = boards_.constFind(deviceId);
    if (it == boards_.constEnd()) {
        // This situation can occur if unrecognized board is disconnected.
        qCInfo(logCategoryHcsBoard).noquote() << "Disconnected unknown board." << logDeviceId(deviceId);
        return;
    }

    QString classId = it.value().device->property(DeviceProperties::classId);
    QString platformId = it.value().device->property(DeviceProperties::platformId);

    boards_.remove(deviceId);

    qCInfo(logCategoryHcsBoard).noquote() << "Disconnected board." << logDeviceId(deviceId);

    emit boardDisconnected(classId, platformId);
}

void BoardController::messageFromBoard(QString message)
{
    Device *device = qobject_cast<Device*>(QObject::sender());
    if (device == nullptr) {
        return;
    }

    int deviceId = device->deviceId();
    QJsonObject wrapper {
        { "message", message },
        { JSON_DEVICE_ID, deviceId }
    };

    QJsonObject notification {
        { "notification", wrapper }
    };
    QJsonDocument wrapperDoc(notification);
    QString wrapperStrJson(wrapperDoc.toJson(QJsonDocument::Compact));

    QString platformId = getPlatformId(deviceId);

    qCDebug(logCategoryHcsBoard).noquote() << "New board message." << logDeviceId(deviceId);

    emit boardMessage(platformId, wrapperStrJson);
}

QString BoardController::createPlatformsList() {
    QJsonArray arr;
    for (auto it = boards_.constBegin(); it != boards_.constEnd(); ++it) {
        QJsonObject item {
            { JSON_CLASS_ID, it.value().device->property(DeviceProperties::classId) },
            { JSON_DEVICE_ID, it.value().device->deviceId() }
        };
        arr.append(item);
    }
    QJsonObject notif {
        { JSON_LIST, arr },
        { JSON_TYPE, JSON_CONNECTED_PLATFORMS }
    };
    QJsonObject msg {
        { JSON_HCS_NOTIFICATION, notif }
    };
    QJsonDocument doc(msg);

    return doc.toJson(QJsonDocument::Compact);
}

QByteArray BoardController::getClientId(const int deviceId) const {
    auto it = boards_.constFind(deviceId);
    if (it != boards_.constEnd()) {
        return it.value().clientId;
    }
    return QByteArray();
}

QString BoardController::getClassId(const int deviceId) const {
    auto it = boards_.constFind(deviceId);
    if (it != boards_.constEnd()) {
        return it.value().device->property(DeviceProperties::classId);
    }
    return QString();
}

QString BoardController::getPlatformId(const int deviceId) const {
    auto it = boards_.constFind(deviceId);
    if (it != boards_.constEnd()) {
        return it.value().device->property(DeviceProperties::platformId);
    }
    return QString();
}

bool BoardController::getDeviceIdByClientId(const QByteArray& clientId, int& deviceId) const {
// Original implementation in BoardsController class iterated through boards (PlatformBoard objects)
// and returned first board which had desired client ID.
    for (auto it = boards_.constBegin(); it != boards_.constEnd(); ++it) {
        if (clientId == it.value().clientId) {
            deviceId = it.key();
            return true;
        }
    }
    return false;
}

bool BoardController::getFirstDeviceIdByClassId(const QString& classId, int& deviceId) const {
// Original implementation in BoardsController class iterated through boards (PlatformBoard objects)
// and returned first board which had desired class ID.
    for (auto it = boards_.constBegin(); it != boards_.constEnd(); ++it) {
        if (classId == it.value().device->property(DeviceProperties::classId)) {
            deviceId = it.key();
            return true;
        }
    }
    return false;
}

bool BoardController::setClientId(const QByteArray& clientId, const int deviceId) {
    auto it = boards_.find(deviceId);
    if (it != boards_.end()) {
        if (it.value().clientId.isEmpty()) {
            it.value().clientId = clientId;
            qCDebug(logCategoryHcsBoard).noquote() << logDeviceId(deviceId) << ": Assigned client '" << clientId.toHex() << "' to device";
            return true;
        }
    }
    qCWarning(logCategoryHcsBoard).noquote() << logDeviceId(deviceId) << ": Cannot assign client '" << clientId.toHex() << "' to device";
    return false;
}

bool BoardController::clearClientId(const int deviceId) {
    auto it = boards_.find(deviceId);
    if (it != boards_.end()) {
        it.value().clientId.clear();
        return true;
    }
    return false;
}

bool BoardController::clearClientIdFromAllDevices(const QByteArray& clientId) {
    bool found = false;
    for (auto it = boards_.begin(); it != boards_.end(); ++it) {
        if (clientId == it.value().clientId) {
            it.value().clientId.clear();
            found = true;
        }
    }
    return found;
}

QString BoardController::logDeviceId(const int deviceId) const {
    return "Device Id: 0x" + QString::number(static_cast<uint>(deviceId), 16);
}

BoardController::Board::Board(const DevicePtr& devPtr) : device(devPtr) { }
