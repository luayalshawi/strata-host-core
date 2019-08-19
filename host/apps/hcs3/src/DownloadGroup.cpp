
#include "DownloadGroup.h"
#include "DownloadManager.h"

#include "logging/LoggingQtCategories.h"

#include <QDir>
#include <QDebug>


DownloadGroup::DownloadGroup(uint64_t uiGroupId, DownloadManager* downloadMgr, QObject* parent) : QObject(parent)
    , groupId_(uiGroupId)
    , downloadManager_(downloadMgr)
{

}

void DownloadGroup::setBaseFolder(const QString& baseFolder)
{
    baseFolder_ = baseFolder;
}

void DownloadGroup::downloadFiles(const QStringList& files, const QString& prefix)
{
    for(const auto& item : files) {

        if (createFolderWhenNeeded( QDir(prefix).filePath(item) ) == false) {
            qCDebug(logCategoryHcsDownloader) << "createFolderWhenNeeded() failed!";
            return;
        }

        QString filename(createFilenameFromItem( item, prefix ));

        downloadManager_->download(item, filename);

        ItemState state;
        state.url = item;
        state.filename = filename;
        state.state = EItemState::ePending;

        downloadList_.append(state);
    }
}

QString DownloadGroup::createFilenameFromItem(const QString& item, const QString& prefix)
{
    QString tmpName = QDir(prefix).filePath( item );
    return QDir(baseFolder_).filePath(tmpName);
}

bool DownloadGroup::createFolderWhenNeeded(const QString& relativeFilename)
{
    QFileInfo fi(relativeFilename);

    QDir basePath(baseFolder_);
    return basePath.mkpath(fi.path());
}

bool DownloadGroup::isFilenameInList(const QString& filename) const
{
    for(const auto& item : downloadList_) {
        if (filename == item.filename) {
            return true;
        }
    }
    return false;
}

bool DownloadGroup::getUrlForFilename(const QString& filename, QString& urlResult)
{
    for(const auto& item : downloadList_) {
        if (filename == item.filename) {
            urlResult = item.url;
            return true;
        }
    }
    return false;
}

void DownloadGroup::onDownloadFinished(const QString& filename, bool withError)
{
    ItemState* found = findItemByFilename(filename);
    if (found == nullptr) {
        return;
    }

    found->state = withError ? EItemState::eError : EItemState::eDone;
}

bool DownloadGroup::isAllDownloaded()
{
    int total_count = downloadList_.size();

    int done_count = 0;
    for(const auto& item : downloadList_) {
        if (item.state == EItemState::eDone || item.state == EItemState::eError) {
            done_count++;
        }
    }

    return (done_count == total_count);
}

DownloadGroup::ItemState* DownloadGroup::findItemByFilename(const QString& filename)
{
    QVector<ItemState>::iterator it;
    for(it = downloadList_.begin(); it != downloadList_.end(); ++it) {
        if (it->filename == filename) {
            return &(*it);
        }
    }
    return nullptr;
}

void DownloadGroup::stopDownload()
{
    QVector<ItemState>::iterator it;
    for(it = downloadList_.begin(); it != downloadList_.end(); ++it) {
        if (it->state == EItemState::ePending) {
            downloadManager_->stopDownloadByFilename( it->filename );
            it->state = EItemState::eStopped;
        }
    }
}
