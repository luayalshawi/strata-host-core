#include <QThread>

#include "DispatcherTest.h"

DispatcherTest::DispatcherTest()
{
    cm_.push_back({"handler_1", {}, 1, strata::strataComm::MessageType::Command, "mg"});
    cm_.push_back({"handler_2", {}, 2, strata::strataComm::MessageType::Notifiation, "mg"});
    cm_.push_back({"handler_3", {}, 3, strata::strataComm::MessageType::none, "mg"});
    cm_.push_back({"handler_4", {}, 4, strata::strataComm::MessageType::Command, "mg"});
    cm_.push_back({"handler_5", {}, 5, strata::strataComm::MessageType::Command, "mg"});
}

void DispatcherTest::testStartDispatcher()
{
    Dispatcher dispatcher;

    QVERIFY_(dispatcher.start());
}

void DispatcherTest::testStopDispatcher()
{
    Dispatcher dispatcher;

    QVERIFY_(dispatcher.stop());
}

void DispatcherTest::testRegisteringHandlers()
{
    Dispatcher dispatcher;

    ClientMessage cm;
    cm.clientID = QByteArray("mg");
    cm.handlerName = "handler_1";

    QCOMPARE_(dispatcher.registerHandler(
                  "handler_1", std::bind(&TestHandlers::handler_1, th_, std::placeholders::_1)),
              true);
    QCOMPARE_(dispatcher.registerHandler(
                  "handler_1", std::bind(&TestHandlers::handler_1, th_, std::placeholders::_1)),
              false);
    QCOMPARE_(dispatcher.registerHandler(
                  "handler_2", std::bind(&TestHandlers::handler_1, th_, std::placeholders::_1)),
              true);
    QCOMPARE_(dispatcher.registerHandler(
                  "handler_1", std::bind(&TestHandlers::handler_2, th_, std::placeholders::_1)),
              false);
    QCOMPARE_(dispatcher.registerHandler(
                  "handler_2", std::bind(&TestHandlers::handler_2, th_, std::placeholders::_1)),
              false);
    QCOMPARE_(dispatcher.registerHandler(
                  "handler_3", std::bind(&TestHandlers::handler_3, th_, std::placeholders::_1)),
              true);
}

void DispatcherTest::testDispatchHandlers()
{
    Dispatcher dispatcher;

    ClientMessage cm;
    cm.clientID = QByteArray("mg");
    cm.handlerName = "handler_1";

    QVERIFY_(dispatcher.registerHandler(
        "handler_1", std::bind(&TestHandlers::handler_1, th_, std::placeholders::_1)));
    QVERIFY_(dispatcher.registerHandler(
        "handler_2", std::bind(&TestHandlers::handler_2, th_, std::placeholders::_1)));
    QVERIFY_(dispatcher.registerHandler(
        "handler_3", std::bind(&TestHandlers::handler_3, th_, std::placeholders::_1)));
    QVERIFY_(dispatcher.registerHandler(
        "handler_4", std::bind(&TestHandlers::handler_4, th_, std::placeholders::_1)));

    QCOMPARE_(dispatcher.dispatch(cm_[0]), true);
    QCOMPARE_(dispatcher.dispatch(cm_[1]), true);
    QCOMPARE_(dispatcher.dispatch(cm_[2]), true);
    QCOMPARE_(dispatcher.dispatch(cm_[3]), true);
    QCOMPARE_(dispatcher.dispatch(cm_[4]), false);
    QCOMPARE_(dispatcher.dispatch(cm_[2]), true);
    QCOMPARE_(dispatcher.dispatch(cm_[4]), false);
    QCOMPARE_(dispatcher.dispatch(cm_[3]), true);
    QCOMPARE_(dispatcher.dispatch(cm_[0]), true);
}

void DispatcherTest::testDispatchHandlersUsingSignal()
{
    Dispatcher dispatcher;

    qRegisterMetaType<ClientMessage>("ClientMessage");
    connect(this, &DispatcherTest::disp, &dispatcher, &Dispatcher::dispatchHandler);

    QVERIFY_(dispatcher.registerHandler(
        "handler_1", std::bind(&TestHandlers::handler_1, th_, std::placeholders::_1)));
    QVERIFY_(dispatcher.registerHandler(
        "handler_2", std::bind(&TestHandlers::handler_2, th_, std::placeholders::_1)));
    QVERIFY_(dispatcher.registerHandler(
        "handler_3", std::bind(&TestHandlers::handler_3, th_, std::placeholders::_1)));
    QVERIFY_(dispatcher.registerHandler(
        "handler_4", std::bind(&TestHandlers::handler_4, th_, std::placeholders::_1)));

    emit disp(cm_[0]);
    emit disp(cm_[1]);
    emit disp(cm_[2]);
    emit disp(cm_[3]);
    emit disp(cm_[3]);
    emit disp(cm_[4]);
    emit disp(cm_[0]);
}

