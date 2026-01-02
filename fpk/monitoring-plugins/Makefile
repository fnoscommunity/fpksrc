FPK_NAME = monitoring-plugins
FPK_VERS = 2.3.1
FPK_REV = 2
FPK_ICON = src/monitoring-plugins.png

DEPENDS = cross/monitoring-plugins

FPK_DEPENDS = Perl

MAINTAINER = Gagi2k
DESCRIPTION = Standard plugins for Icinga, Naemon, Nagios, Shinken, Sensu, and other monitoring applications.
CHANGELOG = "1. Update monitoring-plugins to v2.3.1<br/>2. Add Perl package as requirement.<br/>3. Link the check commands to /usr/local/bin."
STARTABLE = false
DISPLAY_NAME = Monitoring Plugins

HOMEPAGE = https://www.monitoring-plugins.org
LICENSE  = GPLv3

FPK_COMMANDS  = bin/check_breeze
FPK_COMMANDS += bin/check_clamd
FPK_COMMANDS += bin/check_cluster
FPK_COMMANDS += bin/check_disk
FPK_COMMANDS += bin/check_disk_smb
FPK_COMMANDS += bin/check_dummy
FPK_COMMANDS += bin/check_file_age
FPK_COMMANDS += bin/check_ftp
FPK_COMMANDS += bin/check_http
FPK_COMMANDS += bin/check_ide_smart
FPK_COMMANDS += bin/check_ifoperstatus
FPK_COMMANDS += bin/check_ifstatus
FPK_COMMANDS += bin/check_imap
FPK_COMMANDS += bin/check_ircd
FPK_COMMANDS += bin/check_load
FPK_COMMANDS += bin/check_log
FPK_COMMANDS += bin/check_mailq
FPK_COMMANDS += bin/check_mrtg
FPK_COMMANDS += bin/check_mrtgtraf
FPK_COMMANDS += bin/check_nagios
FPK_COMMANDS += bin/check_nntp
FPK_COMMANDS += bin/check_nt
FPK_COMMANDS += bin/check_ntp
FPK_COMMANDS += bin/check_ntp_peer
FPK_COMMANDS += bin/check_ntp_time
FPK_COMMANDS += bin/check_nwstat
FPK_COMMANDS += bin/check_oracle
FPK_COMMANDS += bin/check_overcr
FPK_COMMANDS += bin/check_ping
FPK_COMMANDS += bin/check_pop
FPK_COMMANDS += bin/check_procs
FPK_COMMANDS += bin/check_real
FPK_COMMANDS += bin/check_rpc
FPK_COMMANDS += bin/check_smtp
FPK_COMMANDS += bin/check_ssh
FPK_COMMANDS += bin/check_swap
FPK_COMMANDS += bin/check_tcp
FPK_COMMANDS += bin/check_time
FPK_COMMANDS += bin/check_udp
FPK_COMMANDS += bin/check_ups
FPK_COMMANDS += bin/check_uptime
FPK_COMMANDS += bin/check_users
FPK_COMMANDS += bin/check_wave
# must be found in /usr/local/bin too:
FPK_COMMANDS += bin/utils.sh
FPK_COMMANDS += bin/utils.pm

include ../../mk/fpksrc.fpk.mk
