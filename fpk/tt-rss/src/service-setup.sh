
# Package
PACKAGE="tt-rss"
SVC_KEEP_LOG=y
SVC_BACKGROUND=y
SVC_WRITE_PID=y

# Others
DSM6_WEB_DIR="/var/services/web"
if [ "${TRIM_SYS_VERSION_MAJOR}" -ge 7 ]; then
  WEB_DIR="/var/services/web_packages"
else
  WEB_DIR="${DSM6_WEB_DIR}"
fi
LOGS_DIR="${WEB_DIR}/${PACKAGE}/logs"

VERSION_FILE_DIRECTORY="var"
VERSION_FILE="${VERSION_FILE_DIRECTORY}/version.txt"

if [ "${TRIM_SYS_VERSION_MAJOR}" -ge 7 ]; then
    if [ "${TRIM_SYS_VERSION_MINOR}" -ge 2 ]; then
        PHP="/usr/local/bin/php82"
    else
        PHP="/usr/local/bin/php80"
    fi
else
    PHP="/usr/local/bin/php74"
fi
JQ="/bin/jq"
SYNOSVC="/usr/syno/sbin/synoservice"
MARIADB_10_INSTALL_DIRECTORY="/var/apps/MariaDB10"
MARIADB_10_BIN_DIRECTORY="${MARIADB_10_INSTALL_DIRECTORY}/target/usr/local/mariadb10/bin"
MYSQL="${MARIADB_10_BIN_DIRECTORY}/mysql"
MYSQLDUMP="${MARIADB_10_BIN_DIRECTORY}/mysqldump"
MYSQL_USER="ttrss"
MYSQL_DATABASE="ttrss"

exec_update_schema() {
  TTRSS="${WEB_DIR}/${PACKAGE}/update.php"
  "${PHP}" "${TTRSS}" --update-schema=force-yes
}

service_prestart ()
{
  TTRSS="${WEB_DIR}/${PACKAGE}/update.php"
  LOG_FILE="${LOGS_DIR}/daemon.log"
  "${PHP}" "${TTRSS}" --daemon >> "${LOG_FILE}" 2>&1 &
  echo "$!" > "${PID_FILE}"
}

service_postinst ()
{
  ${MKDIR} -p "${LOGS_DIR}"

  # Setup database and configuration file
  if [ "${SYNOPKG_PKG_STATUS}" = "INSTALL" ]; then
    single_user_mode=$([ "${wizard_single_user}" = "true" ] && echo "true" || echo "false")
    ${CP} "${WEB_DIR}/${PACKAGE}/config.php-dist" "${WEB_DIR}/${PACKAGE}/config.php"
    {
      echo "putenv('TTRSS_DB_TYPE=mysql');"
      echo "putenv('TTRSS_DB_HOST=localhost');"
      echo "putenv('TTRSS_DB_USER=${MYSQL_USER}');"
      echo "putenv('TTRSS_DB_NAME=${MYSQL_DATABASE}');"
      echo "putenv('TTRSS_DB_PASS=${wizard_mysql_password_ttrss}');"
      echo "putenv('TTRSS_SINGLE_USER_MODE=${single_user_mode}');"
      echo "putenv('TTRSS_SELF_URL_PATH=http://${wizard_domain_name}/${PACKAGE}/');"
      echo "putenv('TTRSS_PHP_EXECUTABLE=${PHP}');"
      echo "putenv('TTRSS_MYSQL_DB_SOCKET=/run/mysqld/mysqld10.sock');"
    } >>"${WEB_DIR}/${PACKAGE}/config.php"
    if [ "${TRIM_SYS_VERSION_MAJOR}" -ge 7 ]; then
      touch "${SYNOPKG_PKGVAR}/.dsm7_migrated"
    fi
  fi

  if [ "${SYNOPKG_PKG_STATUS}" = "INSTALL" ]; then
    exec_update_schema
  fi

  return 0
}

