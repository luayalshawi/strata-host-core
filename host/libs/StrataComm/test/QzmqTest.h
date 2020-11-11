#pragma once

#include <QObject>
#include <QCoreApplication>
#include <QEventLoop>

#include "QtTest.h"
#include "../src/ServerConnector.h"
#include "../src/ClientConnector.h"

class ServerConnectorTest : public QObject {
    Q_OBJECT

private slots:
    void testServerConnector();
    void testOpenServerConnectorFaild();
    void testClientConnector();
    void testOpenClientConnectorFaild();
    void testServerAndClient();

private:
    static constexpr char address_[] = "tcp://127.0.0.1:5564";

};
