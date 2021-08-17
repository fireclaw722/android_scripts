#!/bin/bash

# Variables
export version=0.6.1 device buildDate updaterDate releaseType romName=lineage romVers fileName

cleanMka(){
        cd ~/android/$romName/$romVers

        if ! mka clean ; then
                make clean
        fi

        if ! mka clobber ; then
                make clobber
        fi
}

setupEnv() {
        cd ~/android/$romName/$romVers

        # Setup build environment
        source build/envsetup.sh

        # Set buildtime and disable ccache
        export updaterDate=$(date --date="4 hours ago" -u +%s) buildDate=$(date --date="4 hours ago" -u +%Y%m%d) USE_CCACHE=0 CCACHE_DISABLE=1

        # Ubuntu 16.04+ fix
        export LC_ALL=C

        # Set Filename
        if [[ "$releaseType" = "experimental" ]] ; then
                export fileName=$romName-$romVers-$buildDate-$releaseType-$device
        else
                export fileName=$romName-$romVers-$buildDate-$releaseType-cerulean-$device
        fi
}

buildDevice() {
        cd ~/android/$romName/$romVers

        # Breakfast
        #breakfast lineage_$device-user
        if [[ "$romVers" = "15.1" || "$romVers" = "16.0" || "$device" = "victara" ]] ; then
                breakfast lineage_$device-userdebug
        else
                breakfast lineage_$device-user
        fi

        # Run build
        if ! mka target-files-package otatools ; then
                echo "Error: Make failed"
                echo "Revert last change and try again."
                exit
        fi

        # Sign Build
        if ! sign_target_files_apks -o -d ~/.android-certs --avb_vbmeta_key ~/.android-certs/avb.pem --avb_vbmeta_algorithm SHA256_RSA2048 --avb_system_key ~/.android-certs/avb.pem --avb_system_algorithm SHA256_RSA2048 $OUT/obj/PACKAGING/target_files_intermediates/*-target_files-*.zip signed-target_files.zip ; then
                echo "Error: Signing failed, again. Exiting..."
                exit
        fi

        # Package Full OTA
        if ! ota_from_target_files -k ~/.android-certs/releasekey --block --retrofit_dynamic_partitions signed-target_files.zip signed-ota_update.zip ; then
                echo "Error: Creating Full OTA failed"
                exit
        fi

        # Package Images zip
        if ! img_from_target_files signed-target_files.zip signed-images.zip ; then
                echo "Error: Exporting Recovery, Boot, and System Images failed"
                exit
        fi

        # also include the AVB Public key bin
        cp ~/.android-certs/avb_pkmd.bin ./
        zip signed-images.zip avb_pkmd.bin
        rm avb_pkmd.bin
}

saveFiles() {
        cd ~/android/$romName/$romVers

        echo "Saving Recovery, Boot, and System Images"
        mv signed-images.zip ~/builds/img/$fileName.zip

        # Save target_files
        echo "Saving Build Files"
        mv signed-target_files.zip ~/builds/target_files/$fileName.zip

        # Save Full OTA
        echo "Saving OTA update"
        mv signed-ota_update.zip ~/builds/full/$fileName.zip

        # output updater info
        echo ./addrom.py --filename $fileName --device $device --version $romVers --romtype $releaseType --md5sum $(md5sum ~/builds/full/$fileName.zip | awk '{ print $1 }') --romsize $(ls -l ~/builds/full/$fileName.zip | awk '{ print $5 }') --url "https://updater.ceruleanfire.com/builds/full/$fileName.zip" --datetime $updaterDate >> ~/builds/update
}

## Enter main()
# supported devices
if [[ "$1" = "bonito" || "$1" = "oneplus3" || "$1" = "sargo" || "$1" = "victara" ]] ; then
        export device=$1
else
        echo "Device" $1 "is currently not supported"
        echo "please enter a supported device and try again"
        exit
fi

# supported lineage versions
if [[ "$2" = "18.1" ]] ; then
        export romVers=$2
else
        echo "Build version is required"
        echo "Supported versions include 18.1"
        exit
fi

# device per version
if [[ "$device" = "bonito" || "$device" = "oneplus3" || "$device" = "sargo" || "$device" = "victara" ]] ; then
        if ! [[ "$romVers" = "18.1" ]] ; then
                echo "Build Version isn't supported for this device"
                echo $device "only supports version 18.1"
                exit
        fi
fi

# supported build-types
if [[ "$3" = "experimental" || "$3" = "snapshot" || "$3" = "release" || "$3" = "unofficial" ]] ; then
        export releaseType=$3
else
        echo "Release Type is not supported"
        echo "Supported types are experimental | snapshot | release | unofficial"
        exit
fi

# extra build-type work
if [[ "$releaseType" = "experimental" ]] ; then
        export LINEAGE_BUILDTYPE=SNAPSHOT
elif [[ "$releaseType" = "snapshot" ]] ; then
        export LINEAGE_BUILDTYPE=SNAPSHOT LINEAGE_EXTRAVERSION=cerulean
elif [[ "$releaseType" = "release" ]] ; then
        if [[ "$4" = "" ]] ; then
                echo "Release build type requires TARGET_VENDOR_RELEASE_BUILD_ID to be set"
                echo "include vendor release id and try again"
                exit
        fi

        export LINEAGE_BUILDTYPE=RELEASE TARGET_VENDOR_RELEASE_BUILD_ID=$4 LINEAGE_EXTRAVERSION=cerulean
else
        export LINEAGE_EXTRAVERSION=cerulean
fi

cd ~/android/$romName/$romVers

# run build
cleanMka
setupEnv
buildDevice
saveFiles

# cleanup
cleanMka
