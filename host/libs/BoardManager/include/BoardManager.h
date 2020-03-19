#ifndef BOARD_MANAGER_H
#define BOARD_MANAGER_H

#include <set>
#include <map>
#include <memory>

#include <QObject>
#include <QString>
#include <QTimer>
#include <QHash>
#include <QVariantMap>
#include <QVector>

#include <SerialDevice.h>
#include <DeviceProperties.h>


namespace strata {

    class DeviceOperations;

    class BoardManager : public QObject
    {
        Q_OBJECT
        Q_DISABLE_COPY(BoardManager)

        Q_PROPERTY(QVector<int> readyDeviceIds READ readyDeviceIds NOTIFY readyDeviceIdsChanged)

    public:
        BoardManager();
        ~BoardManager();

        /**
         * Initialize BoardManager (start managing connected devices).
         * @param getFwInfo if true send also get_firmware_info command during device identification
         */
        void init(bool getFwInfo = true);

        /**
         * Send a message to the device.
         * @param connectionId device connection ID
         * @param message message to send to the device
         */
        [[deprecated("Do not use this function anymore, it will be deleted soon.")]]
        Q_INVOKABLE void sendMessage(const int connectionId, const QString& message);

        /**
         * Disconnect from the device.
         * @param deviceId device ID
         */
        Q_INVOKABLE void disconnect(const int deviceId);

        /**
         * Reconnect the device.
         * @param deviceId device ID
         */
        Q_INVOKABLE void reconnect(const int deviceId);

        /**
         * Get smart pointer to the device.
         * @param deviceId device ID
         */
        SerialDeviceShPtr getDevice(const int deviceId) const;

        /**
         * Get information about connected device (platform ID, bootloader version, ...).
         * @param connectionId device connection ID
         * @return QVariantMap filled with information about device
         */
        [[deprecated("Do not use this function anymore, it will be deleted soon.")]]
        Q_INVOKABLE QVariantMap getConnectionInfo(const int connectionId);

        /**
         * Get list of available connection IDs.
         * @return list of available connection IDs (those, which have serial port opened)
         */
        QVector<int> readyDeviceIds();

        /**
         * Get device property.
         * @param connectionId device connection ID
         * @param property value from enum DeviceProperties
         * @return QString filled with value of required property
         */
        [[deprecated("Do not use this function anymore, it will be deleted soon.")]]
        QString getDeviceProperty(const int connectionId, const DeviceProperties property);

    signals:
        /**
         * Emitted when new board is connected to computer.
         * @param deviceId device ID
         */
        void boardConnected(int deviceId);

        /**
         * Emitted when board is disconnected.
         * @param deviceId device ID
         */
        void boardDisconnected(int deviceId);

        /**
         * Emitted when board is ready for communication.
         * @param deviceId device ID
         * @param recognized true when board was recognized (identified), otherwise false
         */
        void boardReady(int deviceId, bool recognized);

        /**
         * Emitted when error occured during communication with the board.
         * @param deviceId device ID
         * @param message error description
         */
        void boardError(int deviceId, QString message);

        /**
         * Emitted when there is available new message from the connected board.
         * @param deviceId device ID
         * @param message message from board
         */
        // DEPRECATED
        void newMessage(int deviceId, QString message);

        /**
         * Emitted when required operation cannot be fulfilled (e.g. connection ID does not exist).
         * @param deviceId device ID
         */
        // DEPRECATED
        void invalidOperation(int deviceId);

        /**
         * Emitted when device IDs has changed (available device ID list has changed).
         */
        void readyDeviceIdsChanged();

    private slots:
        void checkNewSerialDevices();
        void handleNewMessage(QString message);  // DEPRECATED
        void handleBoardError(QString message);
        void handleOperationFinished(int operation, int);

    private:
        void computeListDiff(std::set<int>& list, std::set<int>& added_ports, std::set<int>& removed_ports);
        bool addedSerialPort(const int deviceId);
        void removedSerialPort(const int deviceId);

        void logInvalidDeviceId(const QString& message, const int deviceId) const;

        QTimer timer_;

        // There is no need to use lock now because there is only one event loop in application. But if this library
        // will be used across QThreads (more event loops in application) in future, mutex will be necessary.

        // Access to these 3 members should be protected by mutex (one mutex for all) in case of multithread usage.
        // Do not emit signals in block of locked code (because their slots are executed immediately in QML
        // and deadlock can occur if from QML is called another function which uses same mutex).
        std::set<int> serialPortsList_;
        std::map<int, QString> serialIdToName_;
        QHash<int, SerialDeviceShPtr> openedSerialPorts_;
        std::map<int, std::unique_ptr<DeviceOperations>> serialDeviceOprations_;

        // flag if send get_firmware_info command
        bool getFwInfo_;
    };

}

#endif
