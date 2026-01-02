
# Package
SC_DNAME="Wallabag"
SC_PKG_PREFIX="com-FnOScommunity-packages-"
SC_PKG_NAME="${SC_PKG_PREFIX}${SYNOPKG_PKGNAME}"

# Others
MYSQL="/usr/local/mariadb10/bin/mysql"
MYSQLDUMP="/usr/local/mariadb10/bin/mysqldump"
MYSQL_USER="${SYNOPKG_PKGNAME}"
MYSQL_DATABASE="${SYNOPKG_PKGNAME}"
if [ "${TRIM_SYS_VERSION_MAJOR}" -ge 7 ]; then
    WEB_DIR="/var/services/web_packages"
else
    WEB_DIR="/var/services/web"
    # DSM 6 file and process ownership
    WEB_USER="http"
    WEB_GROUP="http"
fi
WEB_ROOT="${WEB_DIR}/${SYNOPKG_PKGNAME}"
SYNOSVC="/usr/syno/sbin/synoservice"
CFG_FILE="${WEB_ROOT}/app/config/parameters.yml"
IDX_FILE="${WEB_ROOT}/index.php"

exec_php ()
{
    # Pick PHP by DSM version
    if [ "${TRIM_SYS_VERSION_MAJOR}" -ge 7 ]; then
        if [ "${TRIM_SYS_VERSION_MINOR}" -ge 2 ]; then
            PHP="/usr/local/bin/php82"
        else
            PHP="/usr/local/bin/php80"
        fi
    else
        PHP="/usr/local/bin/php74"
    fi
    # Fallback check (helpful if dependency not installed)
    if [ ! -x "$PHP" ]; then
        echo "Error: PHP binary not found or not executable: $PHP" >&2
        echo "Ensure the matching WebStation PHP package is installed/enabled." >&2
        return 1
    fi
    # Define the resource file
    RESOURCE_FILE="${SYNOPKG_PKGDEST}/web/wallabag.json"
    # Extract extensions and assign to variable
    if [ -f "$RESOURCE_FILE" ]; then
        PHP_SETTINGS=$(jq -r '.extensions | map("-d extension=" + . + ".so") | join(" ")' "$RESOURCE_FILE")
    else
        PHP_SETTINGS=""
    fi
    COMMAND="${PHP} ${PHP_SETTINGS} $*"
    $COMMAND
    return $?
}

validate_preinst ()
{
    if [ "${SYNOPKG_PKG_STATUS}" = "INSTALL" ]; then
        if ! ${MYSQL} -u root -p"${wizard_mysql_password_root}" -e quit > /dev/null 2>&1; then
            echo "Incorrect MariaDB 'root' password"
            exit 1
        fi
        if ${MYSQL} -u root -p"${wizard_mysql_password_root}" mysql -e "SELECT User FROM user" | grep ^"${MYSQL_USER}"$ > /dev/null 2>&1; then
            echo "MariaDB user '${MYSQL_USER}' already exists"
            exit 1
        fi
        if ${MYSQL} -u root -p"${wizard_mysql_password_root}" -e "SHOW DATABASES" | grep ^"${MYSQL_DATABASE}"$ > /dev/null 2>&1; then
            echo "MariaDB database '${MYSQL_DATABASE}' already exists"
            exit 1
        fi

        # Check for valid backup to restore
        if [ "${wizard_wallabag_restore}" = "true" ] && [ -n "${wizard_backup_file}" ]; then
            if [ ! -r "${wizard_backup_file}" ]; then
                echo "The backup file path specified is incorrect or not accessible"
                exit 1
            fi
            # Check backup file prefix
            filename=$(basename "${wizard_backup_file}")
            expected_prefix="${SYNOPKG_PKGNAME}_backup_v"
            
            if [ "${filename#"$expected_prefix"}" = "$filename" ]; then
                echo "The backup filename does not start with the expected prefix"
                exit 1
            fi
        fi
    fi
}

