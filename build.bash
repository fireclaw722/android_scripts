#!/bin/bash

# Variables
device=
version=0.16

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
			mv ~/lineage/signed-ota_update.zip ~/build/$device/14.1-$(date +%Y%m%d)-$device.zip

			# Generate md5 hashes
			if [ -e ~/build/$device/14.1-$(date +%Y%m%d)-$device.zip ] ; then
				# ota-zip
				md5sum ~/build/$device/14.1-$(date +%Y%m%d)-$device.zip >> ~/build/$device/14.1-$(date +%Y%m%d)-$device.zip.md5sum
			fi
			
			# save recovery
			unzip -j signed-target_files.zip IMAGES/recovery.img
			mv recovery.img ~/build/$device/recovery-$(date +%Y%m%d)-$device.img

			# save signed-images
			mv signed-target_files.zip ~/build/images/14.1-$(date +%Y%m%d)-$device-factory_imgs.zip

			# update ota.xml
			sed -r s/14.1-[0-9]*-$device.zip/14.1-$(date +%Y%m%d)-$device.zip/ ~/build/ota.xml >ota.xml
			mv ~/build/ota.xml ~/build/ota.xml.old
			mv ota.xml ~/build/ota.xml
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

	# Add SafetyNet Commits
	# addison
	cd ~/lineage/kernel/motorola/msm8953
	git fetch https://github.com/franciscofranco/one_plus_3T
	git cherry-pick 4ccdebba15186d6631ca286c8b8348ac3b1f3301 5a9321d9e89dda28c68272e98b9a2e07ba76dbc9

	# athene
	cd ~/lineage/kernel/motorola/msm8952
	git fetch https://github.com/franciscofranco/one_plus_3T
	git cherry-pick 4ccdebba15186d6631ca286c8b8348ac3b1f3301 5a9321d9e89dda28c68272e98b9a2e07ba76dbc9
	
	# oneplus3
	cd ~/lineage/kernel/oneplus/msm8996
	git fetch https://github.com/franciscofranco/one_plus_3T
	git cherry-pick 4ccdebba15186d6631ca286c8b8348ac3b1f3301 5a9321d9e89dda28c68272e98b9a2e07ba76dbc9
	
	cd ~/lineage

	## Add UnifiedNlp patch
	wget -O ~/'Downloads/UnifiedNlp-android_frameworks_base-N.patch' 'https://raw.githubusercontent.com/microg/android_packages_apps_UnifiedNlp/master/patches/android_frameworks_base-N.patch' && cd ~/lineage && patch --forward --no-backup-if-mismatch --strip='1' --directory='frameworks/base' < ~/'Downloads/UnifiedNlp-android_frameworks_base-N.patch' && rm -f ~/'Downloads/UnifiedNlp-android_frameworks_base-N.patch' && sync

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