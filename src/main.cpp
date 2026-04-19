#include <QApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include <QQuickStyle>
#include <QIcon>
#include <QFontDatabase>
#include "bridge.h"
#include "logger.h"

int main(int argc, char *argv[])
{
    // Enable High-DPI support
    QApplication::setAttribute(Qt::AA_EnableHighDpiScaling);
    QApplication::setAttribute(Qt::AA_UseHighDpiPixmaps);

    QApplication app(argc, argv);
    app.setApplicationName("Smart File Optimizer");
    app.setOrganizationName("SmartFileOptimizer");
    app.setApplicationVersion("1.0.0");
    app.setWindowIcon(QIcon(":/icons/app.png"));

    // Use Material style for modern look
    QQuickStyle::setStyle("Material");

    // Create the central bridge object
    Bridge bridge;

    // Setup QML engine
    QQmlApplicationEngine engine;

    // Expose bridge as "App" to all QML files
    engine.rootContext()->setContextProperty("App", &bridge);
    engine.rootContext()->setContextProperty("LogModel", bridge.log());

    // Load main QML file
    engine.load(QUrl(QStringLiteral("qrc:/qml/Main.qml")));

    if (engine.rootObjects().isEmpty()) return -1;

    return app.exec();
}
