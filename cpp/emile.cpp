#include "emile.h"

#include <QDir>
#include <QFile>
#include <QTextStream>
#include <QQuickStyle>
#include <QJsonObject>
#include <QJsonDocument>
#include <QCoreApplication>
#include <QRegularExpression>

Emile::Emile(QObject *parent) : QObject(parent)
{
    init();
    m_qsettings = new QSettings(m_configMap.value("name").toString(), m_configMap.value("description").toString());
}

Emile::~Emile()
{
    delete m_qsettings;
}

void Emile::init()
{
    loadConfigMap();
    loadPlugins();

    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);
    QCoreApplication::setApplicationName(m_configMap.value("name").toString());
    QCoreApplication::setOrganizationName(m_configMap.value("name").toString());
    QCoreApplication::setOrganizationDomain(m_configMap.value("description").toString());
    QQuickStyle::setStyle(QLatin1String("Material"));
}

void Emile::loadConfigMap()
{
    QFile file;
    file.setFileName(":/cpp/settings.json");
    file.open(QIODevice::ReadOnly | QIODevice::Text);
    QString settings(file.readAll());
    file.close();
    QJsonDocument jsonDocument = QJsonDocument::fromJson(settings.toUtf8());
    m_configMap = jsonDocument.object().toVariantMap();
    m_configMap.insert("theme", m_configMap.value("theme").toMap().value("material").toMap());
}

void Emile::loadPlugins()
{
    QJsonParseError error;
    QFile pluginsQrc(":/cpp/plugins.qrc");
    QRegularExpression regexp("alias=\"(.*\\.json)?\"");
    if (pluginsQrc.open(QIODevice::ReadOnly)) {
        QTextStream in(&pluginsQrc);
        while (!in.atEnd()) {
            QRegularExpressionMatch match = regexp.match(in.readLine());
            if (match.hasMatch()) {
                QFile configJson(":/plugins/" + match.captured(1));
                if (configJson.open(QIODevice::ReadOnly)) {
                    QJsonObject jsonObject = QJsonDocument::fromJson(configJson.readAll(), &error).object();
                    jsonObject["root_folder"] = "/plugins/" + match.captured(1).split('/').first();
                    m_pluginsArray << jsonObject;
                }
            }
        }
    }
    pluginsQrc.close();
}

QVariantMap Emile::configMap()
{
    return m_configMap;
}

QJsonArray Emile::pluginsArray()
{
    return m_pluginsArray;
}

QVariant Emile::readData(const QString &key)
{
    return m_qsettings->value(key, QLatin1String(""));
}

bool Emile::readBool(const QString &key)
{
    return m_qsettings->value(key, QLatin1String("")).toBool();
}

QVariantMap Emile::readObject(const QString &key)
{
    QJsonObject jsonObject = QJsonDocument::fromJson(readData(key).toByteArray()).object();
    return jsonObject.toVariantMap();
}

void Emile::saveData(const QString &key, const QVariant &value)
{
    m_qsettings->setValue(key, value);
}

void Emile::saveObject(const QString &key, const QVariantMap &value)
{
    QJsonDocument doc(QJsonObject::fromVariantMap(value));
    saveData(key, QVariant(doc.toJson(QJsonDocument::Compact)));
}

void Emile::registerToken(const QVariant &token)
{
    saveData(QStringLiteral("push_notification_token"), token);
}
