### Merge Substratum OMS changes from substratum gerrit 
### [num] means non-clean merge
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
# moto-msm8953/addison
### NOT INCLUDED BECAUSE ADDISON ISNT PORTED TO 15.1
cd ~/android/cerulean/oreo-mr1/kernel/motorola/msm8953

# moto-msm8952/athene
### NOT INCLUDED BECAUSE ATHENE ISNT PORTED TO 15.1
cd ~/android/cerulean/oreo-mr1/kernel/motorola/msm8952

# oneplus-msm8996/oneplus3
cd ~/android/cerulean/oreo-mr1/kernel/oneplus/msm8996
git fetch https://github.com/franciscofranco/one_plus_3T
git cherry-pick 8e65978cec11a62b0404d88db43adb35f3258e7d c97c758b15ba49bb848e0644089432569145ade3

# moto-msm8974/victara not applicable :: no bootloader check on safetynet

### Remove modemAssertion from device/oneplus/oneplus3/releasetools.py
    # Replace
    def IncrementalOTA_Assertions(info):
        AddModemAssertion(info)
        return
    # With
    def IncrementalOTA_Assertions(info):
        return

## Extras
# add Google Apps, fdroid, and other pre-builts to build process
cd ~/android/cerulean/oreo-mr1/vendor/lineage/config/
cat commons-additions.mk >> common.mk

# Change icon-mask back to square
# revert: https://github.com/LineageOS/android_vendor_lineage/commit/d12ab12c6142337fc79a76af50fc3d62bc337626
cd ~/android/cerulean/oreo-mr1/vendor/lineage/overlay/common/frameworks/base/core/res/res/values/
sed -r 's/<string name="config_icon_mask" translatable="false">"M50 0A50 50,0,1,1,50 100A50 50,0,1,1,50 0"</string>//' config.xml

# add blue bootanimation
cp ~/Downloads/blue-los-bootanimation.tar ~/android/cerulean/oreo-mr1/vendor/lineage/bootanimation/bootanimation.tar
cd ~/android/cerulean/oreo-mr1/vendor/lineage/bootanimation/

# Cerulean Rebrand
cd ~/android/cerulean/oreo-mr1/lineage-sdk/lineage/res/res/values/
sed -r 's/LineageOS/Cerulean/' strings.xml

cd ~/android/cerulean/oreo-mr1/vendor/lineage/config/
sed -r 's/LineageOS/Cerulean/' common.mk

cd ~/android/cerulean/oreo-mr1/packages/apps/LineageParts/res/values
sed -r 's/LineageOS/Cerulean/' strings.xml
