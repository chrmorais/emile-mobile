#ifndef EMILE_H
#define EMILE_H

#include <QObject>
#include <QString>
#include <QVariant>
#include <QSettings>
#include <QJsonArray>
#include <QQuickWindow>

class Emile : public QObject
{
    Q_OBJECT
public:
    explicit Emile(QObject *parent = 0);
    ~Emile();

    void init();
    void loadPlugins();
    void loadConfigMap();

    // return the application json config to qml as js object
    QVariantMap configMap();

    // return all plugins as objects array. Each object is the plugin config.json
    QJsonArray pluginsArray();

    Q_INVOKABLE
    QVariant readData(const QString &key);

    Q_INVOKABLE
    QString readString(const QString &key);

    Q_INVOKABLE
    bool readBool(const QString &key);

    Q_INVOKABLE
    QVariantMap readObject(const QString &key);

    Q_INVOKABLE
    void saveData(const QString &key, const QVariant &value);

    Q_INVOKABLE
    void saveObject(const QString &key, const QVariantMap &value);

    Q_INVOKABLE
    void minimizeApp();

    static void appNativeEventNotify(const QString &eventName, const QString &eventData);

    void setAppWindow(QQuickWindow *appWindow);

public slots:
    void registerToken(const QVariant &token);

signals:
    void tokenUpdated(const QVariant &token);
    void pushNotificationUpdated(const QVariant &messageData);

private:
    QQuickWindow *m_appWindow;
    static Emile *m_instance;
    QSettings &m_qsettings;
    QVariantMap m_configMap;
    QJsonArray m_pluginsArray;
};

#endif // EMILE_H
