#include "PlatformInterfaceGenerator.h"
#include "SGUtilsCpp.h"
#include "logging/LoggingQtCategories.h"

#include <QFile>
#include <QDir>
#include <QDebug>
#include <QJsonDocument>
#include <QJsonArray>
#include <QJsonParseError>
#include <QMetaType>
#include <QVariantList>
#include <QDateTime>

QString PlatformInterfaceGenerator::lastError_ = QString();

PlatformInterfaceGenerator::PlatformInterfaceGenerator(QObject *parent) : QObject(parent) {}

PlatformInterfaceGenerator::~PlatformInterfaceGenerator() {}

QString PlatformInterfaceGenerator::lastError()
{
    return lastError_;
}

bool PlatformInterfaceGenerator::generate(const QString &pathToJson, const QString &outputPath)
{
    lastError_ = "";
    if (!QFile::exists(pathToJson)) {
        lastError_ = "Path to input file (" + pathToJson + ") does not exist.";
        qCCritical(logCategoryPlatformInterfaceGenerator) << "Input file path does not exist. Tried to read from" << pathToJson;
        return false;
    }

    QFile inputFile(pathToJson);
    inputFile.open(QIODevice::ReadOnly | QIODevice::Text);

    QString fileText = inputFile.readAll();
    inputFile.close();

    QJsonParseError parseError;
    QJsonDocument doc = QJsonDocument::fromJson(fileText.toUtf8(), &parseError);

    if (parseError.error != QJsonParseError::NoError) {
        lastError_ = "Failed to parse json: " + parseError.errorString();
        qCCritical(logCategoryPlatformInterfaceGenerator) << lastError_;
        return false;
    }

    QJsonObject platInterfaceData = doc.object();

    QDir outputDir(outputPath);

    if (!outputDir.exists()) {
        lastError_ = "Path to output folder (" + outputPath + ") does not exist.";
        qCCritical(logCategoryPlatformInterfaceGenerator) << "Output folder path does not exist.";
        return false;
    }

    QFile outputFile(outputDir.filePath("PlatformInterface.qml"));

    if (!outputFile.open(QFile::WriteOnly | QFile::Truncate)) {
        lastError_ = "Could not open " + outputFile.fileName() + " for writing";
        qCCritical(logCategoryPlatformInterfaceGenerator) << "Could not open" << outputFile.fileName() + "for writing";
        return false;
    }

    QTextStream outputStream(&outputFile);
    int indentLevel = 0;

    // Generate imports
    outputStream << generateImports();

    // Generate Header Comment
    QDateTime localTime(QDateTime::currentDateTime());
    SGUtilsCpp utils;
    outputStream << generateCommentHeader("File auto-generated by PlatformInterfaceGenerator on " + utils.formatDateTimeWithOffsetFromUtc(localTime));

    // Start of root item
    outputStream << "PlatformInterfaceBase {\n";
    indentLevel++;
    outputStream << insertTabs(indentLevel)
                 << "id: platformInterface\n"
                 << insertTabs(indentLevel) << "apiVersion: " << API_VERSION << "\n\n";
    outputStream << insertTabs(indentLevel) << "property alias notifications: notifications\n";
    outputStream << insertTabs(indentLevel) << "property alias commands: commands\n\n";

    // Notifications
    outputStream << generateCommentHeader("NOTIFICATIONS", indentLevel);
    outputStream << insertTabs(indentLevel) << "QtObject {\n";

    indentLevel++;
    outputStream << insertTabs(indentLevel) << "id: notifications\n\n";

    // Create QtObjects to handle notifications

    if (!platInterfaceData.contains("notifications")) {
        lastError_ = "Missing notifications list in JSON.";
        qCCritical(logCategoryPlatformInterfaceGenerator) << lastError_;
        return false;
    }

    QJsonValue notificationsList = platInterfaceData["notifications"];

    if (!notificationsList.isArray()) {
        lastError_ = "'notifications' needs to be an array";
        qCCritical(logCategoryPlatformInterfaceGenerator) << lastError_;
        return false;
    }

    for (QJsonValue vNotification : notificationsList.toArray()) {
        QJsonObject notification = vNotification.toObject();
        if (notification.contains("payload") && notification["payload"].isNull()) {
            continue;
        }
        outputStream << generateNotification(notification, indentLevel);
        if (lastError_.length() > 0) {
            return false;
        }
    }

    indentLevel--;
    outputStream << insertTabs(indentLevel) << "}\n\n";

    // Commands
    outputStream << generateCommentHeader("COMMANDS", indentLevel);
    outputStream << insertTabs(indentLevel) << "QtObject {\n";

    indentLevel++;
    outputStream << insertTabs(indentLevel) << "id: commands\n";

    if (!platInterfaceData.contains("commands")) {
        lastError_ = "Missing commands list in JSON.";
        qCCritical(logCategoryPlatformInterfaceGenerator) << lastError_;
        return false;
    }

    QJsonArray commandsList = platInterfaceData["commands"].toArray();

    if (!notificationsList.isArray()) {
        lastError_ = "'commands' needs to be an array";
        qCCritical(logCategoryPlatformInterfaceGenerator) << lastError_;
        return false;
    }

    for (int i = 0; i < commandsList.count(); ++i) {
        QJsonObject command = commandsList[i].toObject();
        outputStream << generateCommand(command, indentLevel);
        if (lastError_.length() > 0) {
            return false;
        }
    }

    indentLevel--;
    outputStream << insertTabs(indentLevel) + "}\n";
    indentLevel--;
    outputStream << "}\n";
    outputFile.close();

    if (indentLevel != 0) {
        lastError_ = "Final indent level is not 0. Check file for indentation errors";
        qCWarning(logCategoryPlatformInterfaceGenerator) << lastError_;
        return true;
    }

    lastError_ = "";
    return true;
}