validate_preuninst ()
{
  if [ "${SYNOPKG_PKG_STATUS}" = "UNINSTALL" ]; then
    # Check database
    if ! ${MYSQL} -u root -p"${wizard_mysql_password_root}" -e quit > /dev/null 2>&1; then
      echo "Incorrect MySQL root password"
      exit 1
    fi

    # Check database export location
    if [ -n "${wizard_dbexport_path}" ]; then
      if [ -f "${wizard_dbexport_path}" ] || [ -e "${wizard_dbexport_path}/${MYSQL_DATABASE}.sql" ]; then
        echo "File ${wizard_dbexport_path}/${MYSQL_DATABASE}.sql already exists. Please remove or choose a different location"
        exit 1
      fi

      if [ -d "${wizard_dbexport_path}" ]; then
        if [ ! -w "${wizard_dbexport_path}" ]; then
          echo "Cannot write to ${wizard_dbexport_path}. Please choose a writable location"
          exit 1
        fi
      else
        parent_dir="$(dirname "${wizard_dbexport_path}")"
        if [ ! -w "${parent_dir}" ]; then
          echo "Cannot create ${wizard_dbexport_path}. Please choose a writable location"
          exit 1
        fi
      fi
    fi
  fi
}

service_preuninst ()
{
  # Export database
  if [ "${SYNOPKG_PKG_STATUS}" = "UNINSTALL" ]; then
    if [ -n "${wizard_dbexport_path}" ]; then
      ${MKDIR} -p "${wizard_dbexport_path}"
      ${MYSQLDUMP} -u root -p"${wizard_mysql_password_root}" "${MYSQL_DATABASE}" > "${wizard_dbexport_path}/${MYSQL_DATABASE}.sql"
    fi
  fi  
}

