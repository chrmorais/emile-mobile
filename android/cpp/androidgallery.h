#ifndef ANDROIDGALLERY_H
#define ANDROIDGALLERY_H

#include <QObject>
#include <QtAndroidExtras>

class AndroidGallery : public QObject, public QAndroidActivityResultReceiver
{
    Q_OBJECT
public:
    explicit AndroidGallery(QObject *parent = 0);

    Q_INVOKABLE void open();
    void handleActivityResult(int receiverRequestCode, int resultCode, const QAndroidJniObject &data);

signals:
    void imagePathSelected(const QString &imagePath);
};

#endif // ANDROIDGALLERY_H
