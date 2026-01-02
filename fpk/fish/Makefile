FPK_NAME = fish
FPK_VERS = 4.0.2
FPK_REV = 8
FPK_ICON = src/fish.png

DEPENDS = cross/fish

UNSUPPORTED_ARCHS = $(ARMv5_ARCHS) $(PPC_ARCHS)

MAINTAINER = FnOScommunity
DESCRIPTION = fish is a smart and user-friendly command line shell for Linux, macOS, and the rest of the family.
DISPLAY_NAME = fish
STARTABLE = false
CHANGELOG = "Update fish to v4.0.2"

HOMEPAGE = https://fishshell.com
LICENSE = GPL-2.0
LICENSE_FILE = $(WORK_DIR)/$(FPK_NAME)-$(FPK_VERS)/COPYING

SERVICE_SETUP = src/service-setup.sh

FPK_COMMANDS = bin/fish bin/fish_indent bin/fish_key_reader

include ../../mk/fpksrc.fpk.mk
