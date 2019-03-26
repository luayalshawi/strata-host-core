//----
// Core Framework
//
// WARNING : DO NOT EDIT THIS FILE UNLESS YOU ARE ON THE CORE FRAMEWORK TEAM
//
//  Platform Implementation is done in PlatformInterface/platforms/<type>/PlatformInterface.h/cpp
//
//

#include "core/CoreInterface.h"

using namespace std;
using namespace Spyglass;

const char* HOST_CONTROLLER_SERVICE_IN_ADDRESS = "tcp://127.0.0.1:5563";

CoreInterface::CoreInterface(QObject *parent) : QObject(parent)
{
    //qDebug() << "CoreInterface::CoreInterfaceQObject *parent) : QObject(parent) CTOR\n";

    hcc = new HostControllerClient(HOST_CONTROLLER_SERVICE_IN_ADDRESS);

    // [TODO] [prasanth] : need to be added in a better place
    // json command to ask the list of available platforms from hcs
    registerClient();

    // --------------------
    // Core Framework
    // install main notification notification handlers
    //
    // Main sources:
    // "notification"           // platform devices
    // "cloud::notification"    // cloud notifications
    //
    // from platform TODO [ian] make namespaced platform::notification
    registerNotificationHandler("notification",
                                bind(&CoreInterface::platformNotificationHandler,
                                     this, placeholders::_1));

    registerNotificationHandler("hcs::notification",
                                bind(&CoreInterface::platformListHandler,
                                     this, placeholders::_1));

    registerNotificationHandler("remote::notification",
                                bind(&CoreInterface::remoteSetupHandler,
                                     this, placeholders::_1));

    registerNotificationHandler("cloud::notification",
                                bind(&CoreInterface::cloudNotificationHandler,
                                     this, placeholders::_1));

    registerNotificationHandler("platform_id",
                                bind(&CoreInterface::platformIDNotificationHandler,
                                     this, placeholders::_1));

    registerNotificationHandler("platform_connection_change_notification",
                                bind(&CoreInterface::connectionChangeNotificationHandler,
                                     this, placeholders::_1));

    platform_state_ = false;
    notification_thread_running_ = false;
    notification_thread_= std::thread(&CoreInterface::notificationsThread,this);

}

CoreInterface::~CoreInterface()
{
    //qDebug() << "CoreInterface::~CoreInterface() DTOR\n";

    delete(hcc);
    notification_thread_.detach();
}

// @f notificationsThreadHandle
// @b main dispatch thread for notifications from Host Controller Service
//
//
void CoreInterface::notificationsThread()
{
    //qDebug () << "CoreInterface::notificationsThread - notification handling.";
    notification_thread_running_ = true;

    while(notification_thread_running_) {
        // Notification Message Architecture
        //
        //    {
        //        "notification": {
        //            "value": "platform_connection_change_notification",
        //            "payload": {
        //                "status": "disconnected"
        //            }
        //        }
        //    }
        //
        //    {
        //        "cloud::notification": {
        //        "type": "document",
        //        "name": "schematic",
        //        "documents": [
        //              {"data": "*******","filename": "schematic1.png"},
        //              {"data": "*******","filename": "schematic1.png"}
        //        ]
        //        }
        //   }
        //

        // TODO [ian] need to avoid uneeded std::string to QString conversion
        // TODO [ian] need to error check/validate json messages
        string message = hcc->receiveNotification();  // Host Controller Service

        QString n(message.c_str());



        // Debug; Some messages are too long to print (ex: cloud images)
        if (n.length() < 500) {
          qDebug() <<"[recv]" << n;
          emit pretendMetrics(n); // TODO: remove this (see pretendMetrics in CoreInterface.H)
        } else {
          qDebug() <<"[recv] Unprinted: Long Data Message Over 500 Chars";
          emit pretendMetrics("Cloud file download, over 500 chars"); // TODO: remove this (see pretendMetrics in CoreInterface.H)
        }

        QJsonDocument doc = QJsonDocument::fromJson(n.toUtf8());
        if(doc.isNull()) {
            // TODO [ian] fix the "ONSEMI" message from fouling up all this
            //qCritical()<<"ERROR: void CoreInterface::notificationsThreadHandle()."
            //             "Failed to create JSON doc. message=" << n.toStdString().c_str();
            continue;
        }

        QJsonObject notification_json = doc.object();
        if(notification_json.isEmpty() ) {
            qCritical()<<"ERROR: void CoreInterface::notificationsThreadHandle():"
                         "JSON is empty.";
            continue;
        }

        //[TODO: ack responses to setting a parameter have both an "ack" and a "payload", which generates an error here. How should that be fixed?]
        QStringList keys = notification_json.keys();
        if( keys.size() != 1 ) {
            //qCritical()<<"ERROR: void CoreInterface::notificationsThreadHandle():"
            //             " More then one key in notification message. Violates message architecture.";
            continue;
        }

        QString notification(keys.at(0)); // top level JSON keys

        auto handler = notification_handlers_.find(notification.toStdString());
        if( handler == notification_handlers_.end()) {
            qCritical("CoreInterface::notificationsThreadHandle()"
                      " ERROR: no handler exits for %s !!", notification.toStdString().c_str ());
            continue;
        }

        // dispatch handler for notification
        handler->second(notification_json[notification].toObject());
    }
}

