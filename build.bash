#!/bin/bash

# Variables
device=
releasetype=unofficial
stable=0
version=0.27.6

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
		echo "Build failed"
		if [ $stable -eq 1 ] ; then
			echo "Try unofficial? Check $device/sepolicy/kernel.te."
		elif [ $stable -eq 0 ] ; then
			echo "Revert last change and try again."
		fi
		exit
	fi

	# Sign Build
	if ! ./build/tools/releasetools/sign_target_files_apks -o -d ~/.android-certs out/dist/*-target_files-*.zip signed-target_files.zip ; then
		echo "Signing failed."
		exit
	fi

	# Save Signed Stable Images
	if [ stable -eq 1 ]; then
		./build/tools/releasetools/img_from_target_files signed-target_files.zip ~/builds/$device/img/lineage-14.1-$(date +%Y%m%d)-$device.zip
	fi
	
	# Package Full OTA
	if ! ./build/tools/releasetools/ota_from_target_files -k ~/.android-certs/releasekey --block --backup=true signed-target_files.zip signed-ota_update.zip ; then
		echo "Creating OTA .zip failed"
		exit
	fi

	# Save Full OTA
	mv ~/android/lineage/cm-14.1/signed-ota_update.zip ~/builds/$device/full/lineage-14.1-$(date +%Y%m%d)-$releasetype-$device.zip

	# Add Full OTA
	cd ~/updater
	echo "Adding full OTA to list"
	FLASK_APP=updater.app flask addrom -f lineage-14.1-$(date +%Y%m%d)-$releasetype-$device.zip -d $device -v 14.1 -t "$(date "+%Y-%m-%d %H:%M:%S")" -r $releasetype -m $(md5sum ~/builds/$device/full/lineage-14.1-$(date +%Y%m%d)-$releasetype-$device.zip  | awk '{ print $1 }') -u https://rctest.nt.jwolfweb.net/builds/$device/full/lineage-14.1-$(date +%Y%m%d)-$releasetype-$device.zip
	cd ~/android/lineage/cm-14.1

	# Package Incremental OTA
	if ! ./build/tools/releasetools/ota_from_target_files -k ~/.android-certs/releasekey --block -i ~/builds/$device/target_files/lineage-14.1-*-$releasetype-$device.zip ~/android/lineage/cm-14.1/signed-target_files.zip ~/builds/$device/delta/lineage-14.1-$(date +%Y%m%d)-$releasetype-$device.zip ; then
		echo "Creating Incremental OTA failed. Saving target_files anyways."
		# Save target_files
		mv ~/android/lineage/cm-14.1/signed-target_files.zip ~/builds/$device/target_files/lineage-14.1-$(date +%Y%m%d)-$releasetype-$device.zip
		exit
	fi

	# Save old target_files
	mv ~/builds/$device/target_files/lineage-14.1-*-$releasetype-$device.zip ~/builds/$device/target_files/archive/
	
	# Save new target_files
	mv ~/android/lineage/cm-14.1/signed-target_files.zip ~/builds/$device/target_files/lineage-14.1-$(date +%Y%m%d)-$releasetype-$device.zip
	
	# New protection, because I want to leave the code for later, but don't want to add incrementals to OTA-server
	if [ $stable -eq 3 ] ; then
		echo "Adding delta OTA to list"
		cd ~/updater
		# Remove Full OTA
		FLASK_APP=updater.app flask delrom -f lineage-14.1-$(date +%Y%m%d)-$releasetype-$device.zip

		# Add Incremental OTA
		FLASK_APP=updater.app flask addrom -f lineage-14.1-$(date +%Y%m%d)-$releasetype-$device.zip -d $device -v 14.1 -t "$(date "+%Y-%m-%d %H:%M:%S")" -r $releasetype -m $(md5sum ~/builds/$device/delta/lineage-14.1-$(date +%Y%m%d)-$releasetype-$device.zip | awk '{ print $1 }') -u https://rctest.nt.jwolfweb.net/builds/$device/delta/lineage-14.1-$(date +%Y%m%d)-$releasetype-$device.zip
	else
		echo "Leaving full OTA, not adding Incremental"
	fi

	cd ~/updater
	killall flask && zsh ./run.sh&!
	
	cd ~/android/lineage/cm-14.1
}

updateLineage() {
	cd ~/android/lineage/cm-14.1/vendor/cm
	git -c core.editor=true pull https://github.com/LineageOS/android_vendor_cm cm-14.1
	git push origin HEAD:cm-14.1

	cd ~/android/lineage/cm-14.1/frameworks/base
	repo sync --force-sync ./
	git -c core.editor=true pull https://github.com/LineageOS/android_frameworks_base cm-14.1
	git push origin HEAD:cm-14.1

	cd ~/android/lineage/cm-14.1/packages/apps/Settings
	repo sync --force-sync ./
	git -c core.editor=true pull https://github.com/LineageOS/android_packages_apps_Settings cm-14.1
	git push origin HEAD:cm-14.1

	cd ~/android/lineage/cm-14.1/packages/apps/ContactsCommon
	repo sync --force-sync ./
	git -c core.editor=true pull https://github.com/LineageOS/android_packages_apps_ContactsCommon cm-14.1
	git push origin HEAD:cm-14.1

	cd ~/android/lineage/cm-14.1/packages/apps/PhoneCommon
	repo sync --force-sync ./
	git -c core.editor=true pull https://github.com/LineageOS/android_packages_apps_PhoneCommon cm-14.1
	git push origin HEAD:cm-14.1

	cd ~/android/lineage/cm-14.1/packages/apps/Contacts
	repo sync --force-sync ./
	git -c core.editor=true pull https://github.com/LineageOS/android_packages_apps_Contacts cm-14.1
	git push origin HEAD:cm-14.1

	cd ~/android/lineage/cm-14.1/system/sepolicy
	repo sync --force-sync ./
	git -c core.editor=true pull https://github.com/LineageOS/android_system_sepolicy cm-14.1
	git push origin HEAD:cm-14.1

	cd ~/android/lineage/cm-14.1/frameworks/native
	repo sync --force-sync ./
	git -c core.editor=true pull https://github.com/LineageOS/android_frameworks_native cm-14.1
	git push origin HEAD:cm-14.1

	cd ~/android/lineage/cm-14.1/packages/apps/ExactCalculator
	repo sync --force-sync ./
	git -c core.editor=true pull https://github.com/LineageOS/android_packages_apps_ExactCalculator cm-14.1
	git push origin HEAD:cm-14.1

	cd ~/android/lineage/cm-14.1/packages/apps/PackageInstaller
	repo sync --force-sync ./
	git -c core.editor=true pull https://github.com/LineageOS/android_packages_apps_PackageInstaller.git cm-14.1
	git push origin HEAD:cm-14.1

	cd ~/android/lineage/cm-14.1/packages/apps/Dialer
	repo sync --force-sync ./
	git -c core.editor=true pull https://github.com/LineageOS/android_packages_apps_Dialer cm-14.1
	git push origin HEAD:cm-14.1
}

setuppatches() {
	# Add SafetyNet Patches
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
			cd ~/android/lineage/cm-14.1/kernel/oneplus
			rm -rf msm8996
			git clone https://github.com/franciscofranco/one_plus_3T -b lineageos-14.1 msm8996
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

	updateLineage
	
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

			sed -r '281 s/CM_BUILDTYPE := [^ ]*/CM_BUILDTYPE := UNOFFICIAL/' ~/android/lineage/cm-14.1/vendor/cm/config/common.mk >common.mk
			mv common.mk ~/android/lineage/cm-14.1/vendor/cm/config/common.mk

			rm -rf ~/android/lineage/cm-14.1/kernel/oneplus/msm8996

			cd ~/android/lineage/cm-14.1

			stable=0
			releasetype=unofficial

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

			sed -r '281 s/CM_BUILDTYPE := [^ ]*/CM_BUILDTYPE := STABLE/' ~/android/lineage/cm-14.1/vendor/cm/config/common.mk >common.mk
			mv common.mk ~/android/lineage/cm-14.1/vendor/cm/config/common.mk

			cd ~/android/lineage/cm-14.1

			stable=1
			releasetype=stable

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