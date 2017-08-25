#!/bin/bash

# Variables
device=
version=0.10.1

bdevice() {
	cd ~/lineage

	# Breakfast
	breakfast $device

	# Run build
	brunch $device

	# Move to ~/build
	mv ~/lineage/out/target/product/$device/lineage-14.1-*.zip ~/build/$device/LOS_OMS-14.1-$(date +%Y%m%d)-$device.zip
	
	if [ -e ~/build/$device/LOS_OMS-14.1-$(date +%Y%m%d)-$device.zip ]; then
		# Remove old hash and lineage_ota
		rm ~/lineage/out/target/product/$device/lineage-14.1-*.zip.md5sum
		rm ~/lineage/out/target/product/$device/lineage_$device-*.zip

		# Generate hashes
		# sha256
		sha256sum ~/build/$device/LOS_OMS-14.1-$(date +%Y%m%d)-$device.zip >> ~/build/$device/LOS_OMS-14.1-$(date +%Y%m%d)-$device.zip.sha256sum
		# md5
		md5sum ~/build/$device/LOS_OMS-14.1-$(date +%Y%m%d)-$device.zip >> ~/build/$device/LOS_OMS-14.1-$(date +%Y%m%d)-$device.zip.md5sum
	fi
}

setupenv() {
	cd ~/lineage 

	# Sync new changes
	repo sync

	# MicroG Signature Spoofing
	wget -O ~/Downloads/GmsCore-android_frameworks_base-N.patch https://raw.githubusercontent.com/microg/android_packages_apps_GmsCore/master/patches/android_frameworks_base-N.patch && cd ~/lineage && patch -N --no-backup-if-mismatch --strip=1 --directory='frameworks/base' < ~/Downloads/GmsCore-android_frameworks_base-N.patch && rm -f ~/Downloads/GmsCore-android_frameworks_base-N.patch && sync

	# Location providers outside of /system
	wget -O ~/Downloads/UnifiedNlp-android_frameworks_base-N.patch https://raw.githubusercontent.com/microg/android_packages_apps_UnifiedNlp/master/patches/android_frameworks_base-N.patch && cd ~/lineage && patch -N --no-backup-if-mismatch --strip=1 --directory=frameworks/base < ~/Downloads/UnifiedNlp-android_frameworks_base-N.patch && rm -f ~/Downloads/UnifiedNlp-android_frameworks_base-N.patch && sync

	# Setup Substratum
	cd lineage/frameworks/base/
	git pull https://github.com/LineageOMS/android_frameworks_base cm-14.1
	cd ~/lineage/frameworks/native/
	git pull https://github.com/LineageOMS/android_frameworks_native cm-14.1
	cd ~/lineage/packages/apps/Contacts/
	git pull https://github.com/LineageOMS/android_packages_apps_Contacts cm-14.1
	cd ~/lineage/packages/ContactsCommon/
	git pull https://github.com/LineageOMS/android_packages_apps_ContactsCommon cm-14.1
	cd ~/lineage/packages/Dialer/
	git pull https://github.com/LineageOMS/android_packages_apps_Dialer cm-14.1
	cd ~/lineage/packages/ExactCalculator/
	git pull https://github.com/LineageOMS/android_packages_apps_ExactCalculator cm-14.1
	cd ~/lineage/packages/PackageInstaller/
	git pull https://github.com/LineageOMS/android_packages_apps_PackageInstaller cm-14.1
	cd ~/lineage/packages/PhoneCommon/
	git pull https://github.com/LineageOMS/android_packages_apps_PhoneCommon cm-14.1
	cd ~/lineage/packages/Settings/
	git pull https://github.com/LineageOMS/android_packages_apps_Settings cm-14.1
	cd ~/lineage/system/sepolicy/
	git pull https://github.com/LineageOMS/android_system_sepolicy cm-14.1
	cd ~/lineage/vendor/cm/
	git pull https://github.com/LineageOMS/android_vendor_cm cm-14.1

	cd ~/lineage 

	# Setup build environment
	. build/envsetup.sh 

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