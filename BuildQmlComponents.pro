QT += qml quick quickcontrols2

CONFIG += c++11

SOURCES += main.cpp

RESOURCES += qml.qrc components/AwesomeIcon/AwesomeIcon.qrc components/MaterialIcon/MaterialIcon.qrc

QT_QUICK_CONTROLS_STYLE=material ./qml

# Additional import path used to resolve QML modules in Qt Creator's code model
QML_IMPORT_PATH =

# Default rules for deployment.
qnx: target.path = /tmp/$${TARGET}/bin
else: unix:!android: target.path = /opt/$${TARGET}/bin
!isEmpty(target.path): INSTALLS += target
