####
#### This isn't an actual script, and it is to
#### function as a how-to merge different changes
####
exit

## Merge Substratum OMS changes from substratum gerrit 
# [num] means non-clean merge
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

## unofficial addison builds
# proprietary blobs
cd ~/android/lineage/oreo-mr1/vendor/motorola
git pull https://github.com/BtbN/proprietary_vendor_motorola

# kernel
cd ~/android/lineage/oreo-mr1/kernel/motorola
git clone -b lineage-15.1 https://github.com/BtbN/android_kernel_motorola_msm8953 msm8953

# device-tree
cd ~/android/lineage/oreo-mr1/device/motorola
git clone -b lineage-15.1 https://github.com/BtbN/android_device_motorola_addison addison

# Battery Mods + Efficiency mode
# import manually "branch:lineage-15.1 topic:moto-mods"
cd ~/android/lineage/oreo-mr1/
vendor/lineage/build/tools/repopick.py -f -g https://review.lineageos.org -t moto-mods-battery-lineage-15.1

# Define Vendor security patch level OPN27.76-12-22
cd ~/android/lineage/oreo-mr1/device/motorola/addison
nano lineage.mk
    # Vendor security patch level
    PRODUCT_PROPERTY_OVERRIDES += \
        ro.lineage.build.vendor_security_patch=2018-04-01

## unofficial athene builds
# proprietary blobs
cd ~/android/lineage/oreo-mr1/vendor/motorola
git pull https://github.com/sgspluss/proprietary_vendor_motorola

# kernel
cd ~/android/lineage/oreo-mr1/kernel/motorola
git clone -b lineage-15.1 https://github.com/sgspluss/android_kernel_motorola_msm8952 msm8952

# device-tree
cd ~/android/lineage/oreo-mr1/device/motorola
git clone -b lineage-15.1 https://github.com/sgspluss/android_device_motorola_athene athene

# Define Vendor security patch level NPJS25.93-14.7-8
cd ~/android/lineage/oreo-mr1/device/motorola/athene
nano lineage.mk
    # Vendor security patch level
    PRODUCT_PROPERTY_OVERRIDES += \
        ro.lineage.build.vendor_security_patch=2018-04-01

## Add SafetyNet Patches
# moto-msm8953/addison
cd ~/android/lineage/oreo-mr1/kernel/motorola/msm8953
git fetch https://github.com/franciscofranco/one_plus_3T
git cherry-pick b50f418ddd549e22d32377c09f289439bb0f0d60 da7787b36a4d5ed8646e5110aecf1015ca1591db

# moto-msm8996/griffin
cd ~/android/lineage/oreo-mr1/kernel/motorola/msm8996
git fetch https://github.com/franciscofranco/one_plus_3T
git cherry-pick b50f418ddd549e22d32377c09f289439bb0f0d60 da7787b36a4d5ed8646e5110aecf1015ca1591db

# oneplus-msm8996/oneplus3
cd ~/android/lineage/oreo-mr1/kernel/oneplus/msm8996
git fetch https://github.com/franciscofranco/one_plus_3T
git cherry-pick b50f418ddd549e22d32377c09f289439bb0f0d60
git commit
git cherry-pick da7787b36a4d5ed8646e5110aecf1015ca1591db

# unofficial Trust changes (vendor patch level)
cd ~/android/lineage/oreo-mr1/
vendor/lineage/build/tools/repopick.py -g https://review.lineageos.org 217171

## add fdroid and other pre-builts to build process
cd ~/android/lineage/oreo-mr1/vendor/lineage/config/
cat commons-additions.mk >> common.mk

# Move updates to fore-front
cd ~/android/lineage/oreo-mr1/packages/apps/Settings/res/xml
nano device_info_settings.xml
    # remove
    <!-- LineageOS updates -->
    <org.lineageos.internal.preference.deviceinfo.LineageUpdatesPreference
        android:key="lineage_updates"
        lineage:requiresOwner="true"
        lineage:requiresPackage="org.lineageos.updater" />

### Cerulean-specific changes ###
# Change icon-mask back to square
# revert: https://github.com/LineageOS/android_vendor_lineage/commit/d12ab12c6142337fc79a76af50fc3d62bc337626
cd ~/android/lineage/oreo-mr1/vendor/lineage/overlay/common/frameworks/base/core/res/res/values/
nano config.xml
    # remove
    <string name="config_icon_mask" translatable="false">"M50 0A50 50,0,1,1,50 100A50 50,0,1,1,50 0"</string>

# Change values for updater, version
cd ~/android/lineage/oreo-mr1/lineage-sdk/lineage/res/res/values/
sed -r 's/LineageOS/Cerulean/' strings.xml

cd ~/android/lineage/oreo-mr1/packages/apps/Updater/res/values
sed -r 's/Lineage/Cerulean/' strings.xml

# Change Major Version
cd ~/android/lineage/oreo-mr1/vendor/lineage/config/
nano common.mk
    # edit
    PRODUCT_VERSION_MAJOR = 15
    # to 
    PRODUCT_VERSION_MAJOR = 8

# EmojiOne
cd ~/android/lineage/oreo-mr1/external/noto-fonts/emoji
cp ~/Downloads/NotoColorEmoji.ttf ./

# Win8 bootanimation
cd ~/android/lineage/oreo-mr1/vendor/lineage/bootanimation
cp ~/Downloads/windows-8-bootanim/bootanimation.tar ./
cp ~/Downloads/windows-8-bootanim/desc.txt ./
