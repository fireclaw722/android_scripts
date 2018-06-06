#!/bin/bash

# Variables
version=0.3.1
builddate=$(date -u +%Y%m%d)
updaterDate=$(date -u "+%Y-%m-%d %H:%M:%S")
releasetype=
device=

showHelp() {
        echo "Usage: build <device> [releasetype]"
        echo ""
        echo "Available devices are:"
        echo "'angler', 'athene', 'bullhead', 'griffin', 'marlin', 'oneplus2', 'oneplus3', 'sailfish'"
        echo ""
        echo "Available releasetypes are:"
        echo "'release', 'nightly'"
        echo "default is 'release'"
        echo "nightlies are not actually built nightly, and are of beta quality"
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

buildDevice() {
        # Start clean
        cleanMka

        cd ~/android/lineage/oreo-mr1

        # Breakfast
        if [ "$releasetype" == "nightly" ] ; then
                if ! breakfast lineage_$device-userdebug ; then
                        echo "Error: Breakfast failed for lineage_$device-userdebug"
                        exit
                fi
        elif [ "$releasetype" == "release" ] ; then
                if ! breakfast lineage_$device-user ; then
                        echo "Error: Breakfast failed for lineage_$device-user"
                        exit
                fi
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

addOTA() {
        # Add packaged update to the update backend
        echo "Adding full OTA to list"
        echo ""
        cd ~/updater

        FLASK_APP=updater/app.py flask addrom -f 15.1_$builddate_$device -d $device -v 15.1 -t "$updaterDate" -r $releasetype -s $(stat --printf="%s" /srv/builds/$device/full/LineageOMS-15.1.$builddate.zip) -m $(md5sum /srv/builds/$device/full/LineageOMS-15.1.$builddate.zip | awk '{ print $1 }') -u https://ota.jwolfweb.com/builds/$device/full/LineageOMS-15.1.$builddate.zip
        echo "Full OTA added"

        echo ""

        # Restart the updater
        echo "Restarting updater backend..."
        echo ""
        ./run.sh&
        disown
        echo "Updater backend restarted"
        echo ""
}

saveFiles() {
        cd ~/android/lineage/oreo-mr1

        # Save Recovery (and boot)
        echo "Saving Recovery and Boot Images"
        ./build/tools/releasetools/img_from_target_files -z signed-target_files.zip /srv/builds/$device/img/LineageOMS-15.1.$builddate.zip        

        # Save target_files
        echo "Saving Build Files"
        mv signed-target_files.zip /srv/builds/$device/target_files/LineageOMS-15.1.$builddate.zip

        # Save OTA files
        echo "Saving OTA update"
        mv signed-ota_update.zip /srv/builds/$device/full/LineageOMS-15.1.$builddate.zip
}

setupEnv() {
        cd ~/android/lineage/oreo-mr1

        cleanMka

        # Setup build environment
        source build/envsetup.sh

        # export vars
        export USE_CCACHE=0 CCACHE_DISABLE=1 ANDROID_JACK_VM_ARGS="-Dfile.encoding=UTF-8 -XX:+TieredCompilation -Xmx8G"
        if [ "$releasetype" == "nightly" ] ; then
                export RELEASE_TYPE=NIGHTLY
        elif [ "$releasetype" == "release" ] ; then
                export RELEASE_TYPE=RELEASE
        fi
}

## Enter main()

# take care of releasetype
if [ $# -eq 2 ] ; then
        case $2 in
                release)
                        releasetype=$2
                        builddate=$(date -u +%Y%m)
                        ;;
                nightly)
                        releasetype=$2
                        ;;
                *)
                        echo "Error: releasetype not available"
                        echo ""
                        showHelp
                        exit
        esac        
elif [ $# -eq 1 ] ; then
        releasetype=release
else
        echo "Error: Please use a codename for the device you wish to build."
        showHelp
        exit
fi

# now device
case $1 in
        angler|athene|bullhead|griffin|marlin|oneplus2|oneplus3|sailfish)
                device=$1
                shift

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
                echo ""
                showHelp
esac
