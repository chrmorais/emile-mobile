#include "pushnotificationtokenlistener.h"

PushNotificationTokenListener* PushNotificationTokenListener::m_instance = nullptr;

PushNotificationTokenListener::PushNotificationTokenListener(QObject *parent) : QObject(parent)
{
    m_instance = this;
}

void PushNotificationTokenListener::tokenUpdateNotify(const QString &token)
{
    if (token.isEmpty())
        return;
    m_instance->sendSignal(token);
}

void PushNotificationTokenListener::sendSignal(const QString &token)
{
    emit tokenUpdated(QVariant(token));
}
