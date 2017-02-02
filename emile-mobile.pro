QT += qml quick quickcontrols2 svg

CONFIG += c++11

HEADERS += cpp/pushnotificationtokenlistener.h

SOURCES += main.cpp cpp/pushnotificationtokenlistener.cpp

RESOURCES += qml.qrc plugins.qrc

qnx: target.path = /tmp/$${TARGET}/bin
else: unix:!android: target.path = /opt/$${TARGET}/bin
!isEmpty(target.path): INSTALLS += target

android: {
    QT += androidextras
    HEADERS += android/cpp/androidgallery.h android/JavaToCppBind.h
    SOURCES += android/cpp/androidgallery.cpp

    ANDROID_PACKAGE_SOURCE_DIR = $$PWD/android

    OTHER_FILES += \
        android/AndroidManifest.xml \
        android/google-services.json \
        android/gradle/wrapper/gradle-wrapper.jar \
        android/gradlew \
        android/res/values/libs.xml \
        android/build.gradle \
        android/gradle/wrapper/gradle-wrapper.properties \
        android/gradlew.bat \
        android/src/gsort/pos/engsisubiq/EmileMobile/TokenToApplication.java \
        android/src/gsort/pos/engsisubiq/EmileMobile/FirebaseListenerService.java \
        android/src/gsort/pos/engsisubiq/EmileMobile/FirebaseInstanceIDListenerService.java
}

ios: {
    ios_google_plist.files = $$PWD/ios/GoogleService-Info.plist
    QMAKE_BUNDLE_DATA += ios_google_plist
    QMAKE_INFO_PLIST = ios/Info.plist

    QMAKE_LFLAGS += $(inherited) -ObjC -l"c++" -l"sqlite3" -l"z" -framework "AdSupport" -framework "AddressBook" -framework "CoreGraphics" -framework "FirebaseAnalytics" -framework "FirebaseInstanceID" -framework "FirebaseMessaging" -framework "GoogleIPhoneUtilities" -framework "GoogleInterchangeUtilities" -framework "GoogleSymbolUtilities" -framework "GoogleUtilities" -framework "SafariServices" -framework "StoreKit" -framework "SystemConfiguration"
    Q_ENABLE_BITCODE.value = NO
    Q_ENABLE_BITCODE.name = ENABLE_BITCODE
    QMAKE_MAC_XCODE_SETTINGS += Q_ENABLE_BITCODE

    HEADERS += ios/Firebase/Firebase.h
    OBJECTIVE_SOURCES += ios/QtAppDelegate.mm

    mac: LIBS += -F$$PWD/ios/Firebase/ -framework FirebaseAnalytics
    INCLUDEPATH += $$PWD/ios/Firebase
    DEPENDPATH += $$PWD/ios/Firebase

    mac: LIBS += -F$$PWD/ios/Firebase/ -framework FirebaseMessaging
    INCLUDEPATH += $$PWD/ios/Firebase
    DEPENDPATH += $$PWD/ios/Firebase

    mac: LIBS += -F$$PWD/ios/Firebase/ -framework GoogleIPhoneUtilities
    INCLUDEPATH += $$PWD/ios/Firebase
    DEPENDPATH += $$PWD/ios/Firebase

    mac: LIBS += -F$$PWD/ios/Firebase/ -framework FirebaseInstanceID
    INCLUDEPATH += $$PWD/ios/Firebase
    DEPENDPATH += $$PWD/ios/Firebase

    mac: LIBS += -F$$PWD/ios/Firebase/ -framework GoogleInterchangeUtilities
    INCLUDEPATH += $$PWD/ios/Firebase
    DEPENDPATH += $$PWD/ios/Firebase

    mac: LIBS += -F$$PWD/ios/Firebase/ -framework GoogleSymbolUtilities
    INCLUDEPATH += $$PWD/ios/Firebase
    DEPENDPATH += $$PWD/ios/Firebase

    mac: LIBS += -F$$PWD/ios/Firebase/ -framework GoogleUtilities
    INCLUDEPATH += $$PWD/ios/Firebase
    DEPENDPATH += $$PWD/ios/Firebase
}
