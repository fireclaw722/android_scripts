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

# Secondary User Logout
cd ~/android/lineage/18.1/frameworks/base
git fetch https://github.com/GrapheneOS/platform_frameworks_base -t RQ3A.211001.001.2021100606
git cherry-pick f1d6d41b4fa836b7b0953eb3b24f3af6e1d5cbcf

# SystemUI: Require unlocking to use sensitive QS tiles
cd ~/android/lineage/18.1/frameworks/base
git fetch https://github.com/GrapheneOS/platform_frameworks_base -t RQ3A.211001.001.2021100606
git cherry-pick fb872c6b60560e5d29f630f692df1ab13eed063b
git cherry-pick 6f815982c3970378da2d5744ac4c18e9bbbc64e2
git cherry-pick 226f63786fd70943dea5c973e039548a9af89df7
git cherry-pick f9cdb1c823a8c6abccedf5b73b83a0995cef82bb
git cherry-pick 8bbf513ef2cc207dd8bfadb0b05f5583f6472696
git cherry-pick 9a2aa0b64c801dadeb7c9210c330444211d15786
git cherry-pick d535ed4b7e7ca8674f267f0b73278a2932f00848
git cherry-pick ac513e3540a0e9d293ec90c9afdfc1d0e72721ce
git cherry-pick 83b2f897d575c1e647a5c3457948f72d346aa57c
git cherry-pick 2e872d2e2537d6a53be160f7ac35c83847b68868

# WiFi and Bluetooth auto turn-off
cd ~/android/lineage/18.1/frameworks/base
git fetch https://github.com/GrapheneOS/platform_frameworks_base -t RQ3A.211001.001.2021100606
git cherry-pick e9d17cd4807dbfa837b16296b3a2e4434c060002
git cherry-pick 423f3e151beae0c608881d4bf16b8dff22b5efc6

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
# remove last of the lines containing "newPkg.isForceQueryable()"
# remove first of the lines containing "newPkgSetting.forceQueryableOverride"
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
# fix merge error; may not be a merge error depending on first error changes/fixes
# Same issue as ac61e010f27ad4f9f9bdacbfad824909dc219883
# fix the same way; remove the extra calls

cd ~/android/lineage/18.1/bionic
git fetch https://github.com/ProtonAOSP/android_bionic rvc
git cherry-pick bc443b6de8343858d2cb2272bc840f4c519ab2de

cd ~/android/lineage/18.1/libcore
git fetch https://github.com/ProtonAOSP/android_libcore rvc
git cherry-pick af740ed9fae7d6ec494b98b7eb6960ccd49b4076
git cherry-pick 55f4cb6cd74191178263a492fecab2419c19715f

# add pre-built apps to build process (see commons-addition.mk for options)
cd ~/android/lineage/18.1/vendor/lineage/config/
vi common.mk

# Allow Bromite Webview (since package name change)
cd ~/android/lineage/18.1/vendor/lineage/overlay/common/frameworks/base/core/res/res/xml
vi config_webview_packages.xml
    # add
    <webviewprovider description="Bromite System Webview" packageName="org.bromite.webview" availableByDefault="true" />

# Blue Bootanimation
cd ~/android/lineage/18.1/vendor/lineage/bootanimation
cp ~/Downloads/bootanimation.tar ./

# Raise maximum users from 4 to 16
cd ~/android/lineage/18.1/vendor/lineage/overlay/common/frameworks/base/core/res/res/values
vi config.xml
    # Edit
    <integer name="config_multiuserMaximumUsers">16</integer>

# For MicroG Signature-Spoofing support (for reference)
cd ~/android/lineage/18.1/
patch --no-backup-if-mismatch --strip='1' --directory=frameworks/base < ~/Downloads/GmsCore-android_frameworks_base-R.patch
cd ~/android/lineage/18.1/frameworks/base
git commit

# Updater URL
cd ~/android/lineage/18.1/packages/apps/Updater/res/values/
vi strings.xml

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
## Android 12/12L / Lineage 19.1 (S)
##

### System-based changes

# Secondary User Logout
cd ~/android/lineage/19.1/frameworks/base
git fetch https://github.com/GrapheneOS/platform_frameworks_base -t SQ3A.220705.003.A1.2022081800
git cherry-pick 8722e3a9484863146cd9d787a79ba4510b78ee96

# SystemUI: Require unlocking to use sensitive QS tiles
cd ~/android/lineage/19.1/frameworks/base
git fetch https://github.com/GrapheneOS/platform_frameworks_base -t SQ3A.220705.003.A1.2022070800
git cherry-pick 6f7cde6351b1ba2fb0513d713ad20d42e7f18745

# WiFi and Bluetooth auto turn-off
cd ~/android/lineage/19.1/frameworks/base
git fetch https://github.com/GrapheneOS/platform_frameworks_base -t SQ3A.220705.003.A1.2022070800
git cherry-pick 21129623994a43464b95f148762b9e8931149179
git cherry-pick 4dc91f9a8faf944eb8b3c88b80fbbd82ff3902c9

# Support forwarding notifications from other users
cd ~/android/lineage/19.1/frameworks/base
git fetch https://github.com/GrapheneOS/platform_frameworks_base -t SQ3A.220705.003.A1.2022070800
git cherry-pick 074cbbedd81cbf5e34b4c25835fc300500926b87

# GMS Compat from ProtonAOSP and GrapheneOS
# Requires https://github.com/fireclaw722/platform_packages_apps_GmsCompat/tree/12.1
# ^-- forked from GrapheneOS/platform_packages_apps_GmsCompat/tree/12.1 w/ commit added moving to system_ext partition

