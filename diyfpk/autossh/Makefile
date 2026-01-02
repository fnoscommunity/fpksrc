FPK_NAME = autossh
FPK_VERS = 1.4g
FPK_REV = 1

DEPENDS = cross/autossh

MAINTAINER = chrisellsworth
DESCRIPTION = Automatically restart SSH sessions and tunnels. autossh is a program to start a copy of ssh and monitor it, restarting it as necessary should it die or stop passing traffic. The idea is from rstunnel (Reliable SSH Tunnel), but implemented in C.
DISPLAY_NAME = autossh
STARTABLE = false

HOMEPAGE = https://www.harding.motd.ca/autossh/

FPK_COMMANDS = bin/autossh
FPK_COMMANDS += bin/scp bin/sftp bin/slogin bin/ssh bin/ssh-add bin/ssh-agent bin/ssh-keygen bin/ssh-keyscan
FPK_COMMANDS += libexec/sftp-server libexec/ssh-keysign libexec/ssh-pkcs11-helper libexec/ssh-sk-helper
FPK_COMMANDS += sbin/sshd

include ../../mk/fpksrc.fpk.mk
