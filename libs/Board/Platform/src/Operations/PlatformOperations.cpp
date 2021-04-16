#include <Operations/PlatformOperations.h>
#include <Operations/Backup.h>
#include <Operations/Flash.h>
#include <Operations/Identify.h>
#include <Operations/SetAssistedPlatformId.h>
#include <Operations/SetPlatformId.h>
#include <Operations/StartApplication.h>
#include <Operations/StartBootloader.h>

#include "logging/LoggingQtCategories.h"

namespace strata::platform::operation {

PlatformOperations::PlatformOperations(bool runOperations, bool overwriteEnabled) :
    runOperations_(runOperations),
    overwriteEnabled_(overwriteEnabled)
{ }

PlatformOperations::~PlatformOperations() {
    stopAllOperations();
}

OperationSharedPtr PlatformOperations::processOperation(const OperationSharedPtr& operation) {
    if (overwriteEnabled_) {
        if (operations_.contains(operation->deviceId())) {
            stopOperation(operation->deviceId());
        }
    } else {
        if (operations_.count(operation->deviceId()) != 0) {
            return nullptr;
        }
    }

    connect(operation.get(), &operation::BasePlatformOperation::finished,
            this, &PlatformOperations::handleOperationFinished);

    qCDebug(logCategoryPlatformOperation) << "Starting operation" << operation->type()
                                          << "for device Id:" << operation->deviceId();

    operations_.insert(operation->deviceId(), operation);

    if (runOperations_) {
        operation->run();
    }

    return operation;
}

void PlatformOperations::stopOperation(const QByteArray& deviceId) {
    auto it = operations_.find(deviceId);
    if (it != operations_.end()) {
        qCDebug(logCategoryPlatformOperation) << "Cancelling operation" << it.value()->type()
                                              << "for device Id:" << deviceId;
        it.value()->cancelOperation();

        // If operation is cancelled, finished is signal will be received (with Result::Cancel)
        // and operation will be removed from operations_ in handleOperationFinished slot.
    }
}

void PlatformOperations::stopAllOperations() {
    auto it = operations_.begin();
    while (it != operations_.end()) {
        it.value()->cancelOperation();

        // If operation is cancelled, finished signal will be received (with Result::Cancel)
        // and operation will be removed from operations_ in handleOperationFinished slot.
        it = operations_.begin();
    }
}

OperationSharedPtr PlatformOperations::getOperation(const QByteArray& deviceId) {
    return operations_.value(deviceId);
}

OperationSharedPtr PlatformOperations::Backup(const PlatformPtr& platform) {
    OperationSharedPtr operation(new operation::Backup(platform), operationLaterDeleter);

    return processOperation(operation);
}

OperationSharedPtr PlatformOperations::Flash(const PlatformPtr& platform,
                                             int size,
                                             int chunks,
                                             const QString &md5,
                                             bool flashFirmware) {
    OperationSharedPtr operation (
        new operation::Flash(platform, size, chunks, md5, flashFirmware),
        operationLaterDeleter
    );

    return processOperation(operation);
}

OperationSharedPtr PlatformOperations::Identify(const PlatformPtr& platform,
                                                bool requireFwInfoResponse,
                                                uint maxFwInfoRetries,
                                                std::chrono::milliseconds delay) {
    OperationSharedPtr operation (
        new operation::Identify(platform, requireFwInfoResponse, maxFwInfoRetries, delay),
        operationLaterDeleter
    );

    return processOperation(operation);
}

OperationSharedPtr PlatformOperations::SetAssistedPlatformId(const PlatformPtr& platform) {
    OperationSharedPtr operation(new operation::SetAssistedPlatformId(platform), operationLaterDeleter);

    return processOperation(operation);
}

OperationSharedPtr PlatformOperations::SetPlatformId(const PlatformPtr& platform,
                                                     const command::CmdSetPlatformIdData &data) {
    OperationSharedPtr operation(new operation::SetPlatformId(platform, data), operationLaterDeleter);

    return processOperation(operation);
}

OperationSharedPtr PlatformOperations::StartApplication(const PlatformPtr& platform) {
    OperationSharedPtr operation(new operation::StartApplication(platform), operationLaterDeleter);

    return processOperation(operation);
}

OperationSharedPtr PlatformOperations::StartBootloader(const PlatformPtr& platform) {
    OperationSharedPtr operation(new operation::StartBootloader(platform), operationLaterDeleter);

    return processOperation(operation);
}

void PlatformOperations::operationLaterDeleter(BasePlatformOperation* operation) {
    operation->deleteLater();
}

void PlatformOperations::handleOperationFinished(Result result, int status, QString errorString) {
    operation::BasePlatformOperation *baseOp = qobject_cast<operation::BasePlatformOperation*>(QObject::sender());
    if (baseOp == nullptr) {
        qCCritical(logCategoryPlatformOperation) << "Corrupt operation pointer:" << QObject::sender();
        return;
    }

    const QByteArray deviceId = baseOp->deviceId();
    const Type type = baseOp->type();

    disconnect(baseOp, nullptr, this, nullptr);

    // operation has finished, we do not need BasePlatformOperation object anymore
    operations_.remove(deviceId);

    emit finished(deviceId, type, result, status, errorString);
}

}  // namespace
