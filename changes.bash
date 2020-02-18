####
#### This isn't an actual script, and it is to
#### function as a how-to merge different changes
####
exit

##
## System-based changes
##
cd ~/android/lineage/17.1

# add fdroid and other pre-built apps to build process
cd ~/android/lineage/17.1/vendor/lineage/config/
cat commons-additions.mk >> common.mk

# match AOSP versioning
cd ~/android/lineage/17.1/vendor/lineage/config/
vi common.mk

# Change System icon-mask back to square
cd ~/android/lineage/17.1/vendor/lineage/overlay/common/frameworks/base/core/res/res/values/
vi config.xml
    # change
    <string name="config_icon_mask" translatable="false">"M50 0A50 50,0,1,1,50 100A50 50,0,1,1,50 0"</string>
    <string name="config_icon_mask" translatable="false">"M0,20C0,8.954 8.954,0 20,0H80C91.046,0 100,8.954 100,20V80C100,91.046 91.046,100 80,100H20C8.954,100 0,91.046 0,80V20Z"</string>
    
    # remove
    <!-- Flag indicating whether round icons should be parsed from the application manifest. -->
    <bool name="config_useRoundIcon">true</bool>

# Replace Android system emoji with EmojiOne
cd ~/android/lineage/17.1/external/noto-fonts/emoji
cp ~/Downloads/NotoColorEmoji.ttf ./

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
cd kernel/google/msm-4.9
git fetch "https://github.com/LineageOS/android_kernel_google_msm-4.9" refs/changes/40/263940/1 && git cherry-pick FETCH_HEAD