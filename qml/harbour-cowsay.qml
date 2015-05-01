import QtQuick 2.0
import Sailfish.Silica 1.0
import harbour.cowsay.FileLister 1.0

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

    function resolveSkinFilename(name)
    {
        return Qt.resolvedUrl(Globals.FOLDER_DIRECTORY + name + Globals.FILE_EXTENSION);
    }

    // -----------------------------------------------------------------------

    cover: CoverPage { }
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
    FileLister
    {
        id: fileLister

        folder: Qt.resolvedUrl(Globals.FOLDER_DIRECTORY)
        filter: "*" + Globals.FILE_EXTENSION
        onFilenamesChanged:
        {
            var newSkinNames = [];
            for (var idx = 0; idx < filenames.length; ++idx)
            {
                var filename = filenames[idx];
                var extensionStartPos = filename.lastIndexOf(Globals.FILE_EXTENSION);
                newSkinNames.push(filename.substring(0, extensionStartPos));
            }
            skinNames = newSkinNames;
        }
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
