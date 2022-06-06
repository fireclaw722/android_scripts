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
git fetch https://github.com/GrapheneOS/platform_frameworks_base -t SP2A.220505.002.2022051100 # update with each Graphene release
git cherry-pick 0a2af569df39511922d90fd5aeefe1cc5960244e 
# fix merge error
# remove line containing "OTHER_SENSORS" AS WELL AS the following line
## That is a GrapheneOS and ProtonAOSP addition
git cherry-pick 0d8be8cd6849f33f97effde15410c718eedbe480
git cherry-pick c33b8d439dc8ff2a75b37743cf32e4480a484dd4
git cherry-pick c529ce04fb37a4b64198dc0aaa2d8f9f9dc1cfe5
git cherry-pick 8fa2eb15669e5fe62557573c360580fc5839a48f
git cherry-pick 80f8c1f71b8d631e16979545d72739ca60fd457f
# fix merge error
# remove line containing "OTHER_SENSORS" AS WELL AS the following line
## That is a GrapheneOS and ProtonAOSP addition
git cherry-pick 9a6fa6beec787bf42f3db836094d8379fcef539a
git cherry-pick 730a12600232e5527685a0a966f06c78c16a5567
git cherry-pick 56ffc332d5fc82ffa9f51b2023172723b7e1cea1
git cherry-pick 0db65e613ef1ee8c25e944a9b8de619ff85d6c2f
git cherry-pick 0d1c7681f1208a711a1b2c6b54cbe5d46bc52c2c
git cherry-pick 85b761a7f04b0d594e89403f3566d31765634bc4
git cherry-pick 30cfe2ea46ea24be4becbc7e0f36286c21dbe7e3
git cherry-pick e53b8dbdb9494dbbd3e5e637d7cb6010132a3c63
git cherry-pick 0c2fb7574bff3a9a2bef30b232aa8ee4b2ccf59b
git cherry-pick 4bc376622e41d26cc955139ddf2da0b9ad3570ae
git cherry-pick c5712c74553c51490e4b23f0bdaf5965fc1a8159
git cherry-pick 224f6a33ff86836a6326497880799f25c9efed32
git cherry-pick 22f279d202ea8737f157a4647aeaf0dabb2c58f6
git cherry-pick 93934b97ab7291c9491b27f2b6b9440aa9afdef8
git cherry-pick 82d072125312fdd482d6abb3e6ca2a345d4a863a
git cherry-pick d4c3d5926d45d4211c422c8526425ded1558a5f6
git cherry-pick 462fe6e78dcfd6668113b6e9e3cf5949b7a1da97
git cherry-pick fe2b588c467ebace6f9fce86e9e9caeb52108851
git cherry-pick 5a2e4a5d0d6a1c276d9845110c02df54f5b45994
git cherry-pick 74176bc724f83ecea19f6c6655a36a205e4d5469
git cherry-pick 252dad3d0cff70e555fb4ea528602d5be6e9ec12
git cherry-pick 2f48a174de97045550a3b4d5774afacbbf08fc88
git cherry-pick e5c749c8d7806a6c3f0732c4a288952e56e45e91
git cherry-pick 97551c5d7f2fa3f7135939ffc072a16d5bead1bf
git cherry-pick 169ae107d1850d2dfdc9403bf4a4d26c6b837273
git cherry-pick 6417b476dd38c754fb8e606aeb38e607ea3f1117
git cherry-pick 0081b26c8a7aa31eff30f0f7d69144384f293e01
git cherry-pick c5d85edd04d69adb47d0b8d924a973a0d8038e5d
git cherry-pick 422a6cf6502027216164c2e64d055991c08b0b6a
git cherry-pick 59aeb4b41aaeafb80c3bc8ae4a2dde9af6a3ddba
git cherry-pick 04d67ab3f1cf01a7e9545f15bdd1b131edcc7681
git cherry-pick 014097b47058bbcea082fb986ffc6dbf4a1498a3
git cherry-pick 9b3bf71dc66b00747eebffa95d51f3790ae59480
git cherry-pick c3572c5232446eb12c1c09a74d21a1810444a9c5
git cherry-pick 5d6ed286c3255414b7ff25b744be9d93fb709d72
git cherry-pick 3ffd351b28e4f12ee01437ebed0f554e1fb461f0
git cherry-pick 3dcbc786046a2e62e583ef84b99961070456ade2
git cherry-pick ce75428f5bc1be480bf5bffcc93fad3043be43bf
git cherry-pick 484e2e0fbc57193814c55cf6da554aa920786992
git cherry-pick 24aaaf84e4f3f942265e1d90c10cd5e65ee28c8b
git cherry-pick 13f84229d04e2ce29715569064116fbf9b576175
git cherry-pick cafeae91c017e53f662b743c26769b17b1cc9798
git cherry-pick 0f11747125192aaf592a8ba8d5537cf815a755dc
git cherry-pick e5e7a1b50f2d37c17b4fdb953451a00fcda8d6ce
git cherry-pick b736eebf900f85b3dc59a5b1e9364ee30fad4d18
git cherry-pick 9eda6555257bcdc30a9b2fdcb334b1505dca9034
git cherry-pick 03143bde4dc8dad89d34cc8a637e0746d1d3f922
git cherry-pick 70b2b47dcdcdcea4ebcb6c7589d56ea92e1ffae2
git cherry-pick 5611e97b8fb1e3c52e908fe1bb4b0b36b1eb728c
git cherry-pick 22583ba16fe4c73151795b53082f694d75382154
git cherry-pick 020010d3a0c89aea8ebb061215321def68992eae
git cherry-pick 24c85c579377d94b18dfb042ff3f1d646d4f735f
git cherry-pick 9e73778b0e2830ef1722a1b6faecac9f40e342b0
git cherry-pick 5467d304e405ee2c3aeeaa371621794e49b846aa
git cherry-pick c87f3134acc25dc722a9d6f723726df9f86b83bd
git cherry-pick 7e6ea7c22d24975a7daa22debfd9c61bfa7ee993
git cherry-pick 845f037b8c848cbc5772255a5971094e34aced84
git cherry-pick d8713709cdbb4746ccb86ff5f680637b6a94e087
git cherry-pick 94af229d3d558781cfad09324542d43ca59b1356
git cherry-pick a8c45f0c5fb3fd3b2c875aeeafccaa5784b78c1c
git cherry-pick 85b499d3f00af2e0061a05e6f501f409f11a6ec7
git cherry-pick f7a43fbaa081eb94184f85ad5fb98d7ea5a36d96
git cherry-pick ed42b8c6b0a54610440cbd39073a7006a0939771
git cherry-pick a380397b3660ab37386e17da76c161608b9bb116
git cherry-pick ceead9329eddf99da69b7492f4965a63fd9c7cce
git cherry-pick 9b3ab2f5e2f997f3b69cfd0271384be33e83baa2
git cherry-pick 32d2c34ba1673e4865247ccfdf8ac9072132691e
git cherry-pick fdd43fd6a33795aa68d46effbfdd9375dcae688c
git cherry-pick 2227de8b7d8e0b67b895c15be054c656c3ee128e
git cherry-pick 7c08368758295296262901be989b9870d078cbbb
git cherry-pick 8fb8ee704c9ad5c4057e6991f9edc2fbfae2ad8a
git cherry-pick 2e4645698be51a34b755367cb46053120b633bc6
git cherry-pick b4203210568835751d5dd0bebb8e53bf58833f10
git cherry-pick 1a3741770ea3f486d0989f729b4dea1f61c6669e
git cherry-pick e262ed16669c0ae314f276e3bbcc9b506df415fe
git cherry-pick 1f88e98b91d41282716669903930ab239d0b8379
git cherry-pick 75a7cc382f70cd5173cd581d67e5ba3238f9b479
git cherry-pick 41a47ed8ae5061eaf8e18281467890c55d9f9c85
git cherry-pick 71e23bc32d12464f4a003fb5832d582b6c1e4c04
git cherry-pick a1c4a51f2601e805dfb2bc910e81042557171616

