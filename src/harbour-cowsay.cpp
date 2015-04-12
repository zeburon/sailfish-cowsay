#ifdef QT_QML_DEBUG
#include <QtQuick>
#endif

#include <sailfishapp.h>
#include <QScopedPointer>
#include <QQuickView>

#include "skin.h"

int main(int argc, char *argv[])
{
    qmlRegisterType<Skin>("harbour.cowsay.Skin", 1, 0, "Skin");

    QScopedPointer<QGuiApplication> app(SailfishApp::application(argc, argv));
    QScopedPointer<QQuickView> view(SailfishApp::createView());
    view->setSource(SailfishApp::pathTo("qml/harbour-cowsay.qml"));
    view->show();
    return app->exec();
}
