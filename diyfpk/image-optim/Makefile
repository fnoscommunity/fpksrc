FPK_NAME = image-optim
FPK_VERS = 1.0
FPK_REV = 1

# pngquant (pngquant3) must be built first
OPTIONAL_DEPENDS = cross/pngquant
include ../../mk/fpksrc.archs.mk
ifneq ($(findstring $(ARCH), $(OLD_PPC_ARCHS)),$(ARCH))
DEPENDS = cross/pngquant
endif

DEPENDS += cross/jpegoptim cross/pngcrush cross/advancecomp

MAINTAINER = FnOScommunity
DESCRIPTION = Several utilities for image optimization \(pngquant, jpegoptim, pngcrush, advancecomp\)
DISPLAY_NAME = Image Optimizers
STARTABLE = false

LICENSE = GPLv3

SPK_COMMANDS = bin/pngquant bin/jpegoptim bin/pngcrush bin/advmng bin/advpng

include ../../mk/fpksrc.fpk.mk
