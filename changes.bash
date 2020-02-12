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

## May or may not be included
# For MicroG Signature-Spoofing support (for reference)
cd ~/android/lineage/17.1/
patch --no-backup-if-mismatch --strip='1' --directory=frameworks/base < ~/Downloads/GmsCore-android_frameworks_base-Q.patch
cd ~/android/lineage/17.1/frameworks/base
git commit

# Device-specfic commits
# Sargo (first fix bootloop; second fix bluetooth)
source build/envsetup.sh
repopick 263927
repopick 268545