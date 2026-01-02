FPK_NAME = java-11-openjdk
JAVA_REPO_NAME = jdk11u
JAVA_NAME = jdk
JAVA_RELEASE = 7
JAVA_VERSION = 11.0.12
FPK_VERS = $(JAVA_VERSION).$(JAVA_RELEASE)
FPK_REV = 1
FPK_ICON = src/java-11-openjdk.png

DEPENDS = cross/java-11-openjdk

MAINTAINER = FnOScommunity
DESCRIPTION = OpenJDK version $(JAVA_VERSION)+$(JAVA_RELEASE). OpenJDK 11 is the open-source reference implementation of version 11 of the Java SE Platform as specified by by JSR 384 in the Java Community Process.
STARTABLE = false
DISPLAY_NAME = Java 11 OpenJDK
CHANGELOG = "Initial version for Synology NAS's"

HOMEPAGE = http://openjdk.java.net/
LICENSE_FILE = src/LICENSE

FPK_COMMANDS += bin/jar
FPK_COMMANDS += bin/jarsigner
FPK_COMMANDS += bin/java
FPK_COMMANDS += bin/javac
FPK_COMMANDS += bin/javadoc
FPK_COMMANDS += bin/javap
FPK_COMMANDS += bin/jcmd
FPK_COMMANDS += bin/jconsole
FPK_COMMANDS += bin/jdb
FPK_COMMANDS += bin/jdeprscan
FPK_COMMANDS += bin/jdeps
FPK_COMMANDS += bin/jfr
FPK_COMMANDS += bin/jimage
FPK_COMMANDS += bin/jinfo
FPK_COMMANDS += bin/jjs
FPK_COMMANDS += bin/jlink
FPK_COMMANDS += bin/jmap
FPK_COMMANDS += bin/jmod
FPK_COMMANDS += bin/jps
FPK_COMMANDS += bin/jrunscript
FPK_COMMANDS += bin/jshell
FPK_COMMANDS += bin/jstack
FPK_COMMANDS += bin/jstat
FPK_COMMANDS += bin/jstatd
FPK_COMMANDS += bin/keytool
FPK_COMMANDS += bin/pack200
FPK_COMMANDS += bin/rmic
FPK_COMMANDS += bin/rmid
FPK_COMMANDS += bin/rmiregistry
FPK_COMMANDS += bin/serialver
FPK_COMMANDS += bin/unpack200

include ../../mk/fpksrc.fpk.mk
