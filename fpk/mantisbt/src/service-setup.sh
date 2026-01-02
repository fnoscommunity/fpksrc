
# Package
SC_DNAME="MantisBT"
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
CFG_FILE="${WEB_ROOT}/config/config_inc.php"

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
    RESOURCE_FILE="${SYNOPKG_PKGDEST}/web/mantisbt.json"
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
        if [ "${wizard_mantisbt_restore}" = "true" ] && [ -n "${wizard_backup_file}" ]; then
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
        if [ "${wizard_mantisbt_restore}" = "true" ]; then
            echo "The backup file is valid, performing restore"
            # Extract archive to temp folder
            TEMPDIR="${SYNOPKG_PKGTMP}/${SYNOPKG_PKGNAME}"
            ${MKDIR} "${TEMPDIR}"
            tar -xzf "${wizard_backup_file}" -C "${TEMPDIR}" 2>&1
            # Restore configuration
            echo "Restoring configuration to ${WEB_DIR}/config"
            # Restore the configuration file
            rsync -aX -I "${TEMPDIR}/config/config_inc.php" "${WEB_ROOT}/config/" 2>&1
            # Restore custom files
            for file in "${TEMPDIR}/config"/custom*
            do
                if [ -f "$file" ]; then
                    rsync -aX -I "$file" "${WEB_ROOT}/config/" 2>&1
                fi
            done

            # Update database password
            MARIADB_PASSWORD_ESCAPED=$(printf '%s' "${wizard_mysql_password_mantisbt}" | sed 's/[&/\]/\\&/g')
            sed -i "s|\(\$g_db_password[ \t]*=[ \t]*'\)[^']*\(';\)|\1${MARIADB_PASSWORD_ESCAPED}\2|" "${CFG_FILE}"

            # Restore the Database
            echo "Restoring database to ${MYSQL_DATABASE}"
            ${MYSQL} -u root -p"${wizard_mysql_password_root}" "${MYSQL_DATABASE}" < "${TEMPDIR}/database/${MYSQL_DATABASE}-dbbackup.sql" 2>&1

            # Run update scripts
            sed -i -e "s/gpc_get_int( 'install', 0 );/gpc_get_int( 'install', 2 );/g" "${WEB_ROOT}/admin/install.php"
            exec_php "${WEB_ROOT}/admin/install.php" > /dev/null

            # Remove admin directory
            ${RM} "${WEB_ROOT}/admin"

            # Clean-up temporary files
            ${RM} "${TEMPDIR}"
        else
            # Install config file
            rsync -aX -I "${SYNOPKG_PKGDEST}/web/config_inc.php" "${CFG_FILE}" 2>&1

            # Setup configuration file
            MARIADB_PASSWORD_ESCAPED=$(printf '%s' "${wizard_mysql_password_mantisbt}" | sed 's/[&/\]/\\&/g')
            sed -i -e "s/@password@/${MARIADB_PASSWORD_ESCAPED:=mantisbt}/g" "${CFG_FILE}"
            RAND_STR=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | head -c 64)
            sed -i -e "s/@rand_str@/${RAND_STR}/g" "${CFG_FILE}"
            sed -i -e "s#@web_url@#${wizard_install_url}#g" "${CFG_FILE}"
            
            # Install/upgrade database
            echo "Run ${SC_DNAME} installer"
            sed -i -e "s/gpc_get_int( 'install', 0 );/gpc_get_int( 'install', 2 );/g" "${WEB_ROOT}/admin/install.php"
            exec_php "${WEB_ROOT}/admin/install.php" > /dev/null

            # Remove admin directory
            ${RM} "${WEB_ROOT}/admin"
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
        if [ -f "${WEB_ROOT}/core/constant_inc.php" ]; then
            MANTIS_VER=$(sed -n "s|define[ \t]*([ \t]*'MANTIS_VERSION'[ \t]*,[ \t]*'\(.*\)'[ \t]*);|\1|p" "${WEB_ROOT}/core/constant_inc.php" | xargs)
        fi
        TEMPDIR="${SYNOPKG_PKGTMP}/${SYNOPKG_PKGNAME}_backup_v${MANTIS_VER}_$(date +"%Y%m%d")"
        ${MKDIR} "${TEMPDIR}"

        # Backup the configuration file
        echo "Copying previous configuration and data from ${WEB_ROOT}/config"
        ${MKDIR} "${TEMPDIR}/config"
        rsync -aX "${WEB_ROOT}/config/config_inc.php" "${TEMPDIR}/config/" 2>&1

        # Backup custom files
        for file in "${WEB_ROOT}/config"/custom*
        do
            if [ -f "$file" ]; then
                rsync -aX "$file" "${TEMPDIR}/config/" 2>&1
            fi
        done

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
    # Prepare temp folder
    [ -d "${SYNOPKG_TEMP_UPGRADE_FOLDER}/${SYNOPKG_PKGNAME}" ] && ${RM} "${SYNOPKG_TEMP_UPGRADE_FOLDER}/${SYNOPKG_PKGNAME}"
    ${MKDIR} "${SYNOPKG_TEMP_UPGRADE_FOLDER}/${SYNOPKG_PKGNAME}"
    
    # Save the configuration file
    rsync -aX "${WEB_ROOT}/config/config_inc.php" "${SYNOPKG_TEMP_UPGRADE_FOLDER}/${SYNOPKG_PKGNAME}/" 2>&1

    # Save custom files
    for file in "${WEB_ROOT}/config"/custom*
    do
        if [ -f "$file" ]; then
            rsync -aX "$file" "${SYNOPKG_TEMP_UPGRADE_FOLDER}/${SYNOPKG_PKGNAME}/" 2>&1
        fi
    done
}

service_restore ()
{
    # Restore the configuration file
    rsync -aX -I "${SYNOPKG_TEMP_UPGRADE_FOLDER}/${SYNOPKG_PKGNAME}/config_inc.php" "${WEB_ROOT}/config/" 2>&1

    # Restore custom files
    for file in "${SYNOPKG_TEMP_UPGRADE_FOLDER}/${SYNOPKG_PKGNAME}"/custom*
    do
        if [ -f "$file" ]; then
            rsync -aX -I "$file" "${WEB_ROOT}/config/" 2>&1
        fi
    done

    # Remove admin directory
    if [ -d "${WEB_ROOT}/admin" ]; then
        ${RM} "${WEB_ROOT}/admin"
    fi

    ${RM} "${SYNOPKG_TEMP_UPGRADE_FOLDER}/${SYNOPKG_PKGNAME}"
}
