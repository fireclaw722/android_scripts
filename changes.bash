####
#### This isn't an actual script, and it is to
#### function as a how-to merge different changes
####
exit

# Updater URL
cd ~/android/lineage/16.0/packages/apps/Updater/res/values/
vi strings.xml

##
## Android 10 / Lineage 17.1 (Q)
##
cd ~/android/lineage/17.1

### System-based changes

# add pre-built apps to build process (see commons-addition.mk for options)
cd ~/android/lineage/17.1/vendor/lineage/config/
vi common.mk
# or do by device
cd ~/android/lineage/17.1/device/google/bonito
vi device-common.mk

cd ~/android/lineage/17.1/device/oneplus/oneplus3
vi device.mk

cd ~/android/lineage/17.1/device/motorola/victara
vi device.mk

# Blue Bootanimation
cd ~/android/lineage/17.1/vendor/lineage/bootanimation
cp ~/Downloads/bootanimation.tar ./

# For MicroG Signature-Spoofing support (for reference)
cd ~/android/lineage/17.1/
patch --no-backup-if-mismatch --strip='1' --directory=frameworks/base < ~/Downloads/GmsCore-android_frameworks_base-Q.patch
cd ~/android/lineage/17.1/frameworks/base
git commit

# Updater URL
cd ~/android/lineage/17.1/packages/apps/Updater/res/values/
vi strings.xml

### Device-specfic commits
# Sargo Performance improvements
cd ~/android/lineage/17.1/kernel/google/msm-4.9
git fetch "https://github.com/LineageOS/android_kernel_google_msm-4.9" refs/changes/40/263940/1 && git cherry-pick FETCH_HEAD

## Bootloader status masking
# google_msm-4.9 Safetynet 
cd ~/android/lineage/17.1/kernel/google/msm-4.9
git fetch https://github.com/flar2/Bluecross 
git cherry-pick 27823dd5b1bc55f6ae3b09bcd321d2e2614c28a1
git cherry-pick 978aa6865137c3a7cf7c05415dbeb30ad3e82052

##
## Android 11 / Lineage 18.1 (R)
##
cd ~/android/lineage/18.1

### System-based changes

# add pre-built apps to build process (see commons-addition.mk for options)
cd ~/android/lineage/18.1/vendor/lineage/config/
vi common.mk
# or do by device
cd ~/android/lineage/18.1/device/google/bonito
vi device-common.mk

cd ~/android/lineage/18.1/device/oneplus/oneplus3
vi device.mk

cd ~/android/lineage/18.1/device/motorola/victara
vi device.mk

# Blue Bootanimation
cd ~/android/lineage/18.1/vendor/lineage/bootanimation
cp ~/Downloads/bootanimation.tar ./

# For MicroG Signature-Spoofing support (for reference)
cd ~/android/lineage/18.1/
patch --no-backup-if-mismatch --strip='1' --directory=frameworks/base < ~/Downloads/GmsCore-android_frameworks_base-R.patch
cd ~/android/lineage/18.1/frameworks/base
git commit

# Updater URL
cd ~/android/lineage/18.1/packages/apps/Updater/res/values/
vi strings.xml

# GMS Compat from ProtonAOSP and GrapheneOS
# pulled from https://github.com/ProtonAOSP/android_frameworks_base/commit/05c0673d57ea9183eb04ef31573a96a9306c3b74
cd ~/android/lineage/18.1/frameworks/base
git fetch https://github.com/ProtonAOSP/android_frameworks_base rvc
git cherry-pick caf68a608b9806c8c9bed6003c5770fc9fe39113
git cherry-pick 1f5b60e686a1bb60611ce510509abc0a5af23bcc
git cherry-pick 31f39f24fca258fe0a6d467f21ee40cdca331014
git cherry-pick 101e4f994635a77056135d87ac511e5b2e585725
git cherry-pick bee11e7cb2bd8fa9f1a74461dec5881b57146520
git cherry-pick 8768d3d4741fef1c190f1d9f2f765091453ef78c
git cherry-pick 946d5f2aac01b6b56b629c56ea39d7f9838d790b
git cherry-pick ed40fef2cd80afe1cd042f7d7fd512598d55fcb6
# fix merge error
# remove line containing "OTHER_SENSORS" AS WELL AS the following line
## That is a GrapheneOS and ProtonAOSP addition
git cherry-pick 7a420d2e0f5a710d194c714d111402e021379617
git cherry-pick d59f9e0c7401484d5a617e55900a6b474a94a21e
git cherry-pick ac61e010f27ad4f9f9bdacbfad824909dc219883
# fix merge error
# remove ONE of the lines containing "newPkg.isForceQueryable()"
# remove ONE of the lines containing "newPkgSetting.forceQueryableOverride"
## keep the other (of both)
git cherry-pick 100407a57ef4018a507931e51d80c15bed2b153a
git cherry-pick 9723fa311dc82c546028f20f1c6766692bc36a59
git cherry-pick 69cc21f538305f6d3024d86de3690bb313f5eb1b
git cherry-pick f9e45fd421716de5c91ac744daf9118cb75a5697
git cherry-pick 94b0be463149f8020aacd21ac9da9b98b53e7e44
git cherry-pick a83c73765827e3da282b34a62c0e5ca479d92b56
git cherry-pick 0ff2739056f34a61b4f682ae5781151c575c58fe
git cherry-pick 39b5ecdd0387c1e918cc77a31f15b52364dc15a5
git cherry-pick 9d7f4e47e882010005f3b668911c009c586ce526
git cherry-pick 8fe750a9d3484467e75222c11aac5973a06e53fd
git cherry-pick 4593203ba079f9590fa319585dcf24c9488d3b09
# fix merge error
# remove lines containing "maybeSpoofBuild(app);"
git cherry-pick 2f70981714393593b733d78522c83b7323f5a891
git cherry-pick c965caa7a0dd4d4f561b66c58484deda04cd6791
git cherry-pick b4811718bf68108fb6419bf0d09579536373e008
git cherry-pick 68603ce63a90d452f233731e4ddf9b12d68c1749
git cherry-pick 3aff70d2b02cc68540208f132d9f8178ecc4c2f9
git cherry-pick 2646990f914c8ad38f925bfd73249b9b803e229f
git cherry-pick 02044c1fb2c740f180a77bec5896a61a37325b96
# fix merge error
# Same issue as ac61e010f27ad4f9f9bdacbfad824909dc219883
# fix the same way; remove the extra calls

