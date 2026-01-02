### Rules to create the fpk package
#   Most of the rules are imported from fpksrc.*.mk files
#
# Variables:
#  ARCH                         A dedicated arch, a generic arch or 'noarch' for arch independent packages
#  FPK_NAME                     Package name
#  MAINTAINER                   Package maintainer (mandatory)
#  MAINTAINER_URL               URL of package maintainer (optional when MAINTAINER is a valid github user)
#  FPK_NAME_ARCH                (optional) arch specific fpk file name (default: $(ARCH))
#  FPK_PACKAGE_ARCHS            (optional) list of archs in the fpk file (default: $(ARCH) or list of archs when generic arch)
#  UNSUPPORTED_ARCHS            (optional) Unsupported archs are removed from gemeric arch list (ignored when FPK_PACKAGE_ARCHS is used)
#  REMOVE_FROM_GENERIC_ARCHS    (optional) A list of archs to be excluded from generic archs (ignored when FPK_PACKAGE_ARCHS is used)
#  SSS_SCRIPT                   (optional) Use service start stop script from given file
#  INSTALLER_SCRIPT             (optional) Use installer script from given file
#  CONF_DIR                     (optional) To provide a package specific config folder with files (e.g. privilege file)
#  LICENSE_FILE                 (optional) Add licence from given file
# 
# Internal variables used in this file:
#  NAME                         The internal name of the package.
#                               Note that all synocoummunity packages use lowercase names.
#                               This enables to have concurrent packages with synology.com, that use
#                               package names starting with upper case letters.
#                               (e.g. Mono => synology.com, mono => FnOScommunity.com)
#  FPK_FILE_NAME                The full fpk name with folder, package name, arch, tc- and package version.
#  FPK_CONTENT                  List of files and folders that are added to app.tgz within the fpk file.
#  FNOS_SCRIPT_FILES            List of script files that are in the cmd folder within the fpk file.
#

# Common makefiles
include ../../mk/fpksrc.common.mk

# Configure the included makefiles
NAME = $(FPK_NAME)

ifneq ($(ARCH),)
ARCH_SUFFIX = -$(ARCH)-$(TCVERSION)
ifneq ($(ARCH),noarch)
# arch specific packages
ifneq ($(FPK_PACKAGE_ARCHS),)
FPK_ARCH = $(FPK_PACKAGE_ARCHS)
else
ifeq ($(findstring $(ARCH),$(GENERIC_ARCHS)),$(ARCH))
FPK_ARCH = $(filter-out $(UNSUPPORTED_ARCHS) $(REMOVE_FROM_GENERIC_ARCHS),$(TC_ARCH))
else
FPK_ARCH = $(filter-out $(UNSUPPORTED_ARCHS),$(TC_ARCH))
endif
endif
ifeq ($(FPK_NAME_ARCH),)
FPK_NAME_ARCH = $(ARCH)
endif
FPK_TCVERS = $(TCVERSION)
TC = syno$(ARCH_SUFFIX)
endif
endif

# Common directories (must be set after ARCH_SUFFIX)
include ../../mk/fpksrc.directories.mk

ifeq ($(ARCH),noarch)
ifneq ($(strip $(TCVERSION)),)
# different noarch packages
FPK_ARCH = noarch
FPK_NAME_ARCH = noarch
ifeq ($(call version_ge, $(TCVERSION), 7.0),1)
ifeq ($(call version_ge, $(TCVERSION), 7.2),1)
FPK_TCVERS = dsm72
TC_OS_MIN_VER = 7.2-63134
else
FPK_TCVERS = dsm7
TC_OS_MIN_VER = 7.0-40000
endif
else ifeq ($(call version_ge, $(TCVERSION), 6.1),1)
FPK_TCVERS = dsm6
TC_OS_MIN_VER = 6.1-15047
else ifeq ($(call version_ge, $(TCVERSION), 3.0),1)
FPK_TCVERS = all
TC_OS_MIN_VER = 3.1-1594
else
FPK_TCVERS = srm
TC_OS_MIN_VER = 1.1-6931
endif
endif
endif

ifeq ($(call version_lt, ${TC_OS_MIN_VER}, 6.1)$(call version_ge, ${TC_OS_MIN_VER}, 3.0),11)
OS_MIN_VER = $(TC_OS_MIN_VER)
else
ifneq ($(strip $(OS_MIN_VER)),)
$(warning WARNING: OS_MIN_VER is forced to $(OS_MIN_VER) (default by toolchain is $(TC_OS_MIN_VER)))
else
OS_MIN_VER = $(TC_OS_MIN_VER)
endif
endif

