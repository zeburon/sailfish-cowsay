import QtQuick 2.0
import Sailfish.Silica 1.0
import harbour.cowsay.Exporter 1.0
import harbour.cowsay.Skin 1.0

import "../globals.js" as Globals

Page
{
    id: page

    // -----------------------------------------------------------------------

    property bool landscapeMode: orientation === Orientation.Landscape || orientation === Orientation.LandscapeInverted
    property alias enteringText: textField.focus
    property string lastImageFilename

    // -----------------------------------------------------------------------

    function init()
    {
        eyesComboBox.init();
        tongueComboBox.init();
        skinComboBox.init();
    }

    // -----------------------------------------------------------------------

    allowedOrientations: Orientation.All

    // -----------------------------------------------------------------------

    Skin
    {
        id: skin

        filename: app.resolveSkinFilename(settings.skin)
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
                onClicked:
                {
                    pageStack.push(aboutPage);
                }
            }
            MenuItem
            {
                text: qsTr("Copy text")
                onClicked:
                {
                    Clipboard.text = skin.output;
                    clipboardTimer.start();
                }
            }
            MenuItem
            {
                text: qsTr("Save image")
                onClicked:
                {
                    lastImageFilename = exporter.saveTextToImage(skin.output);
                    imageLocationTimer.start();
                }
            }
            MenuItem
            {
                text: qsTr("Switch to") + " " + ((!settings.thinking || !enabled) ?  qsTr("Cowthink") : qsTr("Cowsay"))
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
                title: settings.thinking ? qsTr("Cowthink") : qsTr("Cowsay")
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
                        if (initialized)
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
                opacity: Math.max(0.15, 1.0 - imageLocationText.opacity * 0.85 - clipboardText.opacity * 0.85)

                Text
                {
                    id: text

                    anchors { fill: parent }
                    color: Theme.highlightColor
                    font { family: "Monospace"; pixelSize: Theme.fontSizeTiny }
                    text: skin.output
                    horizontalAlignment: Text.AlignLeft
                    verticalAlignment: Text.AlignBottom
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

            Text
            {
                id: imageLocationText

                anchors { left: parent.left; right: parent.right; top: settingsFlow.bottom; bottom: textField.top }
                opacity: imageLocationTimer.running ? 1.0 : 0.0
                wrapMode: Text.WrapAtWordBoundaryOrAnywhere
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                textFormat: Text.RichText
                font { family: Theme.fontFamily; pixelSize: Theme.fontSizeSmall }
                color: Theme.primaryColor
                text: "<style>a:link { color: " + Theme.highlightColor + "; }</style><br/>" +
                      qsTr("Image saved to") + " <a href=\"" + lastImageFilename + "\">" + lastImageFilename + "</a>";
                onLinkActivated:
                {
                    Qt.openUrlExternally(link);
                }

                Behavior on opacity
                {
                    NumberAnimation { easing.type: Easing.InOutQuart; duration: 500 }
                }
            }
            Timer
            {
                id: imageLocationTimer

                repeat: false
                interval: 3000
            }

            Text
            {
                id: clipboardText

                anchors { left: parent.left; right: parent.right; top: settingsFlow.bottom; bottom: textField.top }
                opacity: clipboardTimer.running ? 1.0 : 0.0
                wrapMode: Text.WrapAtWordBoundaryOrAnywhere
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                font { family: Theme.fontFamily; pixelSize: Theme.fontSizeSmall }
                color: Theme.primaryColor
                text: qsTr("Text copied to clipboard")

                Text
                {
                    id: clipboardFontInfoText

                    anchors { horizontalCenter: parent.horizontalCenter; verticalCenter: parent.verticalCenter; verticalCenterOffset: Theme.paddingLarge * 1.5 }
                    wrapMode: Text.WrapAtWordBoundaryOrAnywhere
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                    font { family: Theme.fontFamily; pixelSize: Theme.fontSizeTiny; italic: true }
                    color: Theme.secondaryColor
                    text: qsTr("Monospaced font required!")
                }
                Behavior on opacity
                {
                    NumberAnimation { easing.type: Easing.InOutQuart; duration: 750 }
                }
            }

            Timer
            {
                id: clipboardTimer

                repeat: false
                interval: 2000
            }

            TextField
            {
                id: textField

                anchors { left: parent.left; right: parent.right; bottom: parent.bottom }
                placeholderText: qsTr("Enter text...")
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
