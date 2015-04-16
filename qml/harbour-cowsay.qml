import QtQuick 2.0
import Sailfish.Silica 1.0

import "components"
import "cover"
import "pages"

ApplicationWindow
{
    id: app

    // -----------------------------------------------------------------------

    property bool active: Qt.application.state === Qt.ApplicationActive
    property bool initialized: false

    // -----------------------------------------------------------------------

    cover: cover
    initialPage: mainPage

    // -----------------------------------------------------------------------

    Component.onCompleted:
    {
        // load settings
        settings.loadValues();
        mainPage.init();
        settings.startStoringValueChanges();
        initialized = true;
    }

    // -----------------------------------------------------------------------

    Settings
    {
        id: settings
    }
    CoverPage
    {
        id: cover
    }
    MainPage
    {
        id: mainPage
    }
}
