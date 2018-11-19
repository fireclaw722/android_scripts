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

# apps
cd ~/android/lineage/nougat-mr1/packages/apps/Dialer
git pull https://github.com/LineageOMS/android_packages_apps_Dialer

cd ~/android/lineage/nougat-mr1/packages/apps/Settings
git pull https://github.com/LineageOMS/android_packages_apps_Settings

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

# Blue Bootanimation
cd ~/android/lineage/nougat-mr1/vendor/cm/bootanimation
cp ~/Downloads/bootanimation.tar ./

# Unofficial updater uses AOSP update settings location
cd ~/android/lineage/nougat-mr1/packages/apps/Settings/res/xml
nano device_info_settings.xml
    # remove
    <!-- LineageOS updates -->

# Turn LineageOS stats collection off
cd ~/android/lineage/nougat-mr1/packages/apps/CMParts/res/values
sed -r 's/stats.lineageos.org/blank.nourl.nothanks/' config.xml

# Replace Android system emoji with EmojiOne
cd ~/android/lineage/nougat-mr1/external/noto-fonts/other
cp ~/Downloads/NotoColorEmoji.ttf ./

## May or may not be included
# For MicroG Signature-Spoofing support (for reference)
patch --no-backup-if-mismatch --strip='1' --directory=frameworks/base < ~/Downloads/GmsCore-android_frameworks_base-O.patch
cd ~/android/lineage/oreo-mr1/frameworks/base
git commit

# Cerulean
cd ~/android/lineage/nougat-mr1/vendor/cmsdk/cm/res/res/values
sed -r 's/LineageOS/Cerulean/' strings.xml > strings.xml.new
rm strings.xml 
mv strings.xml.new strings.xml
sed -r 's/Lineage/Cerulean/' strings.xml > strings.xml.new
rm strings.xml 
mv strings.xml.new strings.xml

cd ~/android/lineage/nougat-mr1/packages/apps/Updater/res/values
sed -r 's/LineageOS/Cerulean/' strings.xml > strings.xml.new
rm strings.xml 
mv strings.xml.new strings.xml
sed -r 's/Lineage/Cerulean/' strings.xml > strings.xml.new
rm strings.xml 
mv strings.xml.new strings.xml

# Make Build-ID and Lineage-Version more configurable
cd ~/android/lineage/nougat-mr1/build/core
vi build_id.mk
    ifndef TARGET_VENDOR_RELEASE_BUILD_ID
        export BUILD_ID=NJH47F
    else
        export BUILD_ID=$(TARGET_VENDOR_RELEASE_BUILD_ID) # dont forget to set at buildtime
    endif

cd ~/android/lineage/nougat-mr1/vendor/cm/config
vi common.mk
    ifeq ($(TARGET_BUILD_VARIANT),user)
        LINEAGE_VERSION := $(TARGET_VENDOR_RELEASE_BUILD_ID)
    else

##
## Device Specific changes
##

## athene (Moto G4 / Moto G4 Plus)
# device files from LineageOS repos

# SafetyNet Patches
cd ~/android/lineage/oreo-mr1/kernel/motorola/msm8952
git fetch https://github.com/franciscofranco/one_plus_3T
git cherry-pick b50f418ddd549e22d32377c09f289439bb0f0d60 da7787b36a4d5ed8646e5110aecf1015ca1591db

## victara (Moto X 2014)
# device files from LineageOS repos

# SafetyNet Patches
cd ~/android/lineage/oreo-mr1/kernel/motorola/msm8974
git fetch https://github.com/franciscofranco/one_plus_3T
git cherry-pick b50f418ddd549e22d32377c09f289439bb0f0d60 da7787b36a4d5ed8646e5110aecf1015ca1591db
