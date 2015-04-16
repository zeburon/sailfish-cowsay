import QtQuick 2.0
import Sailfish.Silica 1.0
import Qt.labs.folderlistmodel 2.1
import harbour.cowsay.Exporter 1.0
import harbour.cowsay.Skin 1.0

import "../globals.js" as Globals

Page
{
    id: page

    // -----------------------------------------------------------------------

    property string folderDirectory: "../cows/"
    property string extension: ".cow"
    property bool landscapeMode: orientation === Orientation.Landscape || orientation === Orientation.LandscapeInverted
    property var skinNames: []
    property bool skinNamesApplied: skinNames.length > 0 && skinRepeater.count > 0
    property bool enteringText: textField.focus

    // -----------------------------------------------------------------------

    function init()
    {
        eyesComboBox.init();
        tongueComboBox.init();
    }

    // -----------------------------------------------------------------------

    function resolveSkinFilename(str)
    {
         return Qt.resolvedUrl(folderDirectory + str + extension);
    }

    // -----------------------------------------------------------------------

    allowedOrientations: Orientation.All
    onSkinNamesAppliedChanged:
    {
        skinComboBox.init();
    }

    // -----------------------------------------------------------------------

    FolderListModel
    {
        id: folderListModel

        folder: folderDirectory
        nameFilters: ["*" + extension]
        showDirs: false
        onCountChanged:
        {
            var newSkinNames = [];
            for (var idx = 0; idx < count; ++idx)
            {
                var filename = get(idx, "fileName");
                var extensionStartPos = filename.lastIndexOf(extension);
                newSkinNames.push(filename.substring(0, extensionStartPos));
            }
            skinNames = newSkinNames;
        }
    }

    Skin
    {
        id: skin

        filename: resolveSkinFilename(settings.skin)
        tongue: settings.tongue
        eyes: settings.eyes
        thinking: settings.thinking
        text: settings.text
    }
    Exporter
    {
        id: exporter
    }

    SilicaFlickable
    {
        anchors { fill: parent }
        contentHeight: contentItem.height

        PullDownMenu
        {
            MenuItem
            {
                text: qsTr("About") + " " + header.title
            }
            MenuItem
            {
                text: qsTr("Copy text")
                onClicked:
                {
                    Clipboard.text = skin.output;
                }
            }
            MenuItem
            {
                text: qsTr("Save image")
                onClicked:
                {
                    exporter.saveTextToImage(skin.output);
                }
            }
            MenuItem
            {
                text: (!settings.thinking || !enabled) ? qsTr("Switch to Cowthink") : qsTr("Switch to Cowsay")
                enabled: skin.supportsThinking
                onClicked:
                {
                    settings.thinking = !settings.thinking;
                }
            }
        }

        Item
        {
            id: contentItem

            width: landscapeMode ? Screen.height : Screen.width
            height: landscapeMode ? Screen.width : Screen.height

            PageHeader
            {
                id: header

                anchors { left: parent.left; right: parent.right; top: parent.top }
                title: settings.thinking ? "Cowthink" : "Cowsay"
            }

            Flow
            {
                id: settingsFlow

                anchors { left: parent.left; right: parent.right; top: header.bottom }

                ComboBox
                {
                    id: skinComboBox

                    function init()
                    {
                        for (var idx = 0; idx < skinNames.length; ++idx)
                        {
                            if (skinNames[idx] === settings.skin)
                            {
                                currentItem = skinRepeater.itemAt(idx);
                                break;
                            }
                        }
                    }

                    width: landscapeMode ? parent.width / 2 : parent.width
                    label: "Skin"
                    menu: ContextMenu
                    {
                        Repeater
                        {
                            id: skinRepeater

                            model: skinNames

                            MenuItem { text: modelData }
                        }
                    }
                    onCurrentIndexChanged:
                    {
                        settings.skin = value;
                    }
                }
                ComboBox
                {
                    id: eyesComboBox

                    function init()
                    {
                        var idx = Globals.EYES.indexOf(settings.eyes);
                        if (idx !== -1)
                            currentIndex = idx;
                    }

                    width: landscapeMode ? parent.width / 4 : parent.width / 2
                    enabled: skin.supportsEyes
                    label: "Eyes"
                    menu: ContextMenu
                    {
                        Repeater
                        {
                            model: Globals.EYES

                            MenuItem
                            {
                                text: modelData
                            }
                        }
                    }
                    onCurrentIndexChanged:
                    {
                        settings.eyes = value;
                    }
                }
                ComboBox
                {
                    id: tongueComboBox

                    function init()
                    {
                        var idx = Globals.TONGUES.indexOf(settings.tongue);
                        if (idx !== -1)
                            currentIndex = idx;
                    }

                    width: landscapeMode ? parent.width / 4 : parent.width / 2
                    enabled: skin.supportsTongue
                    label: "Tongue"
                    menu: ContextMenu
                    {
                        MenuItem { text: qsTr("none") }
                        MenuItem { text: qsTr("left") }
                        MenuItem { text: qsTr("right") }
                    }
                    onCurrentIndexChanged:
                    {
                        settings.tongue = Globals.TONGUES[currentIndex];
                    }
                }
            }

            Flickable
            {
                anchors { left: parent.left; leftMargin: Theme.paddingMedium; right: parent.right; rightMargin: Theme.paddingMedium; top: settingsFlow.bottom; bottom: textField.top }
                contentWidth: Math.max(width, text.contentWidth)
                contentHeight: Math.max(height, text.contentHeight)
                clip: true

                Text
                {
                    id: text

                    anchors { fill: parent }
                    color: Theme.highlightColor
                    font { family: "Monospace"; pixelSize: Theme.fontSizeTiny }
                    text: skin.output
                    horizontalAlignment: Qt.AlignLeft
                    verticalAlignment: Qt.AlignBottom
                }
                HorizontalScrollDecorator
                {
                    flickable: parent
                }
                VerticalScrollDecorator
                {
                    flickable: parent
                }
            }

            TextField
            {
                id: textField

                anchors { left: parent.left; right: parent.right; bottom: parent.bottom }
                placeholderText: qsTr("Type here")
                EnterKey.enabled: true
                EnterKey.iconSource: "image://theme/icon-m-enter-close"
                EnterKey.onClicked: focus = false
                text: settings.text
                onTextChanged:
                {
                    settings.text = textField.text;
                }
            }
        }
    }
}