void DispatcherTest::testDispatchHandlersInDispatcherThread()
{
    Dispatcher *dispatcher = new Dispatcher();
    QThread *myThread = new QThread();

    dispatcher->moveToThread(myThread);
    myThread->start();

    qRegisterMetaType<ClientMessage>("ClientMessage");
    connect(this, &DispatcherTest::disp, dispatcher, &Dispatcher::dispatchHandler);

    QVERIFY_(dispatcher->registerHandler(
        "handler_1", std::bind(&TestHandlers::handler_1, th_, std::placeholders::_1)));
    QVERIFY_(dispatcher->registerHandler(
        "handler_2", std::bind(&TestHandlers::handler_2, th_, std::placeholders::_1)));
    QVERIFY_(dispatcher->registerHandler(
        "handler_3", std::bind(&TestHandlers::handler_3, th_, std::placeholders::_1)));
    QVERIFY_(dispatcher->registerHandler(
        "handler_4", std::bind(&TestHandlers::handler_4, th_, std::placeholders::_1)));

    ClientMessage cm;
    cm.clientID = QByteArray("mg");
    cm.handlerName = "handler_1";
    cm.messageID = 0;

    emit disp(cm);
    emit disp(cm);
    emit disp(cm);
    emit disp(cm);
    emit disp(cm);
    emit disp(cm);
    emit disp(cm);

    myThread->quit();
    myThread->wait();
}

void DispatcherTest::testDispatchHandlersLocalClientMessage()
{
    Dispatcher dispatcher;
    dispatcher.start();

    qRegisterMetaType<ClientMessage>("ClientMessage");
    connect(this, &DispatcherTest::disp, &dispatcher, &Dispatcher::dispatchHandler,
            Qt::QueuedConnection);

    dispatcher.registerHandler("handler_1",
                               std::bind(&TestHandlers::handler_1, th_, std::placeholders::_1));
    dispatcher.registerHandler("handler_2",
                               std::bind(&TestHandlers::handler_2, th_, std::placeholders::_1));
    dispatcher.registerHandler("handler_3",
                               std::bind(&TestHandlers::handler_3, th_, std::placeholders::_1));
    dispatcher.registerHandler("handler_4",
                               std::bind(&TestHandlers::handler_4, th_, std::placeholders::_1));

    ClientMessage cm;
    cm.clientID = QByteArray("mg");
    cm.handlerName = "handler_1";

    emit disp(cm);
    emit disp(cm);
    emit disp(cm);
    emit disp(cm);
    emit disp(cm);
    emit disp(cm);
    emit disp(cm);
}

void DispatcherTest::testLargeNumberOfHandlers()
{
    Dispatcher dispatcher;

    for (int i = 0; i < 1000; i++) {
        dispatcher.registerHandler(QString::number(i), [i](const ClientMessage &cm) {
            QCOMPARE_(cm.handlerName, QString::number(i));
        });
    }

    for (int i = 0; i < 1000; i++) {
        dispatcher.dispatch({QString::number(i), {}, 1, strata::strataComm::MessageType::Command, "mg"});
    }
}

void DispatcherTest::testLargeNumberOfHandlersUsingDispatcherThread()
{
    Dispatcher *dispatcher = new Dispatcher();
    QThread *myThread = new QThread();

    qRegisterMetaType<ClientMessage>("ClientMessage");
    connect(this, &DispatcherTest::disp, dispatcher, &Dispatcher::dispatchHandler);

    dispatcher->moveToThread(myThread);
    myThread->start();

    for (int i = 0; i < 1000; i++) {
        dispatcher->registerHandler(QString::number(i), [i](const ClientMessage &cm) {
            QCOMPARE_(cm.handlerName, QString::number(i));
        });
    }

    for (int i = 0; i < 1000; i++) {
        emit disp({QString::number(i), {}, 1, strata::strataComm::MessageType::Command, "mg"});
    }

    // wait for all events to be dispatched
    QTimer timer;
    timer.setSingleShot(true);
    timer.start(100);
    do {
        QCoreApplication::processEvents(QEventLoop::WaitForMoreEvents);
    } while (timer.isActive());

    myThread->quit();
    myThread->wait();
}
