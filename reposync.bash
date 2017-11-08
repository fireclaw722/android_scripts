#!/bin/bash

#Start
cd ~/android/lineage/cm-14.1

updateLineage() {
	cd ~/android/lineage/cm-14.1/vendor/cm
	git -c core.editor=true pull https://github.com/LineageOS/android_vendor_cm cm-14.1
	git push origin HEAD:cm-14.1

	cd ~/android/lineage/cm-14.1/frameworks/base
	repo sync --force-sync ./
	git -c core.editor=true pull https://github.com/LineageOS/android_frameworks_base cm-14.1
	git push origin HEAD:cm-14.1

	cd ~/android/lineage/cm-14.1/packages/apps/Settings
	repo sync --force-sync ./
	git -c core.editor=true pull https://github.com/LineageOS/android_packages_apps_Settings cm-14.1
	git push origin HEAD:cm-14.1

	cd ~/android/lineage/cm-14.1/packages/apps/ContactsCommon
	repo sync --force-sync ./
	git -c core.editor=true pull https://github.com/LineageOS/android_packages_apps_ContactsCommon cm-14.1
	git push origin HEAD:cm-14.1

	cd ~/android/lineage/cm-14.1/packages/apps/PhoneCommon
	repo sync --force-sync ./
	git -c core.editor=true pull https://github.com/LineageOS/android_packages_apps_PhoneCommon cm-14.1
	git push origin HEAD:cm-14.1

	cd ~/android/lineage/cm-14.1/packages/apps/Contacts
	repo sync --force-sync ./
	git -c core.editor=true pull https://github.com/LineageOS/android_packages_apps_Contacts cm-14.1
	git push origin HEAD:cm-14.1

	cd ~/android/lineage/cm-14.1/system/sepolicy
	repo sync --force-sync ./
	git -c core.editor=true pull https://github.com/LineageOS/android_system_sepolicy cm-14.1
	git push origin HEAD:cm-14.1

	cd ~/android/lineage/cm-14.1/frameworks/native
	repo sync --force-sync ./
	git -c core.editor=true pull https://github.com/LineageOS/android_frameworks_native cm-14.1
	git push origin HEAD:cm-14.1

	cd ~/android/lineage/cm-14.1/packages/apps/ExactCalculator
	repo sync --force-sync ./
	git -c core.editor=true pull https://github.com/LineageOS/android_packages_apps_ExactCalculator cm-14.1
	git push origin HEAD:cm-14.1

	cd ~/android/lineage/cm-14.1/packages/apps/PackageInstaller
	repo sync --force-sync ./
	git -c core.editor=true pull https://github.com/LineageOS/android_packages_apps_PackageInstaller.git cm-14.1
	git push origin HEAD:cm-14.1

	cd ~/android/lineage/cm-14.1/packages/apps/Dialer
	repo sync --force-sync ./
	git -c core.editor=true pull https://github.com/LineageOS/android_packages_apps_Dialer cm-14.1
	git push origin HEAD:cm-14.1
}

setuppatches() {
	# Add SafetyNet Patches
    cd ~/android/lineage/cm-14.1/kernel/motorola/msm8953
    git fetch https://github.com/franciscofranco/one_plus_3T
    git cherry-pick 4ccdebba15186d6631ca286c8b8348ac3b1f3301 5a9321d9e89dda28c68272e98b9a2e07ba76dbc9

    cd ~/android/lineage/cm-14.1/kernel/motorola/msm8952
    git fetch https://github.com/franciscofranco/one_plus_3T
    git cherry-pick 4ccdebba15186d6631ca286c8b8348ac3b1f3301 5a9321d9e89dda28c68272e98b9a2e07ba76dbc9

    cd ~/android/lineage/cm-14.1/kernel/oneplus
    rm -rf msm8996
    git clone https://github.com/franciscofranco/one_plus_3T -b lineageos-14.1 msm8996

	# Add support for updater
	cd ~/android/lineage/cm-14.1/packages/apps/Updater/
	sed -r 's/download.lineageos.org/ota.jwolfweb.com/' ~/android/lineage/cm-14.1/packages/apps/Updater/res/values/strings.xml > strings.xml 
	mv strings.xml ~/android/lineage/cm-14.1/packages/apps/Updater/res/values/strings.xml
	git commit -m "Change update location for Unofficial builds"

	cd ~/android/lineage/cm-14.1

	## Add UnifiedNlp patch
	wget -O ~/Downloads/UnifiedNlp-android_frameworks_base-N.patch https://raw.githubusercontent.com/microg/android_packages_apps_UnifiedNlp/master/patches/android_frameworks_base-N.patch
	patch --forward --no-backup-if-mismatch --strip='1' --directory='frameworks/base' < ~/Downloads/UnifiedNlp-android_frameworks_base-N.patch 
	rm -f ~/Downloads/UnifiedNlp-android_frameworks_base-N.patch
	
	cd ~/android/lineage/cm-14.1
}

# Sync new changes
repo sync

# Update the LineageOS base
updateLineage

# Setup various patches
setuppatches

# Take me back to the start
cd ~/android/lineage/cm-14.1