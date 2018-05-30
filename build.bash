#!/bin/bash

# Variables
version=0.1.0
builddate=$(date -u +%Y%m%d)
updaterDate=$(date -u "+%Y-%m-%d %H:%M:%S")
releasetype=release
device=

showHelp() {
        echo "Usage: build <device>"
        echo ""
        echo "Available devices are:"
        echo "'oneplus3'"
        echo ""
        echo "using the 'help' subcommand shows this text"
        echo ""
        echo "using the 'version' subcommand outputs version info"
}

cleanMka(){
        cd ~/android/cerulean/oreo-mr1

        if ! mka clobber ; then
                make clobber
                make clean
        fi
}

buildDevice() {
        # Start clean
        cleanMka

        cd ~/android/cerulean/oreo-mr1

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
                echo "Signing failed. Re-input the passwords for second attempt."
                rm signed-target_files.zip
                 if ! ./build/tools/releasetools/sign_target_files_apks -o -d ~/.android-certs out/dist/*$device-target_files-*.zip signed-target_files.zip ; then
                        echo "Signing failed, again. Exiting..."
                        exit
                fi
        fi
}

buildOTA() {
        cd ~/android/cerulean/oreo-mr1

        # For some reason, brotli doesn't work unless "otatools" is ran
        # so build "otatools" for future use
        mka otatools

        # Package Full OTA
        if ! ./build/tools/releasetools/ota_from_target_files -k ~/.android-certs/releasekey --block --backup=true signed-target_files.zip signed-ota_update.zip ; then
                echo "Creating Full OTA failed"
                exit
        fi
}

addOTA() {
        # Add packaged update to the update backend
        echo "Adding full OTA to list"
        cd ~/updater

        FLASK_APP=updater/app.py flask addrom -f Cerulean-15.1.$builddate-$device.zip -d $device -v 15.1 -t "$updaterDate" -r $releasetype -s $(stat --printf="%s" /srv/builds/$device/full/Cerulean-15.1-$builddate.zip) -m $(md5sum /srv/builds/$device/full/Cerulean-15.1-$builddate.zip | awk '{ print $1 }') -u https://ota.jwolfweb.com/builds/$device/full/Cerulean-15.1-$builddate.zip

        # Restart the updater
        echo "Restarting updater backend..."
        ./run.sh&
        disown
        echo "Updater backend restarted"
}

saveFiles() {
        cd ~/android/cerulean/oreo-mr1

        # Save Information
        echo "Build Time for Updater: " >> /srv/builds/$device/target_files/Cerulean-15.1-$builddate.txt
        echo $updaterDate >> /srv/builds/$device/target_files/Cerulean-15.1-$builddate.txt

        # Save Recovery (and boot)
        echo "Saving Recovery and Boot Images"
        ./build/tools/releasetools/img_from_target_files -z signed-target_files.zip /srv/builds/$device/img/Cerulean-15.1-$builddate.zip        

        # Save target_files
        echo "Saving Build Files"
        mv signed-target_files.zip /srv/builds/$device/target_files/Cerulean-15.1-$builddate.zip

        # Save OTA files
        echo "Saving OTA update"
        mv signed-ota_update.zip /srv/builds/$device/full/Cerulean-15.1-$builddate.zip
}

setupEnv() {
        cd ~/android/aosp/oreo-mr1

        cleanMka

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

                        cd ~/android/cerulean/oreo-mr1

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
                        echo ""
                        showHelp
        esac
else
        echo "Error: Please use a codename for the device you wish to build."
        showHelp
fi