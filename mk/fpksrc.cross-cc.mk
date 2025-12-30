#
# Default make programs
#

# Configure the included makefiles
URLS          = $(PKG_DIST_SITE)/$(PKG_DIST_NAME)
NAME          = $(PKG_NAME)
COOKIE_PREFIX = $(PKG_NAME)-
ifneq ($(PKG_DIST_FILE),)
LOCAL_FILE    = $(PKG_DIST_FILE)
else
LOCAL_FILE    = $(PKG_DIST_NAME)
endif
DIST_FILE     = $(DISTRIB_DIR)/$(LOCAL_FILE)
DIST_EXT      = $(PKG_EXT)

ifneq ($(ARCH),)
ARCH_SUFFIX = -$(ARCH)-$(TCVERSION)
ifneq ($(ARCH),noarch)
TC = syno$(ARCH_SUFFIX)
endif
endif

# Common directories (must be set after ARCH_SUFFIX)
include ../../mk/fpksrc.directories.mk

# Common makefiles
include ../../mk/fpksrc.common.mk

#####

include ../../mk/fpksrc.pre-check.mk

include ../../mk/fpksrc.cross-env.mk

include ../../mk/fpksrc.download.mk

include ../../mk/fpksrc.depend.mk

include ../../mk/fpksrc.status.mk

checksum: download
include ../../mk/fpksrc.checksum.mk

extract: checksum depend status
include ../../mk/fpksrc.extract.mk

patch: extract
include ../../mk/fpksrc.patch.mk

configure: patch
include ../../mk/fpksrc.configure.mk

compile: configure
include ../../mk/fpksrc.compile.mk

install: compile
include ../../mk/fpksrc.install.mk

plist: install
include ../../mk/fpksrc.plist.mk

###

# Define _all as a real target that does the work
.PHONY: _all
_all: install plist

# all wraps _all with logging
.PHONY: all
.DEFAULT_GOAL := all

all:
	@mkdir -p $(WORK_DIR)
	@bash -o pipefail -c ' \
	    if [ -z "$$LOGGING_ENABLED" ]; then \
	        export LOGGING_ENABLED=1 ; \
	        script -q -e -c "$(MAKE) -f $(firstword $(MAKEFILE_LIST)) _all" /dev/null \
	            | tee >(sed -r "s/\x1B\[[0-9;]*[mK]//g; s/\\r//g" >> "$(DEFAULT_LOG)") ; \
	    else \
	        $(MAKE) -f $(firstword $(MAKEFILE_LIST)) _all ; \
	    fi \
	' || { \
	    $(MSG) $$(printf "%s MAKELEVEL: %02d, PARALLEL_MAKE: %s, ARCH: %s, NAME: %s - FAILED\n" \
	    "$$(date +%Y%m%d-%H%M%S)" $(MAKELEVEL) "$(PARALLEL_MAKE)" "$(ARCH)-$(TCVERSION)" "$(NAME)") \
	    | tee --append $(STATUS_LOG) ; \
	    exit 1 ; \
	}

####

### For arch-* and all-<supported|latest>
include ../../mk/fpksrc.supported.mk

####
