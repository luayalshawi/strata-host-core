#include "Server.h"
#include "logging/LoggingQtCategories.h"

#include <QDateTime>

using namespace strata::strataRPC;

Server::Server(QObject *parent)
    : QObject(parent),
      strataServer_(std::make_shared<StrataServer>(address_, true, this)),
      serverTimeBroadcastTimer_(this),
      randomGraph_(new RandomGraph(strataServer_, this))
{
    strataServer_->registerHandler(
        "close_server", std::bind(&Server::closeServerHandler, this, std::placeholders::_1));

    strataServer_->registerHandler(
        "server_status", std::bind(&Server::serverStatusHandler, this, std::placeholders::_1));

    strataServer_->registerHandler("ping", [this](const Message &message) {
        strataServer_->notifyClient(message, QJsonObject(), ResponseType::Response);
    });
}

Server::~Server()
{
}

bool Server::init()
{
    qCDebug(logCategoryStrataServerSample) << "Initializing Strata Server.";
    return strataServer_->initializeServer();
}

void Server::start()
{
    connect(strataServer_.get(), &StrataServer::errorOccurred, this, &Server::serverErrorHandler);

    serverTimeBroadcastTimer_.setInterval(std::chrono::seconds(10));
    connect(&serverTimeBroadcastTimer_, &QTimer::timeout, this, &Server::serverTimeBroadcast);
    serverTimeBroadcastTimer_.start();
}

void Server::serverErrorHandler(StrataServer::ServerError errorType, const QString &errorMessage)
{
    qCDebug(logCategoryStrataServerSample).noquote() << QString(84, '#');
    qCDebug(logCategoryStrataServerSample) << "Error type:" << errorType;
    qCDebug(logCategoryStrataServerSample) << "Error message:" << errorMessage;
    qCDebug(logCategoryStrataServerSample).noquote() << QString(84, '#');
}

void Server::closeServerHandler(const Message &message)
{
    strataServer_->notifyClient(message, QJsonObject{{"message", "server shutdown requested"}},
                                ResponseType::Response);
    qCInfo(logCategoryStrataServerSample) << "Closing Strata Server...";
    emit appDone(0);
}

void Server::serverStatusHandler(const strata::strataRPC::Message &message)
{
    strataServer_->notifyClient(message, QJsonObject{{"status", "active"}}, ResponseType::Response);
}

void Server::serverTimeBroadcast()
{
    auto currentTimeString = QDateTime::currentDateTime().toString("hh:mm:ss t");
    qCInfo(logCategoryStrataServerSample) << "Broadcasting server time." << currentTimeString;

    strataServer_->notifyAllClients("server_time", QJsonObject{{"time", currentTimeString}});
}