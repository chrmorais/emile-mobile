#include "pushnotificationtokenlistener.h"

#include <QtDebug>

PushNotificationTokenListener* PushNotificationTokenListener::m_instance = nullptr;

PushNotificationTokenListener::PushNotificationTokenListener(QObject *parent) : QObject(parent)
{
    m_instance = this;
}

PushNotificationTokenListener::~PushNotificationTokenListener()
{
    delete m_instance;
}

void PushNotificationTokenListener::setApplicationSettings(const QVariantMap &applicationSettings)
{
    m_applicationSettings = applicationSettings;
    QSettings m_qsettings(m_applicationSettings.value("name").toString(), m_applicationSettings.value("description").toString());
    QString tokenSaved = m_qsettings.value(QString("push_notification_token")).toString();
    if (!tokenSaved.isEmpty())
        qDebug() << "has token saved: " << tokenSaved;
}

void PushNotificationTokenListener::tokenUpdateNotify(const QString &token)
{
    if (token.isEmpty())
        return;
    qDebug() << "Recebeu o token do firebase!: " << token;
    m_instance->m_qsettings.setValue(QStringLiteral("push_notification_token"), QVariant(token));
    m_instance->sendSignal();
}

QVariant PushNotificationTokenListener::pushNotificationToken()
{
    qDebug() << "reading for new token";
    return m_qsettings.value(QString("push_notification_token"), QStringLiteral(""));
}

void PushNotificationTokenListener::sendSignal()
{
    qDebug() << "Notificando o qml que um token foi gerado...";
    emit tokenUpdated();
}
