####
#### This isn't an actual script, and it is to
#### function as a how-to merge different changes
####
exit

##
## Android 8.1 / Lineage 15.1 (Oreo)
##
cd ~/android/lineage/15.1

### System-based changes

# add pre-built apps to build process (see commons-addition.mk for options)
cd ~/android/lineage/15.1/vendor/lineage/config/
vi common.mk

# Blue Bootanimation
cd ~/android/lineage/15.1/vendor/lineage/bootanimation
cp ~/Downloads/bootanimation.tar ./

# Updater URL
cd ~/android/lineage/15.1/packages/apps/Updater/res/values/
vi strings.xml

# MicroG Signature-Spoofing support
cd ~/android/lineage/15.1/
patch --no-backup-if-mismatch --strip='1' --directory=frameworks/base < ~/Downloads/GmsCore-android_frameworks_base-O.patch
cd ~/android/lineage/15.1/frameworks/base
git commit

# Update for new security patches
vendor/lineage/build/tools/repopick.py -g https://review.lineageos.org -t #O_asb_XXXX-XX

### Device-based changes
# Moto Mod Battery Efficiency Mode (run twice because it doesn't merge cleanly)
cd ~/android/lineage/15.1
vendor/lineage/build/tools/repopick.py -f -g https://review.lineageos.org -t moto-mods-battery-lineage-15.1

##
## Android 9 / Lineage 16.0 (Pie)
##
cd ~/android/lineage/16.0

### System-based changes

# add pre-built apps to build process (see commons-addition.mk for options)
cd ~/android/lineage/16.0/vendor/lineage/config/
vi common.mk

# Blue Bootanimation
cd ~/android/lineage/16.0/vendor/lineage/bootanimation
cp ~/Downloads/bootanimation.tar ./

# For MicroG Signature-Spoofing support (for reference)
cd ~/android/lineage/16.0/
patch --no-backup-if-mismatch --strip='1' --directory=frameworks/base < ~/Downloads/GmsCore-android_frameworks_base-P.patch
cd ~/android/lineage/16.0/frameworks/base
git commit

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
# DOES NOT EXIST YET
#cd ~/android/lineage/18.1/
#patch --no-backup-if-mismatch --strip='1' --directory=frameworks/base < ~/Downloads/GmsCore-android_frameworks_base-P.patch
#cd ~/android/lineage/18.1/frameworks/base
#git commit

# Updater URL
cd ~/android/lineage/18.1/packages/apps/Updater/res/values/
vi strings.xml
