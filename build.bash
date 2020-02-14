#!/bin/bash

# Variables
version=0.1
device=
builddate=
updaterDate=
releasetype=unofficial
RomName=lineage
RomVers=17.1
fileName=

cleanMka(){
        cd ~/android/lineage/17.1

        if ! mka clean ; then
                make clean
        fi
}

setupEnv() {
        cd ~/android/lineage/17.1

        # Setup build environment
        source build/envsetup.sh

        # export vars
        if [ "$releasetype" == "release" ] ; then
                export RELEASE_TYPE=RELEASE
        elif [ "$releasetype" == "experimental" ] ; then
                export RELEASE_TYPE=SNAPSHOT
        else
                exit
        fi
        export LC_ALL=C builddate=$(date --date="4 hours ago" -u +%Y%m%d)

        export USE_CCACHE=0 CCACHE_DISABLE=1 ANDROID_JACK_VM_ARGS="-Dfile.encoding=UTF-8 -XX:+TieredCompilation -Xmx8G" LC_ALL=C fileName=$RomName-$RomVers-$builddate-$releasetype-$device
}

buildDevice() {
        cd ~/android/lineage/17.1

        # Breakfast
        if ! breakfast lineage_$device-userdebug ; then
                echo "Error: Breakfast failed for lineage_$device-user"
                exit
        fi

        # Run build
        if ! mka target-files-package otatools ; then
                echo "Error: Make failed"
                echo "Revert last change and try again."
                exit
        fi

        # Sign Build
        if ! ./build/tools/releasetools/sign_target_files_apks -o -d ~/.android-certs --avb_vbmeta_key ~/android/graphene/10/keys/sargo/avb.pem --avb_vbmeta_algorithm SHA256_RSA2048 --avb_system_key ~/android/graphene/10/keys/sargo/avb.pem --avb_system_algorithm SHA256_RSA2048 $OUT/obj/PACKAGING/target_files_intermediates/*-target_files-*.zip signed-target_files.zip ; then
                echo "Error: Signing failed, again. Exiting..."
                exit
        fi

        # Package Full OTA
        if ! ./build/tools/releasetools/ota_from_target_files -k ~/.android-certs/releasekey --block --retrofit_dynamic_partitions signed-target_files.zip signed-ota_update.zip ; then
                echo "Error: Creating Full OTA failed"
                exit
        fi
}

saveFiles() {
        cd ~/android/lineage/17.1

        # Save Recovery (and boot)
        echo "Saving Recovery, Boot, and System Images"
        ./build/tools/releasetools/img_from_target_files signed-target_files.zip /mnt/share/img/$fileName.zip

        # Save target_files
        echo "Saving Build Files"
        mv signed-target_files.zip /mnt/share/target_files/$fileName.zip

        # Save OTA files
        echo "Saving OTA update"
        mv signed-ota_update.zip /mnt/share/full/$fileName.zip

        # UPDATER SCRIPT
        echo ./addrom.py --filename $fileName --device $device --version $RomVers --romtype $releasetype --md5sum $(md5sum /mnt/share/full/$filename.zip | awk '{ print $1 }') --romsize $(ls -l /mnt/share/full/$filename.zip | awk '{ print $5 }') --url "https://updater.ceruleanfire.com/builds/full/$filename.zip" --datetime $(date --date="$builddate" +%s) >> /mnt/share/update
}

## Enter main()
# supported devices
if [ "$1" == "bonito" ] ; then
        export device=bonito
elif [ "$1" == "oneplus3" ] ; then
        export device=oneplus3
elif [ "$1" == "sargo" ] ; then
        export device=sargo
else
        echo "Device " $1 " is currently not supported"
        echo "please enter a supported device and try again"
fi

cd ~/android/lineage/17.1

# run build
setupEnv
buildDevice
saveFiles

# cleanup
cleanMka

