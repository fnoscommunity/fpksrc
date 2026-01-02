FPK_NAME = bind
FPK_VERS = 9.20.11
FPK_REV = 1

UNSUPPORTED_ARCHS = $(OLD_PPC_ARCHS)

OPTIONAL_DEPENDS = cross/bind cross/bind_9.16

MAINTAINER = FnOScommunity
DESCRIPTION = BIND \(Berkeley Internet Name Domain\) is a complete, highly portable implementation of the DNS \(Domain Name System\) protocol.
STARTABLE = false

HOMEPAGE = https://www.isc.org/
LICENSE = MPL 2.0

FPK_COMMANDS = bin/arpaname bin/delv bin/dig bin/mdig

include ../../mk/fpksrc.fpk.mk

ifeq ($(call version_ge,${TCVERSION},7.0),1)
# DSM 7
ifneq ($(findstring $(ARCH),comcerto2k),$(ARCH))
DEPENDS += cross/bind_9.20
else
DEPENDS += cross/bind_9.18
FPK_VERS = 9.18.38
endif
else
# DSM 6
ifeq ($(findstring $(ARCH),$(ARMv5_ARCHS) $(ARMv7L_ARCHS)),$(ARCH))
DEPENDS += cross/bind_9.16
FPK_VERS = 9.16.50
else ifeq ($(ARCH)-$(TCVERSION),x86-5.2)
DEPENDS += cross/bind_9.16
FPK_VERS = 9.16.50
else
DEPENDS += cross/bind_9.18
FPK_VERS = 9.18.38
endif
endif
