# NOTICE:
#
# Application name defined in TARGET has a corresponding QML filename.
# If name defined in TARGET is changed, the following needs to be done
# to match new name:
#   - corresponding QML filename must be changed
#   - desktop icon filename must be changed
#   - desktop filename must be changed
#   - icon definition filename in desktop file must be changed
#   - translation filenames have to be changed

# The name of your application
TARGET = harbour-cowsay

CONFIG += sailfishapp

SOURCES += src/harbour-cowsay.cpp \
    src/skin.cpp

OTHER_FILES += qml/harbour-cowsay.qml \
    qml/cover/CoverPage.qml \
    rpm/harbour-cowsay.changes.in \
    rpm/harbour-cowsay.spec \
    rpm/harbour-cowsay.yaml \
    translations/*.ts \
    harbour-cowsay.desktop \
    qml/cows/apt.cow \
    qml/cows/beavis.zen.cow \
    qml/cows/bong.cow \
    qml/cows/bud-frogs.cow \
    qml/cows/bunny.cow \
    qml/cows/calvin.cow \
    qml/cows/cheese.cow \
    qml/cows/cock.cow \
    qml/cows/cower.cow \
    qml/cows/daemon.cow \
    qml/cows/default.cow \
    qml/cows/dragon-and-cow.cow \
    qml/cows/dragon.cow \
    qml/cows/duck.cow \
    qml/cows/elephant-in-snake.cow \
    qml/cows/elephant.cow \
    qml/cows/eyes.cow \
    qml/cows/flaming-sheep.cow \
    qml/cows/ghostbusters.cow \
    qml/cows/gnu.cow \
    qml/cows/head-in.cow \
    qml/cows/hellokitty.cow \
    qml/cows/kiss.cow \
    qml/cows/kitty.cow \
    qml/cows/koala.cow \
    qml/cows/kosh.cow \
    qml/cows/luke-koala.cow \
    qml/cows/mech-and-cow.cow \
    qml/cows/meow.cow \
    qml/cows/milk.cow \
    qml/cows/moofasa.cow \
    qml/cows/moose.cow \
    qml/cows/mutilated.cow \
    qml/cows/pony-smaller.cow \
    qml/cows/pony.cow \
    qml/cows/ren.cow \
    qml/cows/sheep.cow \
    qml/cows/skeleton.cow \
    qml/cows/snowman.cow \
    qml/cows/sodomized-sheep.cow \
    qml/cows/stegosaurus.cow \
    qml/cows/stimpy.cow \
    qml/cows/suse.cow \
    qml/cows/three-eyes.cow \
    qml/cows/turkey.cow \
    qml/cows/turtle.cow \
    qml/cows/tux.cow \
    qml/cows/unipony-smaller.cow \
    qml/cows/unipony.cow \
    qml/cows/vader-koala.cow \
    qml/cows/vader.cow \
    qml/cows/www.cow \
    qml/pages/MainPage.qml

# to disable building translations every time, comment out the
# following CONFIG line
CONFIG += sailfishapp_i18n

# German translation is enabled as an example. If you aren't
# planning to localize your app, remember to comment out the
# following TRANSLATIONS line. And also do not forget to
# modify the localized app name in the the .desktop file.
TRANSLATIONS += translations/harbour-cowsay-de.ts

HEADERS += \
    src/skin.h

