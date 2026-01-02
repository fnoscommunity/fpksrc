FPK_NAME = ffmpeg
FPK_VERS = 4.4.4
FPK_REV = 50
FPK_ICON = src/ffmpeg.png
CHANGELOG = "1. Update to version 4.4.4<br/>2. Fix permissions on DSM6<br/>3. Update Intel Media Driver 2023Q1 Release (DSM7 only)<br/>4. Update jellyfin and libsvtav1 patches along with multiple dependencies<br/>5. Update to latest version of x264 (fix for \#6176) - rev50 UNRELEASED"

DEPENDS = cross/ffmpeg4

MAINTAINER = th0ma7
DESCRIPTION = FFmpeg is a complete, cross-platform solution to record, convert and stream audio and video. It includes libavcodec - the leading audio/video codec library.  More information from FnOScommunity FFmpeg package available at https://github.com/fnoscommunity/fpksrc/wiki/FAQ-FFmpeg
DESCRIPTION_FRE = FFmpeg est une solution complète multiplateforme pour enregistrer, convertir et diffuser du contenu audio et vidéo. Il comprend libavcodec - la principale bibliothèque de codecs audio/vidéo.  Informations additionnelles concernant le paquet FFmpeg de FnOScommunity disponibles à https://github.com/fnoscommunity/fpksrc/wiki/FAQ-FFmpeg
DISPLAY_NAME = FFmpeg $(firstword $(subst ., ,$(FPK_VERS)))
STARTABLE = false

HOMEPAGE = https://www.ffmpeg.org/
LICENSE  = GPLv3

POST_STRIP_TARGET = ffmpeg4_extra_install

FPK_COMMANDS  = bin/ffmpeg
FPK_COMMANDS += bin/ffmpeg4

include ../../mk/fpksrc.archs.mk

ifeq ($(call version_ge, $(TCVERSION), 7.0),1)
SERVICE_USER = auto
VIDEODRIVER = on
endif

ifeq ($(findstring $(ARCH),$(x64_ARCHS)),$(ARCH))
SERVICE_SETUP = src/service-setup.sh
FPK_COMMANDS += bin/vainfo
endif

include ../../mk/fpksrc.fpk.mk

.PHONY: ffmpeg4_extra_install
ffmpeg4_extra_install:
	cd $(STAGING_DIR)/bin && ln -sf ffmpeg ffmpeg4
