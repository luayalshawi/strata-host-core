TEMPLATE = app

QT += qml quick webview webengine opengl charts

CONFIG += c++11 resources_big

RESOURCES += qml.qrc
ICON = spyglass.icns

#Windows Icon
win32: RC_ICONS = spyglass.ico

# Additional import path used to resolve QML modules in Qt Creator's code model
QML_IMPORT_PATH =

# Additional import path used to resolve QML modules just for Qt Quick Designer
QML_DESIGNER_IMPORT_PATH =

# The following define makes your compiler emit warnings if you use
# any feature of Qt which as been marked deprecated (the exact warnings
# depend on your compiler). Please consult the documentation of the
# deprecated API in order to know how to port your code away from it.
DEFINES += QT_DEPRECATED_WARNINGS

# You can also make your code fail to compile if you use deprecated APIs.
# In order to do so, uncomment the following line.
# You can also select to disable deprecated APIs only up to a certain version of Qt.
#DEFINES += QT_DISABLE_DEPRECATED_BEFORE=0x060000    # disables all the APIs deprecated before Qt 6.0.0

# Default rules for deployment.
qnx: target.path = /tmp/$${TARGET}/bin
else: unix:!android: target.path = /opt/$${TARGET}/bin
!isEmpty(target.path): INSTALLS += target

DISTFILES += \
    deviceOutlineActive.png \
    deviceOutlineActive.png

# set root host build path
HOST_ROOT = ../../../host

# linux
unix : !macx : !win32 {
    message("Building on Linux")
    LIBS += -L$${HOST_ROOT}/ext_libs/libzmq/lib/linux -lzmq
    INCLUDEPATH += $${HOST_ROOT}/libs/HostControllerClient/include/
    INCLUDEPATH += $${HOST_ROOT}/ext_libs/zmq/include
    INCLUDEPATH += $${HOST_ROOT}/ext_libs/libzmq/include
    DEPENDPATH += $${HOST_ROOT}/lib/linux/include
}

# mac (not iOS)
else : macx : !win32 {
    message("Building on OSX")
    LIBS += -L$${HOST_ROOT}/ext_libs/libzmq/lib/mac -lzmq
    DEPENDPATH += $${HOST_ROOT}/include/macos
    INCLUDEPATH += $${HOST_ROOT}/libs/HostControllerClient/include/
    INCLUDEPATH += $${HOST_ROOT}/ext_libs/zmq/include
    INCLUDEPATH += $${HOST_ROOT}/ext_libs/libzmq/include
}

# windows
else : win32 {
    message("Building on Windows")
    LIBS += -L$$PWD/../../lib/windows/zeromq/ -llibzmq
    INCLUDEPATH += $$PWD/../../lib/windows/zeromq
    DEPENDPATH += $$PWD/../../lib/windows/zeromq
    INCLUDEPATH += $$PWD/../../lib/linux/include
    DEPENDPATH += $$PWD/../../lib/linux/include
}
else: message("UNKNOWN machine type. Build configuration failed !!!!")

message("BUILD VARIABLES")
message(Host Root: $${HOST_ROOT});
message(Current Build Directory: $$PWD);
message(Include Path: $$INCLUDEPATH);
message(Depend Path: $$DEPENDPATH);
message("done");

HEADERS += PlaformInterface/CoreInterface.h \
           PlatformInterface/PlatformInterface.h \
           DocumentManager.h \
           DataCollector.h \
           $${HOST_ROOT}/libs/HostControllerClient/include/HostControllerClient.hpp \
           $${HOST_ROOT}/ext_libs/zmq/include/zhelpers.hpp \
           $${HOST_ROOT}/ext_libs/zmq/include/zmq.hpp \
           $${HOST_ROOT}/ext_libs/zmq/include/zmq_addon.hpp \

SOURCES += main.cpp \
           PlatformInterface/CoreInterface.cpp \
           PlatformInterface/PlatformInterface.cpp \
           DocumentManager.cpp \
           DataCollector.cpp
