FPK_NAME = selfoss
FPK_VERS = 2.19
FPK_REV = 9
FPK_ICON = src/selfoss.png

DEPENDS  = cross/selfoss
# Pure PHP package, make sure ARCH is noarch
override ARCH=noarch

REQUIRED_MIN_DSM = 6.0
# SRM is not supported due lacking webstation, php and apache packages
REQUIRED_MIN_SRM = 3.0

MAINTAINER = moneytoo
DESCRIPTION = The new multipurpose rss reader, live stream, mashup, aggregation web application.
DISPLAY_NAME = Selfoss
CHANGELOG = "1. Align WebStation/PHP profile with DSM 6/7 requirements."
HOMEPAGE   = https://selfoss.aditu.de/

LICENSE    = GPLv3

WIZARDS_DIR = src/wizard/

SYSTEM_GROUP = http

# Admin link for in DSM UI
ADMIN_URL = /selfoss/

FNOS_UI_DIR = app
DSM_UI_CONFIG = src/app/config

# Set user as 'auto' for DSM 6 privilege
SERVICE_USER = auto
SERVICE_SETUP = src/service-setup.sh
STARTABLE = false

# TMPDIR is used for selfoss built in backup and update
USE_ALTERNATE_TMPDIR = 1

include ../../mk/fpksrc.common.mk

# Default to PHP 7.4 on DSM 6.x
FPK_DEPENDS = "WebStation:PHP7.4:Apache2.4"

ifeq ($(call version_ge, ${TCVERSION}, 7.2),1)
# Use PHP 8.2 on DSM 7.2+
FPK_DEPENDS = "WebStation:PHP8.2:Apache2.4"
CONF_DIR = src/conf_72/
else ifeq ($(call version_ge, ${TCVERSION}, 7.0),1)
# Use PHP 8.0 on DSM 7.0/7.1
FPK_DEPENDS = "WebStation:PHP8.0:Apache2.4"
OS_MAX_VER = 7.1-59999
CONF_DIR = src/conf_7/
endif

ifeq ($(call version_lt, ${TCVERSION}, 7.0),1)
POST_STRIP_TARGET = selfoss_extra_install
endif

include ../../mk/fpksrc.fpk.mk

.PHONY: selfoss_extra_install
selfoss_extra_install:
	install -m 755 -d $(STAGING_DIR)/web
	install -m 644 src/web/selfoss.conf $(STAGING_DIR)/web/selfoss.conf
	install -m 644 src/web/selfoss.json $(STAGING_DIR)/web/selfoss.json
