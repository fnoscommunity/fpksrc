FPK_NAME = rhash
FPK_VERS = 1.4.6
FPK_REV = 1

DEPENDS = cross/rhash

MAINTAINER = Fredrike
DESCRIPTION = "RHash is a console utility for calculation and verification of magnet links and a wide range of hash sums like CRC32, MD4, MD5, SHA1, SHA256, SHA512, SHA3, AICH, ED2K, Tiger, DC++ TTH, BitTorrent BTIH, GOST R 34.11-94, RIPEMD-160, HAS-160, EDON-R, Whirlpool and Snefru."
DISPLAY_NAME = RHash
STARTABLE = false

POST_STRIP_TARGET = rhash_extra_install

HOMEPAGE = http://rhash.sourceforge.net/
LICENSE = MIT

FPK_COMMANDS  = bin/rhash
FPK_COMMANDS += bin/ed2k-link
FPK_COMMANDS += bin/edonr256-hash
FPK_COMMANDS += bin/edonr512-hash
FPK_COMMANDS += bin/gost12-256-hash
FPK_COMMANDS += bin/gost12-512-hash
FPK_COMMANDS += bin/has160-hash
FPK_COMMANDS += bin/magnet-link
FPK_COMMANDS += bin/sfv-hash
FPK_COMMANDS += bin/tiger-hash
FPK_COMMANDS += bin/tth-hash
FPK_COMMANDS += bin/whirlpool-hash

include ../../mk/fpksrc.fpk.mk

.PHONY: rhash_extra_install
rhash_extra_install:
	@$(MSG) "Set library runpath in rhash executable."
	@patchelf --set-rpath /var/apps/$(FPK_NAME)/target/lib $(STAGING_DIR)/bin/rhash
