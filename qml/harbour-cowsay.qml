import QtQuick 2.0
import Sailfish.Silica 1.0
import Qt.labs.folderlistmodel 2.1

import "components"
import "cover"
import "pages"

import "globals.js" as Globals

ApplicationWindow
{
    id: app

    // -----------------------------------------------------------------------

    property bool active: Qt.application.state === Qt.ApplicationActive
    property bool initialized: false
    property var skinNames: []

    // -----------------------------------------------------------------------

    function resolveSkinFilename(str)
    {
        return Qt.resolvedUrl(Globals.FOLDER_DIRECTORY + str + Globals.FILE_EXTENSION);
    }

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

        enteringText: mainPage.enteringText
    }
    FolderListModel
    {
        id: folderListModel

        folder: Globals.FOLDER_DIRECTORY
        nameFilters: ["*" + Globals.FILE_EXTENSION]
        showDirs: false
        onCountChanged:
        {
            var newSkinNames = [];
            for (var idx = 0; idx < count; ++idx)
            {
                var filename = get(idx, "fileName");
                var extensionStartPos = filename.lastIndexOf(Globals.FILE_EXTENSION);
                newSkinNames.push(filename.substring(0, extensionStartPos));
            }
            skinNames = newSkinNames;
        }
    }

    CoverPage
    {
        id: cover
    }
    MainPage
    {
        id: mainPage
    }
    AboutPage
    {
        id: aboutPage
    }
}
