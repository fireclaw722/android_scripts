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