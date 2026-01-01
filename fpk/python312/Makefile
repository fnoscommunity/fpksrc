FPK_NAME = python312
FPK_VERS = 3.12.12
FPK_VERS_MAJOR_MINOR = $(word 1,$(subst ., ,$(FPK_VERS))).$(word 2,$(subst ., ,$(FPK_VERS)))
FPK_REV = 6
FPK_ICON = src/python3.png

# Compiler must support std=c++11
UNSUPPORTED_ARCHS = $(OLD_PPC_ARCHS) $(ARMv5_ARCHS)

DEPENDS  = cross/python312

MAINTAINER = FnOScommunity
DESCRIPTION = Python Programming Language.
DESCRIPTION_FRE = Language de programmation Python.
DESCRIPTION_SPN = Lenguaje de programación Python.
STARTABLE = false
DISPLAY_NAME = Python 3.12
CHANGELOG = "1. Update to Python 3.12.12"

HOMEPAGE = https://www.python.org
LICENSE  = PSF

# Force compiler LTO optimizations
ENV += PYTHON_OPTIMIZE=1

# Force building pure-python wheels
WHEELS_PURE_PYTHON_PACKAGING_ENABLE = 1
WHEELS = src/requirements-pure.txt

SERVICE_SETUP = src/service-setup.sh

PYTHON_LIB_DIR = lib/python$(FPK_VERS_MAJOR_MINOR)

POST_STRIP_TARGET = python312_extra_install

SPK_USR_LOCAL_LINKS = bin:bin/python3.12

include ../../mk/fpksrc.fpk.mk

.PHONY: python312_extra_install
python312_extra_install:
	@$(MSG) - Remove compiled files from __pycache__
	find $(STAGING_DIR)/$(PYTHON_LIB_DIR) -type f -regex '.*\.py[co]' -delete
