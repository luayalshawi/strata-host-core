#ifndef WINDOW_MANAGER
#define WINDOW_MANAGER

#include <QObject>
#include <QQmlApplicationEngine>

class WindowManager : public QObject
{
    Q_OBJECT

public:
    WindowManager(QQmlApplicationEngine *engine) : engine (engine) {}

    ~WindowManager() {}

    Q_INVOKABLE void createNewWindow();

    Q_INVOKABLE void closeWindow(const int &id);

private:
    const QUrl mainDir = QUrl(QStringLiteral("qrc:/qml/MainWindow.qml"));

    QQmlApplicationEngine *engine =  nullptr;

    std::map<int, QObject*> allWindows;

    int ids = 0;
};

#endif
