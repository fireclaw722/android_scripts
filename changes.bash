####
#### This isn't an actual script, and it is to
#### function as a how-to merge different changes
####
exit

##
## System-based changes
##
cd ~/android/lineage/17.1

# add fdroid and other pre-built apps to build process (from commons-addition.mk)
cd ~/android/lineage/17.1/vendor/lineage/config/
vi common.mk

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

##
## Device-specfic commits
##
# Sargo bootloop issue
cd ~/android/lineage/17.1/kernel/google/msm-4.9
git fetch "https://github.com/LineageOS/android_kernel_google_msm-4.9" refs/changes/27/263927/2 && git cherry-pick FETCH_HEAD

# Sargo Bluetooth issue
cd ~/android/lineage/17.1/device/google/bonito
git fetch "https://github.com/LineageOS/android_device_google_bonito" refs/changes/45/268545/1 && git cherry-pick FETCH_HEAD

# Sargo Performance improvements
cd  ~/android/lineage/17.1/kernel/google/msm-4.9
git fetch "https://github.com/LineageOS/android_kernel_google_msm-4.9" refs/changes/40/263940/1 && git cherry-pick FETCH_HEAD

# Bonito/Sargo update fingerprint
cd ~/android/lineage/17.1/device/google/bonito
git fetch https://github.com/invisiblek/android_device_google_bonito lineage-17.1_btwtf
git cherry-pick 1d50d687d6d5ab027ad98e53e999f14fa9aa1d6d

# google_msm-4.9 Safetynet
cd  ~/android/lineage/17.1/kernel/google/msm-4.9
git fetch https://github.com/flar2/Bluecross 
git cherry-pick 27823dd5b1bc55f6ae3b09bcd321d2e2614c28a1
git cherry-pick 978aa6865137c3a7cf7c05415dbeb30ad3e82052
