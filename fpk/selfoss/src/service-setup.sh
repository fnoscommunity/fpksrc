
# Selfoss service setup
WEB_DIR="/var/services/web_packages"
if [ -z "${SYNOPKG_PKGTMP}" ]; then
    SYNOPKG_PKGTMP="${SYNOPKG_PKGDEST_VOL}/@tmp"
fi

# Others
SELFOSS_ROOT="${WEB_DIR}/${SYNOPKG_PKGNAME}"
JQ="/bin/jq"
SYNOSVC="/usr/syno/sbin/synoservice"

service_save ()
{
    # Backup configuration and data
    [ -d "${SYNOPKG_TEMP_UPGRADE_FOLDER}/${SYNOPKG_PKGNAME}" ] && ${RM} "${SYNOPKG_TEMP_UPGRADE_FOLDER}/${SYNOPKG_PKGNAME}"
    echo "Backup existing distribution to ${SYNOPKG_TEMP_UPGRADE_FOLDER}/${SYNOPKG_PKGNAME}"
    ${MKDIR} "${SYNOPKG_TEMP_UPGRADE_FOLDER}/${SYNOPKG_PKGNAME}"
    rsync -aX "${SELFOSS_ROOT}/" "${SYNOPKG_TEMP_UPGRADE_FOLDER}/${SYNOPKG_PKGNAME}" 2>&1
}

service_restore ()
{
    # Restore data directory
    echo "Restore previous data directory from ${SYNOPKG_TEMP_UPGRADE_FOLDER}/${SYNOPKG_PKGNAME}/data"
    rsync -aX --update -I "${SYNOPKG_TEMP_UPGRADE_FOLDER}/${SYNOPKG_PKGNAME}/data" "${SELFOSS_ROOT}/" 2>&1

    # Restore the configuration file
    if [ -f "${SYNOPKG_TEMP_UPGRADE_FOLDER}/${SYNOPKG_PKGNAME}/config.ini" ]; then
        echo "Restore previous configuration from ${SYNOPKG_TEMP_UPGRADE_FOLDER}/${SYNOPKG_PKGNAME}"
        rsync -aX --update -I "${SYNOPKG_TEMP_UPGRADE_FOLDER}/${SYNOPKG_PKGNAME}/config.ini" "${SELFOSS_ROOT}/" 2>&1
    fi

    # Remove upgrade backup files
    ${RM} "${SYNOPKG_TEMP_UPGRADE_FOLDER}/${SYNOPKG_PKGNAME}"
}
