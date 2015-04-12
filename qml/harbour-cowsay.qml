import QtQuick 2.0
import Sailfish.Silica 1.0

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

    CoverPage
    {
        id: cover
    }
    MainPage
    {
        id: mainPage
    }
}
