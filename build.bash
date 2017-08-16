#!/bin/bash

# Variables
device=

bdevice() {
	# Ensure proper starting location
	cd ~/lineage

	# Breakfast
	breakfast $device > ~/$device-$(date +%Y%m%d).log

	# Run build
	brunch $device > ~/$device-$(date +%Y%m%d).log

	# Move to ~/build
	mv ~/lineage/out/target/product/$device/lineage-14.1-*.zip ~/build/$device/LOS_OMS-14.1-$(date +%Y%m%d)-$device.zip > ~/$device-$(date +%Y%m%d).log
	
	if [ -e ~/build/$device/LOS_OMS-14.1-$(date +%Y%m%d)-$device.zip ]; then
		# Remove old hash and lineage_ota
		rm ~/lineage/out/target/product/$device/lineage-14.1-*.zip.md5sum
		rm ~/lineage/out/target/product/$device/lineage_$device-*.zip

		# Generate hashes
		# sha256
		sha256sum ~/build/$device/LOS_OMS-14.1-$(date +%Y%m%d)-$device.zip > ~/build/$device/LOS_OMS-14.1-$(date +%Y%m%d)-$device.zip.sha256sum
		# sha1
		sha1sum ~/build/$device/LOS_OMS-14.1-$(date +%Y%m%d)-$device.zip > ~/build/$device/LOS_OMS-14.1-$(date +%Y%m%d)-$device.zip.sha1sum
		# md5
		md5sum ~/build/$device/LOS_OMS-14.1-$(date +%Y%m%d)-$device.zip > ~/build/$device/LOS_OMS-14.1-$(date +%Y%m%d)-$device.zip.md5sum
	fi

	# Move back to original directory
	cd ~/lineage
}



setupenv() {
	# Sync new changes
	repo sync > ~/0-repo_sync-$(date +%Y%m%d).log

	# Setup build environment
	. build/envsetup.sh 

	export USE_CCACHE=1
	prebuilts/misc/linux-x86/ccache/ccache -M 100G
	export ANDROID_JACK_VM_ARGS="-Dfile.encoding=UTF-8 -XX:+TieredCompilation -Xmx8G"

}

cd /home/builder/lineage

if [ $# -gt 0 ]; then
	# Parse Args
	case $1 in
		addison|athene|oneplus3|victara)
			device=$1
			
			shift

			setupenv

			bdevice
			;;
		all)
			setupenv

			device=addison
			bdevice

			device=athene
			bdevice

			device=oneplus3
			bdevice

			device=victara
			bdevice
			;;
		help|-h|--help)
			echo "Please use a codename for the device you wish to build."
			echo ""
			echo "Available devices are:"
			echo "'addison','athene','victara','all'**"
			echo ""
			echo "**'all' will build all available devices!"
			;;
		*)
			echo "Codename not available for build."
			echo ""
			build help
	esac
else
        echo "Please use a codename for the device you wish to build."
fi

