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

cd ~/android/lineage/nougat-mr1/build/core
vi build_id.mk
    ifndef TARGET_VENDOR_RELEASE_BUILD_ID
        export BUILD_ID=NJH47F
    else
        export BUILD_ID=$(TARGET_VENDOR_RELEASE_BUILD_ID) # dont forget to set at buildtime
    endif

cd ~/android/lineage/oreo-mr1/vendor/lineage/config
vi common.mk
    ifeq ($(TARGET_BUILD_VARIANT),user)
        LINEAGE_VERSION := $(TARGET_VENDOR_RELEASE_BUILD_ID)
    else


# For user/production builds :: this might cause breakage
cd ~/android/lineage/oreo-mr1/system/sepolicy/public
# comment 250-260
# remove on 413 & 416
userdebug_or_eng

##
## Device Specific changes
##

## addison (Moto Z Play)
# clone device/kernel/proprietary files
cd ~/android/lineage/oreo-mr1
git clone -b lineage-15.1 https://github.com/BtbN/android_device_motorola_addison device/motorola/addison
git clone -b lineage-15.1 https://github.com/BtbN/android_kernel_motorola_msm8953 kernel/motorola/msm8953
git clone -b lineage-15.1 https://github.com/BtbN/proprietary_vendor_motorola vendor/motorola

# Moto Mod Battery Efficiency Mode (run twice because it doesn't merge cleanly)
cd ~/android/lineage/oreo-mr1
vendor/lineage/build/tools/repopick.py -f -g https://review.lineageos.org -t moto-mods-battery-lineage-15.1

# greybus additions for Moto-Mods
vendor/lineage/build/tools/repopick.py -g https://review.lineageos.org -t kbd_mod -P kernel/motorola/msm8953

# Define Vendor security patch level 
# OPN27.76-12-22 blobs used, but update as needed
# 2018-08-01 OPNS27.76-12-22-9
# 2018-06-01 OPNS27.76-12-22-3
# * 2018-04-01 OPN27.76-12-22
cd ~/android/lineage/oreo-mr1/device/motorola/addison
nano lineage.mk
# Vendor security patch level
PRODUCT_PROPERTY_OVERRIDES += \
    ro.lineage.build.vendor_security_patch=2018-04-01

# SafetyNet Patches
cd ~/android/lineage/oreo-mr1/kernel/motorola/msm8953
git fetch https://github.com/franciscofranco/one_plus_3T
git cherry-pick b50f418ddd549e22d32377c09f289439bb0f0d60 da7787b36a4d5ed8646e5110aecf1015ca1591db

## athene (Moto G4 / Moto G4 Plus)
# clone device/kernel/proprietary files
cd ~/android/lineage/oreo-mr1
git clone -b lineage-15.1 https://github.com/sgspluss/android_device_motorola_athene device/motorola/athene
git clone -b lineage-15.1 https://github.com/sgspluss/android_kernel_motorola_msm8952 kernel/motorola/msm8952
git clone -b lineage-15.1 https://github.com/sgspluss/proprietary_vendor_motorola vendor/motorola

# Define Vendor security patch level NPJS25.93-14.7-8
cd ~/android/lineage/oreo-mr1/device/motorola/athene
nano lineage.mk
# Vendor security patch level
PRODUCT_PROPERTY_OVERRIDES += \
    ro.lineage.build.vendor_security_patch=2018-04-01

## griffin (Moto Z)
# device files from LineageOS repos

# Moto Mod Battery Efficiency Mode (run twice because it doesn't merge cleanly)
cd ~/android/lineage/oreo-mr1
vendor/lineage/build/tools/repopick.py -f -g https://review.lineageos.org -t moto-mods-battery-lineage-15.1

# SafetyNet Patches
cd ~/android/lineage/oreo-mr1/kernel/motorola/msm8996
git fetch https://github.com/franciscofranco/one_plus_3T
git cherry-pick b50f418ddd549e22d32377c09f289439bb0f0d60 da7787b36a4d5ed8646e5110aecf1015ca1591db

## oneplus3 (Oneplus 3)
# device files from LineageOS repos

# SafetyNet Patches
cd ~/android/lineage/oreo-mr1/kernel/oneplus/msm8996
git fetch https://github.com/franciscofranco/one_plus_3T
git cherry-pick b50f418ddd549e22d32377c09f289439bb0f0d60
git commit
git cherry-pick da7787b36a4d5ed8646e5110aecf1015ca1591db

## pioneer (Xperia XA2)
# device files from LineageOS repos

# SafetyNet Patches
cd ~/android/lineage/oreo-mr1/kernel/motorola/msm8996
git fetch https://github.com/franciscofranco/one_plus_3T
git cherry-pick b50f418ddd549e22d32377c09f289439bb0f0d60 da7787b36a4d5ed8646e5110aecf1015ca1591db
