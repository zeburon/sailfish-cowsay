import QtQuick 2.0
import Sailfish.Silica 1.0
import harbour.cowsay.Skin 1.0

import "../globals.js" as Globals

CoverBackground
{
    id: cover

    // -----------------------------------------------------------------------

    property bool coverActive: status === Cover.Active
    property var eyeStrings: ["oo", "oO", "Oo", "--"]
    property var eyeIntervals: [4000, 2000, 2000, 8000]

    property bool moveIn: false
    property int moveInStepCount: 14
    property bool moveOut: false
    property int moveOutStepCount: -20
    property int currentStep

    // -----------------------------------------------------------------------

    function switchToNextSkin()
    {
        var currentSkinIndex = Globals.COVER_SKIN_NAMES.indexOf(settings.coverSkin);
        var nextSkinIndex = (currentSkinIndex + 1) % Globals.COVER_SKIN_NAMES.length;
        settings.coverSkin = Globals.COVER_SKIN_NAMES[nextSkinIndex];
        skin.eyes = eyeStrings[0];
    }

    // -----------------------------------------------------------------------

    function updateTimeLabel()
    {
        var currentTime = new Date();
        timeLabel.text = Qt.formatTime(currentTime, Globals.COVER_TIME_FORMAT);
        updateTimeTimer.start(1000 * (60 - currentTime.getSeconds()));
    }

    // -----------------------------------------------------------------------

    onCoverActiveChanged:
    {
        if (!coverActive)
        {
            updateSkinTimer.stop();
            updateTimeTimer.stop();
        }
        else
        {
            updateSkinTimer.start();
            updateTimeLabel();
        }
    }

    // -----------------------------------------------------------------------

    Label
    {
        id: timeLabel

        anchors { horizontalCenter: parent.horizontalCenter; top: parent.top; topMargin: Theme.paddingMedium }
        color: Theme.secondaryHighlightColor
        font { family: "Monospace"; pixelSize: Theme.fontSizeExtraLarge }
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
    }
    Timer
    {
        id: updateTimeTimer

        repeat: false
        onTriggered:
        {
            updateTimeLabel();
        }
    }
    Skin
    {
        id: skin

        filename: app.resolveSkinFilename(settings.coverSkin)
        tongue: "  "
    }
    Label
    {
        id: skinLabel

        anchors { left: parent.left; leftMargin: (currentStep + 1) * 20; verticalCenter: parent.verticalCenter }
        text: skin.output
        color: Theme.highlightColor
        font { family: "Monospace"; pixelSize: Theme.fontSizeMedium }
        horizontalAlignment: Text.AlignLeft
        verticalAlignment: Text.AlignBottom
    }
    Timer
    {
        id: updateSkinTimer

        repeat: false
        onTriggered:
        {
            // move out animation
            if (moveOut)
            {
                --currentStep;
                if (currentStep <= moveOutStepCount)
                {
                    moveOut = false;
                    moveIn = true;
                    currentStep = moveInStepCount;
                    switchToNextSkin();
                }
            }
            // move in animation
            else if (moveIn)
            {
                --currentStep;
                if (currentStep == 0)
                {
                    moveOut = moveIn = false;
                }
            }
            // eye animation
            else
            {
                var eyeIndex = Math.floor(Math.random() * eyeStrings.length);
                skin.eyes = eyeStrings[eyeIndex];
                updateSkinTimer.interval = eyeIntervals[eyeIndex];
            }
            updateSkinTimer.start();
        }
    }

    CoverActionList
    {
        enabled: !moveIn && !moveOut

        CoverAction
        {
            iconSource: "image://theme/icon-cover-previous"
            onTriggered:
            {
                moveOut = true;
                currentStep = 0;
                updateSkinTimer.interval = 100;
            }
        }
    }
}
