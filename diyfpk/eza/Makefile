FPK_NAME = eza
SPK_VERS = 0.23.4
SPK_REV = 1

UNSUPPORTED_ARCHS = $(OLD_PPC_ARCHS)

DEPENDS = cross/eza

include ../../mk/fpksrc.archs.mk
ifeq ($(findstring $(ARCH),$(ARMv5_ARCHS)),$(ARCH))
SPK_VERS = 0.20.18
endif

MAINTAINER = FnOScommunity
DESCRIPTION = A modern replacement for 'ls'.
STARTABLE = false

HOMEPAGE = https://eza.rocks/
LICENSE = MIT

SPK_COMMANDS = bin/eza

include ../../mk/fpksrc.fpk.mk
