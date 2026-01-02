
SOURCE_WEB_DIR=${SYNOPKG_PKGDEST}/web
HTACCESS_SOURCE_FILE=${SOURCE_WEB_DIR}/.htaccess

HTACCESS_TARGET_FILE=/var/services/web_packages/adminer/.htaccess

service_postinst ()
{
    # Edit .htaccess according to the wizard
    sed -e "s|@@_wizard_htaccess_allowed_from_@@|${wizard_htaccess_allowed_from}|g" -i ${HTACCESS_SOURCE_FILE}

    if [ ${TRIM_SYS_VERSION_MAJOR} -ge 7 ];then
        # Edit .htaccess according to the wizard
        sed -e "s|@@_wizard_htaccess_allowed_from_@@|${wizard_htaccess_allowed_from}|g" -i ${HTACCESS_TARGET_FILE}
    fi
}

service_postupgrade ()
{
    if [ ${TRIM_SYS_VERSION_MAJOR} -ge 7 ];then
        # Update .htaccess according to the wizard
        sed -e "s|@@_wizard_htaccess_allowed_from_@@|${wizard_htaccess_allowed_from}|g" -i ${HTACCESS_TARGET_FILE}
    fi
}
