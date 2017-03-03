#include <QDebug>
#include <QTranslator>
#include <QQmlContext>
#include <QQuickWindow>
#include <QApplication>
#include <QQmlApplicationEngine>

#ifdef Q_OS_ANDROID
#include "android/JavaToCppBind.h"
#include "android/cpp/androidgallery.h"
#endif

#include "cpp/emile.h"
#include "cpp/requesthttp.h"
#include "cpp/pushnotificationtokenlistener.h"

int main(int argc, char *argv[])
{
    Emile emile;
    QApplication app(argc, argv);

    Q_INIT_RESOURCE(translations);
    RequestHttp requestHttp;

    QQmlApplicationEngine engine;
    QQmlContext *context = engine.rootContext();
    context->setContextProperty(QLatin1String("Emile"), &emile);
    context->setContextProperty(QLatin1String("PostFile"), &requestHttp);
    context->setContextProperty(QLatin1String("appSettings"), emile.configMap());
    context->setContextProperty(QLatin1String("crudModel"), QVariant::fromValue(emile.pluginsArray()));

    // read for system locale to set in translator object
    QString locale(QLocale::system().name());

    // if locale is not defined - set to default brazilian pt_br
    if (locale.isEmpty())
        locale = QLocale(QLocale::Portuguese, QLocale::Brazil).system().name();

    QTranslator translator;
    if (translator.load(locale, QLatin1String(":/translations")))
        app.installTranslator(&translator);
    else
        qWarning("Ops! translator cannot load the file!");

    #ifdef Q_OS_ANDROID
        AndroidGallery androidgallery;
        context->setContextProperty(QLatin1String("androidGallery"), &androidgallery);
    #endif

    PushNotificationTokenListener pushNotificationTokenListener;

    engine.load(QUrl(QLatin1String("qrc:/qml/Main.qml")));

    QQuickWindow *window = qobject_cast<QQuickWindow *>(engine.rootObjects().value(0));
    QObject::connect(&pushNotificationTokenListener, SIGNAL(tokenUpdated(QVariant)), window, SLOT(sendToken(QVariant)));
    QObject::connect(&pushNotificationTokenListener, SIGNAL(tokenUpdated(QVariant)), &emile, SLOT(registerToken(QVariant)));

    return app.exec();
}
