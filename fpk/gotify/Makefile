FPK_NAME = gotify
FPK_VERS = 2.1.4
FPK_REV = 1
FPK_ICON = src/gotify.png

DEPENDS = cross/gotify-server cross/gotify-cli

UNSUPPORTED_ARCHS = $(PPC_ARCHS) $(ARMv5_ARCHS) $(ARMv7L_ARCHS)

MAINTAINER = FnOScommunity
DISPLAY_NAME = Gotify
DESCRIPTION = A simple server for sending and receiving messages. Includes gotify-cli for pushing messages to gotify/server.
HOMEPAGE = https://gotify.net/
HELPURL = https://github.com/gotify/server/issues
LICENSE = MIT
CHANGELOG = "Initial release"

STARTABLE = yes
SERVICE_USER = auto
SERVICE_SETUP = src/service-setup.sh
SERVICE_PORT = 7152
ADMIN_PORT = $(SERVICE_PORT)
SERVICE_PORT_TITLE = Gotify (HTTP)

POST_STRIP_TARGET = gotify_extra_install

FPK_COMMANDS = bin/gotify-cli

include ../../mk/fpksrc.fpk.mk

.PHONY: gotify_extra_install
gotify_extra_install:
	@install -d -m 755 $(STAGING_DIR)/var
	@install -m 644 src/environment-variables $(STAGING_DIR)/var/
