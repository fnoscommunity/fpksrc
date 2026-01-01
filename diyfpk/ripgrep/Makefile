FPK_NAME = ripgrep
FPK_VERS = 15.1.0
FPK_REV = 1
FPK_ICON = src/ripgrep.png

# powerpc archs (except qoriq) are not supported
UNSUPPORTED_ARCHS = $(OLD_PPC_ARCHS)

DEPENDS = cross/ripgrep

include ../../mk/fpksrc.common.mk
ifeq ($(findstring $(ARCH),$(ARMv5_ARCHS) $(PPC_ARCHS)),$(ARCH))
FPK_VERS = 14.1.1
else ifeq ($(findstring $(ARCH),$(i686_ARCHS)),$(ARCH))
ifeq ($(call version_le, $(TC_GCC), 5.0),1)
FPK_VERS = 14.1.1
endif
endif

MAINTAINER = Hylen
DESCRIPTION = ripgrep is a line-oriented search tool that recursively searches your current directory for a regex pattern.
DISPLAY_NAME = ripgrep
STARTABLE = false

HOMEPAGE = https://github.com/BurntSushi/ripgrep
LICENSE  = public domain/Unlicense

SPK_COMMANDS = bin/rg

include ../../mk/fpksrc.fpk.mk
