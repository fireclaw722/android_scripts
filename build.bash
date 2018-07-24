#!/bin/bash

# Variables
version=0.6.1
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
        echo "'griffin', 'oneplus3'"
        echo ""
        echo "Available romtypes are:"
        echo "'cerulean', 'lineageoms'"
        echo "default is 'lineageoms'"
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

        # setup variables
        updaterDate=$(date -u "+%Y-%m-%d %H:%M:%S")
        builddate=$(date -u +%Y%m%d) 

        cleanMka

        # Setup build environment
        source build/envsetup.sh

        # export vars
        export USE_CCACHE=0 CCACHE_DISABLE=1 ANDROID_JACK_VM_ARGS="-Dfile.encoding=UTF-8 -XX:+TieredCompilation -Xmx8G" 
        if [ "$RomName" == "LineageOMS" ] ; then
                export TARGET_UNOFFICIAL_BUILD_ID=fireclaw
        elif [ "$RomName" == "Cerulean" ] ; then
                export RELEASE_TYPE=RELEASE
        fi
}

buildDevice() {
        # Start clean
        cleanMka

        cd ~/android/lineage/oreo-mr1

        # Breakfast
        if ! breakfast lineage_$device-userdebug ; then
                echo "Error: Breakfast failed for lineage_$device-userdebug"
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
        ./build/tools/releasetools/img_from_target_files -z signed-target_files.zip /srv/builds/$device/img/$RomName-$RomVers.$builddate-$device.zip        

        # Save target_files
        echo "Saving Build Files"
        mv signed-target_files.zip /srv/builds/$device/target_files/$RomName-$RomVers.$builddate-$device.zip

        # Save OTA files
        echo "Saving OTA update"
        mv signed-ota_update.zip /srv/builds/$device/full/$RomName-$RomVers.$builddate-$device.zip
}

addOTA() {
        # Add packaged update to the update backend
        echo "Adding full OTA to list"
        echo ""
        cd ~/updater

        FLASK_APP=updater/app.py flask addrom -f $RomName-$RomVers.$builddate-$device -d $device -v $RomVers -t "$updaterDate" -r $releasetype -s $(stat --printf="%s" /srv/builds/$device/full/$RomName-$RomVers.$builddate.zip) -m $(md5sum /srv/builds/$device/full/$RomName-$RomVers.$builddate.zip | awk '{ print $1 }') -u https://ota.jwolfweb.com/builds/$device/full/Cerulean-8.1.$builddate.zip

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

## Enter main()

# take care of releasetype
if [ $# -eq 2 ] ; then
        case $2 in
                lineageoms)
                        releasetype=unofficial
                        RomName=LineageOMS
                        RomVers=15.1
                        ;;
                cerulean)
                        releasetype=release
                        RomName=Cerulean
                        RomVers=8.1
                        ;;
                *)
                        echo "Error: romtype not available"
                        echo ""
                        showHelp
                        exit
        esac        
elif [ $# -eq 1 ] ; then
        releasetype=unofficial
        RomName=LineageOMS
        RomVers=15.1
else
        echo "Error: Please use a codename for the device you wish to build."
        showHelp
        exit
fi

# now device
case $1 in
        angler|bullhead|marlin|sailfish|oneplus3|addison|athene|griffin|oneplus2|victara)
                device=$1
                
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
