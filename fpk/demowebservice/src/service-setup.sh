WEB_ROOT=/var/services/web_packages
WEB_DIR=${WEB_ROOT}/${SYNOPKG_PKGNAME}

service_postinst ()
{
    echo "Install the web app (${WEB_DIR})"

    if [ -d "${WEB_DIR}" ]; then
        if [ -n "${SHARE_NAME}" ]; then
            sed -e "s|@@shared_folder_name@@|${SHARE_NAME}|g" \
                -e "s|@@shared_folder_fullname@@|${SHARE_PATH}|g" \
                -i ${WEB_DIR}/index.php
        else
            echo "ERROR: SHARE_PATH is not defined"
        fi
    else
        echo "ERROR: ${WEB_DIR} does not exist"
    fi
}

