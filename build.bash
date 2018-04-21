#!/bin/bash

# Variables
version=15.0.8
datetime=$(date -u +%Y%m%d)
dateforota=$(date -u "+%Y-%m-%d %H:%M:%S")
releasetype=release
device=

bdevice() {
        cd ~/android/lineage/lineage-15.1

        # Breakfast
        if ! breakfast lineage_$device-user ; then
                echo "Breakfast failed for lineage_$device-user."
                exit
        fi

        # Run build
        if ! mka target-files-package dist ; then
                echo "Build failed"
                echo "Revert last change and try again."
                exit
        fi

        # Sign Build
        if ! ./build/tools/releasetools/sign_target_files_apks -o -d ~/.android-certs out/dist/*$device-target_files-*.zip signed-target_files.zip ; then
                echo "Signing failed."
                exit
        fi

        # Save Recovery (and boot)
        ./build/tools/releasetools/img_from_target_files -z signed-target_files.zip /srv/builds/$device/img/LOS-IMG-15.1-$datetime-$device.zip

        mka otatools

        # Package Full OTA
        if ! ./build/tools/releasetools/ota_from_target_files -k ~/.android-certs/releasekey --block --backup=true signed-target_files.zip signed-ota_update.zip ; then
                echo "Creating OTA .zip failed"
                exit
        fi

        # Save Full OTA
        mv ~/android/lineage/lineage-15.1/signed-ota_update.zip /srv/builds/$device/full/LOS-15.1-$datetime-$device.zip

        # Save target_files
        mv signed-target_files.zip /srv/builds/$device/target_files/LOS-TF-15.1-$datetime-$device.zip

        # Add Full OTA
        cd ~/updater
        echo "Adding full OTA to list"
        FLASK_APP=updater/app.py flask addrom -f LOS-15.1-$datetime-$device.zip -d $device -v 15.1 -t "$dateforota" -r $releasetype -s $(stat --printf="%s" /srv/builds/$device/full/LOS-15.1-$datetime-$device.zip) -m $(md5sum /srv/builds/$device/full/LOS-15.1-$datetime-$device.zip | awk '{ print $1 }') -u https://ota.jwolfweb.com/builds/$device/full/LOS-15.1-$datetime-$device.zip
        cd ~/android/lineage/lineage-15.1

        # Restart the updater
        cd ~/updater
        ./run.sh&
        disown

        cd ~/android/lineage/lineage-15.1

        make clobber
        mka clobber
}

setupenv() {
        cd ~/android/lineage/lineage-15.1

        make clobber

        # Setup build environment
        source build/envsetup.sh

        # export vars
        export USE_CCACHE=0 CCACHE_DISABLE=1 ANDROID_JACK_VM_ARGS="-Dfile.encoding=UTF-8 -XX:+TieredCompilation -Xmx8G" RELEASE_TYPE=RELEASE
}

# Enter main()
if [ $# -gt 0 ]; then
        case $1 in
                oneplus3)
                        device=$1
                        shift

                        cd ~/android/lineage/lineage-15.1

                        setupenv

                        bdevice
                        ;;
                help|-h|--help)
                        echo "Usage: build <device>"
                        echo ""
                        echo "Available devices are:"
                        echo "'oneplus3'"
                        echo ""
                        echo "using the 'help' subcommand shows this text"
                        echo ""
                        echo "using the 'version' subcommand outputs version info"
                        ;;
                version|-v|--version)
                        echo "Version: "$version
                        ;;
                *)
                        echo "Codename not available for build."
                        echo ""
                        build-15 help
        esac
else
        echo "Please use a codename for the device you wish to build."
        build help
fi