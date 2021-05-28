#pragma once

#include <rapidjson/document.h>
#include <QObject>
#include <Mock/MockDevice.h>
#include "Operations/PlatformOperations.h"
#include "Flasher.h"

#include <QtTest>

class FlasherTest : public QObject
{
    Q_OBJECT
    Q_DISABLE_COPY(FlasherTest)

public:
    FlasherTest();

private slots:
    // test init/teardown
    void initTestCase();
    void cleanupTestCase();
    void init();
    void cleanup();

    // tests standard responses
    void flashFirmwareTest();
    void flashFirmwareWithoutStartApplicationTest();
    void flashFirmwareStartInBootloaderTest();
    void flashBootloaderTest();
    void flashBootloaderStartInBootloaderTest();
    void setFwClassIdTest();
    void setFwClassIdWithoutStartApplicationTest();
    //TODO: Add Backup Firmware tests standard & faulty/invalid responses

    // tests faulty/invalid responses
    void startFlashFirmwareInvalidCommandTest();
    void startFlashFirmwareFirmwareTooLargeTest();
    void flashFirmwareResendChunkTest();
    void flashFirmwareMemoryErrorTest();
    void flashFirmwareInvalidCmdSequenceTest();

    // tests faulty scenarios
    void disconnectWhileFlashingTest();
    void setNoFwClassIdTest();
    void flashFirmwareCancelTest();
    void flashBootloaderCancelTest();

protected slots:
    void handleFlasherFinished(strata::Flasher::Result result, QString);
    void handleFlashingProgressForDisconnectWhileFlashing(int chunk, int total);
    void handleFlashingProgressForCancelFlashOperation(int chunk, int total);

private:
    static void printJsonDoc(rapidjson::Document &doc);
    static void verifyMessage(const QByteArray &msg, const QByteArray &expectedJson);

    void connectFlasherHandlers(strata::Flasher* flasher) const;
    void connectFlasherForDisconnectWhileFlashing(strata::Flasher* flasher) const;
    void connectFlasherForCancelFirmwareOperation(strata::Flasher* flasher) const;

    void createFiles();
    void getExpectedValues(QString firmwarePath);
    void clearExpectedValues();

    strata::platform::PlatformPtr platform_;
    strata::device::MockDevicePtr mockDevice_;
    QSharedPointer<strata::Flasher> flasher_;
    strata::platform::operation::PlatformOperations platformOperations_;

    int flasherFinishedCount_ = 0;
    int flasherOkCount_ = 0;
    int flasherNoFirmwareCount_ = 0;
    int flasherErrorCount_ = 0;
    int flasherDisconnectedCount_ = 0;
    int flasherTimeoutCount_ = 0;
    int flasherCancelledCount_ = 0;

    QTemporaryFile fakeFirmware_;
    QTemporaryFile fakeBootloader_;

    QString expectedMd5_;
    int expectedChunksCount_ = 0;
    QVector<quint64> expectedChunkSize_;
    QVector<QByteArray> expectedChunkData_;
    QVector<quint16> expectedChunkCrc_;
};