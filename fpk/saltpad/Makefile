FPK_NAME = saltpad
FPK_VERS = $(shell date +%Y%m%d)
FPK_REV = 5
FPK_ICON = src/saltpad.png
DSM_UI_DIR = app

DEPENDS =
WHEELS = src/requirements.txt
SPK_DEPENDS = "python>=2.7.9-12:salt-master"

MAINTAINER = FnOScommunity
DESCRIPTION = A gui and cli to manage saltstack deployments 
CHANGELOG = "1. Use saltpad_v1 branch \(latest python version\)<br/>2. Update dependencies"

ADMIN_PORT = 8283
DISPLAY_NAME = SaltPad
START_DEP_SERVICES = salt-master

HOMEPAGE   = https://github.com/Lothiraldan/saltpad
LICENSE    = GPL

INSTALLER_SCRIPT = src/installer.sh
SSS_SCRIPT       = src/dsm-control.sh
FWPORTS          = src/${FPK_NAME}.sc
CONF_DIR         = src/conf/

POST_STRIP_TARGET = saltpad_extra_install

# Pure Python package, make sure ARCH is noarch
override ARCH=noarch

include ../../mk/fpksrc.fpk.mk

.PHONY: saltpad_extra_install
saltpad_extra_install: $(STAGING_DIR)/share/saltpad
	install -m 755 -d $(STAGING_DIR)/var

$(STAGING_DIR)/share/saltpad:
	install -m 755 -d $(STAGING_DIR)/share
	cd $(STAGING_DIR)/share && git clone --single-branch --branch saltpad_v1  https://github.com/Lothiraldan/saltpad.git saltpad
