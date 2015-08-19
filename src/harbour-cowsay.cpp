#include <QQuickView>
#include <QScopedPointer>
#include <QtQuick>
#include <sailfishapp.h>

#include "exporter.h"
#include "filelister.h"
#include "skin.h"

// -----------------------------------------------------------------------

int main(int argc, char *argv[])
{
    qmlRegisterType<Skin>("harbour.cowsay.Skin", 1, 0, "Skin");
    qmlRegisterType<FileLister>("harbour.cowsay.FileLister", 1, 0, "FileLister");
    qmlRegisterType<Exporter>("harbour.cowsay.Exporter", 1, 0, "Exporter");

    QScopedPointer<QGuiApplication> app(SailfishApp::application(argc, argv));
    QScopedPointer<QQuickView> view(SailfishApp::createView());
    view->setSource(SailfishApp::pathTo("qml/harbour-cowsay.qml"));
    view->show();
    return app->exec();
}
