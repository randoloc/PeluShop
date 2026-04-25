#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QFontDatabase>

int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);
    app.setOrganizationName("BeautyBook");
    app.setApplicationName("BeautyBook");
    app.setApplicationVersion("1.0.0");
    
    app.setFont(QFont("SF Pro Display", -1, QFont::Normal));

    QQmlApplicationEngine engine;
    QObject::connect(&engine, &QQmlApplicationEngine::quit,
                   &app, &QGuiApplication::quit);

    engine.load(QUrl("qrc:///src/qml/main.qml"));

    return app.exec();
}