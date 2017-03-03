#include "requesthttp.h"

#include <QUrl>
#include <QList>
#include <QFile>
#include <QFileInfo>
#include <QHttpPart>
#include <QMapIterator>
#include <QMimeDatabase>
#include <QHttpMultiPart>
#include <QNetworkRequest>
#include <QNetworkAccessManager>

RequestHttp::RequestHttp(QObject *parent):
    QObject(parent)
    ,m_requestHeaderAuthorization(QByteArray(""))
{
    m_networkAccessManager = new QNetworkAccessManager(this);
    setConnections();
    m_networkAccessManager->setParent(this);
}

RequestHttp::RequestHttp(const RequestHttp &other):
    QObject()
    ,m_requestHeaderAuthorization(other.m_requestHeaderAuthorization)
    ,m_networkAccessManager(new QNetworkAccessManager(other.m_networkAccessManager))
{
    setConnections();
    m_networkAccessManager->setParent(this);
}

RequestHttp::~RequestHttp()
{
}

void RequestHttp::setBasicAuthentication(const QString &username, const QString &password)
{
    if (username.isEmpty() || password.isEmpty())
        return;
    QString usernameAndPassword(username + ":" + password);
    QString headerData(QByteArray(usernameAndPassword.toLocal8Bit().toBase64()));
    headerData.prepend("Basic ");
    m_requestHeaderAuthorization = headerData.toLocal8Bit();
}

void RequestHttp::setConnections()
{
    connect(m_networkAccessManager, SIGNAL(finished(QNetworkReply*)), this, SLOT(requestFinished(QNetworkReply*)));
}

void RequestHttp::setRequestHeaders(const QVariantMap &requestHeaders, QNetworkRequest *request)
{
    QMapIterator<QString, QVariant> i(requestHeaders);
    while (i.hasNext()) {
        i.next();
        request->setRawHeader(i.key().toUtf8(), i.value().toByteArray());
    }
}

bool RequestHttp::setMultiPartRequest(QHttpMultiPart *httpMultiPart, const QVariant &filePath)
{
    QString fpath(filePath.toString());

#ifdef Q_OS_IOS
    QUrl url(fpath);
    fpath = url.toLocalFile();
#endif

    QFile *file = new QFile(fpath);

    if (!file->exists()) {
        delete file;
        emit statusChanged(404, QVariant("File '"+fpath+"' not found! Request aborted!"));
        return false;
    }

    bool isOpened = file->open(QIODevice::ReadOnly);
    file->open(QIODevice::ReadOnly);

    if (!isOpened) {
        delete file;
        emit statusChanged(400, QVariant("File '"+fpath+"' cannot be open! Request aborted!"));
        return false;
    }

    QString contentDisposition = QString("multipart/form-data; name=image_file; filename=%1").arg(QFileInfo(fpath).fileName());

    QHttpPart filePart;
    filePart.setHeader(QNetworkRequest::ContentTypeHeader, QVariant(QMimeDatabase().mimeTypeForFile(fpath).name()));
    filePart.setHeader(QNetworkRequest::ContentDispositionHeader, QVariant(contentDisposition));

    filePart.setBodyDevice(file);
    file->setParent(httpMultiPart);
    httpMultiPart->append(filePart);

    return true;
}

void RequestHttp::postFile(const QString &url, const QVariant &filePathsList, const QVariantMap &requestHeaders)
{
    QHttpMultiPart *multiPart = new QHttpMultiPart(QHttpMultiPart::FormDataType);

    QList<QVariant> filesList(filePathsList.toList());
    int totalFiles = filesList.size();

    for (int i = 0; i < totalFiles; ++i) {
        if (!setMultiPartRequest(multiPart, filesList.at(i))) {
            delete multiPart;
            return;
        }
    }

    QUrl qurl(url);
    QNetworkRequest request(qurl);

    if (!m_requestHeaderAuthorization.isEmpty())
        request.setRawHeader("Authorization", m_requestHeaderAuthorization);

    if (requestHeaders.size())
        setRequestHeaders(requestHeaders, &request);

    QNetworkReply *reply = m_networkAccessManager->post(request, multiPart);
    connect(reply, SIGNAL(error(QNetworkReply::NetworkError)), this, SLOT(requestError(QNetworkReply::NetworkError)));
    multiPart->setParent(reply); // multiPart will be deleted with the reply
}

void RequestHttp::requestFinished(QNetworkReply *reply)
{
    QString serverReply = QString(reply->readAll());
    int statusCode = reply->attribute(QNetworkRequest::HttpStatusCodeAttribute).toInt();
    emit statusChanged(statusCode, QVariant(serverReply));
    if (reply->isFinished()) {
        emit finished(statusCode, serverReply);
        delete reply;
    }
}

void RequestHttp::requestError(QNetworkReply::NetworkError code)
{
    emit statusChanged(code, QVariant(QString("Network reply error %1").arg(code)));
}
