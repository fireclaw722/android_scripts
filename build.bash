#!/bin/bash

# Variables
version=8.0.0
device=
builddate=
updaterDate=
releasetype=
RomName=
RomVers=

showHelp() {
        echo "Usage: build <device> [romtype]"
        echo ""
        echo "Available devices are:"
        echo "'addison', 'oneplus3'"
        echo ""
        echo "using the 'help' subcommand shows this text"
        echo ""
        echo "using the 'version' subcommand outputs version info"
}

cleanMka(){
        cd ~/android/lineage/oreo-mr1

        if ! mka clobber ; then
                make clobber
                make clean
        fi
}

setupEnv() {
        cd ~/android/lineage/oreo-mr1

        cleanMka

        # Setup build environment
        source build/envsetup.sh

        # export vars
        export USE_CCACHE=0 CCACHE_DISABLE=1 ANDROID_JACK_VM_ARGS="-Dfile.encoding=UTF-8 -XX:+TieredCompilation -Xmx8G" LC_ALL=C builddate=$(date --date="4 hours ago" -u +%Y%m%d_%H%M%S) updaterDate=$(date --date="4 hours ago" -u "+%Y-%m-%d %H:%M:%S") TARGET_UNOFFICIAL_BUILD_ID=fireclaw LINEAGE_VERSION_APPEND_TIME_OF_DAY=true
}

buildDevice() {
        # Start clean
        #cleanMka

        cd ~/android/lineage/oreo-mr1

        # Breakfast
        if ! breakfast lineage_$device-user ; then
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
        cd ~/android/lineage/oreo-mr1

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
        cd ~/android/lineage/oreo-mr1

        # Save Recovery (and boot)
        echo "Saving Recovery and Boot Images"
        ./build/tools/releasetools/img_from_target_files -z signed-target_files.zip ~/builds/$device/img/$RomName-$TARGET_VENDOR_RELEASE_BUILD_ID-$device.zip   

        # Save target_files
        echo "Saving Build Files"
        mv signed-target_files.zip ~/builds/$device/target_files/$RomName-$TARGET_VENDOR_RELEASE_BUILD_ID-$device.zip

        # Save OTA files
        echo "Saving OTA update"
        mv signed-ota_update.zip ~/builds/$device/full/$RomName-$TARGET_VENDOR_RELEASE_BUILD_ID-$device.zip
}

addOTA() {
        # Add packaged update to the update backend
        echo "Adding OTA to list"

        touch datetime-for-updater.txt
        echo "----" >> datetime-for-updater.txt

        echo FLASK_APP=updater/app.py flask addrom -f $TARGET_VENDOR_RELEASE_BUILD_ID-$device -d $device -v $RomVers -t \"$updaterDate\" -r $releasetype -s $(stat --printf="%s" ~/builds/$device/full/$RomName-$TARGET_VENDOR_RELEASE_BUILD_ID-$device.zip) -m $(md5sum ~/builds/$device/full/$RomName-$TARGET_VENDOR_RELEASE_BUILD_ID-$device.zip | awk '{ print $1 }') -u https://updater.ceruleanfire.com/builds/$device/full/$RomName-$TARGET_VENDOR_RELEASE_BUILD_ID-$device.zip >> datetime-for-updater.txt
        echo "" >> datetime-for-updater.txt

        echo "Full OTA added"
        echo ""
}

## Enter main()
# take care pf device
case $1 in
        oneplus3|addison)
                export device=$1
                
                # run build
                cd ~/android/lineage/oreo-mr1

                setupEnv

                buildDevice

                buildOTA

                saveFiles

                addOTA

                cleanMka
                ;;
        help|-h|--help)
                showHelp
                ;;
        version|-v|--version)
                echo "Version: "$version
                ;;
        *)
                echo "Error: Codename not available for build."
                echo "Device not set."
                echo ""
                showHelp
esac