service_postinst ()
{
    if [ "${SYNOPKG_PKG_STATUS}" = "INSTALL" ]; then
        # Check restore action
        if [ "${wizard_wallabag_restore}" = "true" ]; then
            echo "The backup file is valid, performing restore"
            # Extract archive to temp folder
            TEMPDIR="${SYNOPKG_PKGTMP}/${SYNOPKG_PKGNAME}"
            ${MKDIR} "${TEMPDIR}"
            tar -xzf "${wizard_backup_file}" -C "${TEMPDIR}" 2>&1
            # Restore configuration and data
            echo "Restoring configuration and data to ${WEB_DIR}"
            rsync -aX -I "${TEMPDIR}/config/parameters.yml" "${CFG_FILE}" 2>&1
            if [ -f "${TEMPDIR}/config/index.php" ]; then
                rsync -aX -I "${TEMPDIR}/config/index.php" "${IDX_FILE}" 2>&1
            else
                # rebuild missing index file
                echo "Rebuilding index redirect file"
                rsync -aX -I "${SYNOPKG_PKGDEST}/web/index.php" "${IDX_FILE}" 2>&1
                DOMAIN_NAME=$(grep 'domain_name:' "${CFG_FILE}" | awk '{ print $2 }' | sed "s/'//g")
                sed -i -e "s|@protocol_and_domain_name@|${DOMAIN_NAME}|g" \
                    "${IDX_FILE}"
            fi
            if [ -d "${TEMPDIR}/images" ]; then
                rsync -aX -I "${TEMPDIR}/images" "${WEB_ROOT}/web/assets/" 2>&1
            fi

            # Update database password
            sed -i "s/^\(\s*database_password:\s*\).*\(\s*\)$/\1${wizard_mysql_database_password}\2/" "${CFG_FILE}"

            # Restore the Database
            echo "Restoring database to ${MYSQL_DATABASE}"
            ${MYSQL} -u root -p"${wizard_mysql_password_root}" "${MYSQL_DATABASE}" < "${TEMPDIR}/database/${MYSQL_DATABASE}-dbbackup.sql" 2>&1

            # migrate database
            if ! exec_php "${WEB_ROOT}/bin/console" doctrine:migrations:migrate --env=prod -n -vvv > "${WEB_ROOT}/migration.log" 2>&1; then
                echo "Unable to migrate database schema. Please check the log: ${WEB_ROOT}/migration.log"
                return
            fi

            # Clean-up temporary files
            ${RM} "${TEMPDIR}"
        else
            # install config files
            rsync -aX -I "${SYNOPKG_PKGDEST}/web/parameters.yml" "${CFG_FILE}" 2>&1
            rsync -aX -I "${SYNOPKG_PKGDEST}/web/index.php" "${IDX_FILE}" 2>&1

            # render properties
            sed -i -e "s|@database_password@|${wizard_mysql_database_password}|g" \
                -e "s|@database_name@|${MYSQL_DATABASE}|g" \
                -e "s|@protocol_and_domain_name@|${wizard_protocol_and_domain_name}/wallabag/web|g" \
                -e "s|@wallabag_secret@|$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | head -c 30 | head -n 1)|g" \
                "${CFG_FILE}"
            sed -i -e "s|@protocol_and_domain_name@|${wizard_protocol_and_domain_name}/wallabag/web|g" \
                "${IDX_FILE}"

            # install wallabag
            if ! exec_php "${WEB_ROOT}/bin/console" wallabag:install --env=prod --reset -n -vvv > "${WEB_ROOT}/install.log" 2>&1; then
                echo "Failed to install wallabag. Please check the log: ${WEB_ROOT}/install.log"
                return
            fi
        fi
    fi
}

validate_preuninst ()
{
    # Check database
    if [ "${SYNOPKG_PKG_STATUS}" = "UNINSTALL" ] && ! ${MYSQL} -u root -p"${wizard_mysql_password_root}" -e quit > /dev/null 2>&1; then
        echo "Incorrect MariaDB 'root' password"
        exit 1
    fi
    # Check export directory
    if [ "${SYNOPKG_PKG_STATUS}" = "UNINSTALL" ] && [ -n "${wizard_export_path}" ]; then
        if [ ! -d "${wizard_export_path}" ]; then
            echo "Error: Export directory ${wizard_export_path} does not exist"
            exit 1
        fi
        if [ ! -w "${wizard_export_path}" ]; then
            echo "Error: Unable to write to directory ${wizard_export_path}. Check permissions."
            exit 1
        fi
    fi
}

