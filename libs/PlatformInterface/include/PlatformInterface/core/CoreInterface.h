#pragma once

//----
// Core Framework
//
// WARNING : DO NOT EDIT THIS FILE UNLESS YOU ARE ON THE CORE FRAMEWORK TEAM
//
//  Platform Implementation is done in PlatformInterface/platforms/<type>/PlatformInterface.h/cpp
//
//

#include <QObject>
#include <QString>
#include <QJsonObject>
#include <QJsonDocument>
#include <QJsonArray>
#include <StrataRPC/StrataClient.h>

class CoreInterface : public QObject
{
    Q_OBJECT

    //----
    // Core Framework Properties
    //
    Q_PROPERTY(QString platform_list_ READ platformList NOTIFY platformListChanged)
    Q_PROPERTY(QString connected_platform_list_ READ connectedPlatformList NOTIFY connectedPlatformListChanged)

public:
    explicit CoreInterface(QObject* parent = nullptr,
                           const std::string& hcsInAddress = "tcp://127.0.0.1:5563");
    virtual ~CoreInterface();

    // ---
    // Core Framework: Q_PROPERTY read methods
    QString platformList() { return platform_list_; }
    QString connectedPlatformList() { return connected_platform_list_; }

    bool registerNotificationHandler(const QString &method, strata::strataRPC::StrataClient::ClientHandler handler);

    // Invokables
    //To send the selected platform and its connection status
    Q_INVOKABLE void loadDocuments(QString class_id);
    Q_INVOKABLE void unregisterClient();
    Q_INVOKABLE void sendCommand(QString cmd);
    Q_INVOKABLE void sendRequest(const QString &handler, const QJsonObject &payload);
    Q_INVOKABLE void sendNotification(const QString &handler, const QJsonObject &payload);

    void setNotificationThreadRunning(bool running);

signals:
    // ---
    // Core Framework Signals
    bool platformListChanged(QString list);
    bool connectedPlatformListChanged(QString list);

    // Platform Framework Signals
    void notification(QString payload);                             // can be replaced with a handler

private:

    // ---
    // Core Framework
    QString platform_list_{"{ \"list\":[]}"};
    QString connected_platform_list_{"{ \"list\":[]}"};
    QString hcs_token_;
    std::atomic_bool notification_thread_running_;

    // Main Catagory Notification handlers
    void platformNotificationHandler(const QJsonObject &notification);
    void cloudNotificationHandler(QJsonObject notification);

    void processAllPlatformsNotification(const QJsonObject &payload);
    void processConnectedPlatformsNotification(const QJsonObject &payload);

    // Core Framework Notificaion Handlers
    void hcsNotificationHandler(QJsonObject payload);

    std::shared_ptr<strata::strataRPC::StrataClient> strataClient_;
};
