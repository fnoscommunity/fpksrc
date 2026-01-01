FPK_NAME = chromaprint
FPK_VERS = 1.6.0
FPK_REV = 24
SPK_ICON = src/chromaprint.png

FFMPEG_PACKAGE = ffmpeg7
DEPENDS = cross/chromaprint
SPK_DEPENDS = $(FFMPEG_PACKAGE)

# ffmpeg7 requires c11 support
UNSUPPORTED_ARCHS = $(ARMv5_ARCHS) $(OLD_PPC_ARCHS)

STARTABLE = false

MAINTAINER = FnOScommunity
DESCRIPTION = Chromaprint is the core component of the AcoustID project. It\'s a client-side library that implements a custom algorithm for extracting fingerprints from any audio source.
DISPLAY_NAME = Chromaprint
CHANGELOG = "1. Version 1.6.0<br/>2. Update to FFMPEG 7.0.3"

HOMEPAGE   = https://acoustid.org/chromaprint
LICENSE    = LGPL2.1+

SPK_COMMANDS = bin/fpcalc

include ../../mk/fpksrc.ffmpeg.mk
