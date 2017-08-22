#!/bin/bash

# Variables
device=
version=0.3

bdevice() {
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
	# Sync new changes
	repo sync

	# Setup build environment
	. build/envsetup.sh 

	export USE_CCACHE=1
	prebuilts/misc/linux-x86/ccache/ccache -M 100G
	export ANDROID_JACK_VM_ARGS="-Dfile.encoding=UTF-8 -XX:+TieredCompilation -Xmx8G"

}

cd ~/lineage

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