service_save ()
{
  SOURCE_WEB_DIR="${WEB_DIR}"
  if [ ! -f "${SYNOPKG_PKGVAR}/.dsm7_migrated" ]; then
    if [ "${TRIM_SYS_VERSION_MAJOR}" -ge 7 ]; then
      SOURCE_WEB_DIR="${DSM6_WEB_DIR}"
    fi
  fi
  # Save the configuration file
  ${MKDIR} "${SYNOPKG_TEMP_UPGRADE_FOLDER}/${PACKAGE}"
  ${CP} "${SOURCE_WEB_DIR}/${PACKAGE}/config.php" "${SYNOPKG_TEMP_UPGRADE_FOLDER}/${PACKAGE}/"

  ${MKDIR} "${SYNOPKG_TEMP_UPGRADE_FOLDER}/${PACKAGE}/feed-icons/"
  ${CP} "${SOURCE_WEB_DIR}/${PACKAGE}/feed-icons"/*.ico "${SYNOPKG_TEMP_UPGRADE_FOLDER}/${PACKAGE}/feed-icons/" 2>/dev/null

  ${CP} "${SOURCE_WEB_DIR}/${PACKAGE}/plugins.local" "${SYNOPKG_TEMP_UPGRADE_FOLDER}/${PACKAGE}/" 2>/dev/null
  ${CP} "${SOURCE_WEB_DIR}/${PACKAGE}/themes.local" "${SYNOPKG_TEMP_UPGRADE_FOLDER}/${PACKAGE}/" 2>/dev/null

  ${MKDIR} -p "${SYNOPKG_TEMP_UPGRADE_FOLDER}/${PACKAGE}/${VERSION_FILE_DIRECTORY}"
  echo "${SYNOPKG_OLD_PKGVER}" | sed -r "s/^.*-([0-9]+)$/\1/" >"${SYNOPKG_TEMP_UPGRADE_FOLDER}/${PACKAGE}/${VERSION_FILE}"

  ${MKDIR} -p "${SYNOPKG_TEMP_UPGRADE_FOLDER}/${PACKAGE}/cache/feed-icons/"
  ${CP} "${SOURCE_WEB_DIR}/${PACKAGE}/cache/feed-icons"/* "${SYNOPKG_TEMP_UPGRADE_FOLDER}/${PACKAGE}/cache/feed-icons/" 2>/dev/null

  return 0
}

service_restore ()
{
  if [ "${TRIM_SYS_VERSION_MAJOR}" -ge 7 ]; then
    touch "${SYNOPKG_PKGVAR}/.dsm7_migrated"
  fi
  # Restore the configuration file
  ${CP} "${SYNOPKG_TEMP_UPGRADE_FOLDER}/${PACKAGE}/config.php" "${WEB_DIR}/${PACKAGE}/config.php"
  OLD_FPK_REV=$(cat "${SYNOPKG_TEMP_UPGRADE_FOLDER}/${PACKAGE}/${VERSION_FILE}")
  if [ "${OLD_FPK_REV}" -lt "14" ]; then
    # Parse old configuration and save to new config format
    sed -i -e "s|define('DB_TYPE', '\(.*\)');|putenv('TTRSS_DB_TYPE=\1');|" \
      -e "s|define('DB_HOST', '\(.*\)');|putenv('TTRSS_DB_HOST=\1');|" \
      -e "s|define('DB_USER', '\(.*\)');|putenv('TTRSS_DB_USER=\1');|" \
      -e "s|define('DB_NAME', '\(.*\)');|putenv('TTRSS_DB_NAME=\1');|" \
      -e "s|define('DB_PASS', '\(.*\)');|putenv('TTRSS_DB_PASS=\1');|" \
      -e "s|define('SINGLE_USER_MODE', \(.*\));|putenv('TTRSS_SINGLE_USER_MODE=\1');|" \
      -e "s|define('SELF_URL_PATH', '\(.*\)');|putenv('TTRSS_SELF_URL_PATH=\1');|" \
      -e "s|define('DB_PORT', '\(.*\)');|putenv('TTRSS_DB_PORT=\1');|" \
      -e "s|define('PHP_EXECUTABLE', \(.*\));||" \
      "${WEB_DIR}/${PACKAGE}/config.php"
    echo "putenv('TTRSS_PHP_EXECUTABLE=${PHP}');">>"${WEB_DIR}/${PACKAGE}/config.php"
  fi
  if [ "${OLD_FPK_REV}" -lt "15" ]; then
    sed -i -e "s|putenv('TTRSS_DB_PASS=.*');|putenv('TTRSS_DB_PASS=${wizard_mysql_password_ttrss}');|" \
      "${WEB_DIR}/${PACKAGE}/config.php"
    echo "putenv('TTRSS_MYSQL_DB_SOCKET=/run/mysqld/mysqld10.sock');">>"${WEB_DIR}/${PACKAGE}/config.php"
  fi
  if [ "${OLD_FPK_REV}" -lt "17" ]; then
    # Check config file for legacy PHP exec to migrate
    PHP_EXEC_LINE="putenv('TTRSS_PHP_EXECUTABLE=${PHP}');"
    SEARCH_PATTERN="^putenv('TTRSS_PHP_EXECUTABLE="
    sed -i "s|$SEARCH_PATTERN.*|$PHP_EXEC_LINE|" "${WEB_DIR}/${PACKAGE}/config.php"
    echo "Legacy PHP exec config migrated successfully."
  fi

  ${MV} "${SYNOPKG_TEMP_UPGRADE_FOLDER}/${PACKAGE}"/feed-icons/*.ico "${WEB_DIR}/${PACKAGE}"/feed-icons/ 2>/dev/null
  ${MV} "${SYNOPKG_TEMP_UPGRADE_FOLDER}/${PACKAGE}"/plugins.local/* "${WEB_DIR}/${PACKAGE}"/plugins.local/ 2>/dev/null
  ${MV} "${SYNOPKG_TEMP_UPGRADE_FOLDER}/${PACKAGE}"/themes.local/* "${WEB_DIR}/${PACKAGE}"/themes.local/ 2>/dev/null

  ${MKDIR} -p "${WEB_DIR}/${PACKAGE}/cache/feed-icons/"
  ${MV} "${SYNOPKG_TEMP_UPGRADE_FOLDER}/${PACKAGE}"/cache/feed-icons/* "${WEB_DIR}/${PACKAGE}"/cache/feed-icons/ 2>/dev/null

  exec_update_schema

  return 0
}
