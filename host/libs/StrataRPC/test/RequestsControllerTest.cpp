#include "RequestsControllerTest.h"

#include <StrataRPC/Message.h>
// #include <StrataRPC/PendingRequest.h>

using namespace strata::strataRPC;

void RequestsControllerTest::testAddRequest()
{
    RequestsController rc;

    for (int i = 1; i < 30; i++) {
        std::pair<std::shared_ptr<PendingRequest>, QByteArray> requestInfo =
            rc.addNewRequest("method_1", {{"api", "v1"}});

        QVERIFY_(requestInfo.first->getId() != 0);
        QVERIFY_(false == requestInfo.second.isEmpty());
    }

    QVERIFY_(rc.isPendingRequest(1));
    QVERIFY_(false == rc.isPendingRequest(100));

    for (int i = 1; i < 30; i++) {
        QVERIFY_(rc.removePendingRequest(i));
    }

    QVERIFY_(false == rc.removePendingRequest(1));
    QVERIFY_(false == rc.removePendingRequest(1000));
}

void RequestsControllerTest::testLargeNumberOfPendingRequests()
{
    RequestsController rc;

    for (int i = 0; i < 300; i++) {
        std::pair<std::shared_ptr<PendingRequest>, QByteArray> requestInfo =
            rc.addNewRequest(QString::number(i), {{"message_id", i}});
        QVERIFY_(requestInfo.first->getId() != 0);
        QVERIFY_(false == requestInfo.second.isEmpty());
    }
}

void RequestsControllerTest::testNonExistanteRequestId()
{
    RequestsController rc;

    QVERIFY_(false == rc.isPendingRequest(0));
    QVERIFY_(false == rc.isPendingRequest(-1));
    QVERIFY_(false == rc.isPendingRequest(2));

    QVERIFY_(false == rc.removePendingRequest(0));
    QVERIFY_(false == rc.removePendingRequest(-1));
    QVERIFY_(false == rc.removePendingRequest(2));
}

void RequestsControllerTest::testGetMethodName()
{
    RequestsController rc;
    std::pair<std::shared_ptr<PendingRequest>, QByteArray> requestInfo_1 =
        rc.addNewRequest("method_handler_1", {});
    QVERIFY_(requestInfo_1.first->getId() != 0);
    QVERIFY_(false == requestInfo_1.second.isEmpty());

    std::pair<std::shared_ptr<PendingRequest>, QByteArray> requestInfo_2 =
        rc.addNewRequest("method_handler_2", {});
    QVERIFY_(requestInfo_2.first->getId() != 0);
    QVERIFY_(false == requestInfo_2.second.isEmpty());

    QVERIFY_(rc.isPendingRequest(1));
    QCOMPARE_(rc.getMethodName(1), "method_handler_1");

    QVERIFY_(rc.isPendingRequest(2));
    QCOMPARE_(rc.getMethodName(2), "method_handler_2");

    QVERIFY_(false == rc.isPendingRequest(3));
    QCOMPARE_(rc.getMethodName(3), "");

    QVERIFY_(rc.removePendingRequest(1));
    QVERIFY_(false == rc.isPendingRequest(1));
    QCOMPARE_(rc.getMethodName(1), "");
}

void RequestsControllerTest::testPopRequest()
{
    RequestsController rc;
    int numOfTestCases = 100;

    for (int i = 0; i < numOfTestCases; i++) {
        const auto [pendingRequest, requestJson] =
            rc.addNewRequest("test_handler", QJsonObject({{}}));

        connect(pendingRequest.get(), &PendingRequest::finishedSuccessfully, this,
                [i](const Message &message) { QCOMPARE_(i, message.messageID); });

        QVERIFY(pendingRequest->getId() > 0);
        QVERIFY(requestJson != "");
    }

    for (int i = 0; i < numOfTestCases; i++) {
        const auto [res, request] = rc.popPendingRequest(i + 1);
        QVERIFY(res);
        QVERIFY(request.pendingRequest_->hasSuccessCallback());
        QVERIFY(false == request.pendingRequest_->hasErrorCallback());

        Message message;
        message.messageID = i;
        request.pendingRequest_->callSuccessCallback(message);
    }

    const auto [res, request] = rc.popPendingRequest(numOfTestCases);
    QVERIFY(false == res);
}
