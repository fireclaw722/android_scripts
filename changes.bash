####
#### This isn't an actual script, and it is to
#### function as a how-to merge different changes
####
exit

##
## System-based changes
##
cd ~/android/lineage/nougat-mr1

## Substratum/OMS7 changes
# system/sepolicy
cd ~/android/lineage/nougat-mr1/system/sepolicy
git pull https://github.com/LineageOMS/android_system_sepolicy

# vendor/cm
cd ~/android/lineage/nougat-mr1/vendor/cm
git pull https://github.com/LineageOMS/android_vendor_cm

# frameworks/base
cd ~/android/lineage/nougat-mr1/frameworks/base
git pull https://github.com/LineageOMS/android_frameworks_base

# frameworks/native
cd ~/android/lineage/nougat-mr1/frameworks/native
git pull https://github.com/LineageOMS/android_frameworks_native

# settings
cd ~/android/lineage/nougat-mr1/packages/apps/Settings
git pull https://github.com/LineageOMS/android_packages_apps_Settings

# apps
cd ~/android/lineage/nougat-mr1/packages/apps/Dialer
git pull https://github.com/LineageOMS/android_packages_apps_Dialer

cd ~/android/lineage/nougat-mr1/packages/apps/ContactsCommon
git pull https://github.com/LineageOMS/android_packages_apps_ContactsCommon

cd ~/android/lineage/nougat-mr1/packages/apps/PhoneCommon
git pull https://github.com/LineageOMS/android_packages_apps_PhoneCommon

cd ~/android/lineage/nougat-mr1/packages/apps/Contacts
git pull https://github.com/LineageOMS/android_packages_apps_Contacts

cd ~/android/lineage/nougat-mr1/packages/apps/ExactCalculator
git pull https://github.com/LineageOMS/android_packages_apps_ExactCalculator

cd ~/android/lineage/nougat-mr1/packages/apps/PackageInstaller
git pull https://github.com/LineageOMS/android_packages_apps_PackageInstaller

## Extra System Changes
cd ~/android/lineage/nougat-mr1

# add fdroid and other pre-built apps to build process
cd ~/android/lineage/nougat-mr1/vendor/cm/config/
cat commons-additions.mk >> common.mk

# match AOSP versioning
cd ~/android/lineage/nougat-mr1/vendor/cm/config/
vi common.mk
    # change 
    PRODUCT_VERSION_MAJOR = 14
    PRODUCT_VERSION_MINOR = 1
    PRODUCT_VERSION_MAINTENANCE := 0
    # to 
    PRODUCT_VERSION_MAJOR = 7
    PRODUCT_VERSION_MINOR = 1
    PRODUCT_VERSION_MAINTENANCE := 0

# updater url for cerulean
cd ~/android/lineage/nougat-mr1/packages/apps/Updater/res/values
vi string.xml
    https://updater.ceruleanfire.com/api/v1/{device}/{type}/{incr}
    # to
    https://rctest.ceruleanfire.com/ota/api/v1/{device}/{type}/{incr}

# build-id
cd ~/android/lineage/nougat-mr1/build/core
vi build_id.mk
    export BUILD_ID=NJH47F
    # to
    export BUILD_ID=NMR1.YYMMDD #replace with actual security date info

# Pixel-Blue Bootanimation
cd ~/android/lineage/nougat-mr1/vendor/cm/bootanimation
cp ~/Downloads/bootanimation.tar ./

# Replace Android system emoji with EmojiOne
cd ~/android/lineage/nougat-mr1/external/noto-fonts/other
cp ~/Downloads/NotoColorEmoji.ttf ./

## May or may not be included
# For MicroG Signature-Spoofing support (for reference)
cd ~/android/lineage/nougat-mr1/
patch --no-backup-if-mismatch --strip='1' --directory=frameworks/base < ~/Downloads/GmsCore-android_frameworks_base-N.patch
cd ~/android/lineage/nougat-mr1/frameworks/base
git commit

## Update for new security patches
vendor/cm/build/tools/repopick.py -g https://review.lineageos.org -t asb-2019.03-cm14

##
## Device Specific changes
##

## athene (Moto G4 / Moto G4 Plus)
# device files from LineageOS repos

# SafetyNet Patches
cd ~/android/lineage/nougat-mr1/kernel/motorola/msm8952
git fetch https://github.com/franciscofranco/one_plus_3T oreo-mr1
git cherry-pick b50f418ddd549e22d32377c09f289439bb0f0d60 da7787b36a4d5ed8646e5110aecf1015ca1591db

## victara (Moto X 2014)
# device files from LineageOS repos

# SafetyNet Patches not needed
