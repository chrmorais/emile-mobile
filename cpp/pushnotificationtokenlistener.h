#ifndef PUSHNOTIFICATIONTOKENLISTENER_H
#define PUSHNOTIFICATIONTOKENLISTENER_H

#include <QObject>
#include <QSettings>

class PushNotificationTokenListener : public QObject
{
    Q_OBJECT
public:
    explicit PushNotificationTokenListener(QObject *parent = 0);
    ~PushNotificationTokenListener();

    // called by Java (from jni connection) or ObjectiveC object to register the push notification
    // token when is updated by Firebase.
    static void tokenUpdateNotify(const QString &token);

    QVariant pushNotificationToken();

private:
    void sendSignal(const QString &token);

signals:
    void tokenUpdated(const QVariant &token);

private:
    static PushNotificationTokenListener *m_instance;
};

#endif // PUSHNOTIFICATIONTOKENLISTENER_H
