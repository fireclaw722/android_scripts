#!/bin/bash

# Variables
version=9.0.0
device=
builddate=
updaterDate=
releasetype=experimental
RomName=cerulean
RomVers=9.0
fileName=

cleanMka(){
        cd ~/android/lineage/pie

        if ! mka clean ; then
                make clean
        fi
}

setupEnv() {
        cd ~/android/lineage/pie

        cleanMka

        # Setup build environment
        source build/envsetup.sh

        # export vars
        # time/date info first
        export builddate=$(date --date="4 hours ago" -u +%Y%m%d_%H%M%S)

        export USE_CCACHE=0 CCACHE_DISABLE=1 ANDROID_JACK_VM_ARGS="-Dfile.encoding=UTF-8 -XX:+TieredCompilation -Xmx8G" LC_ALL=C RELEASE_TYPE=SNAPSHOT LINEAGE_VERSION_APPEND_TIME_OF_DAY=true fileName=$RomName-$RomVers-$builddate-$releasetype-$device
}

buildDevice() {
        # Start clean
        #cleanMka

        cd ~/android/lineage/pie

        # Breakfast
        if ! breakfast lineage_$device-userdebug ; then
                echo "Error: Breakfast failed for lineage_$device-user"
                exit
        fi

        # Run build
        if ! mka target-files-package dist ; then
                echo "Error: Make failed"
                echo "Revert last change and try again."
                exit
        fi

        # Sign Build
        if ! ./build/tools/releasetools/sign_target_files_apks -o -d ~/.android-certs out/dist/*$device-target_files-*.zip signed-target_files.zip ; then
                echo "Error: Signing failed. Re-input the passwords for second attempt."
                rm signed-target_files.zip
                 if ! ./build/tools/releasetools/sign_target_files_apks -o -d ~/.android-certs out/dist/*$device-target_files-*.zip signed-target_files.zip ; then
                        echo "Error: Signing failed, again. Exiting..."
                        exit
                fi
        fi
}

buildOTA() {
        cd ~/android/lineage/pie

        # For some reason, brotli doesn't work unless "otatools" is ran
        # so build "otatools" for future use
        mka otatools

        # Package Full OTA
        if ! ./build/tools/releasetools/ota_from_target_files -k ~/.android-certs/releasekey --block --backup=true signed-target_files.zip signed-ota_update.zip ; then
                echo "Error: Creating Full OTA failed"
                exit
        fi
}

saveFiles() {
        cd ~/android/lineage/pie

        # Save Recovery (and boot)
        echo "Saving Recovery, Boot, and System Images"
        ./build/tools/releasetools/img_from_target_files signed-target_files.zip ~/android/builds/$device/img/$fileName.zip

        # Save target_files
        echo "Saving Build Files"
        mv signed-target_files.zip ~/android/builds/$device/target_files/$fileName.zip

        # Save OTA files
        echo "Saving OTA update"
        mv signed-ota_update.zip ~/android/builds/$device/full/$fileName.zip
}

## Enter main()

# ONEPLUS3
cd ~/android/lineage/pie

export device=oneplus3
# run build
setupEnv
buildDevice
buildOTA
saveFiles

# ADDISON
## Not available