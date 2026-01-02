FPK_NAME = synocli-devel
FPK_VERS = 1.3
FPK_REV = 4
FPK_ICON = src/synocli-devel.png
CHANGELOG = "1. Fix autoconf to use installed m4 command.<br/>2. Update autoconf to v2.72.<br/>3. Update binutils to v2.42.<br/>4. Update gdb to v14.2.<br/>5. Update strace to v6.9."

MAINTAINER = FnOScommunity
DESCRIPTION = SynoCli Development Tools provides a set of command-line utilities for system development and debugging: automake 1.65.5, autoconf 2.71, binutils 2.40$(OPTIONAL_DESC), make 4.4.1, pkg-config 0.29.2, libtree 3.1.1, strace 6.5
DISPLAY_NAME = SynoCli Development Tools
STARTABLE = false

HOMEPAGE = https://github.com/fnoscommunity/fpksrc/wiki/FAQ-SynoCliDevel
LICENSE  = Each tool is licensed under it\'s respective license.

FPK_DEPENDS = "Perl"

OPTIONAL_DEPENDS = cross/llvm

include ../../mk/fpksrc.common.mk

ifneq ($(call version_lt, $(TC_GCC), 4.8.1),1)
DEPENDS += cross/llvm
endif

# build binutils bofore the following
# otherwise it fails to build for ARMv5
DEPENDS += cross/binutils
DEPENDS += cross/pkg-config
DEPENDS += cross/gdb
DEPENDS += cross/make
DEPENDS += cross/libtree
DEPENDS += cross/strace

# build autotools last
# otherwise glib and gdb fail on libiconv on some platforms
# (to investigate ...)
DEPENDS += cross/autoconf
DEPENDS += cross/automake

##
## autoconf
##
FPK_COMMANDS += bin/autoconf
FPK_COMMANDS += bin/autoheader
FPK_COMMANDS += bin/autom4te
FPK_COMMANDS += bin/autoreconf
FPK_COMMANDS += bin/autoscan
FPK_COMMANDS += bin/autoupdate
FPK_COMMANDS += bin/ifnames
## m4 dependency
FPK_COMMANDS += bin/m4

##
## automake
##
FPK_COMMANDS += bin/aclocal
FPK_COMMANDS += bin/aclocal-1.16
FPK_COMMANDS += bin/automake
FPK_COMMANDS += bin/automake-1.16

##
## binutils
##
FPK_COMMANDS += bin/addr2line
FPK_COMMANDS += bin/ar
FPK_COMMANDS += bin/as
FPK_COMMANDS += bin/c++filt
FPK_COMMANDS += bin/dwp
FPK_COMMANDS += bin/elfedit
ifeq ($(findstring $(ARCH),$(64bit_ARCHS)),$(ARCH))
FPK_COMMANDS += bin/gp-archive
FPK_COMMANDS += bin/gp-collect-app
FPK_COMMANDS += bin/gp-display-html
FPK_COMMANDS += bin/gp-display-src
FPK_COMMANDS += bin/gp-display-text
FPK_COMMANDS += bin/gprofng
endif
FPK_COMMANDS += bin/gprof
FPK_COMMANDS += bin/ld
FPK_COMMANDS += bin/ld.bfd
FPK_COMMANDS += bin/ld.gold
FPK_COMMANDS += bin/nm
FPK_COMMANDS += bin/objcopy
FPK_COMMANDS += bin/objdump
FPK_COMMANDS += bin/ranlib
FPK_COMMANDS += bin/readelf
FPK_COMMANDS += bin/size
FPK_COMMANDS += bin/strings
FPK_COMMANDS += bin/strip

##
## gdb
##
ifeq ($(call version_lt, $(TC_GCC), 4.8.1),1)
OPTIONAL_DESC += ", gdb 7.12.1"
else
OPTIONAL_DESC += ", gdb 13.2"
endif
FPK_COMMANDS += bin/gcore
FPK_COMMANDS += bin/gdb
FPK_COMMANDS += bin/gdb-add-index
FPK_COMMANDS += bin/gdbserver
ifeq ($(findstring $(ARCH),$(ARM_ARCHS)),$(ARCH))
FPK_COMMANDS += bin/run
endif

##
## LLVM
##
ifneq ($(call version_lt, $(TC_GCC), 4.8.1),1)
ifeq ($(call version_ge, $(TC_GCC), 5.1),1)
OPTIONAL_DESC += ", LLVM 16.0.6"
FPK_COMMANDS += bin/clang-16
else
OPTIONAL_DESC += ", LLVM 9.0.1"
FPK_COMMANDS += bin/clang-9
endif
FPK_COMMANDS += bin/clang
FPK_COMMANDS += bin/clang++
FPK_COMMANDS += bin/clang-check
FPK_COMMANDS += bin/clang-cl
FPK_COMMANDS += bin/clang-cpp
FPK_COMMANDS += bin/clang-extdef-mapping
FPK_COMMANDS += bin/clang-format
FPK_COMMANDS += bin/clang-refactor
FPK_COMMANDS += bin/clang-rename
FPK_COMMANDS += bin/clang-scan-deps
FPK_COMMANDS += bin/git-clang-format
FPK_COMMANDS += bin/hmaptool
FPK_COMMANDS += bin/lld
FPK_COMMANDS += bin/lld-link
FPK_COMMANDS += bin/llvm-ar
FPK_COMMANDS += bin/llvm-lib
FPK_COMMANDS += bin/llvm-nm
FPK_COMMANDS += bin/llvm-objcopy
FPK_COMMANDS += bin/llvm-objdump
FPK_COMMANDS += bin/llvm-profdata
FPK_COMMANDS += bin/llvm-ranlib
FPK_COMMANDS += bin/llvm-rc
FPK_COMMANDS += bin/llvm-readelf
FPK_COMMANDS += bin/llvm-readobj
FPK_COMMANDS += bin/llvm-size
FPK_COMMANDS += bin/llvm-strings
FPK_COMMANDS += bin/llvm-strip
FPK_COMMANDS += bin/llvm-symbolizer
FPK_COMMANDS += bin/scan-build
FPK_COMMANDS += bin/scan-view
FPK_COMMANDS += bin/wasm-ld
endif

##
## make
##
FPK_COMMANDS += bin/make

##
## pkg-config
##
FPK_COMMANDS += bin/pkg-config

##
## libtree
##
FPK_COMMANDS += bin/libtree

##
## strace
##
FPK_COMMANDS += bin/strace
FPK_COMMANDS += bin/strace-log-merge


include ../../mk/fpksrc.fpk.mk
