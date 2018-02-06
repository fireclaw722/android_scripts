## Themes

# pull LineageOMS for rootless substratum support
cd ~/android/lineage/cm-14.1/frameworks/base
git pull https://github.com/LineageOMS/android_frameworks_base

cd ~/android/lineage/cm-14.1/frameworks/native
git pull https://github.com/LineageOMS/android_frameworks_native

cd ~/android/lineage/cm-14.1/packages/apps/Contacts
git pull https://github.com/LineageOMS/android_packages_apps_Contacts

cd ~/android/lineage/cm-14.1/packages/apps/ContactsCommon
git pull https://github.com/LineageOMS/android_packages_apps_ContactsCommon

cd ~/android/lineage/cm-14.1/packages/apps/Dialer
git pull https://github.com/LineageOMS/android_packages_apps_Dialer

cd ~/android/lineage/cm-14.1/packages/apps/ExactCalculator
git pull https://github.com/LineageOMS/android_packages_apps_ExactCalculator

cd ~/android/lineage/cm-14.1/packages/apps/PackageInstaller
git pull https://github.com/LineageOMS/android_packages_apps_PackageInstaller

cd ~/android/lineage/cm-14.1/packages/apps/PhoneCommon
git pull https://github.com/LineageOMS/android_packages_apps_PhoneCommon

cd ~/android/lineage/cm-14.1/packages/apps/Settings
git pull https://github.com/LineageOMS/android_packages_apps_Settings

cd ~/android/lineage/cm-14.1/system/sepolicy
git pull https://github.com/LineageOMS/android_system_sepolicy

cd ~/android/lineage/cm-14.1/vendor/cm
git pull https://github.com/LineageOMS/android_vendor_cm

# clone ThemeInterfacer for working substratum
cd ~/android/lineage/cm-14.1/packages/services
git clone -b n-rootless https://github.com/substratum/interfacer ThemeInterfacer

# Add support for Color Engine
cd ~/android/lineage/cm-14.1
repopick -f -g https://review.lineageos.org -t pa-color-engine

## Add SafetyNet Patches
# moto-msm8953/addison
cd ~/android/lineage/cm-14.1/kernel/motorola/msm8953
git fetch https://github.com/franciscofranco/one_plus_3T
git cherry-pick 8e65978cec11a62b0404d88db43adb35f3258e7d c97c758b15ba49bb848e0644089432569145ade3

# moto-msm8952/athene
cd ~/android/lineage/cm-14.1/kernel/motorola/msm8952
git fetch https://github.com/franciscofranco/one_plus_3T
git cherry-pick 8e65978cec11a62b0404d88db43adb35f3258e7d c97c758b15ba49bb848e0644089432569145ade3

# oneplus-msm8996/oneplus3 included in sultanxda's sources
# moto-msm8974/victara not applicable :: no bootloader check on safetynet

## Extras
# add Google Apps, fdroid, and other pre-builts to build process
cd ~/android/lineage/cm-14.1/vendor/cm/config/
cat commons-additions.mk >> commons.mk

# Remove perfprofd from sepolicy so lineage_athene-user builds will actually build
cd ~/android/lineage/cm-14.1/device/motorola/athene/sepolicy/
sed -r 's/allow kernel perfprofd:process setsched;//' kernel.te

# Add support for updater
cd ~/android/lineage/cm-14.1/packages/apps/Updater/res/values/
sed -r 's/download.lineageos.org/ota.jwolfweb.com/' strings.xml