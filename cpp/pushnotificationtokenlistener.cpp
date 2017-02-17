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