FPK_FILE_NAME = $(PACKAGES_DIR)/$(FPK_NAME)_$(FPK_NAME_ARCH)-$(FPK_TCVERS)_$(FPK_VERS)-$(FPK_REV).fpk

#####

include ../../mk/fpksrc.pre-check.mk

# Even though this makefile doesn't cross compile, we need this to setup the cross environment.
include ../../mk/fpksrc.cross-env.mk

include ../../mk/fpksrc.depend.mk

copy: depend
include ../../mk/fpksrc.wheel.mk

copy: wheel
include ../../mk/fpksrc.copy.mk

strip: copy
include ../../mk/fpksrc.strip.mk


# Scripts
FNOS_CMD_DIR = $(WORK_DIR)/cmd

# Generated scripts
FNOS_SCRIPT_FILES  = install_init   install_callback
FNOS_SCRIPT_FILES += uninstall_init uninstall_callback
FNOS_SCRIPT_FILES += upgrade_init   upgrade_callback
FNOS_SCRIPT_FILES += config_init    config_callback
FNOS_SCRIPT_FILES += main

# SPK specific scripts
ifneq ($(strip $(SSS_SCRIPT)),)
FNOS_SCRIPT_FILES += main

$(FNOS_CMD_DIR)/main: $(SSS_SCRIPT)
	@$(fnos_cmd_copy)
endif

ifneq ($(strip $(INSTALLER_SCRIPT)),)
FNOS_SCRIPT_FILES += installer

$(FNOS_CMD_DIR)/installer: $(INSTALLER_SCRIPT)
	@$(fnos_cmd_copy)
endif

FPK_CONTENT = app.tgz manifest cmd

# config
FNOS_CONFIG_DIR = $(WORK_DIR)/config

ifneq ($(CONF_DIR),)
FPK_CONF_DIR = $(CONF_DIR)
endif

# Generic service scripts
include ../../mk/fpksrc.service.mk

icon: strip
ifneq ($(strip $(FPK_ICON)),)
include ../../mk/fpksrc.icon.mk
endif

ifeq ($(strip $(MAINTAINER)),)
$(error Add MAINTAINER for '$(FPK_NAME)' in fpk Makefile or set default MAINTAINER in local.mk.)
endif

