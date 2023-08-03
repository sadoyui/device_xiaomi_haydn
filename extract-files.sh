#!/bin/bash
#
<<<<<<< HEAD
# Copyright (C) 2016 The CyanogenMod Project
# Copyright (C) 2017-2020 The LineageOS Project
=======
# Copyright (C) 2020 The LineageOS Project
>>>>>>> lineage-20
#
# SPDX-License-Identifier: Apache-2.0
#

<<<<<<< HEAD
set -e

# Load extract_utils and do some sanity checks
MY_DIR="${BASH_SOURCE%/*}"
if [[ ! -d "${MY_DIR}" ]]; then MY_DIR="${PWD}"; fi

ANDROID_ROOT="${MY_DIR}/../../.."

HELPER="${ANDROID_ROOT}/tools/extract-utils/extract_utils.sh"
if [ ! -f "${HELPER}" ]; then
    echo "Unable to find helper script at ${HELPER}"
    exit 1
fi
source "${HELPER}"

# Default to sanitizing the vendor folder before extraction
CLEAN_VENDOR=true

ONLY_COMMON=
ONLY_TARGET=
KANG=
SECTION=

while [ "${#}" -gt 0 ]; do
    case "${1}" in
        --only-common )
                ONLY_COMMON=true
                ;;
        --only-target )
                ONLY_TARGET=true
                ;;
        -n | --no-cleanup )
                CLEAN_VENDOR=false
                ;;
        -k | --kang )
                KANG="--kang"
                ;;
        -s | --section )
                SECTION="${2}"; shift
                CLEAN_VENDOR=false
                ;;
        * )
                SRC="${1}"
                ;;
    esac
    shift
done

if [ -z "${SRC}" ]; then
    SRC="adb"
fi

function blob_fixup() {
    case "${1}" in
        system_ext/lib64/libwfdnative.so)
            "${PATCHELF}" --remove-needed "android.hidl.base@1.0.so" "${2}"
            ;;
        vendor/etc/media_lahaina/video_system_specs.json \
        |vendor/etc/media_shima_v1/video_system_specs.json \
        |vendor/etc/media_yupik_v1/video_system_specs.json)
            sed -i "/max_retry_alloc_output_timeout/ s/10000/0/" "${2}"
            ;;
        vendor/etc/vintf/manifest/c2_manifest_vendor.xml)
            sed -ni '/ozoaudio/!p' "${2}"
            sed -ni '/dolby/!p' "${2}"
            ;;
        vendor/lib64/android.hardware.secure_element@1.0-impl.so)
            "${PATCHELF}" --remove-needed "android.hidl.base@1.0.so" "${2}"
=======
function blob_fixup() {
    case "${1}" in
        vendor/etc/camera/pureShot_parameter.xml)
            sed -i 's/=\([0-9]\+\)>/="\1">/g' "${2}"
            ;;
        vendor/lib64/hw/camera.qcom.so)
            sed -i "s/\x73\x74\x5F\x6C\x69\x63\x65\x6E\x73\x65\x2E\x6C\x69\x63/\x63\x61\x6D\x65\x72\x61\x5F\x63\x6E\x66\x2E\x74\x78\x74/g" "${2}"
            ;;
        vendor/lib64/hw/camera.xiaomi.so)
            "${SIGSCAN}" -p "52 07 00 94" -P "1F 20 03 D5" -f "${2}"
            ;;
        vendor/lib64/vendor.xiaomi.hardware.cameraperf@1.0-impl.so)
            "${SIGSCAN}" -p "21 00 80 52 7c 00 00 94" -P "21 00 80 52 1F 20 03 D5" -f "${2}"
>>>>>>> lineage-20
            ;;
    esac
}

<<<<<<< HEAD
if [ -z "${ONLY_TARGET}" ]; then
    # Initialize the helper for common device
    setup_vendor "${DEVICE_COMMON}" "${VENDOR}" "${ANDROID_ROOT}" true "${CLEAN_VENDOR}"

    extract "${MY_DIR}/proprietary-files.txt" "${SRC}" "${KANG}" --section "${SECTION}"
fi

if [ -z "${ONLY_COMMON}" ] && [ -s "${MY_DIR}/../${DEVICE}/proprietary-files.txt" ]; then
    # Reinitialize the helper for device
    source "${MY_DIR}/../${DEVICE}/extract-files.sh"
    setup_vendor "${DEVICE}" "${VENDOR}" "${ANDROID_ROOT}" false "${CLEAN_VENDOR}"

    extract "${MY_DIR}/../${DEVICE}/proprietary-files.txt" "${SRC}" "${KANG}" --section "${SECTION}"
fi

"${MY_DIR}/setup-makefiles.sh"
=======
# If we're being sourced by the common script that we called,
# stop right here. No need to go down the rabbit hole.
if [ "${BASH_SOURCE[0]}" != "${0}" ]; then
    return
fi

set -e

# Required!
export DEVICE=haydn
export DEVICE_COMMON=sm8350-common
export VENDOR=xiaomi

"./../../${VENDOR}/${DEVICE_COMMON}/extract-files.sh" "$@"
>>>>>>> lineage-20
