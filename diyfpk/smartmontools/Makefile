FPK_NAME = smartmontools
FPK_VERS = 7.5
FPK_REV = 1

DEPENDS = cross/smartmontools

UNSUPPORTED_ARCHS = $(ARMv5_ARCHS) $(OLD_PPC_ARCHS)

MAINTAINER = FnOScommunity
DESCRIPTION = smartmontools contains two utility programs \(smartctl and smartd\) to control and monitor storage systems using the Self-Monitoring, Analysis and Reporting Technology System \(SMART\).
STARTABLE = false

HOMEPAGE = https://www.smartmontools.org/
LICENSE = GPLv2

# smartctl of this package will not be found by path, because /bin/smartctl is found first
# you have to use smartctl7 (or /usr/local/bin/smartctl or /var/apps/smartmontools/target/sbin/smartctl)
FPK_COMMANDS = sbin/smartctl7 sbin/smartctl sbin/smartd sbin/update-smart-drivedb

include ../../mk/fpksrc.fpk.mk
