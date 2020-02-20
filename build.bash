#!/bin/bash

# Variables
export version=0.2 device buildDate updaterDate releaseType romName=lineage romVers=17.1 fileName

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

        # Set buildtime and disable ccache
        export updaterDate=updaterDate=$(date --date="4 hours ago" -u +%s) buildDate=$(date --date="4 hours ago" -u +%Y%m%d) USE_CCACHE=0 CCACHE_DISABLE=1

        # Ubuntu 16.04+ fix
        export LC_ALL=C

        # Set Filename
        export fileName=$romName-$romVers-$buildDate-$releaseType-$device
}

buildDevice() {
        cd ~/android/lineage/17.1

        # Breakfast
        if ! breakfast lineage_$device-userdebug ; then
                echo "Error: Breakfast failed for lineage_$device-userdebug"
                exit
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
        cd ~/android/lineage/17.1

        if [ –f /mnt/share/update ] ; then
                # Save all Images
                echo "Saving Recovery, Boot, and System Images"
                mv signed-images.zip /mnt/share/img/$fileName.zip

                # Save target_files
                echo "Saving Build Files"
                mv signed-target_files.zip /mnt/share/target_files/$fileName.zip

                # Save Full OTA
                echo "Saving OTA update"
                mv signed-ota_update.zip /mnt/share/full/$fileName.zip

                # output updater info
                echo ./addrom.py --filename $fileName --device $device --version $romVers --romtype $releaseType --md5sum $(md5sum /mnt/share/full/$fileName.zip | awk '{ print $1 }') --romsize $(ls -l /mnt/share/full/$fileName.zip | awk '{ print $5 }') --url "https://updater.ceruleanfire.com/builds/full/$fileName.zip" --datetime $updaterDate >> /mnt/share/update
        else
                if touch /mnt/share/update ; then
                        # Save all Images
                        echo "Saving Recovery, Boot, and System Images"
                        mv signed-images.zip /mnt/share/img/$fileName.zip

                        # Save target_files
                        echo "Saving Build Files"
                        mv signed-target_files.zip /mnt/share/target_files/$fileName.zip

                        # Save Full OTA
                        echo "Saving OTA update"
                        mv signed-ota_update.zip /mnt/share/full/$fileName.zip

                        # output updater info
                        echo ./addrom.py --filename $fileName --device $device --version $romVers --romtype $releaseType --md5sum $(md5sum /mnt/share/full/$fileName.zip | awk '{ print $1 }') --romsize $(ls -l /mnt/share/full/$fileName.zip | awk '{ print $5 }') --url "https://updater.ceruleanfire.com/builds/full/$fileName.zip" --datetime $updaterDate >> /mnt/share/update
                else
                        echo "Shared Directory isn't mounted"
                        echo "Saving to build folder instead"
                        echo ""
                        echo "Saving Recovery, Boot, and System Images"
                        mv signed-images.zip $fileName.zip

                        # Save target_files
                        echo "Saving Build Files"
                        mv signed-target_files.zip $fileName.zip

                        # Save Full OTA
                        echo "Saving OTA update"
                        mv signed-ota_update.zip $fileName.zip

                        # output updater info
                        echo ./addrom.py --filename $fileName --device $device --version $romVers --romtype $releaseType --md5sum $(md5sum /mnt/share/full/$fileName.zip | awk '{ print $1 }') --romsize $(ls -l /mnt/share/full/$fileName.zip | awk '{ print $5 }') --url "https://updater.ceruleanfire.com/builds/full/$fileName.zip" --datetime $updaterDate >> update
                fi
        fi
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
