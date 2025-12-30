
# Constants
SHELL := $(SHELL) -e
default: all

WORK_DIR := $(CURDIR)/work

# Setup common directories
include ../../mk/fpksrc.directories.mk

# Common makefiles
include ../../mk/fpksrc.common.mk

# Configure the included makefiles
URLS          = $(TK_DIST_SITE)/$(TK_DIST_NAME)
NAME          = $(TK_NAME)
COOKIE_PREFIX = 
ifneq ($(TK_DIST_FILE),)
LOCAL_FILE    = $(TK_DIST_FILE)
# download.mk uses PKG_DIST_FILE
PKG_DIST_FILE = $(TK_DIST_FILE)
else
LOCAL_FILE    = $(TK_DIST_NAME)
endif
DISTRIB_DIR   = $(TOOLKIT_DIR)/$(TK_VERS)
DIST_FILE     = $(DISTRIB_DIR)/$(LOCAL_FILE)
DIST_EXT      = $(TK_EXT)
EXTRACT_CMD   = $(EXTRACT_CMD.$(DIST_EXT)) --skip-old-files --strip-components=$(TK_STRIP) usr/$(TK_PREFIX)/$(TK_BASE_DIR)/$(TK_SYSROOT_PATH)

#####

RUN = cd $(WORK_DIR)/$(TK_TARGET) && env $(ENV)

include ../../mk/fpksrc.download.mk

checksum: download
include ../../mk/fpksrc.checksum.mk

extract: checksum
include ../../mk/fpksrc.extract.mk

patch: extract
include ../../mk/fpksrc.patch.mk

flags: patch
include ../../mk/fpksrc.toolkit-flags.mk

toolkit_fix: flags
include ../../mk/fpksrc.toolkit-fix.mk

all: toolkit_fix

### For make digests
include ../../mk/fpksrc.generate-digests.mk
