#!/bin/bash

#Start
cd ~/android/lineage/lineage-15.0

setuppatches() {
	# Add SafetyNet Patches
	
    #cd ~/android/lineage/lineage-15.0/kernel/motorola/msm8953
    #git fetch https://github.com/franciscofranco/one_plus_3T
    #git cherry-pick 4ccdebba15186d6631ca286c8b8348ac3b1f3301 5a9321d9e89dda28c68272e98b9a2e07ba76dbc9

    #cd ~/android/lineage/lineage-15.0/kernel/motorola/msm8952
    #git fetch https://github.com/franciscofranco/one_plus_3T
    #git cherry-pick 4ccdebba15186d6631ca286c8b8348ac3b1f3301 5a9321d9e89dda28c68272e98b9a2e07ba76dbc9

    #cd ~/android/lineage/lineage-15.0/kernel/oneplus/msm8996
	#git fetch https://github.com/franciscofranco/one_plus_3T
    #git cherry-pick 4ccdebba15186d6631ca286c8b8348ac3b1f3301 5a9321d9e89dda28c68272e98b9a2e07ba76dbc9

	# Add support for updater
	cd ~/android/lineage/lineage-15.0/packages/apps/Updater/
	sed -r 's/download.lineageos.org/ota.jwolfweb.com/' ~/android/lineage/lineage-15.0/packages/apps/Updater/res/values/strings.xml > strings.xml 
	mv strings.xml ~/android/lineage/lineage-15.0/packages/apps/Updater/res/values/strings.xml
	git stage ~/android/lineage/lineage-15.0/packages/apps/Updater/res/values/strings.xml
	git commit -m "Change update location for Unofficial builds"
	
	cd ~/android/lineage/lineage-15.0
}

# Sync new changes
repo sync

# Setup various patches
setuppatches

# Take me back to the start
cd ~/android/lineage/lineage-15.0