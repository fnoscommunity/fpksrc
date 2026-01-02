FPK_NAME = byobu
FPK_VERS = 5.133
FPK_REV = 1
FPK_ICON = src/byobu.png

PYTHON_PACKAGE = python312
SPK_DEPENDS = "$(PYTHON_PACKAGE):synocli-net"

# Python 3.12 not supported
UNSUPPORTED_ARCHS = $(OLD_PPC_ARCHS) $(ARMv5_ARCHS)

DEPENDS = cross/byobu
DEPENDS += cross/newt

MAINTAINER = tofuHero
DESCRIPTION = Byobu is a GPLv3 open source text-based window manager and terminal multiplexer. It was originally designed to provide elegant enhancements to the otherwise functional, plain, practical GNU Screen, for the Ubuntu server distribution. Byobu now includes an enhanced profiles, convenient keybindings, configuration utilities, and toggle-able system status notifications for both the GNU Screen window manager and the more modern Tmux terminal multiplexer, and works on most Linux, BSD, and Mac distributions.
DISPLAY_NAME = byobu
STARTABLE = false
CHANGELOG = "Initial package release."

LICENSE  = GPLv3
HOMEPAGE = https://www.byobu.org/

FPK_COMMANDS  = bin/byobu
FPK_COMMANDS += bin/byobu-config
FPK_COMMANDS += bin/byobu-ctrl-a
FPK_COMMANDS += bin/byobu-disable
FPK_COMMANDS += bin/byobu-disable-prompt
FPK_COMMANDS += bin/byobu-enable
FPK_COMMANDS += bin/byobu-enable-prompt
FPK_COMMANDS += bin/byobu-export
FPK_COMMANDS += bin/byobu-janitor
FPK_COMMANDS += bin/byobu-launch
FPK_COMMANDS += bin/byobu-launcher
FPK_COMMANDS += bin/byobu-launcher-install
FPK_COMMANDS += bin/byobu-launcher-uninstall
FPK_COMMANDS += bin/byobu-layout
FPK_COMMANDS += bin/byobu-prompt
FPK_COMMANDS += bin/byobu-quiet
FPK_COMMANDS += bin/byobu-reconnect-sockets
FPK_COMMANDS += bin/byobu-screen
FPK_COMMANDS += bin/byobu-select-backend
FPK_COMMANDS += bin/byobu-select-profile
FPK_COMMANDS += bin/byobu-select-session
FPK_COMMANDS += bin/byobu-shell
FPK_COMMANDS += bin/byobu-silent
FPK_COMMANDS += bin/byobu-status
FPK_COMMANDS += bin/byobu-status-detail
FPK_COMMANDS += bin/byobu-tmux
FPK_COMMANDS += bin/byobu-ugraph
FPK_COMMANDS += bin/byobu-ulevel

include ../../mk/fpksrc.python.mk
