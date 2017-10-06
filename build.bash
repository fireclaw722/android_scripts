#!/bin/bash

# Variables
device=
version=0.20.2

bdevice() {
	cd ~/lineage

	# Breakfast
	if ! breakfast lineage_$device-user ; then
		echo "Breakfast failed for $device."
		exit
	fi
	# Run build
	if ! mka target-files-package dist ; then
		echo "$device-user build failed. Try userdebug?"
		exit
	fi
	# Sign Build
	if ! ./build/tools/releasetools/sign_target_files_apks -o -d ~/.android-certs out/dist/*-target_files-*.zip signed-target_files.zip ; then
		echo "Signing failed."
		exit
	fi

	# Package OTA-zip
	if ! ./build/tools/releasetools/ota_from_target_files -k ~/.android-certs/releasekey --block --backup=true signed-target_files.zip signed-ota_update.zip ; then
		echo "Creating OTA .zip failed"
		exit
	fi

	# Move OTA to ~/build
	mv ~/lineage/signed-ota_update.zip ~/build/updater/$device/lineage-14.1-$(date +%Y%m%d)-UNOFFICIAL-$device.zip
	
	# save signed-images
	mv signed-target_files.zip ~/build/images/14.1-$(date +%Y%m%d)-$device-factory_imgs.zip
	unzip -j ~/build/images/14.1-$(date +%Y%m%d)-$device-factory_imgs.zip IMAGES/boot.img IMAGES/recovery.img IMAGES/recovery-two-step.img IMAGES/system.img IMAGES/system.map
	# zip .img's
	mkdir $(date +%Y%m%d)
	mv boot.img $(date +%Y%m%d)/boot.img
	mv recovery.img $(date +%Y%m%d)/recovery.img
	mv recovery-two-step.img $(date +%Y%m%d)/recovery-two-step.img
	mv system.img $(date +%Y%m%d)/system.img
	mv system.map $(date +%Y%m%d)/system.map
	# remove unneeded files
	if zip ~/build/images/$device/lineage-14.1-$(date +%Y%m%d)-factory_imgs-$device.zip $(date +%Y%m%d)/* ; then
		rm -rf $(date +%Y%m%d)/
	fi
}

setuppatches() {
	# Add SafetyNet Patches
	case $device in
		addison)
			cd ~/lineage/kernel/motorola/msm8953
			git fetch https://github.com/franciscofranco/one_plus_3T
			git cherry-pick 4ccdebba15186d6631ca286c8b8348ac3b1f3301 5a9321d9e89dda28c68272e98b9a2e07ba76dbc9
			;;
		athene)
			cd ~/lineage/kernel/motorola/msm8952
			git fetch https://github.com/franciscofranco/one_plus_3T
			git cherry-pick 4ccdebba15186d6631ca286c8b8348ac3b1f3301 5a9321d9e89dda28c68272e98b9a2e07ba76dbc9
			;;
		oneplus3)
			cd ~/lineage/kernel/oneplus/msm8996
			git fetch https://github.com/franciscofranco/one_plus_3T
			git cherry-pick 4ccdebba15186d6631ca286c8b8348ac3b1f3301 5a9321d9e89dda28c68272e98b9a2e07ba76dbc9
			;;
	esac	
	
	cd ~/lineage

	## Add UnifiedNlp patch
	wget -O ~/Downloads/UnifiedNlp-android_frameworks_base-N.patch https://raw.githubusercontent.com/microg/android_packages_apps_UnifiedNlp/master/patches/android_frameworks_base-N.patch
	patch --forward --no-backup-if-mismatch --strip='1' --directory='frameworks/base' < ~/Downloads/UnifiedNlp-android_frameworks_base-N.patch 
	rm -f ~/Downloads/UnifiedNlp-android_frameworks_base-N.patch
}

setupenv() {
	cd ~/lineage 

	make clobber

	# Sync new changes
	repo sync

	setuppatches

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
		addison|athene|victara)
			device=$1
			
			shift

			cd ~/lineage/vendor/cm/config
			cp common.mk.unofficial common.mk
			cd ~/lineage

			setupenv

			bdevice
			;;
		addison-stable|athene-stable|victara-stable)
			case $1 in
				addison-stable)
					device=addison
					shift
					;;
				athene-stable)
					device=athene
					shift
					;;
				victara-stable)
					device=victara
					shift
					;;
				*)
					echo "How? In? The?"
					exit
					;;
			esac

			cd ~/lineage/vendor/cm/config
			cp common.mk.stable common.mk
			cd ~/lineage

			setupenv

			bdevice
			;;
		help|-h|--help)
			echo "Please use a codename for the device you wish to build."
			echo ""
			echo "Available devices are:"
			echo "'addison','athene','victara'"
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