// ---
// Core Framework Infrastructure Notification Handlers
//
void CoreInterface::platformIDNotificationHandler(QJsonObject payload)
{
    if (payload.contains("platform_id")) {
        QString platform_id = payload["platform_id"].toString();
        //qDebug() << "Received platform_id = " << platform_id;

        if(platform_id_ != platform_id ) {
            platform_id_ = platform_id;
            emit platformIDChanged(platform_id_);

            // also update platform connected state
            platform_state_ = true;
            emit platformStateChanged(platform_state_);
        }
    }
}

void CoreInterface::connectionChangeNotificationHandler(QJsonObject payload)
{
    QString state = payload["status"].toString();
    //qDebug() << "platform_state = " << state;

    if( state == "connected" ) {
        platform_state_ = true;
        emit platformStateChanged(platform_state_);
    }
    else {
        platform_state_ = false;
        platform_list_ = "{ \"list\":[]}";
        emit platformStateChanged(platform_state_);
    }
}

// @f platformNotificationHandler
// @b handle platform notifications
//
//  TODO [ian] change "value" to "name" of notification message
//    {
//        "notification": {
//            "value": "platform_connection_change_notification",
//            "payload": {
//                "status": "disconnected"
//            }
//        }
//    }

void CoreInterface::platformNotificationHandler(QJsonObject payload)
{
    //qDebug("ImplementationInterfaceBinding::platformmNotificationHandler: CALLED");

    if( payload.contains("value") == false ) {
        qCritical("CoreInterface::platformNotificationHandler()"
                  " ERROR: no name for notification!!");
        return;
    }

    if( payload.contains("payload") == false ) {
        qCritical("CoreInterface::platformNotificationHandler()"
                  " ERROR: no payload for notification!!");
        return;
    }

    QString value = payload["value"].toString();
    auto handler = notification_handlers_.find(value.toStdString());
    if( handler == notification_handlers_.end()) {
        QJsonDocument doc(payload);
        emit notification( doc.toJson(QJsonDocument::Compact));
        return;
    }

    handler->second(payload["payload"].toObject());
    QJsonDocument doc(payload);
    emit notification( doc.toJson(QJsonDocument::Compact));


}

// @f initialHandshakeHandler
// @b handle initial list of platform message
//
//    {
//        "handshake":
//          "list":[{
//            "verbose":"simulated-usb-pd",
//            "uuid":"P2.2017.1.1.0.0.cbde0519-0f42-4431-a379-caee4a1494af",
//             "remote":false
//            }
//        ]
//    }

void CoreInterface::platformListHandler(QJsonObject payload)
{
    QJsonDocument testdoc(payload);
    QString strJson_list(testdoc.toJson(QJsonDocument::Compact));

    if( platform_list_ != strJson_list ) {
        platform_list_ = strJson_list;
        //qDebug() << "initialHandshakeHandler: platform_list:" << platform_list_;
        emit platformListChanged(platform_list_);
    }
}


