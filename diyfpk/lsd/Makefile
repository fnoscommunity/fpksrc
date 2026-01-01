FPK_NAME = lsd
FPK_VERS = 1.2.0
FPK_REV = 1

UNSUPPORTED_ARCHS = $(OLD_PPC_ARCHS)

DEPENDS = cross/lsd

include ../../mk/fpksrc.archs.mk
ifeq ($(findstring $(ARCH),$(ARMv5_ARCHS) $(PPC_ARCHS)),$(ARCH))
FPK_VERS = 1.1.5
endif

MAINTAINER = FnOScommunity
DESCRIPTION = The next gen ls command.
STARTABLE = false

HOMEPAGE = https://github.com/lsd-rs/lsd
LICENSE = Apache 2.0

SPK_COMMANDS = bin/lsd

include ../../mk/fpksrc.fpk.mk
