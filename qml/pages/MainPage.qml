import QtQuick 2.0
import Sailfish.Silica 1.0
import Qt.labs.folderlistmodel 2.1
import harbour.cowsay.Exporter 1.0
import harbour.cowsay.Skin 1.0

Page
{
    id: page

    // -----------------------------------------------------------------------

    property string folderDirectory: "../cows/"
    property string extension: ".cow"
    property bool thinking: false

    property bool landscapeMode: orientation === Orientation.Landscape || orientation === Orientation.LandscapeInverted

    // -----------------------------------------------------------------------

    function formatFilename(filename)
    {
        var extensionStartPos = filename.lastIndexOf(extension);
        return filename.substring(0, extensionStartPos);
    }

    // -----------------------------------------------------------------------

    function restoreFilename(str)
    {
         return Qt.resolvedUrl(folderDirectory + str + extension);
    }

    // -----------------------------------------------------------------------

    allowedOrientations: Orientation.All

    // -----------------------------------------------------------------------

    FolderListModel
    {
        id: folderListModel

        folder: folderDirectory
        nameFilters: ["*" + extension]
    }

    Skin
    {
        id: skin

        filename: restoreFilename(fileComboBox.value)
        tongue: tongueComboBox.tongue
        eyes: eyesComboBox.value
        thinking: page.thinking
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
                text: (!page.thinking || !enabled) ? qsTr("Switch to Cowthink") : qsTr("Switch to Cowsay")
                enabled: skin.supportsThinking
                onClicked:
                {
                    page.thinking = !page.thinking;
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
                title: page.thinking ? "Cowthink" : "Cowsay"
            }

            Flow
            {
                id: settingsFlow

                anchors { left: parent.left; right: parent.right; top: header.bottom }

                ComboBox
                {
                    id: fileComboBox

                    width: landscapeMode ? parent.width / 2 : parent.width
                    label: "Skin"
                    menu: ContextMenu
                    {
                        Repeater
                        {
                            model: folderListModel

                            MenuItem { text: formatFilename(fileName) }
                        }
                    }
                }
                ComboBox
                {
                    id: eyesComboBox

                    width: landscapeMode ? parent.width / 4 : parent.width / 2
                    enabled: skin.supportsEyes
                    label: "Eyes"
                    menu: ContextMenu
                    {
                        MenuItem { text: "oo" }
                        MenuItem { text: "--" }
                        MenuItem { text: ".." }
                        MenuItem { text: "XX" }
                        MenuItem { text: "$$" }
                        MenuItem { text: "@@" }
                    }
                }
                ComboBox
                {
                    id: tongueComboBox

                    property string tongue: "  "

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
                        switch (currentIndex)
                        {
                            case 0: tongue = "  "; break;
                            case 1: tongue = "U "; break;
                            case 2: tongue = " U"; break;
                        }
                    }
                }
            }

            Flickable
            {
                anchors { left: parent.left; leftMargin: Theme.paddingMedium; right: parent.right; rightMargin: Theme.paddingMedium; top: settingsFlow.bottom; bottom: textField.top }
                contentWidth: Math.max(width, text.contentWidth)
                contentHeight: Math.max(height, text.contentHeight)
                clip: true
                //boundsBehavior: Flickable.StopAtBounds

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
                EnterKey.enabled: false
                onTextChanged:
                {
                    skin.text = textField.text;
                }
            }
        }
    }
}
