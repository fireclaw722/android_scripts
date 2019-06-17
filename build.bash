#!/bin/bash

# Variables
version=8.0.0
device=
builddate=
updaterDate=
releasetype=
RomName=cerulean
RomVers=8.1
fileName=

cleanMka(){
        cd ~/android/lineage/oreo-mr1

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
        RomVers=8.1
        fileName=
}

setupEnv() {
        cd ~/android/lineage/oreo-mr1

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

        export USE_CCACHE=0 CCACHE_DISABLE=1 ANDROID_JACK_VM_ARGS="-Dfile.encoding=UTF-8 -XX:+TieredCompilation -Xmx8G" fileName=$RomName-$RomVers-$builddate-$releasetype-$device
}

buildDevice() {
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
        echo "Saving Recovery, Boot, and System Images"
        ./build/tools/releasetools/img_from_target_files signed-target_files.zip ~/android/builds/img/$fileName.zip

        # Save target_files
        echo "Saving Build Files"
        mv signed-target_files.zip ~/android/builds/target_files/$fileName.zip

        # Save OTA files
        echo "Saving OTA update"
        mv signed-ota_update.zip ~/android/builds/full/$fileName.zip
}

## Enter main()
## ATHENE
export device=athene
releasetype=experimental

# setup
cd ~/android/lineage/oreo-mr1
if [ -d "device/motorola/athene/" ]; then
        rm -rf ~/android/lineage/oreo-mr1/device/motorola/athene
fi

if [ -d "vendor/motorola" ]; then
        rm -rf ~/android/lineage/oreo-mr1/vendor/motorola
fi

cp -r /opt/android/fireclaw722/android_device_motorola_athene/ ~/android/lineage/oreo-mr1/device/motorola/athene
cp -r /opt/android/fireclaw722/proprietary_vendor_motorola/ ~/android/lineage/oreo-mr1/vendor/motorola

# run build
cd ~/android/lineage/oreo-mr1
setupEnv
buildDevice
buildOTA
saveFiles

# cleanup
cleanMka
rm -rf ~/android/lineage/oreo-mr1/device/motorola/athene
rm -rf ~/android/lineage/oreo-mr1/vendor/motorola

#ONEPLUS3
export device=oneplus3
releasetype=release

# run build
cd ~/android/lineage/oreo-mr1
setupEnv
buildDevice
buildOTA
saveFiles

# cleanup
cleanMka

## VICTARA
# Not available

## Moto-mods devices
cd ~/android/lineage/oreo-mr1
if ! vendor/lineage/build/tools/repopick.py -f -g https://review.lineageos.org -t moto-mods-battery-lineage-15.1 ; then
        cd ~/android/lineage/oreo-mr1/frameworks/base
        
        if ! git commit -a --no-edit ; then
                echo "Error: Commit failed in frameworks/base"
                echo "Including Moto Mod support failed"
                exit
        fi
        
        cd ~/android/lineage/oreo-mr1

        if ! vendor/lineage/build/tools/repopick.py -f -g https://review.lineageos.org -t moto-mods-battery-lineage-15.1 ; then
                echo "Error: Commit failed after frameworks/base"
                echo "Including Moto Mod support failed"
                exit
        fi
fi

## ADDISON
export device=addison
releasetype=release

# setup
cd ~/android/lineage/oreo-mr1
if [ -d "device/motorola/addison/" ]; then
        rm -rf ~/android/lineage/oreo-mr1/device/motorola/addison/
fi

if [ -d "vendor/motorola" ]; then
        rm -rf ~/android/lineage/oreo-mr1/vendor/motorola
fi

cp -r /opt/android/fireclaw722/device_motorola_addison/ ~/android/lineage/oreo-mr1/device/motorola/addison
cp -r /opt/android/fireclaw722/vendor_motorola/ ~/android/lineage/oreo-mr1/vendor/motorola

# run build
cd ~/android/lineage/oreo-mr1
setupEnv
buildDevice
buildOTA
saveFiles

# cleanup
cleanMka
rm -rf ~/android/lineage/oreo-mr1/device/motorola/addison
rm -rf ~/android/lineage/oreo-mr1/vendor/motorola
