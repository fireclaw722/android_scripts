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


## Add SafetyNet Patches
## addison, angler, athene, bullhead, griffin, marlin, oneplus2, oneplus3
# moto-msm8953/addison
# no available ports ; maybe when I have the time ill work on it
cd ~/android/lineage/oreo-mr1/kernel/motorola/msm8953

# angler
cd ~/android/lineage/oreo-mr1/kernel/huawei/angler
git fetch https://github.com/franciscofranco/angler
git cherry-pick f2ead91654706afad119b279dbea6c363526d077 9cb8ecbd16b8886e4bd05d63fff78a32d304e94b

# moto-msm8952/athene
# included in current kernel
cd ~/android/lineage/oreo-mr1/kernel/motorola/msm8952

# bullhead
cd ~/android/lineage/oreo-mr1/kernel/lge/bullhead
git fetch https://github.com/franciscofranco/bullhead
git cherry-pick 9617984cebebefcf83d992fb18d59ffe9e18dba0 7134d85554ec3bb40b5f2ba16b514e0495253937

# moto-msm8996/griffin
cd ~/android/lineage/oreo-mr1/kernel/motorola/msm8996
git fetch https://github.com/franciscofranco/one_plus_3T
git cherry-pick b50f418ddd549e22d32377c09f289439bb0f0d60 da7787b36a4d5ed8646e5110aecf1015ca1591db

# marlin (includes sailfish)
cd ~/android/lineage/oreo-mr1/kernel/google/marlin
git fetch https://github.com/franciscofranco/one_plus_3T
git cherry-pick b50f418ddd549e22d32377c09f289439bb0f0d60 da7787b36a4d5ed8646e5110aecf1015ca1591db

# oneplus-msm8994/oneplus2
cd ~/android/lineage/oreo-mr1/kernel/oneplus/msm8994
git fetch https://github.com/franciscofranco/one_plus_2
git cherry-pick e8c7dc05c6f3686b530896d2ad1457033ab41df1 447de8129ab0d1416a751478b59318bebc67aaab

# oneplus-msm8996/oneplus3
cd ~/android/lineage/oreo-mr1/kernel/oneplus/msm8996
git fetch https://github.com/franciscofranco/one_plus_3T
git cherry-pick b50f418ddd549e22d32377c09f289439bb0f0d60
git commit
git cherry-pick da7787b36a4d5ed8646e5110aecf1015ca1591db

## Fix griffin blobs
cd ~/android/lineage/oreo-mr1/vendor/motorola
git fetch https://github.com/TheMuppets/proprietary_vendor_motorola lineage-15.1
git cherry-pick 0cbffd4187afca5b1bed84fba0d4167bc07c08eb

## add fdroid, and other pre-builts to build process
cd ~/android/lineage/oreo-mr1/vendor/lineage/config/
cat commons-additions.mk >> common.mk

## Change icon-mask back to square
# revert: https://github.com/LineageOS/android_vendor_lineage/commit/d12ab12c6142337fc79a76af50fc3d62bc337626
cd ~/android/lineage/oreo-mr1/vendor/lineage/overlay/common/frameworks/base/core/res/res/values/
sed -r 's/<string name="config_icon_mask" translatable="false">"M50 0A50 50,0,1,1,50 100A50 50,0,1,1,50 0"</string>//' config.xml

## LineageOMS Rebrand
# Change values for updater, version
cd ~/android/lineage/oreo-mr1/lineage-sdk/lineage/res/res/values/
sed -r 's/LineageOS updates/Android Updates/' strings.xml

## Vendor-level patch
cd ~/android/lineage/oreo-mr1/packages/apps/Settings/res/xml
vi device_info_settings.xml
    # change
    <Preference android:key="security_patch"
        android:title="Vendor Security Patch Level"
        android:summary="@string/summary_placeholder">
        <intent android:action="android.intent.action.VIEW"
            android:data="https://source.android.com/security/bulletin/" />
    </Preference>
    # add after
    <Preference android:key="aosp_security_patch"
        android:title="Android Security Patch Level"
        android:summary="June 5, 2018">
        <intent android:action="android.intent.action.VIEW"
            android:data="https://source.android.com/security/bulletin/" />
    </Preference>

## Recovery changes
cd ~/android/lineage/oreo-mr1/
vendor/lineage/build/tools/repopick.py 211098 212944 212711 209638

## No stats collection
cd ~/android/lineage/oreo-mr1/packages/apps/LineageParts/res/values/
sed -r "s/stats.lineageos.org/nostatscollection" config.xml
