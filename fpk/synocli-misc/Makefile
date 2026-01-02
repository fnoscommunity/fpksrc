FPK_NAME = synocli-misc
FPK_VERS = 1.3
FPK_REV = 7
FPK_ICON = src/synocli-misc.png

DEPENDS  = cross/bc
DEPENDS += cross/moreutils
DEPENDS += cross/misc-util-linux
DEPENDS += cross/uhubctl
DEPENDS += cross/expect

MAINTAINER = FnOScommunity
DISPLAY_NAME = SynoCli misc. Tools

DESCRIPTION = "SynoCli misc. Tools provide a set of miscellaneous small command-line utilities: bc, errno, expect, ifdata, ifne, isutf8, lckdo, mispipe, parallel, pee, sponge, ts, cal, col, colcrt, colrm, column, hardlink, findmnt, hexdump, lsblk, lscpu, lsipc, lsirq, rev, wall, whereis, zramctl, uhubctl."
STARTABLE = false
CHANGELOG = "1. Add findmnt of util-linux. <br/>2. Update bc to v1.08.2. <br/>3. Update util-linux to v2.4.1. <br/>4. Update uhubctl to v2.6.0."

HOMEPAGE = https://github.com/fnoscommunity/fpksrc/wiki/FAQ-SynoCliMisc
LICENSE  = Each tool is licensed under it's respective license.

# gnu:
FPK_COMMANDS = bin/bc bin/dc

# moreutils:
FPK_COMMANDS += bin/errno
FPK_COMMANDS += bin/ifdata
FPK_COMMANDS += bin/ifne
FPK_COMMANDS += bin/isutf8
FPK_COMMANDS += bin/lckdo
FPK_COMMANDS += bin/mispipe
FPK_COMMANDS += bin/parallel
FPK_COMMANDS += bin/pee
FPK_COMMANDS += bin/sponge
# ts is a perl script
FPK_COMMANDS += bin/ts

# util-linux:
FPK_COMMANDS += bin/cal
FPK_COMMANDS += bin/col
FPK_COMMANDS += bin/colcrt
FPK_COMMANDS += bin/colrm
FPK_COMMANDS += bin/column
# findmnt is not included in OLD_PPC_ARCHS
FPK_COMMANDS += bin/findmnt
FPK_COMMANDS += bin/hardlink
FPK_COMMANDS += bin/hexdump
# lsblk is not included in OLD_PPC_ARCHS
FPK_COMMANDS += bin/lsblk
FPK_COMMANDS += bin/lscpu
FPK_COMMANDS += bin/lsipc
FPK_COMMANDS += bin/lsirq
FPK_COMMANDS += bin/rev
FPK_COMMANDS += bin/wall
FPK_COMMANDS += bin/whereis
FPK_COMMANDS += bin/zramctl

# uhubctl
FPK_COMMANDS += bin/uhubctl

# expect
FPK_COMMANDS += bin/expect

include ../../mk/fpksrc.fpk.mk
