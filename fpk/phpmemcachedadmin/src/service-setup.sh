
# Package
SC_DNAME="PHPMemcachedAdmin"
SC_PKG_PREFIX="com-FnOScommunity-packages-"
SC_PKG_NAME="${SC_PKG_PREFIX}${SYNOPKG_PKGNAME}"
SVC_KEEP_LOG=y
SVC_BACKGROUND=y
SVC_WRITE_PID=y

# Others
if [ "${TRIM_SYS_VERSION_MAJOR}" -ge 7 ]; then
    WEB_DIR="/var/services/web_packages"
else
    WEB_DIR="/var/services/web"
    # DSM 6 file and process ownership
    WEB_USER="http"
    WEB_GROUP="http"
    # For owner of var folder
    GROUP="http"
fi
WEB_ROOT="${WEB_DIR}/${SYNOPKG_PKGNAME}"
CONFIG_DIR="${SYNOPKG_PKGVAR}/phpmemcachedadmin.config"
SYNOSVC="/usr/syno/sbin/synoservice"

service_postinst ()
{
   # Create config file on demand
   if [ ! -e "${CONFIG_DIR}/Memcache.php" ]; then
      echo "Create default config file Memcache.php"
      cp -f "${CONFIG_DIR}/Memcache.sample.php" "${CONFIG_DIR}/Memcache.php"
   fi
}

