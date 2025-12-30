SPK_NAME = fish
SPK_VERS = 4.0.2
SPK_REV = 8
SPK_ICON = src/fish.png

DEPENDS = cross/fish

UNSUPPORTED_ARCHS = $(ARMv5_ARCHS) $(PPC_ARCHS)

MAINTAINER = FnOScommunity
DESCRIPTION = fish is a smart and user-friendly command line shell for Linux, macOS, and the rest of the family.
DISPLAY_NAME = fish
STARTABLE = false
CHANGELOG = "Update fish to v4.0.2"

HOMEPAGE = https://fishshell.com
LICENSE = GPL-2.0
LICENSE_FILE = $(WORK_DIR)/$(SPK_NAME)-$(SPK_VERS)/COPYING

SERVICE_SETUP = src/service-setup.sh

SPK_COMMANDS = bin/fish bin/fish_indent bin/fish_key_reader

include ../../mk/fpksrc.fpk.mk
