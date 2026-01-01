FPK_NAME = google-authenticator-libpam
FPK_VERS = 1.09
FPK_REV = 1
SPK_ICON = src/google-authenticator.png

DEPENDS = cross/google-authenticator-libpam

MAINTAINER = Soraxas
DESCRIPTION = google-authenticator PAM module for two-factor authentication for logging into servers via SSH, etc. To activate this module you have to manually configure the pam module and related configurations. Please follow the instructions on the FnOScommunity Wiki page.
DISPLAY_NAME = Google Authenticator for libpam
STARTABLE = false
CHANGELOG = "Initial package release."

HOMEPAGE = https://github.com/google/google-authenticator-libpam
SUPPORTURL = https://github.com/fnoscommunity/fpksrc/wiki/Google-Authenticator-PAM
LICENSE = Apache-2.0
LICENSE_FILE = $(WORK_DIR)/$(FPK_NAME)-$(FPK_VERS)/LICENSE

WIZARDS_DIR = src/wizard/

# As DSM has google-authenticator installed, create a FnOScommunity specific link
CUSTOM_AUTHENTICATOR_NAME = sc-google-authenticator
POST_STRIP_TARGET = google-authenticator-libpam_extra_install
SPK_COMMANDS = bin/$(CUSTOM_AUTHENTICATOR_NAME)

include ../../mk/fpksrc.fpk.mk

.PHONY: google-authenticator-libpam_extra_install
google-authenticator-libpam_extra_install:
	$(RUN) ; cd $(STAGING_DIR)/bin; ln -sf google-authenticator $(CUSTOM_AUTHENTICATOR_NAME)