QString PlatformInterfaceGenerator::generateImports()
{
    QString imports = "import QtQuick 2.12\n";
    imports += "import QtQuick.Controls 2.12\n";
    imports += "import tech.strata.common 1.0\n";
    imports += "\n\n";
    return imports;
}

QString PlatformInterfaceGenerator::generateCommand(const QJsonObject &command, int &indentLevel)
{
    const QString cmd = command["cmd"].toString();
    QString documentationText = generateComment("@command " + cmd, indentLevel);
    QString commandBody = "";

    commandBody += insertTabs(indentLevel) + "property var " + cmd + ": ({\n";
    commandBody += insertTabs(indentLevel + 1) + "\"cmd\": \"" + cmd + "\",\n";

    QStringList updateFunctionParams;
    QStringList updateFunctionKwRemoved;

    if (command.contains("payload") && !command["payload"].isNull()) {
        QJsonObject payload = command["payload"].toObject();
        for (QString key : payload.keys()) {
            updateFunctionParams.append(key);
        }
        updateFunctionKwRemoved = updateFunctionParams;
        removeReservedKeywords(updateFunctionKwRemoved);

        commandBody += insertTabs(indentLevel + 1) + "\"payload\": {\n";
        QStringList payloadProperties;

        for (QString key : payload.keys()) {
            QJsonValue propValue = payload[key];
            QString propType = getType(propValue);
            if (propType.isNull()) {
                lastError_ = "Property '" + key + "' in command '" + cmd + "' does not have a valid value.";
                qCCritical(logCategoryPlatformInterfaceGenerator) << lastError_;
                return "";
            }

            payloadProperties.append(insertTabs(indentLevel + 2) + "\"" + key + "\": " + getPropertyValue(propValue, propType, indentLevel + 2));

            if (lastError_.length() > 0) {
                qCCritical(logCategoryPlatformInterfaceGenerator) << lastError_;
                return "";
            }

            if (propType == "var" && propValue.isArray()) {
                documentationText += generateComment("@property " + key + ": list of size " + QString::number(propValue.toArray().count()), indentLevel);
            } else {
                documentationText += generateComment("@property " + key + ": " + propType, indentLevel);
            }
        }

        commandBody += payloadProperties.join(",\n");
        commandBody += "\n";
        commandBody += insertTabs(indentLevel + 1) + "},\n";
        commandBody += insertTabs(indentLevel + 1) + "update: function (";
        commandBody += updateFunctionKwRemoved.join(",");
        commandBody += ") {\n";
    } else {
        commandBody += insertTabs(indentLevel + 1) + "update: function () {\n";
    }

    // Write update function definition
    if (updateFunctionParams.count() > 0) {
        commandBody += insertTabs(indentLevel + 2) + "this.set(" + updateFunctionKwRemoved.join(",") + ")\n";
    }
    commandBody += insertTabs(indentLevel + 2) + "this.send(this)\n";
    commandBody += insertTabs(indentLevel + 1) + "},\n";

    // Create set function if necessary
    if (updateFunctionParams.count() > 0) {
        commandBody += insertTabs(indentLevel + 1) + "set: function (" + updateFunctionKwRemoved.join(",") + ") {\n";
        for (int i = 0; i < updateFunctionParams.count(); ++i) {
            commandBody += insertTabs(indentLevel + 2) + "this.payload." + updateFunctionParams.at(i) + " = " + updateFunctionKwRemoved.at(i) + "\n";
        }
        commandBody += insertTabs(indentLevel + 1) + "},\n";
    }

    // Create send function
    commandBody += insertTabs(indentLevel + 1) + "send: function () { platformInterface.send(this) }\n";
    commandBody += insertTabs(indentLevel) + "})\n\n";

    return documentationText + commandBody;
}

