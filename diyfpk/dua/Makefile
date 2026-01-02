FPK_NAME = dua
FPK_VERS = 2.32.0
FPK_REV = 1

UNSUPPORTED_ARCHS = $(OLD_PPC_ARCHS)

include ../../mk/fpksrc.common.mk
ifeq ($(findstring $(ARCH),$(ARMv5_ARCHS) $(PPC_ARCHS)),$(ARCH))
FPK_VERS = 2.30.0
DEPENDS = cross/dua_2.30.0
else
DEPENDS = cross/dua
endif

MAINTAINER = FnOScommunity
DESCRIPTION = A tool to conveniently learn about the disk usage of directories, fast!
STARTABLE = false

HOMEPAGE = https://lib.rs/crates/dua-cli
LICENSE  = MIT

FPK_COMMANDS = bin/dua

include ../../mk/fpksrc.fpk.mk
