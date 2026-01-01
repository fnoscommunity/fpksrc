FPK_NAME = boost_all
FPK_VERS = 1.78.0
SPK_REV = 1

DEPENDS = cross/boost

MAINTAINER = FnOScommunity
DESCRIPTION = Makefile to build all boost libraries (except boost-python).
STARTABLE = false

BOOST_LIBRARIES += all
ENV += BOOST_LIBRARIES="$(BOOST_LIBRARIES)"

include ../../mk/fpksrc.fpk.mk