service_preuninst ()
{
    if [ "${SYNOPKG_PKG_STATUS}" = "UNINSTALL" ] && [ -n "${wizard_export_path}" ]; then
        # Prepare archive structure
        WALLABAG_VER=$(grep 'version:' "${WEB_ROOT}/app/config/wallabag.yml" | awk '{ print $2 }')
        TEMPDIR="${SYNOPKG_PKGTMP}/${SYNOPKG_PKGNAME}_backup_v${WALLABAG_VER}_$(date +"%Y%m%d")"
        ${MKDIR} "${TEMPDIR}"

        # Backup Directories
        echo "Copying previous configuration and data from ${WEB_ROOT}"
        ${MKDIR} "${TEMPDIR}/config"
        rsync -aX "${CFG_FILE}" "${TEMPDIR}/config/" 2>&1
        if [ -f "${IDX_FILE}" ]; then
            rsync -aX "${IDX_FILE}" "${TEMPDIR}/config/" 2>&1
        fi
        if [ -d "${WEB_ROOT}/web/assets/images" ]; then
            rsync -aX "${WEB_ROOT}/web/assets/images" "${TEMPDIR}/" 2>&1
        fi

        # Backup the Database
        echo "Copying previous database from ${MYSQL_DATABASE}"
        ${MKDIR} "${TEMPDIR}/database"
        ${MYSQLDUMP} -u root -p"${wizard_mysql_password_root}" "${MYSQL_DATABASE}" > "${TEMPDIR}/database/${MYSQL_DATABASE}-dbbackup.sql" 2>&1

        # Create backup archive
        archive_name="$(basename "$TEMPDIR").tar.gz"
        echo "Creating compressed archive of ${SC_DNAME} data in file $archive_name"
        tar -C "$TEMPDIR" -czf "${SYNOPKG_PKGTMP}/$archive_name" . 2>&1

        # Move archive to export directory
        RSYNC_BAK_ARGS="--backup --suffix=.bak"
        # shellcheck disable=SC2086  # RSYNC_BAK_ARGS is intentionally a multi-word arg list
        rsync -aX ${RSYNC_BAK_ARGS} "${SYNOPKG_PKGTMP}/$archive_name" "${wizard_export_path}/" 2>&1
        echo "Backup file copied successfully to ${wizard_export_path}"

        # Clean-up temporary files
        ${RM} "${TEMPDIR}"
        ${RM} "${SYNOPKG_PKGTMP}/$archive_name"
    fi
}

service_save ()
{
    # Save configuration and files
    [ -d "${SYNOPKG_TEMP_UPGRADE_FOLDER}/${SYNOPKG_PKGNAME}" ] && ${RM} "${SYNOPKG_TEMP_UPGRADE_FOLDER}/${SYNOPKG_PKGNAME}"
    ${MKDIR} "${SYNOPKG_TEMP_UPGRADE_FOLDER}/${SYNOPKG_PKGNAME}"
    rsync -aX "${CFG_FILE}" "${SYNOPKG_TEMP_UPGRADE_FOLDER}/${SYNOPKG_PKGNAME}/" 2>&1
    if [ -f "${IDX_FILE}" ]; then
        rsync -aX "${IDX_FILE}" "${SYNOPKG_TEMP_UPGRADE_FOLDER}/${SYNOPKG_PKGNAME}/" 2>&1
    fi
    if [ -d "${WEB_ROOT}/web/assets/images" ]; then
        rsync -aX "${WEB_ROOT}/web/assets/images" "${SYNOPKG_TEMP_UPGRADE_FOLDER}/${SYNOPKG_PKGNAME}/" 2>&1
    fi
}

service_restore ()
{
    # Restore configuration
    rsync -aX -I "${SYNOPKG_TEMP_UPGRADE_FOLDER}/${SYNOPKG_PKGNAME}/parameters.yml" "${CFG_FILE}" 2>&1
    if [ -f "${SYNOPKG_TEMP_UPGRADE_FOLDER}/${SYNOPKG_PKGNAME}/index.php" ]; then
        rsync -aX -I "${SYNOPKG_TEMP_UPGRADE_FOLDER}/${SYNOPKG_PKGNAME}/index.php" "${IDX_FILE}" 2>&1
    else
        # rebuild missing index file
        echo "Rebuilding index redirect file"
        rsync -aX -I "${SYNOPKG_PKGDEST}/web/index.php" "${IDX_FILE}" 2>&1
        DOMAIN_NAME=$(grep 'domain_name:' "${CFG_FILE}" | awk '{ print $2 }' | sed "s/'//g")
        sed -i -e "s|@protocol_and_domain_name@|${DOMAIN_NAME}|g" \
            "${IDX_FILE}"
    fi
    if [ -d "${SYNOPKG_TEMP_UPGRADE_FOLDER}/${SYNOPKG_PKGNAME}/images" ]; then
        rsync -aX -I "${SYNOPKG_TEMP_UPGRADE_FOLDER}/${SYNOPKG_PKGNAME}/images" "${WEB_ROOT}/web/assets/" 2>&1
    fi
    ${RM} "${SYNOPKG_TEMP_UPGRADE_FOLDER}/${SYNOPKG_PKGNAME}"

    # migrate database
    if ! exec_php "${WEB_ROOT}/bin/console" doctrine:migrations:migrate --env=prod -n -vvv > "${WEB_ROOT}/migration.log" 2>&1; then
        echo "Unable to migrate database schema. Please check the log: ${WEB_ROOT}/migration.log"
        return
    fi
}
