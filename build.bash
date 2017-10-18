#!/bin/bash

# Variables
device=
stable=0
version=0.22.3

bdevice() {
	cd ~/android/lineage/cm-14.1

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
	
	if [ $stable -eq 1 ] ; then
		# Save Full OTA
		mv ~/android/lineage/cm-14.1/signed-ota_update.zip ~/build/full/$device/lineage-14.1-$(date +%Y%m%d)-STABLE-$device.zip

		# Build Delta/Incremental OTA
		if ./build/tools/releasetools/ota_from_target_files -i ~/build/target-delta/lineage-14.1-*-STABLE-$device.zip ~/android/lineage/cm-14.1/signed-target_files.zip ~/build/delta/lineage-14.1-$(date +%Y%m%d)-STABLE-$device.zip ; then
			rm ~/build/target-delta/lineage-14.1-*-STABLE-$device.zip
			# Save target_files
			mv ~/android/lineage/cm-14.1/signed-target_files.zip ~/build/target-delta/lineage-14.1-$(date +%Y%m%d)-STABLE-$device.zip
		else
			echo "Creating Incremental OTA failed. Saving target_files anyways."
			# Save target_files
			mv ~/android/lineage/cm-14.1/signed-target_files.zip ~/build/target-delta/lineage-14.1-$(date +%Y%m%d)-STABLE-$device.zip
		fi
	else
		# Save Full OTA
		mv ~/android/lineage/cm-14.1/signed-ota_update.zip ~/build/full/$device/lineage-14.1-$(date +%Y%m%d)-UNOFFICIAL-$device.zip
		
		# Build Delta/Incremental OTA
		if ./build/tools/releasetools/ota_from_target_files -i ~/build/target-delta/lineage-14.1-*-UNOFFICIAL-$device.zip ~/android/lineage/cm-14.1/signed-target_files.zip ~/build/delta/lineage-14.1-$(date +%Y%m%d)-UNOFFICIAL-$device.zip ; then
			rm ~/build/target-delta/lineage-14.1-*-UNOFFICIAL-$device.zip
			# Save target_files
			mv ~/android/lineage/cm-14.1/signed-target_files.zip ~/build/target-delta/lineage-14.1-$(date +%Y%m%d)-UNOFFICIAL-$device.zip
		else
			echo "Creating Incremental OTA failed. Saving target_files anyways."
			# Save target_files
			mv ~/android/lineage/cm-14.1/signed-target_files.zip ~/build/target-delta/lineage-14.1-$(date +%Y%m%d)-UNOFFICIAL-$device.zip
		fi
	fi
}

setuppatches() {
	# Add Device/Kernel Specific Patches
	case $device in
		addison)
			cd ~/android/lineage/cm-14.1/kernel/motorola/msm8953
			git fetch https://github.com/franciscofranco/one_plus_3T
			git cherry-pick 4ccdebba15186d6631ca286c8b8348ac3b1f3301 5a9321d9e89dda28c68272e98b9a2e07ba76dbc9
			;;
		athene)
			cd ~/android/lineage/cm-14.1/kernel/motorola/msm8952
			git fetch https://github.com/franciscofranco/one_plus_3T
			git cherry-pick 4ccdebba15186d6631ca286c8b8348ac3b1f3301 5a9321d9e89dda28c68272e98b9a2e07ba76dbc9
			;;
		oneplus3)
			if [ $stable -eq 1 ] ; then
				cd ~/android/lineage/cm-14.1/kernel/oneplus/msm8996
				git fetch https://github.com/franciscofranco/one_plus_3T
				git cherry-pick 4ccdebba15186d6631ca286c8b8348ac3b1f3301 5a9321d9e89dda28c68272e98b9a2e07ba76dbc9
			elif [ $stable -eq 0 ] ; then
				cd ~/android/lineage/cm-14.1/kernel/oneplus/
				rm -rf msm8996
				git clone https://github.com/franciscofranco/one_plus_3T msm8996
			fi
			;;
	esac	
	
	cd ~/android/lineage/cm-14.1

	## Add UnifiedNlp patch
	wget -O ~/Downloads/UnifiedNlp-android_frameworks_base-N.patch https://raw.githubusercontent.com/microg/android_packages_apps_UnifiedNlp/master/patches/android_frameworks_base-N.patch
	patch --forward --no-backup-if-mismatch --strip='1' --directory='frameworks/base' < ~/Downloads/UnifiedNlp-android_frameworks_base-N.patch 
	rm -f ~/Downloads/UnifiedNlp-android_frameworks_base-N.patch
}

setupenv() {
	cd ~/android/lineage/cm-14.1 

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
		addison|athene|oneplus3|victara)
			device=$1
			
			shift

			cd ~/android/lineage/cm-14.1/vendor/cm/config
			cp common.mk.unofficial common.mk

			cd ~/android/lineage/cm-14.1

			stable=0

			setupenv

			bdevice
			;;
		addison-stable|athene-stable|oneplus3-stable|victara-stable)
			case $1 in
				addison-stable)
					device=addison
					shift
					;;
				athene-stable)
					device=athene
					shift
					;;
				oneplus3-stable)
					device=oneplus3
					shift

					cd ~/android/lineage/cm-14.1/kernel/oneplus/
					rm -rf msm8996
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

			cd ~/android/lineage/cm-14.1/vendor/cm/config
			cp common.mk.stable common.mk

			cd ~/android/lineage/cm-14.1

			stable=1

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