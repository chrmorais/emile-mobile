#ifndef REQUESTHTTP_H
#define REQUESTHTTP_H

#include <QObject>
#include <QString>
#include <QVariant>
#include <QNetworkReply>
#include <QNetworkAccessManager>

class QUrl;
class QFile;
class QFileInfo;
class QHttpPart;
class QMimeDatabase;
class QHttpMultiPart;
class QNetworkRequest;

class RequestHttp : public QObject
{
    Q_OBJECT
public:
    explicit RequestHttp(QObject *parent = 0);
    RequestHttp(const RequestHttp &other);
    ~RequestHttp();

    Q_INVOKABLE
    void setBasicAuthentication(const QString &user, const QString &password);

    Q_INVOKABLE
    void postFile(const QString &url, const QVariant &filePathsList, const QVariantMap &requestHeaders = QVariantMap());

private:
    void setConnections();
    void setRequestHeaders(const QVariantMap &requestHeaders, QNetworkRequest *request);
    bool setMultiPartRequest(QHttpMultiPart *httpMultiPart, const QVariant &filePath);

signals:
    void error(int statusCode, const QVariant &message);
    void finished(int statusCode, const QVariant &response);

private slots:
    void requestFinished(QNetworkReply *reply);
    void requestError(QNetworkReply::NetworkError code);

private:
    QByteArray m_requestHeaderAuthorization;
    QNetworkAccessManager m_networkAccessManager;
};

#endif // REQUESTHTTP_H
