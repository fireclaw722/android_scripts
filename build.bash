#!/bin/bash

# Variables
export version=0.3.3 device buildDate updaterDate releaseType romName=lineage romVers=17.1 fileName

cleanMka(){
        cd ~/android/lineage/18.0

        if ! mka clean ; then
                make clean
        fi

        if ! mka clobber ; then
                make clobber
        fi
}

setupEnv() {
        cd ~/android/lineage/18.0

        # Setup build environment
        source build/envsetup.sh

        # Set buildtime and disable ccache
        export updaterDate=$(date --date="4 hours ago" -u +%s) buildDate=$(date --date="4 hours ago" -u +%Y%m%d) USE_CCACHE=0 CCACHE_DISABLE=1

        # Ubuntu 16.04+ fix
        export LC_ALL=C

        # Set Filename
        if [ "$releaseType" == "experimental" ] ; then
                export fileName=$romName-$romVers-$buildDate-$releaseType-$device
        else
                export fileName=$romName-$romVers-$buildDate-$releaseType-cerulean-$device
        fi
}

buildDevice() {
        cd ~/android/lineage/18.0

        # Breakfast
        #breakfast lineage_$device-user
        if [ "$device" == "victara" ] ; then
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
        if ! ./build/tools/releasetools/sign_target_files_apks -o -d ~/.android-certs --avb_vbmeta_key ~/.android-certs/avb.pem --avb_vbmeta_algorithm SHA256_RSA2048 --avb_system_key ~/.android-certs/avb.pem --avb_system_algorithm SHA256_RSA2048 $OUT/obj/PACKAGING/target_files_intermediates/*-target_files-*.zip signed-target_files.zip ; then
                echo "Error: Signing failed, again. Exiting..."
                exit
        fi

        # Package Full OTA
        if ! ./build/tools/releasetools/ota_from_target_files -k ~/.android-certs/releasekey --block --retrofit_dynamic_partitions signed-target_files.zip signed-ota_update.zip ; then
                echo "Error: Creating Full OTA failed"
                exit
        fi

        # Package Images zip
        if ! ./build/tools/releasetools/img_from_target_files signed-target_files.zip signed-images.zip ; then
                echo "Error: Exporting Recovery, Boot, and System Images failed"
                exit
        fi

        # also include the AVB Public key bin
        cp ~/.android-certs/avb_pkmd.bin ./
        zip signed-images.zip avb_pkmd.bin
        rm avb_pkmd.bin
}

saveFiles() {
        cd ~/android/lineage/18.0

        echo "Saving Recovery, Boot, and System Images"
        mv signed-images.zip ~/builds/img/$fileName.zip

        # Save target_files
        echo "Saving Build Files"
        mv signed-target_files.zip ~/builds/target_files/$fileName.zip

        # Save Full OTA
        echo "Saving OTA update"
        mv signed-ota_update.zip ~/builds/full/$fileName.zip

        # output updater info
        cd ~/simple_lineage_updater
        echo ./addrom.py --filename $fileName --device $device --version $romVers --romtype $releaseType --md5sum $(md5sum ~/builds/full/$fileName.zip | awk '{ print $1 }') --romsize $(ls -l ~/builds/full/$fileName.zip | awk '{ print $5 }') --url "https://updater.ceruleanfire.com/builds/full/$fileName.zip" --datetime $updaterDate >> ~/builds/update
        
        ./addrom.py --filename $fileName --device $device --version $romVers --romtype $releaseType --md5sum $(md5sum ~/builds/full/$fileName.zip | awk '{ print $1 }') --romsize $(ls -l ~/builds/full/$fileName.zip | awk '{ print $5 }') --url "https://updater.ceruleanfire.com/builds/full/$fileName.zip" --datetime $updaterDate
}

## Enter main()
# supported devices
if [ "$1" == "bonito" ] ; then
        export device=bonito
elif [ "$1" == "oneplus3" ] ; then
        export device=oneplus3
elif [ "$1" == "sargo" ] ; then
        export device=sargo
elif [ "$1" == "victara" ] ; then
        export device=victara
else
        echo "Device " $1 " is currently not supported"
        echo "please enter a supported device and try again"
        exit
fi

if [ "$2" == "experimental" ] ; then
        export LINEAGE_BUILDTYPE=SNAPSHOT releaseType=experimental
elif [ "$2" == "snapshot" ] ; then
        export LINEAGE_BUILDTYPE=SNAPSHOT LINEAGE_EXTRAVERSION=cerulean releaseType=snapshot
elif [ "$2" == "release" ] ; then
        if [ "$3" == "" ] ; then
                echo "Release build type requires TARGET_VENDOR_RELEASE_BUILD_ID to be set"
                echo "include vendor release id and try again"
                exit
        fi

        export LINEAGE_BUILDTYPE=RELEASE TARGET_VENDOR_RELEASE_BUILD_ID=$3 releaseType=release
else
        export LINEAGE_EXTRAVERSION=cerulean releaseType=unofficial
fi

cd ~/android/lineage/18.0

# run build
cleanMka
setupEnv
buildDevice
saveFiles

# cleanup
cleanMka
