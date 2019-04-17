#!/bin/bash

# Variables
version=7.0.0
device=
builddate=
updaterDate=
releasetype=
RomName=cerulean
RomVers=7.1
fileName=

cleanMka(){
        cd ~/android/lineage/nougat-mr1

        if ! mka clobber ; then
                make clobber
                make clean
        fi

        # clean vars
        device=
        builddate=
        updaterDate=
        releasetype=
        RomName=cerulean
        RomVers=7.1
        fileName=
}

setupEnv() {
        cd ~/android/lineage/nougat-mr1

        # Setup build environment
        source build/envsetup.sh

        # export vars
        if [ "$releasetype" == "release" ] ; then
                export RELEASE_TYPE=RELEASE
        elif [ "$releasetype" == "snapshot" ] ; then
                export RELEASE_TYPE=SNAPSHOT LINEAGE_EXTRAVERSION=fireclaw
        else
                exit
        fi
        export builddate=$(date --date="4 hours ago" -u +%Y%m%d)

        export USE_CCACHE=0 CCACHE_DISABLE=1 ANDROID_JACK_VM_ARGS="-Dfile.encoding=UTF-8 -XX:+TieredCompilation -Xmx8G" LC_ALL=C fileName=$RomName-$RomVers-$builddate-$releasetype-$device
}

buildDevice() {
        cd ~/android/lineage/nougat-mr1

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
        cd ~/android/lineage/nougat-mr1

        # Package Full OTA
        if ! ./build/tools/releasetools/ota_from_target_files -k ~/.android-certs/releasekey --block --backup=true signed-target_files.zip signed-ota_update.zip ; then
                echo "Error: Creating Full OTA failed"
                exit
        fi
}

saveFiles() {
        cd ~/android/lineage/nougat-mr1

        # Save Recovery (and boot)
        echo "Saving Recovery and Boot Images"
        ./build/tools/releasetools/img_from_target_files -z signed-target_files.zip ~/android/builds/img/$fileName.zip

        # Save target_files
        echo "Saving Build Files"
        mv signed-target_files.zip ~/android/builds/target_files/$fileName.zip

        # Save OTA files
        echo "Saving OTA update"
        mv signed-ota_update.zip ~/android/builds/full/$fileName.zip
}

## Enter main()
# ATHENE
device=athene
releasetype=release

# run build
cd ~/android/lineage/nougat-mr1
setupEnv
buildDevice
buildOTA
saveFiles

# cleanup
cleanMka

# VICTARA
device=victara
releasetype=release

# run build
cd ~/android/lineage/nougat-mr1
setupEnv
buildDevice
buildOTA
saveFiles

# cleanup
cleanMka