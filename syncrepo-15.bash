#!/bin/bash

version=15.0

#Start
cd ~/android/lineage/lineage-15.0

setuppatches() {
	# Add SafetyNet Patches
	# these will come later

	# Add support for updater
	cd ~/android/lineage/lineage-15.0/packages/apps/Updater/
	sed -r 's/download.lineageos.org/ota.jwolfweb.com/' ~/android/lineage/lineage-15.0/packages/apps/Updater/res/values/strings.xml > strings.xml 
	mv strings.xml ~/android/lineage/lineage-15.0/packages/apps/Updater/res/values/strings.xml
	git stage ~/android/lineage/lineage-15.0/packages/apps/Updater/res/values/strings.xml
	git commit -m "Change update location for Unofficial builds"
	
	cd ~/android/lineage/lineage-15.0
}

if [ $# -gt 0 ]; then
	case $1 in
		help|-h|--help)
			echo "Usage: syncrepo"
			echo ""
			echo "using the 'help' subcommand shows this text"
			echo ""
			echo "using the 'version' subcommand outputs version info"
			;;
		version|-v|--version)
			echo "Version: "$version
			exit
			;;
		*)
			echo "Codename not available for build."
			echo ""
			syncrepo help
			exit
			;;
	esac
fi

# Sync new changes
repo sync

# Setup various patches
setuppatches

# Take me back to the start
cd ~/android/lineage/lineage-15.0