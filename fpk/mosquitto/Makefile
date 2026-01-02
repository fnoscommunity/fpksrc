FPK_NAME = mosquitto
FPK_VERS = 2.0.22
FPK_REV = 17
FPK_ICON = src/mosquitto.png

DEPENDS = cross/mosquitto

UNSUPPORTED_ARCHS = $(OLD_PPC_ARCHS)

MAINTAINER = FnOScommunity
DESCRIPTION = Eclipse Mosquitto is an open source \(EPL/EDL licensed\) message broker that implements the MQTT protocol versions 5.0, 3.1.1 and 3.1.
DISPLAY_NAME = Mosquitto
CHANGELOG = "Update mosquitto to v2.0.22. Update libwebsockets to v4.3.7."
HOMEPAGE = https://www.mosquitto.org/
LICENSE  = EPL/EDL

WIZARDS_DIR = src/wizard/

SERVICE_USER = auto
STARTABLE = yes
# SERVICE_COMMAND is provided there
SERVICE_SETUP = src/service-setup.sh

SERVICE_PORT = 1883
SERVICE_PORT_TITLE = Mosquitto MQTT (TCP)
NO_SERVICE_SHORTCUT = yes

POST_STRIP_TARGET = mosquitto_extra_install

FPK_COMMANDS  = bin/mosquitto_ctrl
FPK_COMMANDS += bin/mosquitto_passwd
FPK_COMMANDS += bin/mosquitto_rr
FPK_COMMANDS += bin/mosquitto_pub
FPK_COMMANDS += bin/mosquitto_sub

include ../../mk/fpksrc.fpk.mk

.PHONY: mosquitto_extra_install
mosquitto_extra_install:
	install -d $(STAGING_DIR)/var
	install -m 644 src/mosquitto.conf $(STAGING_DIR)/var/mosquitto.conf
	install -m 644 src/passwd $(STAGING_DIR)/var/passwd
