#!/bin/bash

# Variables
device=
version=0.14.2

bdevice() {
	cd ~/lineage

	# Breakfast
	if breakfast lineage_$device-user ; then
		# Run build
		if mka target-files-package dist ; then
			# Sign Build
			./build/tools/releasetools/sign_target_files_apks -o -d ~/.android-certs out/dist/*-target_files-*.zip signed-target_files.zip

			# Package OTA-zip
			./build/tools/releasetools/ota_from_target_files -k ~/.android-certs/releasekey --block --backup=true signed-target_files.zip signed-ota_update.zip

			# Move OTA to ~/build
			mv ~/lineage/signed-ota_update.zip ~/build/$device/lineage-14.1-$(date +%Y%m%d)-$device.zip

			# Generate md5 hashes
			if [ -e ~/build/$device/lineage-14.1-$(date +%Y%m%d)-$device.zip ] ; then
				# ota-zip
				md5sum ~/build/$device/lineage-14.1-$(date +%Y%m%d)-$device.zip >> ~/build/$device/lineage-14.1-$(date +%Y%m%d)-$device.zip.md5sum
				
				# For Updater
				ln -s ~/build/$device/lineage-14.1-$(date +%Y%m%d)-$device.zip /var/www/html/LineageOTA/builds/full/lineage-14.1-$(date +%Y%m%d)-$device.zip
				ln -s ~/build/$device/lineage-14.1-$(date +%Y%m%d)-$device.zip.md5sum /var/www/html/LineageOTA/builds/full/lineage-14.1-$(date +%Y%m%d)-$device.zip.md5sum
			fi
			if [ -e ~/build/$device/lineage-recovery-$(date +%Y%m%d)-$device.img ] ; then
				# recovery
				md5sum ~/build/$device/lineage-recovery-$(date +%Y%m%d)-$device.img >> ~/build/$device/lineage-recovery-$(date +%Y%m%d)-$device.img.md5sum
			fi
		else
			echo "$device-user build failed. Try userdebug?"
		fi
	else
		echo "Breakfast failed for $device."
	fi
}

setupenv() {
	cd ~/lineage 

	make clobber

	# Sync new changes
	repo sync

	# Setup build environment
	source build/envsetup.sh 

	# No CCACHE
	export USE_CCACHE=0
	unset 'CCACHE_DISABLE' && export 'CCACHE_DISABLE=1'

	export ANDROID_JACK_VM_ARGS="-Dfile.encoding=UTF-8 -XX:+TieredCompilation -Xmx8G"

}

if [ $# -gt 0 ]; then
	# Parse Args
	case $1 in
		addison|athene|oneplus3|victara)
			device=$1
			
			shift

			setupenv

			bdevice
			;;
		help|-h|--help)
			echo "Please use a codename for the device you wish to build."
			echo ""
			echo "Available devices are:"
			echo "'addison','athene','oneplus3','victara'"
			;;
		version|-v|--version)
			echo "Version: "$version
			;;
		*)
			echo "Codename not available for build."
			echo ""
			build help
	esac
else
        echo "Please use a codename for the device you wish to build."
fi