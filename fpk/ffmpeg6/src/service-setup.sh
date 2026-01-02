# Package specific behaviors
# Sourced script by generic installer and start-stop-status scripts

KERNEL_MIN="4.4"
KERNEL_RUNNING=$(uname -r)
STATUS=$(printf '%s\n%s' "${KERNEL_MIN}" "${KERNEL_RUNNING}" | sort -VCr && echo $?)
FFMPEG_VER=$(printf %.1s "$SYNOPKG_PKGVER")
FFMPEG_DIR=/var/apps/ffmpeg${FFMPEG_VER}/target
iHD=${FFMPEG_DIR}/lib/iHD_drv_video.so

###
### Disable Intel iHD driver on older kernels
### $(uname -r) <= ${KERNEL}
###
disable_iHD ()
{
    if [ "${STATUS}" = "0" ]; then
       [ -s ${iHD} ] && mv ${iHD} ${iHD}-DISABLED 2>/dev/null
    fi
}

service_postinst ()
{
    disable_iHD
}

service_postupgrade ()
{
    disable_iHD
}
