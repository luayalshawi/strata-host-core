
#include "DownloadManager.h"

DownloadManager::DownloadManager(QObject* parent) : QObject(parent), numberOfDownloads_(4)
{
    manager_.reset(new QNetworkAccessManager(this) );

    QObject::connect(manager_.get(), &QNetworkAccessManager::finished, this, &DownloadManager::onDownloadFinished);
}

DownloadManager::~DownloadManager()
{
    //stop all downloads
    for (QNetworkReply* reply : currentDownloads_) {
        reply->abort();
        reply->deleteLater();
    }
}

void DownloadManager::setBaseUrl(const QString& baseUrl)
{
    baseUrl_ = baseUrl;
    qDebug() << "baseUrl:" << baseUrl_;
}

void DownloadManager::setMaxDownloadCount(uint count)
{
    if (count == 0) {
        return;
    }

    numberOfDownloads_ = count;
}

void DownloadManager::download(const QString& url, const QString& filename)
{
    DownloadItem item;
    item.url = url;
    item.filename = filename;
    item.state = eStateIdle;

    downloadList_.push_back(item);

    if (static_cast<uint>(currentDownloads_.size()) < numberOfDownloads_) {

        QList<DownloadItem>::iterator findIt = findNextDownload();
        if (findIt == downloadList_.end()) {
            return;
        }

        beginDownload(*findIt);
    }
}

bool DownloadManager::stopDownloadByFilename(const QString& filename)
{
    auto findIt = findItemByFilename(filename);
    if (findIt == downloadList_.end()) {
        return false;
    }

    if (findIt->state == eStateIdle) {
        downloadList_.erase(findIt);
        return true;
    }
    else if (findIt->state == eStatePending) {
        QNetworkReply* reply = findReplyByFilename(filename);
        Q_ASSERT(reply);

        findIt->state = eStateCanceled;
        reply->abort();

        //TODO: should we delete the reply or not ??
    }

    return true;
}

void DownloadManager::beginDownload(DownloadItem& item)
{
    QString realUrl(baseUrl_ + item.url);
    QNetworkReply* reply = downloadFile(realUrl);
    if (reply == nullptr) {
        qDebug() << "downloadFile failed! url:" << item.url;
        return;
    }

    mapReplyToFile_.insert(reply, item.filename);

    item.state = eStatePending;
}

QNetworkReply* DownloadManager::downloadFile(const QString& url)
{
    QNetworkRequest request( QUrl::fromUserInput(url) );
    QNetworkReply *reply = manager_->get(request);
    if (reply == Q_NULLPTR) {
        return reply;
    }

    QObject::connect(reply, &QNetworkReply::readyRead, this, &DownloadManager::readyRead);
    QObject::connect(reply, SIGNAL(error(QNetworkReply::NetworkError)), this, SLOT(slotError()) );

#if QT_CONFIG(ssl)
    connect(reply, SIGNAL(sslErrors(QList<QSslError>)), SLOT(sslErrors(QList<QSslError>)));
#endif

    currentDownloads_.append(reply);
    return reply;
}

bool DownloadManager::isHttpRedirect(QNetworkReply *reply)
{
    int statusCode = reply->attribute(QNetworkRequest::HttpStatusCodeAttribute).toInt();
    return statusCode == 301 || statusCode == 302 || statusCode == 303
           || statusCode == 305 || statusCode == 307 || statusCode == 308;
}

void DownloadManager::readyRead()
{
    QNetworkReply* reply = qobject_cast<QNetworkReply*>( QObject::sender() );
    QByteArray buffer = reply->readAll();
    if (buffer.size() > 0) {
        writeToFile(reply, buffer);
    }
}

void DownloadManager::onDownloadFinished(QNetworkReply *reply)
{
    QUrl url = reply->url();
    if (reply->error()) {

        auto findIt = mapReplyToFile_.find(reply);
        if (findIt == mapReplyToFile_.end()) {
            return;
        }

        auto findItItem = findItemByFilename(findIt.value());
        if (findItItem != downloadList_.end()) {
            findItItem->state = eStateDone;
        }

        emit downloadFinishedError(findItItem->filename, reply->errorString());

    }
    else {
        if (isHttpRedirect(reply)) {
            //TODO: do we support redirects ?
            //   fputs("Request was redirected.\n", stderr);

        }
        else {

            QByteArray buffer = reply->readAll();
            if (buffer.size() > 0) {
                writeToFile(reply, buffer);
            }

            auto findIt = mapReplyToFile_.find(reply);
            if (findIt == mapReplyToFile_.end()) {
                return;
            }

            auto findItItem = findItemByFilename(findIt.value());
            if (findItItem != downloadList_.end()) {
                findItItem->state = eStateDone;
            }

            qDebug() << "Downloaded:" << findItItem->url;

            emit downloadFinished(findItItem->filename);

            if (static_cast<uint>(currentDownloads_.size()) <= numberOfDownloads_) {
                auto it = findNextDownload();
                if (it != downloadList_.end()) {
                    beginDownload(*it);
                }
            }
        }
    }

    currentDownloads_.removeAll(reply);
    reply->deleteLater();
}

bool DownloadManager::writeToFile(QNetworkReply* reply, const QByteArray& buffer)
{
    auto findIt = mapReplyToFile_.find(reply);
    if (findIt == mapReplyToFile_.end()) {
        return false;
    }

    QFile file( findIt.value() );
    if (file.open(QIODevice::ReadWrite) == false) {
        return false;
    }
    uint64_t file_size = file.size();
    file.seek(file_size);

    file.write(buffer);
    return true;
}

QList<DownloadManager::DownloadItem>::iterator DownloadManager::findNextDownload()
{
    QList<DownloadItem>::iterator findIt;
    for(findIt = downloadList_.begin(); findIt != downloadList_.end(); ++findIt) {
        if (findIt->state == eStateIdle) {
            break;
        }
    }

    return findIt;
}

QList<DownloadManager::DownloadItem>::iterator DownloadManager::findItemByFilename(const QString& filename)
{
    QList<DownloadItem>::iterator findIt;
    for(findIt = downloadList_.begin(); findIt != downloadList_.end(); ++findIt) {
        if (findIt->filename == filename) {
            break;
        }
    }

    return findIt;
}

QNetworkReply* DownloadManager::findReplyByFilename(const QString& filename)
{
    QMap<QNetworkReply*, QString>::iterator it;
    for(it = mapReplyToFile_.begin(); it != mapReplyToFile_.end(); ++it) {
        if (it.value() == filename) {
            return it.key();
        }
    }

    return nullptr;
}

void DownloadManager::slotError()
{
}

void DownloadManager::sslErrors(const QList<QSslError>& /*errors*/)
{

}

void DownloadManager::stopAllDownloads()
{
    for(auto item : currentDownloads_) {
        item->abort();
    }

    currentDownloads_.clear();
}

