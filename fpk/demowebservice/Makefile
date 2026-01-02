FPK_NAME = demowebservice
FPK_VERS = 1.0
FPK_REV = 2
FPK_ICON = src/demowebservice.png

DEPENDS =

# SRM is not supported due lacking webstation package
REQUIRED_MIN_SRM = 3.0

override ARCH=noarch

MAINTAINER = hgy59
DESCRIPTION = Demopackage to show how to create a web service \(web application\)
DISPLAY_NAME = Demo Web Service
CHANGELOG = "Use service port 18889 instead of 8889"

LICENSE = MIT

include ../../mk/fpksrc.common.mk
# use the latest php version
PHP_VERSION = 8.2
FPK_DEPENDS = WebStation:PHP$(PHP_VERSION):Apache2.4
WIZARDS_DIR = src/wizard/
SERVICE_WIZARD_SHARENAME = wizard_shared_folder_name

SYSTEM_GROUP = http

FNOS_UI_DIR = app
FNOS_UI_CONFIG = src/app/config
# webservice resource definition is for DSM 7 only
CONF_DIR = src/conf_php$(PHP_VERSION)/
# The app/config file is not used on DSM 7 for web services, the app icon is created based on the resources in CONF_DIR only.
# With app/config on DSM 7 (sometimes) an error occurred: System error. Unable to perform this operation. Please try again later.
# Disable the creation of app/config file:
NO_SERVICE_SHORTCUT = y
# create firewall rules, since we add a port based "Web Portal"
SERVICE_PORT = 18889

# apache-web dependency is not used:
# on DSM 7 the settings are ignored as dependency is defined in conf/resource
# on DSM 6 the package runs under the active web server (apache or nginx)
#INSTALL_DEP_SERVICES = apache-web
#START_DEP_SERVICES = apache-web
#INSTUNINST_RESTART_SERVICES = apache-web

SERVICE_SETUP = src/service-setup.sh
STARTABLE = false

COPY_TARGET = demowebservice_install
POST_ICON_TARGET = demowebservice_post_icon

include ../../mk/fpksrc.fpk.mk

.PHONY: demowebservice_install
demowebservice_install:
	@$(MSG) Install the web application
	@install -d -m 755 $(STAGING_DIR)/web/$(FPK_NAME)/
	@install -m 755 src/web/index.php $(STAGING_DIR)/web/$(FPK_NAME)/

.PHONY: demowebservice_post_icon
demowebservice_post_icon:
	@$(MSG) Add some package icons to the web application
	@install -d -m 755 $(STAGING_DIR)/web/$(FPK_NAME)/images
	@for image_size in 16 32; do \
	  install -m 755 $(STAGING_DIR)/app/images/$(FPK_NAME)-$${image_size}.png $(STAGING_DIR)/web/$(FPK_NAME)/images/ ; \
	done