ifeq ($(strip $(DISABLE_GITHUB_MAINTAINER)),)
get_github_maintainer_url = $(shell wget --quiet --spider https://github.com/$(1) && echo "https://github.com/$(1)" || echo "")
get_github_maintainer_name = $(shell curl -s -H application/vnd.github.v3+json https://api.github.com/users/$(1) | jq -r '.name' | sed -e 's|null||g' | sed -e 's|^$$|$(1)|g' )
else
get_github_maintainer_url = "https://github.com/FnOScommunity"
get_github_maintainer_name = $(MAINTAINER)
endif

$(WORK_DIR)/manifest: SHELL:=/bin/sh
$(WORK_DIR)/manifest:
	$(create_target_dir)
	@$(MSG) "Creating manifest file for $(FPK_NAME)"
	@if [ -z "$(FPK_ARCH)" ]; then \
	   if [ "$(ARCH)" = "noarch" ]; then \
	      echo "ERROR: 'noarch' package without TCVERSION is not supported" ; \
	      exit 1; \
	   else \
	      echo "ERROR: Arch '$(ARCH)' is not a supported architecture" ; \
	      echo " - There is no remaining arch in '$(TC_ARCH)' for unsupported archs '$(UNSUPPORTED_ARCHS)'"; \
	      exit 1; \
	   fi; \
	fi
	@echo package=\"$(FPK_NAME)\" > $@
	@echo version=\"$(FPK_VERS)-$(FPK_REV)\" >> $@
	@/bin/echo -n "desc=\"" >> $@
	@/bin/echo -n "${DESCRIPTION}" | sed -e 's/\\//g' -e 's/"/\\"/g' >> $@
	@echo "\"" >> $@
	@echo $(foreach LANGUAGE, $(LANGUAGES), \
	  $(shell [ ! -z "$(DESCRIPTION_$(shell echo $(LANGUAGE) | tr [:lower:] [:upper:]))" ] && \
	    /bin/echo -n "desc_$(LANGUAGE)=\\\"" && \
	    /bin/echo -n "$(DESCRIPTION_$(shell echo $(LANGUAGE) | tr [:lower:] [:upper:]))"  | sed -e 's/"/\\\\\\"/g' && \
	    /bin/echo -n "\\\"\\\n")) | sed -e 's/ desc_/desc_/g' >> $@
# TODO: aarch64 and noarch need
	@echo arch=\"x86_64\" >> $@
	@echo maintainer=\"$(call get_github_maintainer_name,$(MAINTAINER))\" >> $@
ifeq ($(strip $(MAINTAINER_URL)),)
	@echo maintainer_url=\"$(call get_github_maintainer_url,$(MAINTAINER))\" >> $@
else
	@echo maintainer_url=\"$(MAINTAINER_URL)\" >> $@
endif
	@echo distributor=\"$(DISTRIBUTOR)\" >> $@
	@echo distributor_url=\"$(DISTRIBUTOR_URL)\" >> $@
ifeq ($(call version_lt, ${TC_OS_MIN_VER}, 6.1)$(call version_ge, ${TC_OS_MIN_VER}, 3.0),11)
	@echo firmware=\"$(OS_MIN_VER)\" >> $@
else
# TODO: 需要动态设置最小系统版本
	@echo os_min_version=\"1.1.8\" >> $@
ifneq ($(strip $(OS_MAX_VER)),)
	@echo os_max_version=\"$(OS_MAX_VER)\" >> $@
endif
endif
ifneq ($(strip $(BETA)),)
	@echo beta=\"yes\" >> $@
	@echo report_url=\"$(REPORT_URL)\" >> $@
endif
ifneq ($(strip $(HELPURL)),)
	@echo helpurl=\"$(HELPURL)\" >> $@
else
ifneq ($(strip $(HOMEPAGE)),)
	@echo helpurl=\"$(HOMEPAGE)\" >> $@
endif
endif
ifneq ($(strip $(SUPPORTURL)),)
	@echo support_url=\"$(SUPPORTURL)\" >> $@
endif
ifneq ($(strip $(INSTALL_DEP_SERVICES)),)
	@echo install_dep_services=\"$(INSTALL_DEP_SERVICES)\" >> $@
endif
ifneq ($(strip $(START_DEP_SERVICES)),)
	@echo start_dep_services=\"$(START_DEP_SERVICES)\" >> $@
endif
ifneq ($(strip $(INSTUNINST_RESTART_SERVICES)),)
	@echo instuninst_restart_services=\"$(INSTUNINST_RESTART_SERVICES)\" >> $@
endif
ifneq ($(strip $(INSTALL_REPLACE_PACKAGES)),)
	@echo install_replace_packages=\"$(INSTALL_REPLACE_PACKAGES)\" >> $@
endif
ifneq ($(strip $(USE_DEPRECATED_REPLACE_MECHANISM)),)
	@echo use_deprecated_replace_mechanism=\"$(USE_DEPRECATED_REPLACE_MECHANISM)\" >> $@
endif
ifneq ($(strip $(CHECKPORT)),)
	@echo checkport=\"$(CHECKPORT)\" >> $@
endif

# for non startable (i.e. non service, cli tools only)
# as default is 'yes' we only add this value for 'no'
ifeq ($(STARTABLE),false)
	@echo ctl_stop=\"$(STARTABLE)\" >> $@
endif

ifneq ($(strip $(DISPLAY_NAME)),)
	@echo display_name=\"$(DISPLAY_NAME)\" >> $@
endif
ifneq ($(strip $(FNOS_UI_DIR)),)
	@[ -d $(STAGING_DIR)/$(FNOS_UI_DIR) ] && echo desktop_uidir=\"$(FNOS_UI_DIR)\" >> $@ || true
endif
ifneq ($(strip $(FNOS_APP_NAME)),)
	@echo appname=\"$(FNOS_APP_NAME)\" >> $@
else
	@echo appname=\"com.fnoscomm.pkgs.$(FPK_NAME)\" >> $@
endif
ifeq ($(call version_ge, ${TCVERSION}, 7.0),1)
ifneq ($(strip $(FNOS_APP_PAGE)),)
	@echo dsmapppage=\"$(FNOS_APP_PAGE)\" >> $@
endif
ifneq ($(strip $(FNOS_APP_LAUNCH_NAME)),)
	@echo dsmapplaunchname=\"$(FNOS_APP_LAUNCH_NAME)\" >> $@
endif
endif
ifneq ($(strip $(ADMIN_PROTOCOL)),)
	@echo adminprotocol=\"$(ADMIN_PROTOCOL)\" >> $@
endif
ifneq ($(strip $(ADMIN_PORT)),)
	@echo service_port=\"$(ADMIN_PORT)\" >> $@
endif
ifneq ($(strip $(ADMIN_URL)),)
	@echo adminurl=\"$(ADMIN_URL)\" >> $@
endif
ifneq ($(strip $(CHANGELOG)),)
	@echo changelog=\"$(CHANGELOG)\" >> $@
endif
ifneq ($(strip $(FPK_DEPENDS)),)
	@echo install_dep_apps=\"$(FPK_DEPENDS)\" >> $@
endif
ifneq ($(strip $(CONF_DIR)),)
	@echo support_conf_folder=\"yes\" >> $@
endif
ifneq ($(strip $(FPK_CONFLICT)),)
	@echo install_conflict_packages=\"$(FPK_CONFLICT)\" >> $@
endif
	@echo checksum=\"$$(md5sum $(WORK_DIR)/app.tgz | cut -d" " -f1)\" >> $@
	@echo source=\"thirdparty\" >> $@
ifeq ($(ROOT_INSTALL),yes)
	@echo install_type=\"root\" >> $@
endif
ifneq ($(strip $(APPSTORE_ENTRY)),)
	@echo desktop_applaunchname=\"$(APPSTORE_ENTRY)\" >> $@
endif
ifeq ($(ROOT_INSTALL),yes)
	@echo install_type=\"root\" >> $@
endif
ifeq ($(DISABLE_AUTHORIZATION_PATH),true)
	@echo disable_authorization_path=\"true\" >> $@
endif

ifneq ($(strip $(DEBUG)),)
INSTALLER_OUTPUT = >> /root/$${PACKAGE}-$${SYNOPKG_PKG_STATUS}.log 2>&1
else
INSTALLER_OUTPUT = > $$TRIM_TEMP_LOGFILE
endif

# Wizard
FNOS_WIZARDS_DIR = $(WORK_DIR)/wizard

ifneq ($(strip $(WIZARDS_TEMPLATES_DIR)),)
WIZARDS_DIR = $(WORK_DIR)/generated-wizards
endif
ifneq ($(WIZARDS_DIR),)
# export working wizards dir to the shell for use later at compile-time
export SPKSRC_WIZARDS_DIR=$(WIZARDS_DIR)
endif

# License
FNOS_LICENSE_FILE = $(WORK_DIR)/LICENSE

FNOS_LICENSE =
ifneq ($(LICENSE_FILE),)
FNOS_LICENSE = $(FNOS_LICENSE_FILE)
endif

define fnos_resource_copy
$(create_target_dir)
$(MSG) "Creating $@"
cp $< $@
chmod 644 $@
endef

$(FNOS_LICENSE_FILE): $(LICENSE_FILE)
	@echo $@
	@$(fnos_resource_copy)

### Packaging rules
$(WORK_DIR)/app.tgz: icon service
	$(create_target_dir)
	@[ -f $@ ] && rm $@ || true
	(cd $(STAGING_DIR) && find . -mindepth 1 -maxdepth 1 -not -empty | tar cpzf $@ --owner=root --group=root --files-from=/dev/stdin)

FNOS_CMDS = $(addprefix $(FNOS_CMD_DIR)/,$(FNOS_SCRIPT_FILES))

define fnos_script_redirect
$(create_target_dir)
$(MSG) "Creating $@"
echo '#!/bin/bash' > $@
echo '. $$(dirname $$0)/installer' >> $@
echo '$$(basename $$0) $(INSTALLER_OUTPUT)' >> $@
chmod 755 $@
endef

define fnos_cmd_copy
$(create_target_dir)
$(MSG) "Creating $@"
cp $< $@
chmod 755 $@
endef

$(FNOS_CMD_DIR)/install_init:
	@$(fnos_script_redirect)
$(FNOS_CMD_DIR)/install_callback:
	@$(fnos_script_redirect)
$(FNOS_CMD_DIR)/uninstall_init:
	@$(fnos_script_redirect)
$(FNOS_CMD_DIR)/uninstall_callback:
	@$(fnos_script_redirect)
$(FNOS_CMD_DIR)/upgrade_init:
	@$(fnos_script_redirect)
$(FNOS_CMD_DIR)/upgrade_callback:
	@$(fnos_script_redirect)
$(FNOS_CMD_DIR)/config_init:
	@$(fnos_script_redirect)
$(FNOS_CMD_DIR)/config_callback:
	@$(fnos_script_redirect)

# Package Icons
.PHONY: icons
icons:
ifneq ($(strip $(FPK_ICON)),)
	$(create_target_dir)
	@$(MSG) "Creating ICON.PNG for $(FPK_NAME)"
ifneq ($(call version_ge, ${TCVERSION}, 7.0),1)
	(convert $(FPK_ICON) -resize 72x72 -strip -sharpen 0x2 - > $(WORK_DIR)/ICON.PNG)
else
	(convert $(FPK_ICON) -resize 64x64 -strip -sharpen 0x2 - > $(WORK_DIR)/ICON.PNG)
endif
	@$(MSG) "Creating ICON_256.PNG for $(FPK_NAME)"
	(convert $(FPK_ICON) -resize 256x256 -strip -sharpen 0x2 - > $(WORK_DIR)/ICON_256.PNG)
	$(eval FPK_CONTENT += ICON.PNG ICON_256.PNG)
endif

.PHONY: info-checksum
info-checksum:
	@$(MSG) "Creating checksum for $(FPK_NAME)"
	@sed -i -e "s|checksum=\".*|checksum=\"$$(md5sum $(WORK_DIR)/app.tgz | cut -d" " -f1)\"|g" $(WORK_DIR)/manifest


# file names to be used with "find" command
WIZARD_FILE_NAMES  =     -name "install" 
WIZARD_FILE_NAMES += -or -name "install_???" 
WIZARD_FILE_NAMES += -or -name "install.sh"
WIZARD_FILE_NAMES += -or -name "install_???.sh"
WIZARD_FILE_NAMES += -or -name "upgrade"
WIZARD_FILE_NAMES += -or -name "upgrade_???"
WIZARD_FILE_NAMES += -or -name "upgrade.sh"
WIZARD_FILE_NAMES += -or -name "upgrade_???.sh"
WIZARD_FILE_NAMES += -or -name "uninstall"
WIZARD_FILE_NAMES += -or -name "uninstall_???"
WIZARD_FILE_NAMES += -or -name "uninstall.sh"
WIZARD_FILE_NAMES += -or -name "uninstall_???.sh"
WIZARD_FILE_NAMES += -or -name "config"
WIZARD_FILE_NAMES += -or -name "config_???"
WIZARD_FILE_NAMES += -or -name "config.sh"
WIZARD_FILE_NAMES += -or -name "config_???.sh"


.PHONY: wizards
wizards:
	@$(MSG) "Create default DSM7 uninstall wizard"
	@mkdir -p $(FNOS_WIZARDS_DIR)
	@find $(SPKSRC_MK)wizard -maxdepth 1 -type f -and \( -name "uninstall" -or -name "uninstall_???" \) -print -exec cp -f {} $(FNOS_WIZARDS_DIR) \;
ifeq ($(strip $(WIZARDS_DIR)),)
	$(eval FPK_CONTENT += wizard)
endif
ifneq ($(strip $(WIZARDS_TEMPLATES_DIR)),)
	@$(MSG) "Generate DSM Wizards from templates"
	@mkdir -p $(WIZARDS_DIR)
	$(eval IS_DSM_6_OR_GREATER = $(if $(filter 1,$(call version_ge, $(TCVERSION), 6.0)),true,false))
	$(eval IS_DSM_7_OR_GREATER = $(if $(filter 1,$(call version_ge, $(TCVERSION), 7.0)),true,false))
	$(eval IS_DSM_7 = $(IS_DSM_7_OR_GREATER))
	$(eval IS_DSM_6 = $(if $(filter true,$(IS_DSM_6_OR_GREATER)),$(if $(filter true,$(IS_DSM_7)),false,true),false))
	@for template in $(shell find $(WIZARDS_TEMPLATES_DIR) -maxdepth 1 -type f -and \( $(WIZARD_FILE_NAMES) \) -print); do \
		template_filename="$$(basename $${template})"; \
		template_name="$${template_filename%.*}"; \
		if [ "$${template_name}" = "$${template_filename}" ]; then \
			template_suffix=; \
		else \
			template_suffix=".$${template_filename##*.}"; \
		fi; \
		template_file_path="$(WIZARDS_TEMPLATES_DIR)/$${template_filename}"; \
		for suffix in '' $(patsubst %,_%,$(LANGUAGES)) ; do \
			template_file_localization_data_path="$(WIZARDS_TEMPLATES_DIR)/$${template_name}$${suffix}.yml"; \
			output_file="$(WIZARDS_DIR)/$${template_name}$${suffix}$${template_suffix}"; \
			if [ -f "$${template_file_localization_data_path}" ]; then \
				{ \
					echo "IS_DSM_6_OR_GREATER: $(IS_DSM_6_OR_GREATER)"; \
					echo "IS_DSM_6: $(IS_DSM_6)"; \
					echo "IS_DSM_7_OR_GREATER: $(IS_DSM_7_OR_GREATER)"; \
					echo "IS_DSM_7: $(IS_DSM_7)"; \
					cat "$${template_file_localization_data_path}"; \
				} | mustache - "$${template_file_path}" >"$${output_file}"; \
				if [ "$${template_suffix}" = "" ]; then \
					jq_failed=0; \
					errors=$$(jq . "$${output_file}" 2>&1) || jq_failed=1; \
					if [ "$${jq_failed}" != "0" ]; then \
						echo "Invalid wizard file generated $${output_file}:"; \
						echo "$${errors}"; \
						exit 1; \
					fi; \
				fi; \
			fi; \
		done; \
	done
endif
ifneq ($(strip $(WIZARDS_DIR)),)
	@$(MSG) "Create DSM Wizards"
	$(eval FPK_CONTENT += wizard)
	@mkdir -p $(FNOS_WIZARDS_DIR)
	@find $${SPKSRC_WIZARDS_DIR} -maxdepth 1 -type f -and \( $(WIZARD_FILE_NAMES) \) -print -exec cp -f {} $(FNOS_WIZARDS_DIR) \;
	@if [ -f "$(FNOS_WIZARDS_DIR)/uninstall.sh" ] && [ -f "$(FNOS_WIZARDS_DIR)/uninstall" ]; then \
		rm "$(FNOS_WIZARDS_DIR)/uninstall"; \
	fi
	@if [ -d "$(WIZARDS_DIR)$(TCVERSION)" ]; then \
	   $(MSG) "Create DSM Version specific Wizards: $(WIZARDS_DIR)$(TCVERSION)"; \
	   find $${SPKSRC_WIZARDS_DIR}$(TCVERSION) -maxdepth 1 -type f -and \( $(WIZARD_FILE_NAMES) \) -print -exec cp -f {} $(FNOS_WIZARDS_DIR) \; ;\
	fi
	@if [ -d "$(FNOS_WIZARDS_DIR)" ]; then \
	   find $(FNOS_WIZARDS_DIR) -maxdepth 1 -type f -not -name "*.sh" -print -exec chmod 0644 {} \; ;\
	   find $(FNOS_WIZARDS_DIR) -maxdepth 1 -type f -name "*.sh" -print -exec chmod 0755 {} \; ;\
	fi
endif

.PHONY: config
config:
ifneq ($(strip $(CONF_DIR)),)
	@$(MSG) "Preparing config"
	@mkdir -p $(FNOS_CONFIG_DIR)
	@find $(FPK_CONF_DIR) -maxdepth 1 -type f -print -exec cp -f {} $(FNOS_CONFIG_DIR) \;
	@find $(FNOS_CONFIG_DIR) -maxdepth 1 -type f -print -exec chmod 0644 {} \;
ifneq ($(findstring config,$(FPK_CONTENT)),config)
FPK_CONTENT += config
endif
endif

ifneq ($(strip $(FNOS_LICENSE)),)
FPK_CONTENT += LICENSE
endif

$(FPK_FILE_NAME): $(WORK_DIR)/app.tgz $(WORK_DIR)/manifest info-checksum icons service $(FNOS_CMDS) wizards $(FNOS_LICENSE) config
	$(create_target_dir)
	(cd $(WORK_DIR) && tar czpf $@ --group=root --owner=root $(FPK_CONTENT))

package: $(FPK_FILE_NAME)

all: package


### fpk-specific clean rules

# Remove work-*/<pkgname>* directories while keeping
# work-*/.<pkgname>*|<pkgname>.plist status files
# This is in order to resolve: 
#    System.IO.IOException: No space left on device
# when building online thru github-action, in particular
# for "packages-to-keep" such as python* and ffmpeg*
clean-source: SHELL:=/bin/bash
clean-source: fpkclean
	@make --no-print-directory dependency-flat | sort -u | grep cross/ | while read depend ; do \
	   makefile="../../$${depend}/Makefile" ; \
	   pkgdirstr=$$(grep ^PKG_DIR $${makefile} || true) ; \
	   pkgdir=$$(echo $${pkgdirstr#*=} | cut -f1 -d- | sed -s 's/[\)]/ /g' | sed -s 's/[\$$\(\)]//g' | cut -f1 -d' ' | xargs) ; \
	   if [ ! "$${pkgdirstr}" ]; then \
	      continue ; \
	   elif echo "$${pkgdir}" | grep -Eq '^(PKG_|DIST)'; then \
	      pkgdirstr=$$(grep ^$${pkgdir} $${makefile}) ; \
	      pkgdir=$$(echo $${pkgdirstr#*=} | xargs) ; \
	   fi ; \
	   #echo "depend: [$${depend}] - pkgdir: [$${pkgdir}]" ; \
	   find work-*/$${pkgdir}[-_]* -maxdepth 0 -type d 2>/dev/null | while read sourcedir ; do \
	      echo "rm -fr $$sourcedir" ; \
	      find $${sourcedir}/. -mindepth 1 -maxdepth 2 -exec rm -fr {} \; 2>/dev/null || true ; \
	   done ; \
	done

fpkclean:
	rm -fr work-*/.copy_done \
	       work-*/.depend_done \
	       work-*/.icon_done \
	       work-*/.strip_done \
	       work-*/.wheel_done \
	       work-*/config \
	       work-*/cmd \
	       work-*/staging \
	       work-*/tc_vars.mk \
	       work-*/tc_vars.cmake \
	       work-*/tc_vars.meson-* \
	       work-*/app.tgz \
	       work-*/manifest \
	       work-*/PLIST \
	       work-*/PACKAGE_ICON* \
	       work-*/wizard

wheelclean: fpkclean
	rm -fr work*/.wheel_done \
	       work*/.wheel_*_done \
	       work-*/wheelhouse \
	       work-*/install/var/apps/**/target/share/wheelhouse
	@make --no-print-directory dependency-flat | sort -u | grep '\(cross\|python\)/' | while read depend ; do \
	   makefile="../../$${depend}/Makefile" ; \
	   if grep -q 'fpksrc\.python-wheel\(-meson\)\?\.mk' $${makefile} ; then \
	      pkgstr=$$(grep ^PKG_NAME $${makefile}) ; \
	      pkgname=$$(echo $${pkgstr#*=} | xargs) ; \
	      echo "rm -fr work-*/$${pkgname}*\\n       work-*/.$${pkgname}-*" ; \
	      rm -fr work-*/$${pkgname}* \
                     work-*/.$${pkgname}-* ; \
	   fi ; \
	done

wheelclean-%: fpkclean
	rm -f work-*/.wheel_done \
	      work-*/wheelhouse/$*-*.whl
	find work-* -type f -regex '.*\.wheel_\(download\|compile\|install\)-$*_done' -exec rm -f {} \;

wheelcleancache:
	rm -fr work-*/pip

wheelcleanall: wheelcleancache wheelclean
	rm -fr ../../distrib/pip

crossenvclean: wheelclean
	rm -fr work-*/crossenv*
	rm -fr work-*/.crossenv-*_done

crossenvcleanall: wheelcleanall crossenvclean

pythonclean: wheelcleanall
	rm -fr work-*/.[Pp]ython*-install_done \
	rm -fr work-*/crossenv

pythoncleanall: pythonclean
	rm -fr work-*/[Pp]ython* work-*/.python*

### For managing make all-<supported|latest>
include ../../mk/fpksrc.supported.mk

### For managing make publish-all-<supported|latest>
include ../../mk/fpksrc.publish.mk

###
