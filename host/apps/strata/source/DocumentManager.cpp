//
// author: ian
// date: 25 October 2017
//
// Document Manager class to interact with corresponding QML SGDocumentViewer Widget
//

#include <QObject>
#include <QJsonObject>
#include <QJsonArray>

#include "DocumentManager.h"

using namespace std;

DocumentManager::DocumentManager()
{
    qDebug("DocumentManager::DocumentManager() ctor: default");
    init();
}

DocumentManager::DocumentManager(CoreInterface *coreInterface) : coreInterface_(coreInterface)
{
    qDebug("DocumentManager::DocumentManager() ctor: core interface");
    /*
        Register document handler with CoreInterface
        This will also send a command to Nimbus
    */
    coreInterface->registerDataSourceHandler("document",
                                            bind(&DocumentManager::dataSourceHandler,
                                            this, placeholders::_1));
    init();
}

DocumentManager::DocumentManager(QObject *parent) : QObject(parent)
{
    qDebug("DocumentManager::DocumentManager(parent=%p)", parent);
    init();
}

DocumentManager::~DocumentManager ()
{
    document_sets_.clear();
}

void DocumentManager::init()
{
    //qDebug("DocumentManager::init");

    // create document sets: "<name>",  & <name>_documnts_
    document_sets_.emplace(make_pair(QString("schematic"), &schematic_documents_));
    document_sets_.emplace(make_pair(QString("assembly"), &assembly_documents_));
    document_sets_.emplace(make_pair(QString("layout"), &layout_documents_));
    document_sets_.emplace(make_pair(QString("test_report"), &test_report_documents_));
    document_sets_.emplace(make_pair(QString("targeted_content"), &targeted_documents_));

    schematic_rev_count_ =  0;
    assembly_rev_count_ =   0;
    layout_rev_count_ =     0;
    testreport_rev_count_ = 0;
    targeted_rev_count_ =   0;

    // register w/ Implementation Interface for Docoument Data Source Updates
    // TODO [ian] change to "document" on cloud update

    // TODO [ian] hack around some messaging issue we have that dead locks the communications
    //             without the sleep.
    //
    //sleep(2);
    //platformInterface_->registerDataSourceHandler("document",
    //                                                 bind(&DocumentManager::dataSourceHandler,
    //                                                      this, placeholders::_1));

}

// @f documentDataSourceHandler
// @b handle document data source updates from Implementation Interface
//
// arguments:
//  IN:
//   data : JSON data object
//
//  ERROR:
//    returns true/false
//
//{
//  "cloud_sync": "document_set",
//  "type": "schematic",
//  "documents": [
//    {
//      "data": "*******",
//      "filename": "schematic15.png"
//    }
//  ]
//}
//{
//  "cloud::notification": {
//    "type": "document",
//    "name": "schematic",
//    "documents": [
//      {"data": "*******","filename": "schematic1.png"},
//      {"data": "*******","filename": "schematic1.png"}
//    ]
//  }
//}
//{
//  "cloud::notification": {
//    "type": "marketing",
//    "name": "adas_sensor_fusion",
//    "data": "raw html"
//  }
//}

//
void DocumentManager::dataSourceHandler(QJsonObject data)
{
    qDebug("DocumentManager::documentDataSourceHandler called");

    if (data.contains("name") && data.contains("documents") ) {

        QString name = data.value("name").toString();  // Can be schematic, layout or assembly and so on

        qDebug("DocumentManager::documentDataSourceHandler called : name=%s", name.toStdString().c_str());

        DocumentSetPtr document_set = getDocumentSet (name);
        if( document_set == nullptr ) {
            qCritical("DocumentManager::updateDocuments: invalid document name = '%s'", name.toStdString ().c_str ());
            return;
        }
        document_set->clear ();

        // walk through documents and add to Document Viewer
        QJsonArray document_array = data["documents"].toArray();
        foreach (const QJsonValue &r, document_array) {
            QString fname = r["filename"].toString();
            QString data = r["data"].toString();
            Document *d = new Document (data);
            document_set->append (d);

            //qDebug("fname=%s, data=%.200s", fname.toStdString().c_str(), data.toStdString().c_str());
        }



        // TODO: [ian] SUPER hack. Unable to call "emit" on dynamic document set.
        //   it may be possible to use QObject::connect to create a "dispatcher" type object
        //   to emit based on string set name
        //
        if( name == "schematic" ) {
            emit schematicDocumentsChanged();
            emit schematicRevisionCountChanged(++schematic_rev_count_);
        }
        else if( name == "assembly" ) {

            emit assemblyDocumentsChanged();
            emit assemblyRevisionCountChanged(++assembly_rev_count_);
        }
        else if( name == "layout" ) {
            emit layoutDocumentsChanged();
            emit layoutRevisionCountChanged(++layout_rev_count_);
        }
        else if( name == "test_report" ) {
            emit testReportDocumentsChanged();
            emit testReportRevisionCountChanged(++testreport_rev_count_);
        }
        else if( name == "targeted_content" ) {
            emit targetedDocumentsChanged();
            emit targetedRevisionCountChanged(++targeted_rev_count_);
        }
        else {
            qCritical("DocumentManager::updateDocuments: invalid document name = '%s'", name.toStdString ().c_str ());
        }
    }
}

// @f getDocumentSet
// @b get document set by name
//
// arguments:
//  IN:
//   set : document set name
//
//  OUT:
//   document set requested
//
//  ERROR:
//    returns nullptr if document set cannot be found
//
DocumentSetPtr DocumentManager::getDocumentSet(const QString &set)
{
    auto document_set = document_sets_.find(set.toStdString ().c_str ());
    if (document_set == document_sets_.end()) {
        qDebug("DocumentManager::getDocumentSet: %s NOT FOUND)", set.toStdString ().c_str ());
        return nullptr;
    }

    return document_set->second;
}

void DocumentManager::clearDocumentSets()
{
    for (auto doc_iter = document_sets_.begin(); doc_iter!= document_sets_.end(); doc_iter++)
    {
        doc_iter->second->clear();
    }

}

void DocumentManager::clearSchematicRevisionCount() {
    schematic_rev_count_ = 0;
    emit schematicRevisionCountChanged(schematic_rev_count_);
}

void DocumentManager::clearAssemblyRevisionCount() {
    assembly_rev_count_ = 0;
    emit assemblyRevisionCountChanged(assembly_rev_count_);
}

void DocumentManager::clearLayoutRevisionCount() {
    layout_rev_count_ = 0;
    emit layoutRevisionCountChanged(layout_rev_count_);
}

void DocumentManager::clearTestReportRevisionCount() {
    testreport_rev_count_ = 0;
    emit testReportRevisionCountChanged(testreport_rev_count_);
}

void DocumentManager::clearTargetedRevisionCount() {
    targeted_rev_count_ = 0;
    emit targetedRevisionCountChanged(targeted_rev_count_);
}