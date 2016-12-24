QT += qml quick quickcontrols2 svg

CONFIG += c++11

SOURCES += main.cpp

RESOURCES += qml.qrc plugins.qrc

android: {
    QT += androidextras
    HEADERS += android/cpp/androidgallery.h
    SOURCES += android/cpp/androidgallery.cpp

    ANDROID_PACKAGE_SOURCE_DIR = $$PWD/android

    DISTFILES += \
        android/AndroidManifest.xml \
        android/gradle/wrapper/gradle-wrapper.jar \
        android/gradlew \
        android/res/values/libs.xml \
        android/build.gradle \
        android/gradle/wrapper/gradle-wrapper.properties \
        android/gradlew.bat
}

ios: {
}

qnx: target.path = /tmp/$${TARGET}/bin
else: unix:!android: target.path = /opt/$${TARGET}/bin
!isEmpty(target.path): INSTALLS += target
