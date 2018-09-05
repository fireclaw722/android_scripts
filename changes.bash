####
#### This isn't an actual script, and it is to
#### function as a how-to merge different changes
####
exit

##
## System-based changes
##

cd ~/android/lineage/oreo-mr1/
## Merge Substratum OMS changes from substratum gerrit
# frameworks/base :: 460 461 462 463 464 465 466 467 468 469 470 475 476 477 478 481 [485] [487] 488 455 491 423 [424] 425 427 430 431 [448] 454 458 489 492 494 499
vendor/lineage/build/tools/repopick.py -f -g https://substratum.review -P frameworks/base 460 461 462 463 464 465 466 467 468 469 470 475 476 477 478 481 485
vendor/lineage/build/tools/repopick.py -f -g https://substratum.review -P frameworks/base 487
vendor/lineage/build/tools/repopick.py -f -g https://substratum.review -P frameworks/base 488 455 491 423 424
vendor/lineage/build/tools/repopick.py -f -g https://substratum.review -P frameworks/base 425 427 430 431 448
vendor/lineage/build/tools/repopick.py -f -g https://substratum.review -P frameworks/base 454 458 489 492 494 499

# packages/apps/settings :: 471 472 [473] 479 [482] 484 [447] 495 496
vendor/lineage/build/tools/repopick.py -f -g https://substratum.review -P packages/apps/Settings 471 472 473
vendor/lineage/build/tools/repopick.py -f -g https://substratum.review -P packages/apps/Settings 479 482
vendor/lineage/build/tools/repopick.py -f -g https://substratum.review -P packages/apps/Settings 484 447
vendor/lineage/build/tools/repopick.py -f -g https://substratum.review -P packages/apps/Settings 495 496

# system/sepolicy :: 432 450 493
vendor/lineage/build/tools/repopick.py -f -g https://substratum.review -P system/sepolicy 432 450 493

# build :: 459
vendor/lineage/build/tools/repopick.py -f -g https://substratum.review -P build/target 459

## Extra System Changes
# unofficial Trust changes (vendor patch level)
vendor/lineage/build/tools/repopick.py -g https://review.lineageos.org 217171

# Battery styles
vendor/lineage/build/tools/repopick.py -g https://review.lineageos.org -t battery_customisation

# Moto Mod Battery Efficiency Mode (run twice because it doesn't merge cleanly)
vendor/lineage/build/tools/repopick.py -g https://review.lineageos.org -t moto-mods-battery-lineage-15.1

# add fdroid and other pre-built apps to build process
cd ~/android/lineage/oreo-mr1/vendor/lineage/config/
cat commons-additions.mk >> common.mk

# Unofficial updater uses AOSP update settings location
cd ~/android/lineage/oreo-mr1/packages/apps/Settings/res/xml
nano device_info_settings.xml
    # remove
    <!-- LineageOS updates -->
    <org.lineageos.internal.preference.deviceinfo.LineageUpdatesPreference
        android:key="lineage_updates"
        lineage:requiresOwner="true"
        lineage:requiresPackage="org.lineageos.updater" />

# add MicroG location provider to usable location providers
cd ~/android/lineage/oreo-mr1/vendor/lineage/overlay/common/frameworks/base/core/res/res/values/
nano config.xml
    # edit in
     <!-- The Google provider -->
    <item>com.google.android.gms</item>
    <!-- The MicroG provider (UnifiedNlp) -->
    <item>org.microg.nlp</item>


# Change System icon-mask back to square
cd ~/android/lineage/oreo-mr1/vendor/lineage/overlay/common/frameworks/base/core/res/res/values/
nano config.xml
    # remove
    <string name="config_icon_mask" translatable="false">"M50 0A50 50,0,1,1,50 100A50 50,0,1,1,50 0"</string>

# change Trebuchet icon-mask back to square
cd ~/android/lineage/oreo-mr1/packages/apps/Trebuchet/res/values
nano lineage_adaptive_icons.xml
    # edit
    <string name="icon_shape_default" translatable="false">@string/mask_path_circle</string>
    # to
    <string name="icon_shape_default" translatable="false">@string/mask_path_super_ellipse</string>

# Turn LineageOS stats collection off
cd ~/android/lineage/oreo-mr1/vendor/lineage/overlay/common/lineage-sdk/packages/LineageSettingsProvider/res/values/
sed -r 's/true/false/' defaults.xml

# Replace Android system emoji with EmojiOne
cd ~/android/lineage/oreo-mr1/external/noto-fonts/emoji
cp ~/Downloads/NotoColorEmoji.ttf ./

##
## Device Specific changes
##

## addison (Moto Z Play)
# clone device/kernel/proprietary files
cd ~/android/lineage/oreo-mr1
git clone -b lineage-15.1 https://github.com/BtbN/android_device_motorola_addison device/motorola/addison
git clone -b lineage-15.1 https://github.com/BtbN/android_kernel_motorola_msm8953 kernel/motorola/msm8953
git clone -b lineage-15.1 https://github.com/BtbN/proprietary_vendor_motorola vendor/motorola

# greybus additions for Moto-Mods
vendor/lineage/build/tools/repopick.py -g https://review.lineageos.org -t kbd_mod -P kernel/motorola/msm8953

# Define Vendor security patch level OPNS27.76-12-22-3
cd ~/android/lineage/oreo-mr1/device/motorola/addison
nano lineage.mk
# Vendor security patch level
PRODUCT_PROPERTY_OVERRIDES += \
    ro.lineage.build.vendor_security_patch=2018-06-01

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
