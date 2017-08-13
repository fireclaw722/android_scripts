#!/bin/bash

device=
todate='date +%Y%m%d'

bdevice() {
	# Ensure proper starting location
	cd ~/lineage
		
	# Breakfast
        breakfast $device

        # Run build
	brunch $device
	
	# Move to ~/build
	cp ~/lineage/out/target/product/$device/lineage-14.1*.zip ~/build/$device/lineageOMS-14.1-$todate-$device.zip
	
	# Generate hashes
	# sha256
	sha256sum ~/build/$device/lineageOMS-14.1-$todate-$device.zip > ~/build/$device/lineageOMS-14.1-$todate-$device.zip.sha256
	# sha1
	sha1sum ~/build/$device/lineageOMS-14.1-$todate-$device.zip > ~/build/$device/lineageOMS-14.1-$todate-$device.zip.sha1
	# md5
	md5sum ~/build/$device/lineageOMS-14.1-$todate-$device.zip > ~/build/$device/lineageOMS-14.1-$todate-$device.zip.md5

        # Move back to original directory
        cd ~/lineage
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

cd /home/builder/lineage

if [ $# -gt 0 ]; then

        # Parse Args
        case $1 in
                addison|athene|victara)
                        device=$1
                        shift
                        setupenv
                        bdevice
                        ;;
                help|-h|--help)
                        echo "Please use a codename for the device you wish to build."
                        echo "Available devices are:"
                        echo "'addison','athene','victara','all'**"
                        echo "**'all' will build all available devices!"
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
                *)
                        echo "Codename not available for build. Available devices are:"
                        echo "'all','athene','oneplus3','victara'"

        esac
else
        echo "Please use a codename for the device you wish to build."
fi
