#include <QDir>
#include <QDebug>
#include <QJsonArray>
#include <QJsonObject>
#include <QJsonDocument>
#include <QRegularExpression>
#include <QQmlContext>
#include <QGuiApplication>
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
    return crudArray;
}

int main(int argc, char *argv[])
{
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);
    QGuiApplication app(argc, argv);

    QQmlApplicationEngine engine;
    engine.rootContext()->setContextProperty("crudModel", QVariant::fromValue(loadPlugins()));
    engine.load(QUrl(QLatin1String("qrc:/main.qml")));

    return app.exec();
}

