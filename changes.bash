####
#### This isn't an actual script, and it is to
#### function as a how-to merge different changes
####
exit

##
## System-based changes
##
cd ~/android/lineage/oreo-mr1

## Extra System Changes
cd ~/android/lineage/oreo-mr1
# unofficial Trust changes (vendor patch level)
vendor/lineage/build/tools/repopick.py -f -g https://review.lineageos.org 217171

# Port DU Battery info on ambient display
vendor/lineage/build/tools/repopick.py -f -g https://gerrit.dirtyunicorns.com 2472 -P frameworks/base/

# battery customization
vendor/lineage/build/tools/repopick.py -f -g https://review.lineageos.org 220407 220422
vendor/lineage/build/tools/repopick.py -f https://review.lineageos.org/c/LineageOS/android_packages_apps_LineageParts/+/221756/3 -P packages/apps/LineageParts
vendor/lineage/build/tools/repopick.py -f https://review.lineageos.org/c/LineageOS/android_frameworks_base/+/221716/18 -P frameworks/base/
vendor/lineage/build/tools/repopick.py -f 219299 -P packages/apps/Settings/

# add fdroid and other pre-built apps to build process
cd ~/android/lineage/oreo-mr1/vendor/lineage/config/
cat commons-additions.mk >> common.mk

# match AOSP versioning
cd ~/android/lineage/oreo-mr1/vendor/lineage/config/
vi common.mk
    # change 
    PRODUCT_VERSION_MAJOR = 15
    PRODUCT_VERSION_MINOR = 1
    PRODUCT_VERSION_MAINTENANCE := 0
    # to 
    PRODUCT_VERSION_MAJOR = 8
    PRODUCT_VERSION_MINOR = 1
    PRODUCT_VERSION_MAINTENANCE := 0

# updater url for cerulean
cd ~/android/lineage/oreo-mr1/packages/apps/Updater/res/values
vi strings.xml
    https://updater.ceruleanfire.com/api/v1/{device}/{type}/{incr}
    # to
    https://rctest.ceruleanfire.com/ota/api/v1/{device}/{type}/{incr}

# build-id
cd ~/android/lineage/oreo-mr1/build/core
vi build_id.mk
    export BUILD_ID=
    # to
    export BUILD_ID=OMR1.YYMMDD #replace with actual security date info

# Change System icon-mask back to square
cd ~/android/lineage/oreo-mr1/vendor/lineage/overlay/common/frameworks/base/core/res/res/values/
vi config.xml
    # remove
    <string name="config_icon_mask" translatable="false">"M50 0A50 50,0,1,1,50 100A50 50,0,1,1,50 0"</string>

    <!-- Flag indicating whether round icons should be parsed from the application manifest. -->
    <bool name="config_useRoundIcon">true</bool>

# change Trebuchet icon-mask back to square
cd ~/android/lineage/oreo-mr1/packages/apps/Trebuchet/res/values
vi lineage_adaptive_icons.xml
    # edit
    <string name="icon_shape_default" translatable="false">@string/mask_path_circle</string>
    # to
    <string name="icon_shape_default" translatable="false">@string/mask_path_super_ellipse</string>

# Replace Android system emoji with EmojiOne
cd ~/android/lineage/oreo-mr1/external/noto-fonts/emoji
cp ~/Downloads/NotoColorEmoji.ttf ./

# Blue Bootanimation
cd ~/android/lineage/oreo-mr1/vendor/lineage/bootanimation
cp ~/Downloads/bootanimation.tar ./

cd ~/android/lineage/oreo-mr1/frameworks/base
# Battery Icon (pointy)
git revert 6a600b8f628ddfbcaddc8dc281684b8edf294005
# Other status bar icons
git revert ac9fcf9f1cd85032c251850922ab943f3f86ccd4

# For user/production builds :: this might cause breakage
cd ~/android/lineage/oreo-mr1/system/sepolicy/public
vi domain.te
    # comment 250-260
    # remove on 413 & 416
    userdebug_or_eng

# revert "Make A/B backuptool permissive" because that breaks user builds by making a domain permissive
cd ~/android/lineage/oreo-mr1/device/lineage/sepolicy
git revert 9c28a0dfb91bb468515e123b1aaf3fcfc007b82f

cd ~/android/lineage/oreo-mr1/system/update_engine/
git revert eb9d3414cf991ffe387e4d6adcb8efbef17639c8

# MicroG Signature-Spoofing support
cd ~/android/lineage/oreo-mr1/
patch --no-backup-if-mismatch --strip='1' --directory=frameworks/base < ~/Downloads/GmsCore-android_frameworks_base-O.patch
cd ~/android/lineage/oreo-mr1/frameworks/base
git commit

##
## Device Specific changes
##

## addison (Moto Z Play)
# clone device/kernel/proprietary files from github.com/fireclaw722

# Moto Mod Battery Efficiency Mode (run twice because it doesn't merge cleanly)
cd ~/android/lineage/oreo-mr1
vendor/lineage/build/tools/repopick.py -f -g https://review.lineageos.org -t moto-mods-battery-lineage-15.1

# Define Vendor security patch level 
# OPN27.76-12-22 blobs used, but update as needed
# 2018-08-01 OPNS27.76-12-22-9
# 2018-06-01 OPNS27.76-12-22-3
# 2018-04-01 OPN27.76-12-22
cd ~/android/lineage/oreo-mr1/device/motorola/addison
nano lineage.mk
# Vendor security patch level
PRODUCT_PROPERTY_OVERRIDES += \
    ro.lineage.build.vendor_security_patch=2018-08-01

# SafetyNet Patches ## CURRENTLY BUILDS BUT DOESNT BOOT (WHY?)
cd ~/android/lineage/oreo-mr1/kernel/motorola/msm8953
git fetch https://github.com/franciscofranco/one_plus_3T oreo-mr1
git cherry-pick b50f418ddd549e22d32377c09f289439bb0f0d60 da7787b36a4d5ed8646e5110aecf1015ca1591db

## athene (Moto G4 / Moto G4 Plus)
# clone device/kernel/proprietary files from github.com/sgspluss

# Define Vendor security patch level NPJS25.93-14.7-8
cd ~/android/lineage/oreo-mr1/device/motorola/athene
nano lineage.mk
# Vendor security patch level
PRODUCT_PROPERTY_OVERRIDES += \
    ro.lineage.build.vendor_security_patch=2018-04-01

## oneplus3 (Oneplus 3)
# device files from LineageOS repos

# SafetyNet Patches
cd ~/android/lineage/oreo-mr1/kernel/oneplus/msm8996
git fetch https://github.com/franciscofranco/one_plus_3T oreo-mr1
git cherry-pick b50f418ddd549e22d32377c09f289439bb0f0d60
git commit
git cherry-pick da7787b36a4d5ed8646e5110aecf1015ca1591db
