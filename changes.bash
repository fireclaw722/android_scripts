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

# Allow Bromite Webview (since package name change)
cd ~/android/lineage/18.1/vendor/lineage/overlay/common/frameworks/base/core/res/res/xml
vi config_webview_packages.xml
    # add
    <webviewprovider description="Bromite System Webview" packageName="org.bromite.webview" availableByDefault="true" />

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

# Secondary User Logout
cd ~/android/lineage/18.1/frameworks/base
git fetch https://github.com/GrapheneOS/platform_frameworks_base -t RQ3A.211001.001.2021100606
git cherry-pick f1d6d41b4fa836b7b0953eb3b24f3af6e1d5cbcf

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

# GMS Compat from ProtonAOSP and GrapheneOS
# pulled from https://github.com/ProtonAOSP/android_frameworks_base/commit/05c0673d57ea9183eb04ef31573a96a9306c3b74
cd ~/android/lineage/19.1/frameworks/base
git fetch https://github.com/GrapheneOS/platform_frameworks_base -t SQ1D.220205.004.2022030501 # update with each Graphene release
git cherry-pick 099977ecc80c71bcfe4f5e4003481c237757360f 
# fix merge error
# remove line containing "OTHER_SENSORS" AS WELL AS the following line
## That is a GrapheneOS and ProtonAOSP addition
git cherry-pick 7118b63e37b9f328a20084c72c888ec01a86461b
git cherry-pick fd7495bab4b70eb4f86cb207462bc21b156ac8a5
git cherry-pick 6458e6bbd97cb4192e15b811394d640563018e3a
git cherry-pick 8ec12395dfc539ac3e49ae2e4e6f1543ff8e5e39 # reverted by 6626ff
git cherry-pick 322690e13b30bb9f4524464ba19bb3a56cbabd49
# fix merge error
# remove line containing "OTHER_SENSORS" AS WELL AS the following line
## That is a GrapheneOS and ProtonAOSP addition
git cherry-pick 8e051beb9781669aa6de37a6a105fca27a3cd957
git cherry-pick 6b3a0475e7b35141a087ed8b56235629a821247a
git cherry-pick d8b69c204c52fdcaee89f403a652c577400a475d
git cherry-pick deb1c004cad431d3a966722b50167078b595cb92
git cherry-pick e5c80d6237d8b55a234855ceceedd3c7b2de738f
git cherry-pick 7c7c63e5638fcbf550f69413a47adc8d386f8d1c
git cherry-pick 57dbb9c579454b1bc88502f807a46035afdda0d0
git cherry-pick c156cdeb52f376aa3e064dd118830a75ad6a7586
git cherry-pick ec7fad7e831007ee10a62d972fd7c8279fc63b68
git cherry-pick 31226f9c6e22cf1a24579c0e68957d4842285496
git cherry-pick efee7d2516c3c6d763811a8c4acc5599f5836ede
git cherry-pick 347eb2ba09aa7cd48eefa88c3bd962c5e667c5f7
git cherry-pick eedd80c79e618d887f43068226054e6d9dc58c74
git cherry-pick 6626ff410e1b0b3b29be3b873019f693f4745a13 # reverts 8ec123
git cherry-pick eb02b7b09dbfc8f6a02bdbd4fa195640fc5d2fe0
git cherry-pick dcfab8a72e7eb4f5847a60bdcf66e1998b0d1a30
git cherry-pick 79b22b7620fcf29f3a2934a548f748a1a97bc1c8
git cherry-pick 4691391765e0de8de9d28efe90d1305810f20671
git cherry-pick f374104b4242247d38bd716a5b11c222459df445
git cherry-pick 7828951be236d6fe152c12b0e1859d8c1a3517e1
git cherry-pick 8232983fd09711fd383b551437dea7d88700c145
git cherry-pick d195c986c64e05684008e549d25ca3a796573428
git cherry-pick 08e2baa5899e58b55479f8199ef0896690256f2d
git cherry-pick 925b7efa1794796b63145525e1306bb5834edd71
git cherry-pick 9e3add169c32edce3c19678073578158aeb79e60
git cherry-pick d5d83811fcafa537dea71f920f9c6d792c15a234

cd ~/android/lineage/19.1/packages/providers/DownloadProvider/
git fetch https://github.com/GrapheneOS/platform_packages_providers_DownloadProvider -t SQ1D.220205.004.2022030501
git cherry-pick 602698c1de0df91d84df6f602831b1937a59d004

cd ~/android/lineage/19.1/libcore
git fetch https://github.com/GrapheneOS/platform_libcore -t SQ1D.220205.004.2022030501
git cherry-pick 413f7c0a51f9909d8c9ba87f26826ed5ab3ccafd
git cherry-pick ce58113a964026773cf5547442fd4575540b3496

cd ~/android/lineage/19.1/packages/modules/Wifi
git fetch https://github.com/GrapheneOS/platform_packages_modules_Wifi -t SQ1D.220205.004.2022030501
git cherry-pick 19700fedec1372a5baf32a2537cbb3c7a0dc30ba

cd ~/android/lineage/19.1/packages/modules/Connectivity
git fetch https://github.com/GrapheneOS/platform_packages_modules_Connectivity -t SQ1D.220205.004.2022030501
git cherry-pick 9bc95db37f123fd8258f3f32105872df62cda74a

# Privacy Indicator for Location
cd ~/android/lineage/19.1/frameworks/base
git fetch https://github.com/GrapheneOS/platform_frameworks_base -t SQ1D.220205.004.2022030501
git cherry-pick bc4accfb0b546112d670a15e977684acf9710b7a

# Secondary User Logout
cd ~/android/lineage/19.1/frameworks/base
git fetch https://github.com/GrapheneOS/platform_frameworks_base -t SQ1D.220205.004.2022030501
git cherry-pick efc1a391132e9ab103b04c9df8a71880a9a4bfed

# Not-yet-merged LOS additions
cd ~/android/lineage/19.1/
vendor/lineage/build/tools/repopick.py -t apps-material-you # LatinIME fails
vendor/lineage/build/tools/repopick.py -t qti-usb-1.3
vendor/lineage/build/tools/repopick.py -t twelve-suw-redesign # external-setupcompat fails
    vendor/lineage/build/tools/repopick.py -P external/setupcompat/ 326705
    vendor/lineage/build/tools/repopick.py -P external/setupcompat/ 326706
    vendor/lineage/build/tools/repopick.py -P external/setupcompat/ 326707
vendor/lineage/build/tools/repopick.py -t trust-restrict-usb
vendor/lineage/build/tools/repopick.py 324844 # Gestures over 3-button Nav

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
cp ~/Downloads/bootanimation.tar ./

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