cd ~/android/lineage/19.1/packages/providers/DownloadProvider/
git fetch https://github.com/GrapheneOS/platform_packages_providers_DownloadProvider -t SP2A.220505.002.2022051100
git cherry-pick 0bec1645c6f4cbcb3e58b1ff24c40479a0119c5f

cd ~/android/lineage/19.1/libcore
git fetch https://github.com/GrapheneOS/platform_libcore -t SP2A.220505.002.2022051100
git cherry-pick 5567b6158b4b6e8f27515d3d05cd54fb62c0f60d
git cherry-pick 20cd53d3ffcc4e627d04b9aa3ac40ec7d4b34ef7
git cherry-pick 38c7f627556d68e78630ed811007794f3c1940ff
git cherry-pick 31343fb1678d12b219cca2f0b7f0648622a3f3be
git cherry-pick a7f85eea061d7db75fe89e68ce6ad7fddb7bfab9
git cherry-pick 1cee508a6ec5f51f3c84d0b4bd9579ba1e1aeecd

cd ~/android/lineage/19.1/packages/modules/Wifi
git fetch https://github.com/GrapheneOS/platform_packages_modules_Wifi -t SP2A.220505.002.2022051100
git cherry-pick 7ddba360b5e0a617cf884a4e75cd8afb7e0534de
git cherry-pick 0b69608634b97ecad9b0545d1b9ca0e901e9ed0f

cd ~/android/lineage/19.1/packages/modules/Connectivity
git fetch https://github.com/GrapheneOS/platform_packages_modules_Connectivity -t SP2A.220505.002.2022051100
git cherry-pick 039c4ab8f52da3142581bcf54a7719b47a360045

cd ~/android/lineage/19.1/packages/modules/Permission
git fetch https://github.com/GrapheneOS/platform_packages_modules_Permission -t SP2A.220505.002.2022051100
git cherry-pick 158f190dd2586dc3f24dfb69083e96e2f2f43a0e

# Privacy Indicator for Location
cd ~/android/lineage/19.1/frameworks/base
git fetch https://github.com/GrapheneOS/platform_frameworks_base -t SP2A.220505.002.2022051100
git cherry-pick ba676eb0fb3b1baf5149a8135169143b2dcc52bd

# Secondary User Logout
cd ~/android/lineage/19.1/frameworks/base
git fetch https://github.com/GrapheneOS/platform_frameworks_base -t SP2A.220505.002.2022051100
git cherry-pick 37acbdd4ed80a6f753982e58665eaa20a619f455

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
