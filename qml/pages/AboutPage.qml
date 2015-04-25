import QtQuick 2.0
import Sailfish.Silica 1.0

import "../components"
import "../globals.js" as Globals

Page
{
    id: page

    // -----------------------------------------------------------------------

    Column
    {
        id: column

        spacing: 5
        width: parent.width

        Item
        {
            width: 1
            height: Theme.fontSizeExtraLarge
        }
        Image
        {
            anchors { horizontalCenter: parent.horizontalCenter }
            source: "../gfx/about.png"
        }
        Label
        {
            id: titleLabel

            text: qsTr("Cowsay")
            anchors { horizontalCenter: parent.horizontalCenter }
            color: Theme.highlightColor
            font { family: Theme.fontFamily; pixelSize: Theme.fontSizeExtraLarge * 1.5 }
        }
        Label
        {
            id: subtitleLabel

            text: qsTr("Sailfish OS Port")
            anchors { horizontalCenter: parent.horizontalCenter }
            color: Theme.highlightColor
            font { family: Theme.fontFamily; pixelSize: Theme.fontSizeLarge }
        }
        Label
        {
            text: qsTr("Version %1").arg(Globals.VERSION)
            anchors { horizontalCenter: titleLabel.horizontalCenter }
            color: Theme.secondaryHighlightColor
            font { family: Theme.fontFamily; pixelSize: Theme.fontSizeLarge }
        }
        Label
        {
            text: qsTr("Copyright © 2015 Lukas Fraser")
            anchors { horizontalCenter: titleLabel.horizontalCenter }
            color: Theme.primaryColor
            font { family: Theme.fontFamily; pixelSize: Theme.fontSizeMedium }
        }
        Text
        {
            width: parent.width
            wrapMode: Text.WrapAtWordBoundaryOrAnywhere
            horizontalAlignment: Text.AlignHCenter
            textFormat: Text.RichText
            font { family: Theme.fontFamily; pixelSize: Theme.fontSizeSmall }
            color: Theme.secondaryColor
            text: "<style>a:link { color: " + Theme.highlightColor + "; }</style><br/>" +
                qsTr("This program is open source software and is distributed under the same licensing terms as Perl: the
Artistic License or the GNU General Public License") + "<br/><br/>" + qsTr("You can find the source code at the") +
                "<br/> <a href=\"https://github.com/zeburon/sailfish-cowsay\">" + qsTr("GitHub Project Page") + "</a>";
            onLinkActivated:
            {
                Qt.openUrlExternally(link);
            }
        }
    }
    Text
    {
        wrapMode: Text.WrapAtWordBoundaryOrAnywhere
        horizontalAlignment: Text.AlignHCenter
        anchors { left: parent.left; right: parent.right; bottom: parent.bottom; margins: Theme.paddingSmall }
        color: Theme.secondaryHighlightColor
        font { family: Theme.fontFamily; pixelSize: Theme.fontSizeSmall }
        text: qsTr("Original cowsay created by Tony Monroe.") + "<br/>" + qsTr("Skin files extracted from cowsay package.")
    }
}