FPK_NAME = shairport-sync
FPK_VERS = 2.3.11
SPK_REV = 2
SPK_ICON = src/shairport-sync.png

DEPENDS =  cross/busybox cross/shairport-sync

MAINTAINER = FnOScommunity
DESCRIPTION = Use Synology NAS as an AirPlay receiver. Requires USB soundcard or speakers.
DISPLAY_NAME = Shairport Sync
BETA = 1
CHANGELOG = "Initial FnOScommunity Release"

HOMEPAGE = https://github.com/mikebrady/shairport-sync
LICENSE  =

INSTALLER_SCRIPT = src/installer.sh
SSS_SCRIPT       = src/dsm-control.sh

FWPORTS          = src/${FPK_NAME}.sc

INSTALL_PREFIX = /usr/local/$(FPK_NAME)

POST_STRIP_TARGET = shairport_extra_install

BUSYBOX_CONFIG = daemon
ENV += BUSYBOX_CONFIG="$(BUSYBOX_CONFIG)"

include ../../mk/fpksrc.fpk.mk

.PHONY: shairport_extra_install
shairport_extra_install:
	install -m 755 -d $(STAGING_DIR)/var
	install -m 644 src/alsa.conf $(STAGING_DIR)/share/alsa/alsa.conf
	install -m 644 src/shairport-sync.conf $(STAGING_DIR)/var/shairport-sync.conf