cd ~/android/lineage/18.1/bionic
git fetch https://github.com/ProtonAOSP/android_bionic rvc
git cherry-pick bc443b6de8343858d2cb2272bc840f4c519ab2de

cd ~/android/lineage/18.1/libcore
git fetch https://github.com/ProtonAOSP/android_libcore rvc
git cherry-pick af740ed9fae7d6ec494b98b7eb6960ccd49b4076
git cherry-pick 55f4cb6cd74191178263a492fecab2419c19715f

### Device-specfic commits
# Comment out reserved space for GApps if you build w/ GApps
# 3a
cd ~/android/lineage/18.1/device/google/bonito
vi BoardConfigLineage.mk
# 5a
cd ~/android/lineage/18.1/device/google/redbull
vi BoardConfigLineage.mk

## AVB Pixels
# 3a
cd ~/android/lineage/18.1/device/google/bonito
# Comment out disabling vbmeta
vi BoardConfigLineage.mk
# Add lines to point to avb key file
vi BoardConfig-common.mk
    # described here: (https://forum.xda-developers.com/t/guide-re-locking-the-bootloader-on-the-oneplus-8t-with-a-self-signed-build-of-los-18-1.4259409/)
    BOARD_AVB_ALGORITHM := SHA256_RSA2048
    BOARD_AVB_KEY_PATH := /home/<user>/.android-certs/avb.pem


# 5a
cd ~/android/lineage/18.1/device/google/redbull
# Comment out disabling vbmeta
vi BoardConfigLineage.mk
# Edit key file to point to key
vi BoardConfig-common.mk
    # redbull (Pixel 4a 5G and 5a 5G) differences
    BOARD_AVB_VBMETA_SYSTEM_KEY_PATH := /home/<user>/.android-certs/avb.pem
    BOARD_AVB_VBMETA_SYSTEM_ALGORITHM := SHA256_RSA2048

##
## Android 11 / Graphene 11 (R)
##
cd ~/android/graphene/11

## Unofficial Updater URL
cd ~/android/graphene/11/packages/apps/Updater/res/values/
vi config.xml

## For Bromite WebView to work, the frameworks/base commit needs to either be reverted, or com.android.webview needs to be re-added
## Vanadium isn't kept, so revert for now
cd ~/android/graphene/11/frameworks/base
git revert 6c2d2c234a9ca81b3d9f22d1078f874207b6e8dd

## get vendor imgs
cd ~/android/graphene/11
vendor/android-prepare-vendor/execute-all.sh -d $DEVICE -b $BUILD_ID -o vendor/android-prepare-vendor
mkdir -p vendor/google_devices
rm -rf vendor/google_devices/$DEVICE
mv vendor/android-prepare-vendor/$DEVICE/$BUILD_ID/vendor/google_devices/* vendor/google_devices/

## add pre-built apps to build process (see commons-addition.mk)
cd ~/android/graphene/11/build/target/product
vi base_product.mk
vi base_system.mk

cd ~/android/graphene/11/device/google/bonito
vi device-common.mk

## bootanim 
## !! doesn't work, haven't been using / Removed until bootanim can be properly implemented
# .zip pulled from https://github.com/GrapheneOS/os-issue-tracker/pull/174

## Elmyra for Active Edge
# will not boot without first change
# https://github.com/ProtonAOSP/android_frameworks_base/commit/2b950e103e865aa6a1fe8a917964e0069d4c4037
# https://github.com/ProtonAOSP/android_frameworks_base/commit/013c590411435569077228aacf1e246678c366ab
cd ~/android/graphene/11/frameworks/base
git fetch https://github.com/ProtonAOSP/android_frameworks_base
git cherry-pick 267b0981195af3865202e8fadda0b1070f24ab48
git cherry-pick a5b3d251c712fb9fe7e50941ed60444d857b98b8
cd ~/android/graphene/11/external/ElmyraService
vi res/values/config.xml

##
## Android 12 / Graphene 12 (S)
##
## Unofficial Updater URL
cd ~/android/graphene/12/packages/apps/Updater/res/values/
vi config.xml

## For Bromite WebView to work, the frameworks/base commit needs to either be reverted, or com.android.webview needs to be re-added
## Vanadium isn't kept, so revert for now
cd ~/android/graphene/12/frameworks/base
git revert 6c2d2c234a9ca81b3d9f22d1078f874207b6e8dd

## get vendor imgs
cd ~/android/graphene/12
vendor/android-prepare-vendor/execute-all.sh -d $DEVICE -b $BUILD_ID -o vendor/android-prepare-vendor
mkdir -p vendor/google_devices
rm -rf vendor/google_devices/$DEVICE
mv vendor/android-prepare-vendor/$DEVICE/$BUILD_ID/vendor/google_devices/* vendor/google_devices/

## add pre-built apps to build process (see commons-addition.mk)
cd ~/android/graphene/12/build/target/product
vi base_product.mk
vi base_system.mk

cd ~/android/graphene/12/device/google/bonito
vi device-common.mk