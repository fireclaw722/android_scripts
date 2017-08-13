#!/bin/bash

device=
todate='date +%Y%m%d'

bdevice() {
		# Ensure proper starting location
		cd ~/lineage
		
		# Ensure final folder exists
		if [ -d /var/www/html/build/$device/ ]; then
			echo "Exists"
		else
			mkdir /var/www/html/build/$device/
		fi
		
		# Breakfast
        breakfast $device

        # Run build
		mka target-files-package dist
		
		# Sign Build
		~/lineage/build/tools/releasetools/sign_target_files_apks -o -d ~/.android-certs ~/lineage/out/dist/*-target_files-*.zip ~/lineage/signed-target_files.zip
		
		# Generate .zip file
		~/lineage/build/tools/releasetools/ota_from_target_files -k ~/.android-certs/releasekey --block --backup=true ~/lineage/signed-target_files.zip /var/www/html/builds/$device/lineageOMS-14.1-$todate-$device\.zip
		
		# Generate hashes
		# sha256
		sha256sum /var/www/html/build/$device/lineageOMS-14.1-$todate-$device\.zip > /var/www/html/build/$device/lineageOMS-14.1-$todate-$device\.zip.sha256
		# sha1
		sha1sum /var/www/html/build/$device/lineageOMS-14.1-$todate-$device\.zip > /var/www/html/build/$device/lineageOMS-14.1-$todate-$device\.zip.sha1
		# md5
		md5sum /var/www/html/build/$device/lineageOMS-14.1-$todate-$device\.zip > /var/www/html/build/$device/lineageOMS-14.1-$todate-$device\.zip.md5

        # Move back to original directory
        cd ~/lineage
}

setupenv() {
        # Sync new changes
        repo sync

        # Setup build environment
        . build/envsetup.sh
        unset 'CCACHE_DISABLE' && export 'CCACHE_DISABLE=1'
		unset 'ANDROID_JACK_VM_ARGS' && export 'ANDROID_JACK_VM_ARGS=-Dfile.encoding=UTF-8 -XX:+TieredCompilation -Xmx8G'		
}

cd /home/builder/lineage

if [ $# -gt 0 ]; then

        # Parse Args
        case $1 in
                addison|athene|victara)
                        device=$1
                        shift
                        setupenv
                        bdevice
                        ;;
                help|-h|--help)
                        echo "Please use a codename for the device you wish to build."
                        echo "Available devices are:"
                        echo "'addison','athene','victara','all'**"
                        echo "**'all' will build all available devices!"
                        ;;
                all)
                        setupenv

                        device=addison
                        bdevice

                        device=athene
                        bdevice

                        device=victara
                        bdevice
                        ;;
                *)
                        echo "Codename not available for build. Available devices are:"
                        echo "'all','athene','oneplus3','victara'"

        esac
else
        echo "Please use a codename for the device you wish to build."
fi