cd ~/android/lineage/19.1/frameworks/base
git fetch https://github.com/GrapheneOS/platform_frameworks_base -t SQ3A.220705.003.A1.2022081800
git cherry-pick 986c55b83b7b860a073d4e9666e22086dec2765d
git cherry-pick 4419afb8a18934b92b8e7ae6051b8d491f1aada2
git cherry-pick e8ec2e09e6686b53065749867b74aee52db87b78
git cherry-pick 4e2a0c5c75423f5dff6edd22b25cda13fe16f0d7
git cherry-pick bbdccc887e5c745b97192c159c3523652c1a5d07
git cherry-pick 625c3f447eb894b6feafba15a7fb33e396c6a6c2
git cherry-pick 43771e3de08cbccc8a6ee88428667cdd9a3139a1

cd ~/android/lineage/19.1/packages/providers/DownloadProvider/
git fetch https://github.com/GrapheneOS/platform_packages_providers_DownloadProvider -t SQ3A.220705.003.A1.2022081800
git cherry-pick 7544c3812f60e84cc3f4de7c6642ef79cbf5ecfd

cd ~/android/lineage/19.1/libcore
git fetch https://github.com/GrapheneOS/platform_libcore -t SQ3A.220705.003.A1.2022081800
git cherry-pick e9a5a851cb467d7ed3d8da8d0d6c9d6b24e92fd2
git cherry-pick ac55ac2b7ed3b82cae97d269a18144d3a65189bb

cd ~/android/lineage/19.1/bionic
git fetch https://github.com/GrapheneOS/platform_bionic -t SQ3A.220705.003.A1.2022081800
git cherry-pick bba168f4197155767b4e09758f033c3971e8610b
git cherry-pick 900778a9b7e49af2fec93187b8f3f0af47b58eca # fix merge error...maybe

cd ~/android/lineage/19.1/packages/modules/Wifi
git fetch https://github.com/GrapheneOS/platform_packages_modules_Wifi -t SQ3A.220705.003.A1.2022081800
git cherry-pick c911c43213d20e300545f5951febafc866a9e4c4
git cherry-pick 9eca3d8d62376ae035ea5eaa950147c2e5dab370

cd ~/android/lineage/19.1/packages/modules/Connectivity
git fetch https://github.com/GrapheneOS/platform_packages_modules_Connectivity -t SQ3A.220705.003.A1.2022081800
git cherry-pick 9b6814d58e4e8f594af9a822226e5c7d59941eca

cd ~/android/lineage/19.1/packages/modules/Permission
git fetch https://github.com/GrapheneOS/platform_packages_modules_Permission -t SQ3A.220705.003.A1.2022081800
git cherry-pick b88c34c3f2887b48e7a7cf6b585acc598434f445

cd ~/android/lineage/19.1/art
git fetch https://github.com/GrapheneOS/platform_art -t SQ3A.220705.003.A1.2022081800
git cherry-pick 3b39f26e3cf9c8f16d2fde8fda5b2269e8f372fd
git cherry-pick 433aef188cea2349dcadfb43d420dfd21adb4659 # fix merge error...maybe


# Raise maximum users from 4 to 16
cd ~/android/lineage/19.1/vendor/lineage/overlay/common/frameworks/base/core/res/res/values
vi config.xml
    # Edit
    <integer name="config_multiuserMaximumUsers">16</integer>

# add pre-built apps to build process (see commons-addition.mk for options)
cd ~/android/lineage/19.1/vendor/lineage/config/
vi common.mk

# Allow Bromite Webview (since package name change)
cd ~/android/lineage/19.1/vendor/lineage/overlay/common/frameworks/base/core/res/res/xml
vi config_webview_packages.xml
    # add
    <webviewprovider description="Bromite System Webview" packageName="org.bromite.webview" availableByDefault="true" />

# Blue Bootanimation
cd ~/android/lineage/19.1/vendor/lineage/bootanimation
cp ~/Downloads/bootanimation.tar ./bootanimation.tar 

# Updater URL
cd ~/android/lineage/19.1/packages/apps/Updater/res/values/
vi strings.xml

### Device-specfic commits
# Comment out reserved space for GApps if you build w/ GApps
# 5a
cd ~/android/lineage/19.1/device/google/redbull
vi BoardConfigLineage.mk

## AVB Pixels
# 5a
cd ~/android/lineage/19.1/device/google/redbull
# Comment out disabling vbmeta
vi BoardConfigLineage.mk
# Edit key file to point to key
vi BoardConfig-common.mk
    # redbull (Pixel 4a 5G and 5a 5G) differences
    BOARD_AVB_VBMETA_SYSTEM_KEY_PATH := /home/<user>/.android-certs/avb.pem
    BOARD_AVB_VBMETA_SYSTEM_ALGORITHM := SHA256_RSA2048

# 3a
cd ~/android/lineage/19.1/device/google/bonito
# Comment out disabling vbmeta
vi BoardConfigLineage.mk
# Add lines to point to avb key file
vi BoardConfig-common.mk
    # described here: (https://forum.xda-developers.com/t/guide-re-locking-the-bootloader-on-the-oneplus-8t-with-a-self-signed-build-of-los-18-1.4259409/)
    BOARD_AVB_ALGORITHM := SHA256_RSA2048
    BOARD_AVB_KEY_PATH := /home/<user>/.android-certs/avb.pem