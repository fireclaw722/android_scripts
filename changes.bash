####
#### This isn't an actual script, and it is to
#### function as a how-to merge different changes
####
exit

##
## System-based changes
##
cd ~/android/lineage/pie

## Merge Substratum OMS changes from https://substratum.review
# frameworks/base
vendor/lineage/build/tools/repopick.py -f -g https://substratum.review -P frameworks/base 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 20 21 22 

# packages/apps/settings
vendor/lineage/build/tools/repopick.py -f -g https://substratum.review -P packages/apps/Settings 16 17 

vendor/lineage/build/tools/repopick.py -f -g https://substratum.review -P packages/apps/Settings 18 19

## Extra System Changes
cd ~/android/lineage/pie
# unofficial Trust changes (vendor patch level)
vendor/lineage/build/tools/repopick.py -f -g https://review.lineageos.org 229389

# battery styles
vendor/lineage/build/tools/repopick.py -f -g https://review.lineageos.org -t pie-battery-styles

# add fdroid and other pre-built apps to build process
cd ~/android/lineage/pie/vendor/lineage/config/
cat commons-additions.mk >> common.mk

# match AOSP versioning
cd ~/android/lineage/pie/vendor/lineage/config/
vi common.mk

# Change System icon-mask back to square
cd ~/android/lineage/pie/vendor/lineage/overlay/common/frameworks/base/core/res/res/values/
nano config.xml
    # remove
    <string name="config_icon_mask" translatable="false">"M50 0A50 50,0,1,1,50 100A50 50,0,1,1,50 0"</string>

    <!-- Flag indicating whether round icons should be parsed from the application manifest. -->
    <bool name="config_useRoundIcon">true</bool>

# change Trebuchet icon-mask back to square
cd ~/android/lineage/pie/packages/apps/Trebuchet/res/values
nano lineage_adaptive_icons.xml
    # edit
    <string name="icon_shape_default" translatable="false">@string/mask_path_circle</string>
    # to
    <string name="icon_shape_default" translatable="false">@string/mask_path_square</string>

# Replace Android system emoji with EmojiOne
cd ~/android/lineage/pie/external/noto-fonts/emoji
cp ~/Downloads/NotoColorEmoji.ttf ./

# Blue Bootanimation
cd ~/android/lineage/pie/vendor/lineage/bootanimation
cp ~/Downloads/bootanimation.tar ./

## May or may not be included
# For MicroG Signature-Spoofing support (for reference)
cd ~/android/lineage/pie/
patch --no-backup-if-mismatch --strip='1' --directory=frameworks/base < ~/Downloads/GmsCore-android_frameworks_base-P.patch
cd ~/android/lineage/pie/frameworks/base
git commit

##
## Device Specific changes
##

## addison (Moto Z Play)
# clone device/kernel/proprietary files from github.com/fireclaw722

# Moto Mod Battery Efficiency Mode (run twice because it doesn't merge cleanly)
cd ~/android/lineage/pie


# Define Vendor security patch level 
# OPN27.76-12-22 blobs used, but update as needed
# 2018-08-01 OPNS27.76-12-22-9
# 2018-06-01 OPNS27.76-12-22-3
# 2018-04-01 OPN27.76-12-22
cd ~/android/lineage/pie/device/motorola/addison
nano lineage.mk
# Vendor security patch level
PRODUCT_PROPERTY_OVERRIDES += \
    ro.lineage.build.vendor_security_patch=2018-08-01

# SafetyNet Patches ## CURRENTLY BUILDS BUT DOESNT BOOT (WHY?)
cd ~/android/lineage/pie/kernel/motorola/msm8953
git fetch https://github.com/franciscofranco/one_plus_3T oreo-mr1
git cherry-pick b50f418ddd549e22d32377c09f289439bb0f0d60 da7787b36a4d5ed8646e5110aecf1015ca1591db

## athene (Moto G4 / Moto G4 Plus)
# clone device/kernel/proprietary files from github.com/sgspluss

## oneplus3 (Oneplus 3)
# device files from LineageOS repos
git fetch https://github.com/franciscofranco/one_plus_3T oreo-mr1
git cherry-pick b50f418ddd549e22d32377c09f289439bb0f0d60 

git cherry-pick da7787b36a4d5ed8646e5110aecf1015ca1591db
