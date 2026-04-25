QT += core gui quick qml network sql

CONFIG += c++17 console

TARGET = beauty-booking
TEMPLATE = app

VERSION = 1.0.0

SOURCES += src/main.cpp

HEADERS +=

QML_IMPORT_PATH = $$PWD/src/qml
QML_DESIGNER_IMPORT_PATH = $$PWD/src/qml

RESOURCES += qml.qrc

INCLUDEPATH += $$PWD/src

# macOS configuration
macx {
    # ICON = assets/icon.icns
}

# iOS configuration
ios {
    TARGET_DEVICE_FAMILY = 1,2
    ios.extra.files = $$PWD/ios
    ios.extra.info_plist = $$PWD/ios/Info.plist
    QMAKE_POST_LINK = $(SRCROOT)/../ios-deploy -domain iphonesimulator -bundle $(TARGET)
}

# Android configuration
android {
    ANDROID_PACKAGE_SOURCE_DIR = $$PWD/android
    ANDROID_VERSION_CODE = 1
    ANDROID_MIN_SDK_VERSION = 24
    ANDROID_TARGET_SDK_VERSION = 34
}