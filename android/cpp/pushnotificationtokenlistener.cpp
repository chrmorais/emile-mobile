#include "pushnotificationtokenlistener.h"

#include <QtDebug>

PushNotificationTokenListener* PushNotificationTokenListener::m_instance = nullptr;

PushNotificationTokenListener::PushNotificationTokenListener(QObject *parent) : QObject(parent)
{
    m_instance = this;
}

void PushNotificationTokenListener::tokenUpdateNotify(const QString &token)
{
    qDebug() << "Uoul!! Funcionou!! O token é: " << token;
    m_instance->sendSignal(token);
}

void PushNotificationTokenListener::sendSignal(const QString &token)
{
    emit tokenUpdated(token);
}
