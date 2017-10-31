#!/bin/bash

# Variables
device=
stable=0
version=0.26

bdevice() {
	cd ~/android/lineage/cm-14.1

	# Breakfast
	if [ $stable -eq 1 ] ; then
		if ! breakfast lineage_$device-user ; then
			echo "Breakfast failed for lineage_$device-user."
			exit
		fi
	elif [ $stable -eq 0 ] ; then
		if ! breakfast $device ; then
			echo "Breakfast failed for lineage_$device-userdebug."
			exit
		fi
	fi
	
	# Run build
	if ! mka target-files-package dist ; then
		if [ $stable -eq 1 ] ; then
			echo "$device-stable build failed. Try unofficial?"
		elif [ $stable -eq 0 ] ; then
			echo "$device-unofficial build failed. revert last change and try again."
		fi
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

			echo "Adding delta OTA to list"
			cd ~/updater
			FLASK_APP=updater.app flask addrom -f lineage-14.1-$(date +%Y%m%d)-STABLE-$device.zip -d $device -v 14.1 -t "$(date "+%Y-%m-%d %H:%M:%S")" -r stable -m $(md5sum ~/build/delta/$device/lineage-14.1-$(date +%Y%m%d)-STABLE-$device.zip  | awk '{ print $1 }') -u https://rctest.nt.jwolfweb.net/builds/delta/$device/lineage-14.1-$(date +%Y%m%d)-STABLE-$device.zip
		else
			echo "Creating Incremental OTA failed. Saving target_files anyways."
			# Save target_files
			mv ~/android/lineage/cm-14.1/signed-target_files.zip ~/build/target-delta/lineage-14.1-$(date +%Y%m%d)-STABLE-$device.zip

			echo "Adding full OTA to list"
			cd ~/updater
			FLASK_APP=updater.app flask addrom -f lineage-14.1-$(date +%Y%m%d)-STABLE-$device.zip -d $device -v 14.1 -t "$(date "+%Y-%m-%d %H:%M:%S")" -r stable -m $(md5sum ~/build/full/$device/lineage-14.1-$(date +%Y%m%d)-STABLE-$device.zip  | awk '{ print $1 }') -u https://rctest.nt.jwolfweb.net/builds/full/$device/lineage-14.1-$(date +%Y%m%d)-STABLE-$device.zip
		fi
		
		# save signed recovery
		cd ~/android/lineage/cm-14.1/
		unzip -j signed-target_files.zip IMAGES/recovery.img
		mv recovery.img ~/build/full/$device/recovery-14.1-$(date +%Y%m%d)-$device.img
		unzip -j signed-target_files.zip IMAGES/recovery-two-step.img
		mv recovery-two-step.img ~/build/full/$device/recovery_two_step-14.1-$(date +%Y%m%d)-$device.img
	else
		# Save Full OTA
		mv ~/android/lineage/cm-14.1/signed-ota_update.zip ~/build/full/$device/lineage-14.1-$(date +%Y%m%d)-UNOFFICIAL-$device.zip
		
		# Build Delta/Incremental OTA
		if ./build/tools/releasetools/ota_from_target_files -i ~/build/target-delta/lineage-14.1-*-UNOFFICIAL-$device.zip ~/android/lineage/cm-14.1/signed-target_files.zip ~/build/delta/lineage-14.1-$(date +%Y%m%d)-UNOFFICIAL-$device.zip ; then
			rm ~/build/target-delta/lineage-14.1-*-UNOFFICIAL-$device.zip
			# Save target_files
			mv ~/android/lineage/cm-14.1/signed-target_files.zip ~/build/target-delta/lineage-14.1-$(date +%Y%m%d)-UNOFFICIAL-$device.zip

			echo "Adding delta OTA to list"
			cd ~/updater
			FLASK_APP=updater.app flask addrom -f lineage-14.1-$(date +%Y%m%d)-UNOFFICIAL-$device.zip -d $device -v 14.1 -t "$(date "+%Y-%m-%d %H:%M:%S")" -r unofficial -m $(md5sum ~/build/delta/$device/lineage-14.1-$(date +%Y%m%d)-UNOFFICIAL-$device.zip  | awk '{ print $1 }') -u https://rctest.nt.jwolfweb.net/builds/delta/$device/lineage-14.1-$(date +%Y%m%d)-UNOFFICIAL-$device.zip
		else
			echo "Creating Incremental OTA failed. Saving target_files anyways."
			# Save target_files
			mv ~/android/lineage/cm-14.1/signed-target_files.zip ~/build/target-delta/lineage-14.1-$(date +%Y%m%d)-UNOFFICIAL-$device.zip

			echo "Adding full OTA to list"
			cd ~/updater
			FLASK_APP=updater.app flask addrom -f lineage-14.1-$(date +%Y%m%d)-UNOFFICIAL-$device.zip -d $device -v 14.1 -t "$(date "+%Y-%m-%d %H:%M:%S")" -r unofficial -m $(md5sum ~/build/full/$device/lineage-14.1-$(date +%Y%m%d)-UNOFFICIAL-$device.zip  | awk '{ print $1 }') -u https://rctest.nt.jwolfweb.net/builds/full/$device/lineage-14.1-$(date +%Y%m%d)-UNOFFICIAL-$device.zip
		fi
	fi

	cd ~/android/lineage/cm-14.1
}

