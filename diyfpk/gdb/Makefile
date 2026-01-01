FPK_NAME = gdb
FPK_REV = 1
SPK_ICON = src/gdb.png

DEPENDS = cross/gdb

include ../../mk/fpksrc.common.mk
ifeq ($(findstring $(ARCH),$(ARMv5_ARCHS)),$(ARCH))
FPK_VERS = 7.12.1
else ifeq ($(call version_lt, $(TC_GCC), 4.8),1)
FPK_VERS = 7.12.1
else
FPK_VERS = 14.2
endif

MAINTAINER = th0ma7
DESCRIPTION = The GNU Debugger \(GDB\) is a portable debugger that runs on many Unix-like systems and works for many programming languages, including Ada, C, C++, Objective-C, Free Pascal, Fortran, Go and partially others.
STARTABLE = false

HOMEPAGE = https://www.sourceware.org/gdb/
LICENSE  = GPLv2

SPK_COMMANDS  = bin/gcore
SPK_COMMANDS += bin/gdb
SPK_COMMANDS += bin/gdb-add-index
SPK_COMMANDS += bin/gdbserver
ifeq ($(findstring $(ARCH),$(ARM_ARCHS)),$(ARCH))
SPK_COMMANDS += bin/run
endif

include ../../mk/fpksrc.fpk.mk
