#!/bin/bash

# Variables
device=
releasetype=
gapps=1
releasever=NJH47F
version=14.0

bdevice() {
	cd ~/android/lineage/cm-14.1

	# Breakfast
	if ! breakfast lineage_$device-user ; then
		echo "Breakfast failed for lineage_$device-user."
		exit
	fi
	
	# Run build
	if ! mka target-files-package dist ; then
		echo "Build failed"
		echo "Revert last change and try again."
		exit
	fi

	# Sign Build
	if ! ./build/tools/releasetools/sign_target_files_apks -o -d ~/.android-certs out/dist/*-target_files-*.zip signed-target_files.zip ; then
		echo "Signing failed."
		exit
	fi

	# Save Signed Stable Images
	./build/tools/releasetools/img_from_target_files signed-target_files.zip ~/builds/$device/img/LOS-14.1-$(date +%Y%m%d)-$device.zip
	
	# Package Full OTA
	if ! ./build/tools/releasetools/ota_from_target_files -k ~/.android-certs/releasekey --block --backup=true signed-target_files.zip signed-ota_update.zip ; then
		echo "Creating OTA .zip failed"
		exit
	fi

	# Save Full OTA
	mv ~/android/lineage/cm-14.1/signed-ota_update.zip ~/builds/$device/full/LOS-14.1-$(date +%Y%m%d)-$releasever-$device.zip

	# Add Full OTA
	cd ~/updater
	echo "Adding full OTA to list"
	FLASK_APP=updater.app flask addrom -f LOS-14.1-$(date +%Y%m%d)$releasever-$device.zip -d $device -v 14.1 -t "$(date "+%Y-%m-%d %H:%M:%S")" -r $releasetype -m $(md5sum ~/builds/$device/full/LOS-14.1-$(date +%Y%m%d)-$releasever-$device.zip  | awk '{ print $1 }') -u https://rctest.nt.jwolfweb.net/builds/$device/full/LOS-14.1-$(date +%Y%m%d)-$releasever-$device.zip
	cd ~/android/lineage/cm-14.1

	# Package Incremental OTA
	if ! ./build/tools/releasetools/ota_from_target_files -k ~/.android-certs/releasekey --block -i ~/builds/$device/target_files/LOS-14.1-*-$releasetype-$device.zip ~/android/lineage/cm-14.1/signed-target_files.zip ~/builds/$device/delta/LOS-14.1-$(date +%Y%m%d)-$releasever-$device.zip ; then
		echo "Creating Incremental OTA failed. Saving target_files anyways."
		# Save target_files
		mv ~/android/lineage/cm-14.1/signed-target_files.zip ~/builds/$device/target_files/LOS-14.1-$(date +%Y%m%d)-$releasetype-$device.zip
	fi

	# Save old target_files
	mv ~/builds/$device/target_files/LOS-14.1-*-$releasetype-$device.zip ~/builds/$device/target_files/archive/
	
	# Save new target_files
	mv ~/android/lineage/cm-14.1/signed-target_files.zip ~/builds/$device/target_files/LOS-14.1-$(date +%Y%m%d)-$releasever-$device.zip

	cd ~/updater
	killall flask && zsh ./run.sh&!
	
	cd ~/android/lineage/cm-14.1
}

setupenv() {
	cd ~/android/lineage/cm-14.1

	if [ $gapps -eq 0 ]; then
		releasetype=nogapps

		sed -r '281 s/CM_BUILDTYPE := [^ ]*/CM_BUILDTYPE := NOGAPPS/' ~/android/lineage/cm-14.1/vendor/cm/config/common.mk >common.mk
		mv common.mk ~/android/lineage/cm-14.1/vendor/cm/config/common.mk
	elif [ $gapps -eq 1 ]; then
		releasetype=gapps

		sed -r '281 s/CM_BUILDTYPE := [^ ]*/CM_BUILDTYPE := GAPPS/' ~/android/lineage/cm-14.1/vendor/cm/config/common.mk >common.mk
		mv common.mk ~/android/lineage/cm-14.1/vendor/cm/config/common.mk
	fi

	make clobber 

	# Setup build environment
	source build/envsetup.sh 

	# export vars
	export USE_CCACHE=0 CCACHE_DISABLE=1 ANDROID_JACK_VM_ARGS="-Dfile.encoding=UTF-8 -XX:+TieredCompilation -Xmx8G"
}

# Enter main()
if [ $# -gt 0 ]; then
	if [ $# -eq 2 ]; then
		if [ $2 -eq "nogapps" ]; then
			gapps=0
		fi
	fi

	case $1 in
		addison|athene|oneplus3|victara)
			device=$1
			shift

			cd ~/android/lineage/cm-14.1

			setupenv

			bdevice
			;;
		help|-h|--help)
			echo "Usage: build <device> [nogapps]"
			echo ""
			echo "Available devices are:"
			echo "'addison','athene','oneplus3','victara'"
			echo ""
			echo "To build without Google's apps add 'nogapps' to the end of the command."
			echo ""
			echo "using the 'help' subcommand shows this text"
			echo ""
			echo "using the 'version' subcommand outputs version info"
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
	build help
fi