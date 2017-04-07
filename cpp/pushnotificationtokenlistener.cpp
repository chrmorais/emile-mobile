#include "pushnotificationtokenlistener.h"

#include <QVariant>
#include <QDebug>

PushNotificationTokenListener* PushNotificationTokenListener::m_instance = nullptr;

PushNotificationTokenListener::PushNotificationTokenListener(QObject *parent) : QObject(parent)
{
    m_instance = this;
}

void PushNotificationTokenListener::tokenUpdateNotify(const QString &token)
{
    if (token.isEmpty())
        return;
    m_instance->sendTokenSignal(token);
}

void PushNotificationTokenListener::pushNotificationNotify(const QString &messageData)
{
    if (messageData.isEmpty())
        return;
    m_instance->sendNotificationSignal(messageData);
    qDebug() << "pushNotificationNotify with params: " << messageData;
}

void PushNotificationTokenListener::sendNotificationSignal(const QString &messageData)
{
    emit pushNotificationUpdated(messageData);
}

void PushNotificationTokenListener::sendTokenSignal(const QString &token)
{
    emit tokenUpdated(QVariant(token));
}
