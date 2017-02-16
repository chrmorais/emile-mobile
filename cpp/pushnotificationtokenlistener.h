#ifndef PUSHNOTIFICATIONTOKENLISTENER_H
#define PUSHNOTIFICATIONTOKENLISTENER_H

#include <QObject>
#include <QSettings>

class PushNotificationTokenListener : public QObject
{
    Q_OBJECT
public:
    explicit PushNotificationTokenListener(QObject *parent = 0);

    void setApplicationSettings(const QVariantMap &applicationSettings);
    static void tokenUpdateNotify(const QString &token);

    Q_INVOKABLE
    QVariant pushNotificationToken();

private:
    void sendSignal();

signals:
    void tokenUpdated();

private:
    QVariantMap m_applicationSettings;
    QSettings *m_qsettings;
    static PushNotificationTokenListener *m_instance;
};

#endif // PUSHNOTIFICATIONTOKENLISTENER_H
