FPK_NAME = java-17-openjdk
JAVA_REPO_NAME = jdk17u
JAVA_NAME = jdk
JAVA_RELEASE = 7
JAVA_VERSION = 17.0.16
FPK_VERS = $(JAVA_VERSION).$(JAVA_RELEASE)
FPK_REV = 2
FPK_ICON = src/java-openjdk.png

DEPENDS = cross/java-17-openjdk

# gcc >= 5.0 required
REQUIRED_MIN_DSM = 7.0
UNSUPPORTED_ARCHS = comcerto2k
REQUIRED_MIN_SRM = 1.3

MAINTAINER = FnOScommunity
DESCRIPTION = OpenJDK version $(JAVA_VERSION)+$(JAVA_RELEASE). OpenJDK 17 is the open-source reference implementation of version 17 of the Java SE Platform as specified by JSR 390 in the Java Community Process.

STARTABLE = false
DISPLAY_NAME = Java 17 OpenJDK
CHANGELOG = "Update to v17.0.16+7."

HOMEPAGE = https://openjdk.org/projects/jdk/17/
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
FPK_COMMANDS += bin/jhsdb
FPK_COMMANDS += bin/jimage
FPK_COMMANDS += bin/jinfo
FPK_COMMANDS += bin/jlink
FPK_COMMANDS += bin/jmap
FPK_COMMANDS += bin/jmod
FPK_COMMANDS += bin/jpackage
FPK_COMMANDS += bin/jps
FPK_COMMANDS += bin/jrunscript
FPK_COMMANDS += bin/jshell
FPK_COMMANDS += bin/jstack
FPK_COMMANDS += bin/jstat
FPK_COMMANDS += bin/jstatd
FPK_COMMANDS += bin/keytool
FPK_COMMANDS += bin/rmiregistry
FPK_COMMANDS += bin/serialver

include ../../mk/fpksrc.fpk.mk
