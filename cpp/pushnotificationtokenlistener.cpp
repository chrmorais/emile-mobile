#include "pushnotificationtokenlistener.h"

#include <QtDebug>

PushNotificationTokenListener* PushNotificationTokenListener::m_instance = nullptr;

PushNotificationTokenListener::PushNotificationTokenListener(QObject *parent) : QObject(parent)
{
    m_instance = this;
}

void PushNotificationTokenListener::setApplicationSettings(const QVariantMap &applicationSettings)
{
    m_applicationSettings = applicationSettings;
    m_qsettings = new QSettings(m_applicationSettings.value("name").toString(), m_applicationSettings.value("description").toString());
    QString tokenSaved = m_qsettings->value(QString("push_notification_token")).toString();
    if (!tokenSaved.isEmpty())
        qDebug() << "has token saved: " << tokenSaved;
}

void PushNotificationTokenListener::tokenUpdateNotify(const QString &token)
{
    qDebug() << "Recebeu o token do firebase!: " << token;
    m_instance->m_qsettings->setValue(QStringLiteral("push_notification_token"), QVariant(token));
    m_instance->sendSignal(token);
}

QString PushNotificationTokenListener::pushNotificationToken()
{
    m_qsettings->value(QString("push_notification_token")).toString();
}

void PushNotificationTokenListener::sendSignal(const QString &token)
{
    qDebug() << "Enviando o token para o qml...";
    emit tokenUpdated(token);
}
