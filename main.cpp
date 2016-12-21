#include <QDir>
#include <QDebug>
#include <QJsonArray>
#include <QQmlContext>
#include <QJsonObject>
#include <QQuickStyle>
#include <QJsonDocument>
#include <QGuiApplication>
#include <QRegularExpression>
#include <QQmlApplicationEngine>

QJsonArray loadPlugins()
{
    QFile pluginsQrc(":/plugins.qrc");
    QRegularExpression regexp("alias=\"(.*\\.json)?\"");
    QJsonArray crudArray;
    QJsonParseError error;
    if (pluginsQrc.open(QIODevice::ReadOnly)) {
        QTextStream in(&pluginsQrc);
        while (!in.atEnd()) {
            QRegularExpressionMatch match = regexp.match(in.readLine());
            if (match.hasMatch()) {
                QFile configJson(":/plugins/" + match.captured(1));
                if (configJson.open(QIODevice::ReadOnly)) {
                    QJsonObject jsonObject = QJsonDocument::fromJson(configJson.readAll(), &error).object();
                    jsonObject["root_folder"] = "/plugins/" + match.captured(1).split('/').first();
                    crudArray << jsonObject;
                }
            }
        }
    }
    pluginsQrc.close();
    return crudArray;
}

QVariantMap loadAppConfig()
{
    QFile file;
    file.setFileName(":/settings.json");
    file.open(QIODevice::ReadOnly | QIODevice::Text);
    QString settings(file.readAll());
    file.close();
    QJsonDocument jsonDocument = QJsonDocument::fromJson(settings.toUtf8());
    return jsonDocument.object().toVariantMap();
}

int main(int argc, char *argv[])
{
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);
    QQuickStyle::setStyle("Material");
    QGuiApplication app(argc, argv);

    QQmlApplicationEngine engine;
    QQmlContext *context = engine.rootContext();
    context->setContextProperty("appSettings", loadAppConfig());
    context->setContextProperty("crudModel", QVariant::fromValue(loadPlugins()));
    engine.load(QUrl(QLatin1String("qrc:/qml/Main.qml")));

    return app.exec();
}

