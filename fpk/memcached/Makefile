FPK_NAME = memcached
FPK_VERS = 1.6.39
FPK_REV = 9
FPK_ICON = src/memcached.png

DEPENDS = cross/memcached

MAINTAINER = FnOScommunity
DESCRIPTION = Memcached is a high-performance, distributed memory object caching system, generic in nature, but originally intended for use in speeding up dynamic web applications by alleviating database load.
DISPLAY_NAME = Memcached
CHANGELOG = "1. Update Memcached to v1.6.39."

HOMEPAGE = https://memcached.org/
LICENSE  = 3-Clause BSD

SERVICE_USER = auto
SERVICE_PORT = 11211
NO_SERVICE_SHORTCUT = true

# SERVICE_COMMAND is defined in service setup script
STARTABLE = yes
SERVICE_SETUP = src/service-setup.sh

include ../../mk/fpksrc.fpk.mk
