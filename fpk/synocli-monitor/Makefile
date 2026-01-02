FPK_NAME = synocli-monitor
FPK_VERS = 1.8
FPK_REV = 13
FPK_ICON = src/synocli-monitor.png

DEPENDS  = cross/nmon cross/njmon
DEPENDS += cross/iperf2 cross/iperf3
DEPENDS += cross/busybox
DEPENDS += cross/ionice
DEPENDS += cross/lsof
DEPENDS += cross/htop
DEPENDS += cross/cpulimit
DEPENDS += cross/net-snmp
DEPENDS += cross/lm-sensors

OPTIONAL_DEPENDS  = cross/bandwhich cross/bottom cross/bottom_0.10 cross/procs
OPTIONAL_DEPENDS += cross/btop

include ../../mk/fpksrc.common.mk
ifeq ($(call version_lt,${TCVERSION},6.0)$(call version_gt,${TCVERSION},2.0),11)
# include process utilities including pstree for DSM<6 and DSM>2
BUSYBOX_CONFIG = procutils.dsm5
OPTIONAL_DESC = ", and process utilities \(lsof, iostat, pgrep, pmap, pstree, watch\)"
else
BUSYBOX_CONFIG = procutils
OPTIONAL_DESC = ", and process utilities \(lsof, iostat, pgrep, pmap, watch\)"
endif
ENV += BUSYBOX_CONFIG="$(BUSYBOX_CONFIG)"

ifneq ($(findstring $(ARCH),$(OLD_PPC_ARCHS)),$(ARCH))
OPTIONAL_DESC := $(OPTIONAL_DESC)", bandwhich, bottom, procs"
DEPENDS += cross/bandwhich cross/procs
ifeq ($(findstring $(ARCH),$(ARMv5_ARCHS) $(PPC_ARCHS)),$(ARCH))
DEPENDS += cross/bottom_0.10
else
DEPENDS += cross/bottom
endif
endif

ifneq ($(findstring $(ARCH),$(PPC_ARCHS) $(ARMv5_ARCHS) $(ARMv7L_ARCHS)),$(ARCH))
OPTIONAL_DESC := $(OPTIONAL_DESC)", btop"
DEPENDS += cross/btop
endif

MAINTAINER = hgy59

HOMEPAGE = https://github.com/fnoscommunity/fpksrc/wiki/FAQ-SynoCliMonitor
LICENSE  = Each tool is licensed under it\'s respective license.

WIKI_URL = "\<a target=\"_blank\" href=\"$(HOMEPAGE)\"\>FAQ SynoCliMonitor\</a\>"

# Remarks: html in DESCRIPTION is not supported
DESCRIPTION = SynoCli Monitor Tools provides a set of command-line utilities for system monitoring: nmon, njmon, iperf2, iperf3, htop, ionice, cpulimit, net-snmp tools$(OPTIONAL_DESC).
DISPLAY_NAME = SynoCli Monitor Tools
STARTABLE = false
CHANGELOG  = "1. Add btop 1.4.5. </br>"
CHANGELOG += "2. Update bottom to v0.11.4. </br>"
CHANGELOG += "3. Update iperf3 to v3.20. </br>"
CHANGELOG += "4. Update njmon to v90. </br>"
CHANGELOG += "5. Update nmon v16s. </br>"
CHANGELOG += "<br/>For package details and specific licences see $(WIKI_URL)".

SERVICE_SETUP = src/service-setup.sh

FPK_COMMANDS  = bin/htop
FPK_COMMANDS += bin/btop
FPK_COMMANDS += bin/nmon bin/njmon
FPK_COMMANDS += bin/iperf2 bin/iperf3
FPK_COMMANDS += bin/ionice
FPK_COMMANDS += bin/iostat bin/pgrep bin/pmap bin/watch bin/pstree
FPK_COMMANDS += bin/lsof
FPK_COMMANDS += bin/cpulimit
FPK_COMMANDS += bin/bandwhich
FPK_COMMANDS += bin/btm
FPK_COMMANDS += bin/procs
FPK_COMMANDS += bin/snmpget bin/snmpgetnext bin/snmpbulkget bin/snmpwalk bin/snmpbulkwalk bin/snmpdelta bin/snmpdf
FPK_COMMANDS += bin/snmpinform bin/snmpnetstat bin/snmpps bin/snmpstatus bin/snmptable bin/snmptest bin/snmptranslate
FPK_COMMANDS += bin/sensors bin/sensors-conf-convert sbin/fancontrol sbin/sensors-detect

include ../../mk/fpksrc.fpk.mk