QString PlatformInterfaceGenerator::generateNotification(const QJsonObject &notification, int &indentLevel)
{
    if (!notification.contains("value")) {
        lastError_ = "Notification did not contain 'value'";
        qCCritical(logCategoryPlatformInterfaceGenerator) << lastError_;
        return QString();
    }

    QString notificationId = notification["value"].toString();
    QString notificationBody = "";
    QString documentationBody = "";

    // Create documentation for notification
    documentationBody += generateComment("@notification: " + notificationId, indentLevel);

    // Create the QtObject to handle this notification
    notificationBody += insertTabs(indentLevel) + "property QtObject " + notificationId + ": QtObject {\n";
    indentLevel++;

    QString childrenNotificationBody = "";
    QString childrenDocumentationBody = "";
    QString propertiesBody = "";

    QJsonObject payload = notification["payload"].toObject();

    // Add the properties to the notification
    for (QString payloadProperty : payload.keys()) {
        QJsonValue propValue = payload[payloadProperty];

        generateNotificationProperty(indentLevel, notificationId, payloadProperty, propValue, childrenNotificationBody, childrenDocumentationBody);

        if (lastError_.length() > 0) {
            return "";
        }

        QString propType = getType(propValue);
        if (propType.isNull()) {
            lastError_ = "Property for notification " + notificationId + " has unknown type";
            qCCritical(logCategoryPlatformInterfaceGenerator) << lastError_;
            return "";
        }

        if (propValue.isObject() || (propValue.isArray() && propValue.toArray().count() > 0)) {
            continue;
        }

        propertiesBody += insertTabs(indentLevel) + "property " + propType + " " + payloadProperty + ": " + getPropertyValue(propValue, propType, indentLevel) + "\n";
        if (lastError_.length() > 0) {
            qCCritical(logCategoryPlatformInterfaceGenerator) << lastError_;
            return "";
        }
    }

    notificationBody = childrenDocumentationBody + notificationBody + propertiesBody;
    notificationBody += childrenNotificationBody;

    indentLevel--;
    notificationBody += insertTabs(indentLevel) + "}\n\n";
    return documentationBody + notificationBody;
}

void PlatformInterfaceGenerator::generateNotificationProperty(int indentLevel, const QString &parentId, const QString &id, const QJsonValue &value, QString &childrenNotificationBody, QString &childrenDocumentationBody)
{
    QString propType = getType(value);
    QString notificationBody = "";
    QString documentation = "";

    if (propType.isNull()) {
        lastError_ = "Property for " + id + " is null";
        qCCritical(logCategoryPlatformInterfaceGenerator) << lastError_;
        return;
    }

    if (propType == "var" && value.isArray() && value.toArray().count() > 0) {
        QString properties = "";
        QString childNotificationBody = "";
        QString childDocumentationBody = "";
        QJsonArray valueArray = value.toArray();

        // Generate a property for each element in array
        notificationBody += insertTabs(indentLevel) + "property QtObject " + id + ": QtObject {\n";

        // This documentation text will be passed back to parent
        // This allows us to generate comments above each QtObject for their properties
        documentation += generateComment("@property " + id + ": " + propType, indentLevel - 1);

        // Add the properties to the notification
        for (int i = 0; i < valueArray.count(); ++i) {
            QJsonValue element = valueArray[i];
            QString childId = "index_" + QString::number(i);

            generateNotificationProperty(indentLevel + 1, parentId + "_" + id, childId, element, childNotificationBody, childDocumentationBody);

            if (i == 0) {
                childDocumentationBody = "\n" + childDocumentationBody;
            }

            QString childType = getType(element);
            if (childType.isNull()) {
                lastError_ = "Unrecognized type of property for notificaition " + parentId;
                qCCritical(logCategoryPlatformInterfaceGenerator) << lastError_;
                return;
            }

            if (element.isArray() && element.toArray().count() > 0) {
                continue;
            }

            properties += insertTabs(indentLevel + 1) + "property " + childType + " " + childId + ": " + getPropertyValue(element, childType, indentLevel) + "\n";
            if (lastError_.length() > 0) {
                qCCritical(logCategoryPlatformInterfaceGenerator) << lastError_;
                return;
            }
        }

        notificationBody = childDocumentationBody + notificationBody + properties + childNotificationBody;
        notificationBody += insertTabs(indentLevel) + "}\n";
    } else if (propType == "var" && value.isObject()) {
        QString properties = "";
        QString childNotificationBody = "";
        QString childDocumentationBody = "";
        QJsonObject valueObject = value.toObject();

        // Generate a property for each element in array
        notificationBody += insertTabs(indentLevel) + "property QtObject " + id + ": QtObject {\n";

        // This documentation text will be passed back to parent
        // This allows us to generate comments above each QtObject for their properties
        documentation += generateComment("@property " + id + ": " + propType, indentLevel - 1);

        int i = 0;
        for (QString key : valueObject.keys()) {
            QJsonValue val = valueObject[key];

            generateNotificationProperty(indentLevel + 1, parentId + "_" + id, key, val, childNotificationBody, childDocumentationBody);

            if (i == 0) {
                childDocumentationBody = "\n" + childDocumentationBody;
            }

            QString childType = getType(val);
            if (childType.isNull()) {
                lastError_ = "Unrecognized type of property for notificaition " + parentId;
                qCCritical(logCategoryPlatformInterfaceGenerator) << lastError_;
                return;
            }

            if (val.isObject() || (val.isArray() && val.toArray().count() > 0)) {
                continue;
            }

            properties += insertTabs(indentLevel + 1) + "property " + childType + " " + key + ": " + getPropertyValue(val, childType, indentLevel) + "\n";
            if (lastError_.length() > 0) {
                qCCritical(logCategoryPlatformInterfaceGenerator) << lastError_;
                return;
            }
            i++;
        }

        notificationBody = childDocumentationBody + notificationBody + properties + childNotificationBody;
        notificationBody += insertTabs(indentLevel) + "}\n";
    } else {
        documentation += generateComment("@property " + id + ": " + propType, indentLevel - 1);
    }

    childrenNotificationBody += notificationBody;
    childrenDocumentationBody += documentation;
}

