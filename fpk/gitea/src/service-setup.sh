GITEA="${SYNOPKG_PKGDEST}/bin/gitea"
CFG_FILE="${SYNOPKG_PKGVAR}/conf.ini"
PATH="/var/apps/git/target/bin:${PATH}"

ENV="PATH=${PATH} HOME=${SYNOPKG_PKGHOME}"

SERVICE_COMMAND="env ${ENV} ${GITEA} web --port ${SERVICE_PORT} --pid ${PID_FILE}"
SVC_BACKGROUND=y

service_postinst ()
{
    if [ "${SYNOPKG_PKG_STATUS}" == "INSTALL" ]; then
        IP=$(ip route get 1 | awk '{print $(NF);exit}')

        sed -i -e "s|@share_path@|${SHARE_PATH}|g" ${CFG_FILE}
        sed -i -e "s|@ip_address@|${IP:=localhost}|g" ${CFG_FILE}
        sed -i -e "s|@service_port@|${SERVICE_PORT}|g" ${CFG_FILE}
    fi
}