mergesubstratum() {
	cd ~/android/lineage/cm-14.1/vendor/cm
	repo sync --force-sync ./
	git fetch https://github.com/LineageOMS/android_vendor_cm
	git cherry-pick 218eed7ae28e1185bf922af710f2b944b6241bc4

	cd ~/android/lineage/cm-14.1/frameworks/base
	repo sync --force-sync ./
	git -c core.editor=true pull https://github.com/LineageOMS/android_frameworks_base

	cd ~/android/lineage/cm-14.1/packages/apps/Settings
	repo sync --force-sync ./
	git fetch https://github.com/LineageOMS/android_packages_apps_Settings
	git cherry-pick 5c4faecd8e0c8fe1e6303d161a24210c0d39cbaf
	git cherry-pick aa0e4bea0701e14aef57740d62afba5e99989bfb
	git cherry-pick 8fa67835e4aeff667405ff91bf0a6fe36322fdc0
	git cherry-pick b7404d505d73291ce82f51e4234cc215cf77c040

	git cherry-pick f76b626eae3a230a3a3899e329070a77c9209cf5

	git stage src/com/android/settings/deviceinfo/StorageSettings.java
	git -c core.editor=true commit

	git cherry-pick d2c4af47aac563e1ad4a5d5c84ac8010dbadd1ef
	git cherry-pick 9969406f0a15e2d5cc719b8cdcb54e4a416f1c0b
	git cherry-pick fd23576617e46db5f1d760537b500700efdc0ffc
	git cherry-pick 435d6042fa12b4eb576338afe51269d5c7862c00
	git cherry-pick 2839dd005243ac28d864b8000416a4e93c585533
	git cherry-pick 210416d68a9c881fac5a4d10733b588b16b4a5c6
	git cherry-pick 860834943fa796014490b87285b7d8c9d3918052
	git cherry-pick 985d7aeff1fbca9bccb4d5b8e9fc670dfd5e2144
	git cherry-pick c3216b8071370a0c780ba607e65723ab56e4936c
	git cherry-pick be8d2cf7eb6f315dfe08e756f9aae38b50c10752
	git cherry-pick 61847b52f7e46b1f7fa8f1d19456c6ea7a17e53f
	git cherry-pick e7eda300923f15ac1e578412720cc7228da1f072
	git cherry-pick cbe72a9c9afe98e2598f946dddd2ceee66cec642
	git cherry-pick f553a26c1a7b4e56f71487b210b78ed0a1e7fbf9
	git cherry-pick a84a0e5f16afdda26d42200deeaf8777786986e6

	cd ~/android/lineage/cm-14.1/packages/apps/ContactsCommon
	repo sync --force-sync ./
	git -c core.editor=true pull https://github.com/LineageOMS/android_packages_apps_ContactsCommon

	cd ~/android/lineage/cm-14.1/packages/apps/PhoneCommon
	repo sync --force-sync ./
	git -c core.editor=true pull https://github.com/LineageOMS/android_packages_apps_PhoneCommon

	cd ~/android/lineage/cm-14.1/packages/apps/Contacts
	repo sync --force-sync ./
	git -c core.editor=true pull https://github.com/LineageOMS/android_packages_apps_Contacts

	cd ~/android/lineage/cm-14.1/system/sepolicy
	repo sync --force-sync ./
	git -c core.editor=true pull https://github.com/LineageOMS/android_system_sepolicy

	cd ~/android/lineage/cm-14.1/frameworks/native
	repo sync --force-sync ./
	git -c core.editor=true pull https://github.com/LineageOMS/android_frameworks_native

	cd ~/android/lineage/cm-14.1/packages/apps/ExactCalculator
	repo sync --force-sync ./
	git -c core.editor=true pull https://github.com/LineageOMS/android_packages_apps_ExactCalculator

	cd ~/android/lineage/cm-14.1/packages/apps/PackageInstaller
	repo sync --force-sync ./
	git -c core.editor=true pull https://github.com/LineageOMS/android_packages_apps_PackageInstaller

	cd ~/android/lineage/cm-14.1/packages/apps/Dialer
	repo sync --force-sync ./
	git -c core.editor=true pull https://github.com/LineageOMS/android_packages_apps_Dialer

	cd ~/android/lineage/cm-14.1/packages/services/
	git clone -b n-rootless https://github.com/substratum/interfacer ThemeInterfacer
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
				git clone https://github.com/franciscofranco/one_plus_3T msm8996 -b lineageos-14.1
			fi
			;;
	esac

	# Add support for updater
	cd ~/android/lineage/cm-14.1/packages/apps/Updater/
	sed -r '29 s/download.lineageos.org/ota.jwolfweb.com/' ~/android/lineage/cm-14.1/packages/apps/Updater/res/values/strings.xml > strings.xml 
	mv strings.xml ~/android/lineage/cm-14.1/packages/apps/Updater/res/values/strings.xml
	git commit -m "Change update location for Unofficial builds"

	cd ~/android/lineage/cm-14.1

	## Add UnifiedNlp patch
	wget -O ~/Downloads/UnifiedNlp-android_frameworks_base-N.patch https://raw.githubusercontent.com/microg/android_packages_apps_UnifiedNlp/master/patches/android_frameworks_base-N.patch
	patch --forward --no-backup-if-mismatch --strip='1' --directory='frameworks/base' < ~/Downloads/UnifiedNlp-android_frameworks_base-N.patch 
	rm -f ~/Downloads/UnifiedNlp-android_frameworks_base-N.patch

	mergesubstratum
	
	cd ~/android/lineage/cm-14.1
}

setupenv() {
	cd ~/android/lineage/cm-14.1 

	make clobber

	# Sync new changes
	repo sync

	setuppatches

	cd ~/android/lineage/cm-14.1 

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

			sed -r '280 s/CM_BUILDTYPE := [^ ]*/CM_BUILDTYPE := UNOFFICIAL/' ~/android/lineage/cm-14.1/vendor/cm/config/common.mk >common.mk
			mv common.mk ~/android/lineage/cm-14.1/vendor/cm/config/common.mk

			rm -rf ~/android/lineage/cm-14.1/kernel/oneplus/msm8996

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

			sed -r '280 s/CM_BUILDTYPE := [^ ]*/CM_BUILDTYPE := STABLE/' ~/android/lineage/cm-14.1/vendor/cm/config/common.mk >common.mk
			mv common.mk ~/android/lineage/cm-14.1/vendor/cm/config/common.mk

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

	cd ~/updater
	killall flask && ./run.sh&
else
	echo "Please use a codename for the device you wish to build."
fi