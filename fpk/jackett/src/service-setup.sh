
PATH="${SYNOPKG_PKGDEST}/bin:${PATH}"
JACKETT="${SYNOPKG_PKGDEST}/share/jackett"
HOME_DIR="${SYNOPKG_PKGVAR}"

SERVICE_COMMAND="env HOME=${HOME_DIR} PATH=${PATH} ${JACKETT} --PIDFile ${PID_FILE}"
SVC_BACKGROUND=y

service_preupgrade ()
{
    if [ ${TRIM_SYS_VERSION_MAJOR} -ge 7 ]; then
        CONFIG_DIR="${HOME_DIR}/.config"
        LEGACY_CONFIG_DIR="${SYNOPKG_PKGDEST}/var/.config"
        # ensure user data is in @appdata folder
        if [ -d "${LEGACY_CONFIG_DIR}" ]; then
            if [ "$(realpath ${LEGACY_CONFIG_DIR})" != "$(realpath ${CONFIG_DIR})" ]; then
                echo "Move ${LEGACY_CONFIG_DIR} to ${CONFIG_DIR}"
                mv ${LEGACY_CONFIG_DIR} ${CONFIG_DIR} 2>&1
            fi
        fi
    fi
}