QString PlatformInterfaceGenerator::generateComment(const QString &commentText, int indentLevel)
{
    return insertTabs(indentLevel) + "// " + commentText + "\n";
}

QString PlatformInterfaceGenerator::generateCommentHeader(const QString &commentText, int indentLevel)
{
    QString comment = insertTabs(indentLevel) + "/******************************************************************\n";
    comment += insertTabs(indentLevel) + "  * " + commentText + "\n";
    comment += insertTabs(indentLevel) + "******************************************************************/\n\n";
    return comment;
}

QString PlatformInterfaceGenerator::insertTabs(const int num, const int spaces)
{
    QString text = "";
    for (int tabs = 0; tabs < num; ++tabs) {
        for (int space = 0; space < spaces; ++space) {
            text += " ";
        }
    }
    return text;
}

QString PlatformInterfaceGenerator::getType(const QJsonValue &value)
{
    if (value.isArray()) {
        return "var";
    } else if (value.isString()) {
        QString str = value.toString();
        if (str == "string") {
            return "string";
        } else if (str == "int") {
            return "int";
        } else if (str == "double") {
            return "double";
        } else if (str == "bool") {
            return "bool";
        } else if (str == "array-dynamic") {
            return "var";
        } else if (str == "object-dynamic") {
            return "var";
        } else {
            lastError_ = "Unknown type " + str;
            return QString();
        }
    } else if (value.isObject()) {
        return "var";
    } else {
        lastError_ = "Unknown type";
        return QString();
    }
}

QString PlatformInterfaceGenerator::getPropertyValue(const QJsonValue &value, const QString &propertyType, const int indentLevel)
{
    if (propertyType == "var" && value.isArray()) {
        QString returnText = "[";
        QJsonArray arr = value.toArray();

        for (int i = 0; i < arr.count(); ++i) {
            returnText += getPropertyValue(arr[i], getType(arr[i]), indentLevel);
            if (i != arr.count() - 1)
                returnText += ", ";
        }
        returnText += "]";
        return returnText;
    } else if (propertyType == "bool") {
        return "false";
    } else if (propertyType == "string") {
        return "\"\"";
    } else if (propertyType == "int") {
        return "0";
    } else if (propertyType == "double") {
        return "0.0";
    } else if (propertyType == "var" && value.isObject()) {
        QString returnText = "{\n";
        QJsonObject obj = value.toObject();
        int i = 0;
        for (QString key : obj.keys()) {
            returnText += insertTabs(indentLevel + 1) + "\"" + key + "\": " + getPropertyValue(obj[key], getType(obj[key]), indentLevel + 1);
            if (i != obj.keys().count()) {
                returnText += ",";
            }
            returnText += "\n";
            i++;
        }
        returnText += insertTabs(indentLevel) + "}";
        return returnText;
    } else if (propertyType == "var") {
        // Handle array-dynamic and object-dynamic
        QString type = value.toString();
        if (type == "array-dynamic") {
            return "[]";
        } else {
            return "({})";
        }
    } else {
        return "";
    }
}

void PlatformInterfaceGenerator::removeReservedKeywords(QStringList &paramsList)
{
    for (QString param : paramsList) {
        if (param == "function") {
            param = "func";
        }
    }
}
