#ifndef PUSHNOTIFICATIONTOKENLISTENER_H
#define PUSHNOTIFICATIONTOKENLISTENER_H

#include <QObject>

class PushNotificationTokenListener : public QObject
{
    Q_OBJECT
public:
    explicit PushNotificationTokenListener(QObject *parent = 0);

    // call by Java (from jni connection) or ObjectiveC object to register
    // the push notification token when is updated by Firebase.
    static void tokenUpdateNotify(const QString &token);

    static void pushNotificationNotify(const QString &messageData);

private:
    void sendTokenSignal(const QString &token);
    void sendNotificationSignal(const QString &messageData);

signals:
    void tokenUpdated(const QVariant &token);
    void pushNotificationUpdated(const QVariant &messageData);

private:
    static PushNotificationTokenListener *m_instance;
};

#endif // PUSHNOTIFICATIONTOKENLISTENER_H