// @f remoteSetupHandler
// @b handles the messages required for remote connection
// advertise_platforms - gets the hcs token required for connection
// get_platforms - TO indicate if the hcs token entered is valid
void CoreInterface::remoteSetupHandler(QJsonObject payload)
{
    if( payload.contains("value") == false ) {
        qCritical("CoreInterface::platformNotificationHandler()"
                  " ERROR: no name for notification!!");
        return;
    }

    if( payload.contains("payload") == false ) {
        qCritical("CoreInterface::platformNotificationHandler()"
                  " ERROR: no payload for notification!!");
        return;
    }
    if(payload["value"].toString()=="advertise_platforms") {
        //qDebug("Parse success");
        bool status = payload["payload"].toObject()["status"].toBool();
        if(status) {
            hcs_token_ = payload["payload"].toObject()["hcs_id"].toString();
            //qDebug()<<hcs_token_;
        }
        else {
            hcs_token_ = "";
        }
        emit hcsTokenChanged(hcs_token_);
    }
    else if(payload["value"].toString()=="get_platforms") {
        //qDebug("Parse success");
        bool status = payload["payload"].toObject()["status"].toBool();
        if(status) {
            //qDebug("Remote response: token valid");
        }
        else {
            //qDebug("Remote response: token invalid");
        }
        emit remoteConnectionChanged(status);
    }
    else if(payload["value"].toString()=="remote_activity") {
        //qDebug("parse success");
        remote_user_activity_ = payload["payload"].toObject()["user_name"].toString();
        emit remoteActivityChanged(remote_user_activity_);
        //qDebug()<<remote_user_activity_;
    }
    else if(payload["value"].toString()=="remote_user_added") {
        //qDebug("parse success");
        remote_user_ = payload["payload"].toObject()["user_name"].toString();
        emit remoteUserAdded(remote_user_);
        //qDebug()<<remote_user_;
    }
    else if(payload["value"].toString()=="remote_user_removed") {
        //qDebug("parse success");
        remote_user_ = payload["payload"].toObject()["user_name"].toString();
        emit remoteUserRemoved(remote_user_);
        //qDebug()<<remote_user_;
    }
    //qDebug()<< payload;
}

// @f sendSelectedPlatform
// @b send the user selected platform to HCS to create the mapping
//
// TOOD connect is a better name
void CoreInterface::sendSelectedPlatform(QString verbose, QString connection_status)
{
    QJsonObject cmdPayloadObject;
    cmdPayloadObject.insert("platform_uuid",verbose);
    cmdPayloadObject.insert("remote",connection_status);

    QJsonObject cmdMessageObject;
    cmdMessageObject.insert("cmd", "platform_select");
    cmdMessageObject.insert("payload", cmdPayloadObject);

    QJsonDocument doc(cmdMessageObject);
    QString strJson(doc.toJson(QJsonDocument::Compact));
    //qDebug()<<"parse to send"<<strJson;
    hcc->sendCmd(strJson.toStdString());
}

// @f sendCommand
// @b send json command to platform
//
void CoreInterface::sendCommand(QString cmd)
{
    hcc->sendCmd(cmd.toStdString());
}

// @f registerClient
// @b send initial handshake to receive platform list
//
void CoreInterface::registerClient()
{
    QJsonObject cmdMessageObject;
    cmdMessageObject.insert("cmd", "register_client");
    cmdMessageObject.insert("payload", QJsonObject());

    QJsonDocument doc(cmdMessageObject);
    QString strJson(doc.toJson(QJsonDocument::Compact));
    //qDebug()<<"parse to send"<<strJson;
    hcc->sendCmd(strJson.toStdString());
}

// @f unregisterClient
// @b Unregister to remove any notifications from HCS
//
void CoreInterface::unregisterClient()
{
    QJsonObject cmdMessageObject;
    cmdMessageObject.insert("cmd", "unregister");
    cmdMessageObject.insert("payload", QJsonObject());

    QJsonDocument doc(cmdMessageObject);
    QString strJson(doc.toJson(QJsonDocument::Compact));
    //qDebug()<<"parse to send"<<strJson;
    hcc->sendCmd(strJson.toStdString());
}

