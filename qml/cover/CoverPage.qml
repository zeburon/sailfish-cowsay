import QtQuick 2.0
import Sailfish.Silica 1.0
import harbour.cowsay.Skin 1.0

CoverBackground
{
    id: cover

    // -----------------------------------------------------------------------

    property bool coverActive: status === Cover.Active
    property var skinNames: [".cover_cow", ".cover_sheep"]
    property var eyesAwake: ["oo", "oO", "Oo"]
    property var eyesSleeping: ["--"]

    property string activeSkinName: skinNames[0]
    property bool moveIn: false
    property bool moveOut: false
    property int transitionStep
    property int transitionStepCount: 20

    // -----------------------------------------------------------------------

    function switchToNextSkin()
    {
        var currentSkinIndex = skinNames.indexOf(activeSkinName);
        var nextSkinIndex = (currentSkinIndex + 1) % skinNames.length;
        activeSkinName = skinNames[nextSkinIndex];
    }

    // -----------------------------------------------------------------------

    onCoverActiveChanged:
    {
        if (!coverActive)
        {
            updateTimer.stop();
        }
        else
        {
            updateTimer.start();
        }
    }

    // -----------------------------------------------------------------------

    Skin
    {
        id: skin

        filename: app.resolveSkinFilename(activeSkinName)
        tongue: "  "
    }
    Label
    {
        id: label

        anchors { left: parent.left; leftMargin: (transitionStep + 1) * 20; verticalCenter: parent.verticalCenter }
        text: skin.output
        color: Theme.highlightColor
        font { family: "Monospace"; pixelSize: Theme.fontSizeMedium }
        horizontalAlignment: Text.AlignLeft
        verticalAlignment: Text.AlignBottom
    }
    Timer
    {
        id: updateTimer

        interval: (moveIn || moveOut) ? 100 : 2000
        repeat: false
        onTriggered:
        {
            if (moveOut)
            {
                --transitionStep;
                if (transitionStep <= -transitionStepCount)
                {
                    moveOut = false;
                    moveIn = true;
                    transitionStep = transitionStepCount;
                    switchToNextSkin();
                }
            }
            else if (moveIn)
            {
                --transitionStep;
                if (transitionStep == 0)
                {
                    moveOut = moveIn = false;
                }
            }
            else
            {
                skin.eyes = eyesAwake[Math.floor(Math.random() * eyesAwake.length)];
            }
            updateTimer.start();
        }
    }

    CoverActionList
    {
        enabled: !moveIn && !moveOut

        CoverAction
        {
            iconSource: "image://theme/icon-l-left"
            onTriggered:
            {
                moveOut = true;
                transitionStep = 0;
            }
        }
    }
}
