/**
******************************************************************************
* @file SGDatabase .H
* @author Luay Alshawi
* $Rev: 1 $
* $Date:
* @brief c++ Database object for the local couchbase database
******************************************************************************
* @copyright Copyright 2018 On Semiconductor
*/

#ifndef SGDATABASE_H
#define SGDATABASE_H

#include <string>
#include <thread>
#include <mutex>
#include <c4.h>
#include <FleeceImpl.hh>
#include "SGDocument.h"

namespace Spyglass {
    // Forward declaration is required due to the circular include for SGDatabase<->SGDocument.
    class SGDocument;

    enum class SGDatabaseReturnStatus {
        kNoError,
        kOpenDBError,
        kCloseDBError,
        kCreateDocumentError,
        kUpdatDocumentError,
        kBeginTransactionError,
        kEndTransactionError,
        kDBNameError,
        kCreateDBDirectoryError,
        kDeleteDocumentError,
        kInvalidArgumentError
    };

    /*
     * Thread safe is guaranteed on these functions:
     * getC4db(), open(), isOpen(), close(), save(), getDocumentById(), deleteDocument(), getAllDocumentsKey()
     */
    class SGDatabase {

    public:
        SGDatabase();

		// Using this constructor will create db directory based where the process is running from
        SGDatabase(const std::string &db_name);

		// Using this constructor will create db directory based on the given path
        SGDatabase(const std::string &db_name, const std::string &path);

        virtual ~SGDatabase();

        void setDBName(const std::string &name);

        const std::string &getDBName() const;

        void setDBPath(const std::string &name);

        const std::string &getDBPath() const;

        //  Thread Safe.
        C4Database *getC4db();

        /** SGDatabase Open.
        * @brief Open or create a local embedded database if name does not exist. Thread Safe.
        * @param db_name The couchebase lite embeeded database name.
        */
        SGDatabaseReturnStatus open();

        /** SGDatabase isOpen.
        * @brief Check if database is open. Safe to be called on multi threaded programs. Thread Safe.
        */
        bool isOpen();

        /** SGDatabase Close.
        * @brief Close the local database if it's open. Thread Safe.
        */
        SGDatabaseReturnStatus close();

        /** SGDatabase save.
        * @brief Create/Edit a document. Thread Safe.
        * @param SGDocument The reference to the document object
        */
        SGDatabaseReturnStatus save(SGDocument *doc);

        /** SGDatabase getDocumentById.
        * @brief return C4Document if there is such a document exist in the DB, otherwise return nullptr. Thread Safe.
        * @param docId The document id
        */
        C4Document *getDocumentById(const std::string &doc_id);

        /** SGDatabase deleteDocument.
        * @brief delete existing document from the DB. True successful, otherwise false. Thread Safe.
        * @param SGDocument The document object
        */
        SGDatabaseReturnStatus deleteDocument(SGDocument *doc);

        /** SGDatabase getAllDocumentsKey.
        * @brief Runs local database query to get list of document keys. True on success, False otherwise. Thread Safe.
        */
        bool getAllDocumentsKey(std::vector<std::string>& document_keys);
    private:

        C4Database *c4db_{nullptr};
        C4DatabaseConfig c4db_config_;
        C4Error c4error_ {};
        std::string db_name_;
        std::string db_path_;
        std::mutex db_lock_;

        static constexpr const char *kSGDatabasesDirectory_ = "db";

        /** SGDatabase createNewDocument.
        * @brief Create new couchebase document.
        * @param doc The SGDocument reference.
        * @param body The fleece slice data which will be stored in the body of the document.
        */
        SGDatabaseReturnStatus _createNewDocument(SGDocument *doc, fleece::alloc_slice body);

        /** SGDatabase updateDocument.
        * @brief Update existing couchebase document.
        * @param doc The SGDocument reference.
        * @param body The fleece slice data which will update the body.
        */
        SGDatabaseReturnStatus _updateDocument(SGDocument *doc, fleece::alloc_slice new_body);

        /** SGDatabase isOpen.
        * @brief Check if database is open. Called internally inside locked functions.
        */
        bool _isOpen() const;

    };
}

#endif //SGDDATABASE_H