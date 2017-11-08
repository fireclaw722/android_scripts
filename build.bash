#!/bin/bash

# Variables
device=
releasetype=
stable=
releasever=NJH47F
version=0.29

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
			echo "Try regular/userdebug?"
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
	if [ $stable -eq 1 ]; then
		./build/tools/releasetools/img_from_target_files signed-target_files.zip ~/builds/$device/img/fireLOS-14.1-$(date +%Y%m%d)-$device.zip
	fi
	
	# Package Full OTA
	if ! ./build/tools/releasetools/ota_from_target_files -k ~/.android-certs/releasekey --block --backup=true signed-target_files.zip signed-ota_update.zip ; then
		echo "Creating OTA .zip failed"
		exit
	fi

	# Save Full OTA
	mv ~/android/lineage/cm-14.1/signed-ota_update.zip ~/builds/$device/full/LOS-14.1-$(date +%Y%m%d)$releasever-$device.zip

	# Add Full OTA
	cd ~/updater
	echo "Adding full OTA to list"
	FLASK_APP=updater.app flask addrom -f LOS-14.1-$(date +%Y%m%d)$releasever-$device.zip -d $device -v 14.1 -t "$(date "+%Y-%m-%d %H:%M:%S")" -r $releasetype -m $(md5sum ~/builds/$device/full/LOS-14.1-$(date +%Y%m%d)$releasever-$device.zip  | awk '{ print $1 }') -u https://rctest.nt.jwolfweb.net/builds/$device/full/LOS-14.1-$(date +%Y%m%d)$releasever-$device.zip
	cd ~/android/lineage/cm-14.1

	# Package Incremental OTA
	if ! ./build/tools/releasetools/ota_from_target_files -k ~/.android-certs/releasekey --block -i ~/builds/$device/target_files/fireLOS-14.1-*-$releasetype-$device.zip ~/android/lineage/cm-14.1/signed-target_files.zip ~/builds/$device/delta/LOS-14.1-$(date +%Y%m%d)$releasever-$device.zip ; then
		echo "Creating Incremental OTA failed. Saving target_files anyways."
		# Save target_files
		mv ~/android/lineage/cm-14.1/signed-target_files.zip ~/builds/$device/target_files/LOS-14.1-$(date +%Y%m%d)$releasever-$device.zip
		exit
	fi

	# Save old target_files
	mv ~/builds/$device/target_files/fireLOS-14.1-*-$releasetype-$device.zip ~/builds/$device/target_files/archive/
	
	# Save new target_files
	mv ~/android/lineage/cm-14.1/signed-target_files.zip ~/builds/$device/target_files/LOS-14.1-$(date +%Y%m%d)$releasever-$device.zip
	
	## Future code for possible incremental updates
#		echo "Adding delta OTA to list"
#		cd ~/updater
#		# Remove Full OTA
#		FLASK_APP=updater.app flask delrom -f LOS-14.1-$(date +%Y%m%d)$releasever-$device.zip
#
#		# Add Incremental OTA
#		FLASK_APP=updater.app flask addrom -f LOS-14.1-$(date +%Y%m%d)$releasever-$device.zip -d $device -v 14.1 -t "$(date "+%Y-%m-%d %H:%M:%S")" -r $releasetype -m $(md5sum ~/builds/$device/delta/LOS-14.1-$(date +%Y%m%d)$releasever-$device.zip | awk '{ print $1 }') -u https://rctest.nt.jwolfweb.net/builds/$device/delta/LOS-14.1-$(date +%Y%m%d)$releasever-$device.zip

	cd ~/updater
	killall flask && zsh ./run.sh&!
	
	cd ~/android/lineage/cm-14.1
}

setupenv() {
	cd ~/android/lineage/cm-14.1 

	make clobber 

	# Setup build environment
	source build/envsetup.sh 

	# export vars
	export CM_BUILDTYPE=SNAPSHOT
	if [ $stable -eq 1 ] ; then
		export CM_EXTRAVERSION=$releasever
		releasever=-NJH47F
	elif [ $stable -eq 0 ] ; then
		export WITH_SU=true
		releasever=
	fi
	
	# No CCACHE
	export USE_CCACHE=0
	unset 'CCACHE_DISABLE' && export 'CCACHE_DISABLE=1'

	export ANDROID_JACK_VM_ARGS="-Dfile.encoding=UTF-8 -XX:+TieredCompilation -Xmx8G"
}

# Enter main()
if [ $# -gt 0 ]; then
	# Parse Args
	case $1 in
		addison|athene|oneplus3|victara)
			device=$1
			
			shift

			#sed -r '281 s/CM_BUILDTYPE := [^ ]*/CM_BUILDTYPE := UNOFFICIAL/' ~/android/lineage/cm-14.1/vendor/cm/config/common.mk >common.mk
			#mv common.mk ~/android/lineage/cm-14.1/vendor/cm/config/common.mk

			rm -rf ~/android/lineage/cm-14.1/kernel/oneplus/msm8996

			cd ~/android/lineage/cm-14.1

			stable=0
			releasetype=experimental

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
			esac

			#sed -r '281 s/CM_BUILDTYPE := [^ ]*/CM_BUILDTYPE := STABLE/' ~/android/lineage/cm-14.1/vendor/cm/config/common.mk >common.mk
			#mv common.mk ~/android/lineage/cm-14.1/vendor/cm/config/common.mk

			cd ~/android/lineage/cm-14.1

			stable=1
			releasetype=snapshot

			setupenv

			bdevice
			;;
		help|-h|--help)
			echo "Please use a codename for the device you wish to build."
			echo ""
			echo "Available devices are:"
			echo "'addison','athene','oneplus3','victara'"
			echo "add '-stable' to build a snapshot"
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