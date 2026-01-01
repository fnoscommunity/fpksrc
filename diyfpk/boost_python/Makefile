FPK_NAME = boost_python
FPK_VERS = 1.78.0
FPK_REV = 1

BUILD_DEPENDS = cross/python310
DEPENDS = cross/boost

MAINTAINER = FnOScommunity
DESCRIPTION = Makefile to build boost-python library.
STARTABLE = false

BOOST_LIBRARIES += python
ENV += BOOST_LIBRARIES="$(BOOST_LIBRARIES)"

include ../../mk/fpksrc.fpk.mk
