FPK_NAME = git
FPK_VERS = 2.51.1
FPK_REV = 39
FPK_ICON = src/git.png

DEPENDS = cross/git
OPTIONAL_DEPENDS = cross/git-lfs

MAINTAINER = FnOScommunity
DESCRIPTION = Git is a fast, scalable, distributed revision control system with an unusually rich command set that provides both high-level operations and full access to internals.
DESCRIPTION_FRE = Git est un système de gestion de révision rapide, extensible et distribué avec un ensemble de commandes inhabituellement riche qui fournit à la fois des opérations de haut niveau et un accès complet aux structures de bas niveau.
STARTABLE = false
DISPLAY_NAME = Git
CHANGELOG = "1. Update git to v2.51.1. <br/>2. Update git-lfs to v3.7.1."

HOMEPAGE = https://git-scm.com
LICENSE  = GPLv2

FPK_COMMANDS  = bin/git
FPK_COMMANDS += bin/git-cvsserver
FPK_COMMANDS += bin/git-receive-pack
FPK_COMMANDS += bin/git-shell
FPK_COMMANDS += bin/git-upload-archive
FPK_COMMANDS += bin/git-upload-pack
FPK_COMMANDS += bin/scalar

include ../../mk/fpksrc.fpk.mk

ifneq ($(findstring $(ARCH),$(PPC_ARCHS) $(ARMv5_ARCHS) $(ARMv7L_ARCHS)),$(ARCH))
DEPENDS += cross/git-lfs
FPK_COMMANDS += bin/git-lfs
endif
