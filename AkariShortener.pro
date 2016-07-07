APP_NAME = AkariShortener

CONFIG += qt warn_on cascades10

include(config.pri)

LIBS += -lbb -lbbsystem

LIBS += -lbbcascadesmultimedia


RESOURCES += assets.qrc
DEPENDPATH += assets