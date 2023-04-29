####
#### This isn't an actual script, and it is to
#### function as a how-to merge different changes
####
exit

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

##
## Android 13 / Lineage 20 (T)
##

### System-based changes

# Secondary User Logout
cd ~/android/lineage/20/frameworks/base
git fetch https://github.com/GrapheneOS/platform_frameworks_base -t TQ1A.221205.011.2022122700
git cherry-pick f705be185a84ff95171cc12d424c2d340f2b132e

# Raise maximum users from 4 to 16
cd ~/android/lineage/20/vendor/lineage/overlay/common/frameworks/base/core/res/res/values
vi config.xml
    # Edit
    <integer name="config_multiuserMaximumUsers">16</integer>
    # Also
    <string name="config_icon_mask" translatable="false">"M 50 0 L 50 0 L 19.2 0 C 12.4794 0 9.11905 0 6.55211 1.30792 C 4.29417 2.4584 2.4584 4.29417 1.30792 6.55211 C 0 9.11905 0 12.4794 0 19.2 L 0 80.8C 0 87.5206 0 90.8809 1.30792 93.4479 C 2.4584 95.7058 4.29417 97.5416 6.55211 98.6921 C 9.11905 100 12.4794 100 19.2 100 L 80.8 100 C 87.5206 100 90.8809 100 93.4479 98.6921 C 95.7058 97.5416 97.5416 95.7058 98.6921 93.4479 C 100 90.8809 100 87.5206 100 80.8 L 100 19.2 C 100 12.4794 100 9.11905 98.6921 6.55211 C 97.5416 4.29417 95.7058 2.4584 93.4479 1.30792 C 90.8809 0 87.5206 0 80.8 0Z"</string>

# add pre-built apps to build process (see commons-addition.mk for options)
cd ~/android/lineage/20/vendor/lineage/config/
vi common.mk

# Blue Bootanimation
cd ~/android/lineage/20/vendor/lineage/bootanimation
cp ~/Downloads/bootanimation.tar ./bootanimation.tar 

# Updater URL
cd ~/android/lineage/20/packages/apps/Updater/res/values/
vi strings.xml

### Device-specfic commits
# Comment out reserved space for GApps if you build w/ GApps
# 5a
cd ~/android/lineage/20/device/google/redbull
vi BoardConfigLineage.mk

## AVB Pixels
# 5a
cd ~/android/lineage/20/device/google/redbull
# Comment out disabling vbmeta
vi BoardConfigLineage.mk
# Edit key file to point to key
vi BoardConfig-common.mk
    # redbull (Pixel 4a 5G and 5a 5G) differences
    BOARD_AVB_VBMETA_SYSTEM_KEY_PATH := /home/<user>/.android-certs/avb.pem
    BOARD_AVB_VBMETA_SYSTEM_ALGORITHM := SHA256_RSA2048

# 3a
cd ~/android/lineage/20/device/google/bonito
# Comment out disabling vbmeta
vi BoardConfigLineage.mk
# Add lines to point to avb key file
vi BoardConfig-common.mk
    # described here: (https://forum.xda-developers.com/t/guide-re-locking-the-bootloader-on-the-oneplus-8t-with-a-self-signed-build-of-los-18-1.4259409/)
    BOARD_AVB_ALGORITHM := SHA256_RSA2048
    BOARD_AVB_KEY_PATH := /home/<user>/.android-certs/avb.pem