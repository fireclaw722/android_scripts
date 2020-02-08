#!/bin/bash

# Variables
version=9.0.0
device=
builddate=
updaterDate=
releasetype=
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
        if ! mka target-files-package dist ; then
                echo "Error: Make failed"
                echo "Revert last change and try again."
                exit
        fi

        # Sign Build
        if ! ./build/tools/releasetools/sign_target_files_apks -o -d ~/.android-certs --avb_vbmeta_key ~/android/graphene/10/keys/sargo/avb.pem --avb_vbmeta_algorithm SHA256_RSA2048 --avb_system_key ~/android/graphene/10/keys/sargo/avb.pem --avb_system_algorithm SHA256_RSA2048 out/dist/*$device-target_files-*.zip signed-target_files.zip ; then
                echo "Error: Signing failed, again. Exiting..."
                exit
        fi
}

buildOTA() {
        cd ~/android/lineage/17.1

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
        cd ~/android/lineage/17.1

        # Save Recovery (and boot)
        echo "Saving Recovery, Boot, and System Images"
        ./build/tools/releasetools/img_from_target_files signed-target_files.zip ~/android/builds/img/$fileName.zip

        # Save target_files
        echo "Saving Build Files"
        mv signed-target_files.zip ~/android/builds/target_files/$fileName.zip

        # Save OTA files
        echo "Saving OTA update"
        mv signed-ota_update.zip ~/android/builds/full/$fileName.zip

        # UPDATER SCRIPT
        #./addrom.py --filename $filename --device $device --version $RomVers --romtype unofficial --md5sum $(md5sum /mnt/share/full/$filename | awk '{ print $1 }') --romsize 667175697 --url "https://updater.ceruleanfire.com/builds/full/$filename" --datetime $(date --date="$builddate" +%s)
}

## Enter main()

# ADDISON
## Not available

# ATHENE
## Not available

# ONEPLUS3
cd ~/android/lineage/17.1

export device=oneplus3
releasetype=release
# run build
setupEnv
buildDevice
buildOTA
saveFiles

# cleanup
cleanMka

# VICTARA
## Not available

