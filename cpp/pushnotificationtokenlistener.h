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

    void setApplicationSettings(const QVariantMap &applicationSettings);
    static void tokenUpdateNotify(const QString &token);

    Q_INVOKABLE
    QVariant pushNotificationToken();

private:
    void sendSignal();

signals:
    void tokenUpdated();

private:
    QSettings m_qsettings;
    QVariantMap m_applicationSettings;
    static PushNotificationTokenListener *m_instance;
};

#endif // PUSHNOTIFICATIONTOKENLISTENER_H
