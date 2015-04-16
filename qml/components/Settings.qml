import QtQuick 2.0
import QtQuick.LocalStorage 2.0

import "../storage.js" as Storage
import "../globals.js" as Globals

QtObject
{
    property bool thinking: false;              property string thinkingKey: "thinking"
    property string skin: "default";            property string skinKey: "skin"
    property string tongue: Globals.TONGUES[0]; property string tongueKey: "tongue"
    property string eyes: Globals.EYES[0];      property string eyesKey: "eyes"
    property string text: "";                   property string textKey: "text"

    // -----------------------------------------------------------------------

    function loadValues()
    {
        Storage.startInit();

        // load thinking
        var storedThinking = Storage.getValue(thinkingKey);
        if (storedThinking)
            thinking = storedThinking === "true";

        // load skin
        var storedSkin = Storage.getValue(skinKey);
        if (storedSkin)
            skin = storedSkin;

        // load tongue
        var storedTongue = Storage.getValue(tongueKey);
        if (storedTongue)
            tongue = storedTongue;

        // load tongue
        var storedEyes = Storage.getValue(eyesKey);
        if (storedEyes)
            eyes = storedEyes;

        // load text
        var storedText = Storage.getValue(textKey);
        if (storedText)
            text = storedText;
    }

    // -----------------------------------------------------------------------

    function startStoringValueChanges()
    {
        Storage.finishInit();
    }

    // -----------------------------------------------------------------------

    onThinkingChanged:
    {
        Storage.setValue(thinkingKey, thinking);
    }
    onSkinChanged:
    {
        Storage.setValue(skinKey, skin);
    }
    onTongueChanged:
    {
        Storage.setValue(tongueKey, tongue);
    }
    onEyesChanged:
    {
        Storage.setValue(eyesKey, eyes);
    }
    onTextChanged:
    {
        Storage.setValue(textKey, text);
    }
}
