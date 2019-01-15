//
// author: ian
// date: 25 October 2017
//
// Document Manager class to interact with corresponding QML SGDocumentViewer Widget
//
#ifndef DOCUMENT_MANAGER_H
#define DOCUMENT_MANAGER_H

#include <QQmlListProperty>
#include <QObject>
#include <QByteArray>
#include <QList>
#include <QString>
#include <QDebug>
#include <QJsonObject>
#include <QJsonDocument>
#include <QMetaObject>
#include <QQmlEngine>
#include <PlatformInterface/core/CoreInterface.h>

// Note: adding document set

// 3) Create DocumentSet <name>_documents_;  // class memmber
// 4) add Q_PROPERTY(QmlListProperty<Document> <name>Documents READ <name>Documents NOTIFY <name>DocumentsChanged
// 5) add <name>Documents() READ implementation
//      eg:
//   QQmlListProperty<Document> DocumentManager::<name>Documents() { return QQmlListProperty<Document>(this, <name>_documents_); }
// 6) add signal definition to class.  void <name>DocumentsChanged();
//
//

class Document : public QObject
{
    Q_OBJECT

    Q_PROPERTY(QString data READ data NOTIFY dataChanged)

public:
    Document() {}
    Document(const QString &data) : data_(data) {}
    virtual ~Document() {}

    QString data() const { return data_; }

signals:
    void dataChanged(const QString &name);

private:
    QString data_;
};

using DocumentSet = QList<Document *>;            // typedefs
using DocumentSetPtr = QList<Document *> *;

class DocumentManager : public QObject
{
    Q_OBJECT

    Q_PROPERTY(QQmlListProperty<Document> schematicDocuments READ schematicDocuments NOTIFY schematicDocumentsChanged)
    Q_PROPERTY(QQmlListProperty<Document> assemblyDocuments READ assemblyDocuments NOTIFY assemblyDocumentsChanged)
    Q_PROPERTY(QQmlListProperty<Document> layoutDocuments READ layoutDocuments NOTIFY layoutDocumentsChanged)
    Q_PROPERTY(QQmlListProperty<Document> testReportDocuments READ testReportDocuments NOTIFY testReportDocumentsChanged)
    Q_PROPERTY(QQmlListProperty<Document> targetedDocuments READ targetedDocuments NOTIFY targetedDocumentsChanged)
    Q_PROPERTY(uint schematicRevisionCount MEMBER schematic_rev_count_ NOTIFY schematicRevisionCountChanged)
    Q_PROPERTY(uint assemblyRevisionCount MEMBER assembly_rev_count_ NOTIFY assemblyRevisionCountChanged)
    Q_PROPERTY(uint layoutRevisionCount MEMBER layout_rev_count_ NOTIFY layoutRevisionCountChanged)
    Q_PROPERTY(uint testReportRevisionCount MEMBER testreport_rev_count_ NOTIFY testReportRevisionCountChanged)
    Q_PROPERTY(uint targetedRevisionCount MEMBER targeted_rev_count_ NOTIFY targetedRevisionCountChanged)

public:
    DocumentManager();
    DocumentManager(CoreInterface *coreInterface);
    explicit DocumentManager(QObject *parent);
    virtual ~DocumentManager();

    // read methods
    QQmlListProperty<Document> schematicDocuments() { return QQmlListProperty<Document>(this, schematic_documents_); }
    QQmlListProperty<Document> assemblyDocuments() { return QQmlListProperty<Document>(this, assembly_documents_); }
    QQmlListProperty<Document> layoutDocuments() { return QQmlListProperty<Document>(this, layout_documents_); }
    QQmlListProperty<Document> testReportDocuments() { return QQmlListProperty<Document>(this, test_report_documents_); }
    QQmlListProperty<Document> targetedDocuments() { return QQmlListProperty<Document>(this, targeted_documents_); }

    bool updateDocuments(const QString set, const QList<QString> &documents);

    Q_INVOKABLE void clearSchematicRevisionCount();
    Q_INVOKABLE void clearAssemblyRevisionCount();
    Q_INVOKABLE void clearLayoutRevisionCount();
    Q_INVOKABLE void clearTestReportRevisionCount();
    Q_INVOKABLE void clearTargetedRevisionCount();
    Q_INVOKABLE void clearDocumentSets();

signals:
    // Document Changes
    void schematicDocumentsChanged();
    void assemblyDocumentsChanged();
    void layoutDocumentsChanged();
    void testReportDocumentsChanged();
    void targetedDocumentsChanged();

    // Revision Count Changes
    void schematicRevisionCountChanged(uint revisionCount);
    void assemblyRevisionCountChanged(uint revisionCount);
    void layoutRevisionCountChanged(uint revisionCount);
    void testReportRevisionCountChanged(uint revisionCount);
    void targetedRevisionCountChanged(uint revisionCount);

private:
    CoreInterface *coreInterface_;

    void dataSourceHandler(QJsonObject);

    // Document Sets
    DocumentSet schematic_documents_;
    DocumentSet assembly_documents_;
    DocumentSet layout_documents_;
    DocumentSet test_report_documents_;
    DocumentSet targeted_documents_;

    std::map<QString, DocumentSetPtr> document_sets_;

    DocumentSetPtr getDocumentSet(const QString &set);

    // Count the amount of deployments that have been received
    uint schematic_rev_count_;
    uint assembly_rev_count_;
    uint layout_rev_count_;
    uint testreport_rev_count_;
    uint targeted_rev_count_;

    void init();

};

#endif // DOCUMENT_MANAGER_H