
# Constants
default: all

# Common makefiles
include ../../mk/fpksrc.common.mk
include ../../mk/fpksrc.directories.mk

# Common kernel variables
include ../../mk/fpksrc.kernel-flags.mk

# Configure the included makefiles
NAME          = $(KERNEL_NAME)
URLS          = $(KERNEL_DIST_SITE)/$(KERNEL_DIST_NAME)
COOKIE_PREFIX = $(PKG_NAME)-

ifneq ($(strip $(REQUIRE_KERNEL_MODULE)),)
PKG_NAME      = linux-$(subst syno-,,$(NAME))
PKG_DIR       = $(PKG_NAME)
else
PKG_NAME      = linux
PKG_DIR       = $(PKG_NAME)
endif

ifneq ($(KERNEL_DIST_FILE),)
LOCAL_FILE    = $(KERNEL_DIST_FILE)
# download.mk uses PKG_DIST_FILE
PKG_DIST_FILE = $(KERNEL_DIST_FILE)
else
LOCAL_FILE    = $(KERNEL_DIST_NAME)
endif
DISTRIB_DIR   = $(KERNEL_DIR)/$(KERNEL_VERS)
DIST_FILE     = $(DISTRIB_DIR)/$(LOCAL_FILE)
DIST_EXT      = $(KERNEL_EXT)
EXTRACT_CMD   = $(EXTRACT_CMD.$(KERNEL_EXT)) --skip-old-files --strip-components=$(KERNEL_STRIP) $(KERNEL_PREFIX)

#####

# Prior to interacting with the kernel files
# move the kernel source tree to its final destination
POST_EXTRACT_TARGET      = kernel_post_extract_target

# By default do not install kernel headers
INSTALL_TARGET           = nop

#####

TC ?= syno-$(KERNEL_ARCH)-$(KERNEL_VERS)

#####

include ../../mk/fpksrc.cross-env.mk

include ../../mk/fpksrc.download.mk

checksum: download
include ../../mk/fpksrc.checksum.mk

extract: checksum
include ../../mk/fpksrc.extract.mk

patch: extract
include ../../mk/fpksrc.patch.mk

kernel_configure: patch
include ../../mk/fpksrc.cross-kernel-configure.mk

kernel_module: kernel_configure
include ../../mk/fpksrc.cross-kernel-module.mk

install: kernel_module
include ../../mk/fpksrc.cross-kernel-headers.mk

install: kernel_headers
include ../../mk/fpksrc.install.mk

plist: install
include ../../mk/fpksrc.plist.mk

.PHONY: kernel_post_extract_target
kernel_post_extract_target:
	mv $(WORK_DIR)/$(KERNEL_DIST) $(WORK_DIR)/$(PKG_DIR)

all: install plist

# Common rules makefiles
include ../../mk/fpksrc.common-rules.mk
