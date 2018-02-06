#!/bin/bash

version=14.0.11

# Start
cd ~/android/lineage/cm-14.1

setuppatches() {
	# Add SafetyNet Patches
    cd ~/android/lineage/cm-14.1/kernel/motorola/msm8953
    git fetch https://github.com/franciscofranco/one_plus_3T
    git cherry-pick 8e65978cec11a62b0404d88db43adb35f3258e7d c97c758b15ba49bb848e0644089432569145ade3

    cd ~/android/lineage/cm-14.1/kernel/motorola/msm8952
    git fetch https://github.com/franciscofranco/one_plus_3T
    git cherry-pick 8e65978cec11a62b0404d88db43adb35f3258e7d c97c758b15ba49bb848e0644089432569145ade3

	# Add support for updater
	cd ~/android/lineage/cm-14.1/packages/apps/Updater/
	sed -r 's/download.lineageos.org/ota.jwolfweb.com/' ~/android/lineage/cm-14.1/packages/apps/Updater/res/values/strings.xml > strings.xml 
	mv strings.xml ~/android/lineage/cm-14.1/packages/apps/Updater/res/values/strings.xml
	git stage ~/android/lineage/cm-14.1/packages/apps/Updater/res/values/strings.xml
	git commit -m "Change update location for Unofficial builds"
	
	cd ~/android/lineage/cm-14.1
}

if [ $# -gt 0 ]; then
	case $1 in
		help|-h|--help)
			echo "Usage: syncrepo"
			echo ""
			echo "using the 'help' subcommand shows this text"
			echo ""
			echo "using the 'version' subcommand outputs version info"
			exit
			;;
		version|-v|--version)
			echo "Version: "$version
			exit
			;;
		*)
			echo "Error: Please see usage"
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
cd ~/android/lineage/cm-14.1