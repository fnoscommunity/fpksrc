SPK_NAME = bottom
SPK_VERS = 0.11.4
SPK_REV = 1

UNSUPPORTED_ARCHS = $(OLD_PPC_ARCHS)

include ../../mk/fpksrc.archs.mk
ifeq ($(findstring $(ARCH),$(ARMv5_ARCHS) $(PPC_ARCHS)),$(ARCH))
DEPENDS = cross/bottom_0.10
SPK_VERS = 0.10.2
else
DEPENDS = cross/bottom
endif


MAINTAINER = FnOScommunity
DESCRIPTION = A customizable cross-platform graphical process/system monitor for the terminal.
STARTABLE = false

HOMEPAGE = https://clementtsang.github.io/bottom
LICENSE  = MIT

SPK_COMMANDS = bin/btm

include ../../mk/fpksrc.fpk.mk
