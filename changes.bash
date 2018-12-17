####
#### This isn't an actual script, and it is to
#### function as a how-to merge different changes
####
exit

##
## System-based changes
##
cd ~/android/lineage/oreo-mr1

## Merge Substratum OMS changes from SubstratumResources github
# frameworks/base
cd ~/android/lineage/oreo-mr1/frameworks/base
git fetch https://github.com/SubstratumResources/platform_frameworks_base o
git cherry-pick f18f319d6b262c13dae2469183be1d0dd863c72f
git cherry-pick 4b857261936d3e4fea4beac85ce7ab0466e019a6
git cherry-pick 79a819645b705660d2e77832fa2375fd9729e253
git cherry-pick 79d56d191c7b209de4974dde59959f50dbe89e52
git cherry-pick fb542e2fd9864f992df69214a4f15a9bd00ec536
git cherry-pick 3b1263acd997eec696752b6214422a78fc48aba5
git cherry-pick 798e2853d8dd942e6f465e80cedfb44102a0c48a
git cherry-pick c16409c11b4beb05111d007a4ccfd77f01558e93
git cherry-pick 3e7303f58a1d10b62fcac99c6a77aa49d6f6a85d
git cherry-pick 5401428e43a5af6954cfc3f8dfac112365e78ecc
git cherry-pick 00380f6983a18189744dd0fa8d8979873deb6e61
git cherry-pick c7772458586a1a6bd11fb32765d23e36cda48473
git cherry-pick f844e2d9f3738742f461004e168161351351f7fa
git cherry-pick 3e6696b4bbff0d8b93e652ebe6e2fae26c52441a
git cherry-pick af64826f6968737d48274a147069112e838632c3
git cherry-pick 5d6436cc51781a1f19e49add8af360e238758c60
git cherry-pick a5ce391a3d9b222f8f13d5ff928c4865b3747410
git cherry-pick f4459ab982aacfcf1d7e8cacd43a7325ac8456a2
git cherry-pick cfd591003ddd7fda89139cc5afcb08d9e94b15c7
git cherry-pick 52efd1896fdfac7b5e4a7f258fef5149f151b087
git cherry-pick a5a7864424afcbd2d807c8522998e20f22caaa94
git cherry-pick 1f99d83ccdf422cb6ca39921ac5ab51572e315a5
git cherry-pick 0ef6d8a421a1935d7d828770fa9d0fc4f96263f3

git cherry-pick 2374ce8ca28c742f7257cf317b63371a79ed42d9
git cherry-pick 5ba55a28c7b0af31a6600c215679c83ee5a74a65
git cherry-pick 9bd9a99d16c6442b17dce6f1bfbb02212c4eb687
git cherry-pick 277b31a864f83f03771b58f4fc9718450a7bcc93
git cherry-pick d62f99e6dc01ff3212a9f2c93997c2086e50269e
git cherry-pick e540d2f09060cfb5fbbf8879ae27351007f4d806
git cherry-pick cfef2861cb9cea3d7887d4c287d3750f4fb68c5c

git cherry-pick b84c655f0d274502412bc5b6c9b8df14b55092c8
git cherry-pick 19118a70f57dccbaedb2c1225c156efae8cdc350
git cherry-pick 358554b8e0ec8c26c3784e5b71b2e2ef7c683fa6
git cherry-pick 7fd7a11e7c933dfa2e23a8a1ca3577bc8da19f0a
git cherry-pick 4ce9670d9f1a47a58b398a9ddd21444791b605c6
git cherry-pick af87e3df1f33fc2bd1fb574d26742675ede784f6
git cherry-pick dd3ce110fed39186ea569b62dea569cb307024c1

git cherry-pick 7c3c62f855145447f78e0b71cf574c688ea6b8b2

# packages/apps/settings
cd ~/android/lineage/oreo-mr1/packages/apps/Settings
git fetch https://github.com/SubstratumResources/platform_packages_apps_settings o
git cherry-pick bdd99f47d2d6d74af0effef2e5e4182c439e4089
git cherry-pick 1d592e80281cb42a9d654f2bbe8854ab13812121
git cherry-pick 8af7a4536a8aa55eb1544b1d0e25ff0bbfa15b25

git cherry-pick 6dd080bf2bc5df083822e401fd0e6242b2eebbd4
git cherry-pick e11c2a15a3ceb200cc1eea2513048cb020158be3

git cherry-pick 0960f49e28f441c5b3e5388efc36a6c709e059f6
git cherry-pick 258d6e76252bb6bd0dbfa4f370d5915964b02818

git cherry-pick a850bf91529624b3b2ca4b7181156998ea6eac13
git cherry-pick 7d3bd74f49eb70e0d6689551eb0c2c125f23e6c9

# system/sepolicy
cd ~/android/lineage/oreo-mr1/system/sepolicy
git fetch https://github.com/SubstratumResources/platform_system_sepolicy o
git cherry-pick fd8a0ec2fc04b33e370b42564bd3cdaa028b83ea
git cherry-pick 7022b6a39f8bd15293dffbcc149ce003cfe797a0
git cherry-pick ad3b42ff306c5ca3036162f9b90e75f42fecaaa7

# LineageOMS is a community supported ROM, and this is Lineage+OMS
cd ~/android/lineage/oreo-mr1/vendor/lineage/build/core
nano main_version.mk
    # add
ADDITIONAL_BUILD_PROPERTIES += \
    ro.lineage.version=$(LINEAGE_VERSION) \
    ro.lineageoms.version=$(LINEAGE_VERSION) \

## Extra System Changes
cd ~/android/lineage/oreo-mr1
# unofficial Trust changes (vendor patch level)
vendor/lineage/build/tools/repopick.py -f -g https://review.lineageos.org 217171

# Port DU Battery info on ambient display
vendor/lineage/build/tools/repopick.py -f -g https://gerrit.dirtyunicorns.com 2472 -P frameworks/base/

# add fdroid and other pre-built apps to build process
cd ~/android/lineage/oreo-mr1/vendor/lineage/config/
cat commons-additions.mk >> common.mk

# Change System icon-mask back to square
cd ~/android/lineage/oreo-mr1/vendor/lineage/overlay/common/frameworks/base/core/res/res/values/
nano config.xml
    # remove
    <string name="config_icon_mask" translatable="false">"M50 0A50 50,0,1,1,50 100A50 50,0,1,1,50 0"</string>

    <!-- Flag indicating whether round icons should be parsed from the application manifest. -->
    <bool name="config_useRoundIcon">true</bool>

# change Trebuchet icon-mask back to square
cd ~/android/lineage/oreo-mr1/packages/apps/Trebuchet/res/values
nano lineage_adaptive_icons.xml
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

## May or may not be included
# For MicroG Signature-Spoofing support (for reference)
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
git fetch https://github.com/franciscofranco/one_plus_3T
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
git fetch https://github.com/franciscofranco/one_plus_3T
git cherry-pick b50f418ddd549e22d32377c09f289439bb0f0d60
git commit
git cherry-pick da7787b36a4d5ed8646e5110aecf1015ca1591db
