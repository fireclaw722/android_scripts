#!/bin/bash

version=14.0.10

# Start
cd ~/android/lineage/cm-14.1

setuppatches() {
	# Add SafetyNet Patches
    cd ~/android/lineage/cm-14.1/kernel/motorola/msm8953
    git fetch https://github.com/franciscofranco/one_plus_3T
    git cherry-pick 4ccdebba15186d6631ca286c8b8348ac3b1f3301 5a9321d9e89dda28c68272e98b9a2e07ba76dbc9

    cd ~/android/lineage/cm-14.1/kernel/motorola/msm8952
    git fetch https://github.com/franciscofranco/one_plus_3T
    git cherry-pick 4ccdebba15186d6631ca286c8b8348ac3b1f3301 5a9321d9e89dda28c68272e98b9a2e07ba76dbc9

	cd ~/android/lineage/cm-14.1/kernel/essential/msm8998
    git fetch https://github.com/franciscofranco/one_plus_3T
    git cherry-pick 4ccdebba15186d6631ca286c8b8348ac3b1f3301 5a9321d9e89dda28c68272e98b9a2e07ba76dbc9

	cd ~/android/lineage/cm-14.1/kernel/google/marlin
    git fetch https://github.com/franciscofranco/one_plus_3T
    git cherry-pick 4ccdebba15186d6631ca286c8b8348ac3b1f3301 5a9321d9e89dda28c68272e98b9a2e07ba76dbc9

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