// @f cloudNotificationHandler
// @b handle cloud service notifications
//
//
//  CLOUD JSON STRUCTURE
// {
//   "cloud::notification": {
//     "type": "document",
//     "name": "schematic",
//     "documents": [
//       {"data": "*******","filename": "schematic1.png"},
//       {"data": "*******","filename": "schematic1.png"}
//     ]
//   }
// }
//
// {
//   "cloud::notification": {
//     "type": "marketing",
//     "name": "adas_sensor_fusion",
//     "data": "raw html"
//  }
// }
//
void CoreInterface::cloudNotificationHandler(QJsonObject payload)
{
    // data source type: document_set, chat, marketing et al
    string type = payload.value("type").toString().toStdString();

    auto handler = data_source_handlers_.find(type);
    if( handler == data_source_handlers_.end()) {
        qCritical("CoreInterface::cloudNotification"
                  " ERROR: no handler exits for %s !!", type.c_str ());
        return;
    }

    handler->second(payload);  // dispatch handler for notification

}

bool CoreInterface::registerNotificationHandler(std::string notification, NotificationHandler handler)
{
    //qDebug("CoreInterface::registerNotificationHandler:"
    //          "source=%s", notification.c_str());

    auto search = notification_handlers_.find(notification);
    if( search != notification_handlers_.end()) {
        qCritical("CoreInterface::registerNotificationHandler:"
                  " ERROR: handler already exits for %s !!", notification.c_str ());
        return false;
    }

    notification_handlers_.emplace(std::make_pair(notification, handler));

    return true;
}

bool CoreInterface::registerDataSourceHandler(std::string source, DataSourceHandler handler)
{
    qDebug("CoreInterface::registerDataSourceHanlder:"
              "source=%s", source.c_str());

    auto search = data_source_handlers_.find(source);
    if( search != data_source_handlers_.end()) {
        qCritical("CoreInterface::registerDataSourceHanlder:"
                  " ERROR: handler already exits for %s !!", source.c_str ());
        return false;
    }

    data_source_handlers_.emplace(std::make_pair(source, handler));

    // notify Host Controller Service of the data source connection
    //    {
    //        "db::cmd":"connect_data_source",
    //        "db::payload":{
    //            "type":"documents"
    //        }
    //    }
    //
    QJsonObject cmd;
    QJsonObject payload;

    cmd.insert("db::cmd", "connect_data_source");
    payload.insert("type", source.c_str());
    cmd.insert("db::payload", payload);

    hcc->sendCmd(QString(QJsonDocument(cmd).toJson(QJsonDocument::Compact)).toStdString());
    return true;
}

#if CODE_SNIPPETS
//    auto message = R"(
//                {
//                    "notification": {
//                        "value": "platform_connection_change_notification",
//                        "payload": {
//                            "status": "disconnected"
//                        }
//                    }
//                }
//                )";

//    auto message = R"(
//                {
//                    "cloud::notification": {
//                        "value": "platform_connection_change_notification",
//                        "payload": {
//                            "status": "disconnected"
//                        }
//                    }
//                }
//                )";

//    QString n(message);
//    QJsonDocument doc = QJsonDocument::fromJson(n.toUtf8());
//    if(doc.isNull()){
//        qCritical()<<"ERROR: void ImplementationInterfaceBinding::notificationsThreadHandle(). Failed to create JSON doc.";
//        //continue;
//    }

//    QJsonObject notification_json = doc.object();
//    if(notification_json.isEmpty() ) {
//        qCritical()<<"ERROR: void ImplementationInterfaceBinding::notificationsThreadHandle(): JSON is empty.";
//        //continue;
//    }

//    // get keys from json object. Must only
//    QStringList keys = notification_json.keys();
//    if( keys.size() > 1 ) {
//        qCritical()<<"ERROR: void ImplementationInterfaceBinding::notificationsThreadHandle():"
//                     " More then one key in notification message. Violates message architecture.";
//        //continue;
//    }

//    QString notification(keys.at(0));

//    auto handler = notification_handlers_.find(notification.toStdString());
//    if( handler == notification_handlers_.end()) {
//        qCritical("ImplementationInterfaceBinding::notificationsThreadHandle()"
//                  " ERROR: no handler exits for %s !!", notification.toStdString().c_str ());
//        //return;
//    }
//    handler->second(notification_json);  // dispatch handler for notification
#endif