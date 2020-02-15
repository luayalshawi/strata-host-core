#pragma once

#include <QString>

#include <gtest/gtest.h>


class DatabaseImplTest : public ::testing::Test
{
public:
    DatabaseImplTest();

    bool isJsonMsgSuccess(const QString &msg);

    QString DB_folder_path_;

    const QString url_ = "ws://localhost:4984/db";

protected:
    void SetUp() override;

    virtual void TearDown() override;
};
