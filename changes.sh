## Add SafetyNet Patches
# moto-msm8953/addison
### NOT INCLUDED BECAUSE ADDISON ISNT PORTED TO 15.1
cd ~/android/lineage/lineage-15.1/kernel/motorola/msm8953
git fetch https://github.com/franciscofranco/one_plus_3T
git cherry-pick 8e65978cec11a62b0404d88db43adb35f3258e7d c97c758b15ba49bb848e0644089432569145ade3

# moto-msm8952/athene
### NOT INCLUDED BECAUSE ATHENE ISNT PORTED TO 15.1
cd ~/android/lineage/lineage-15.1/kernel/motorola/msm8952
git fetch https://github.com/franciscofranco/one_plus_3T
git cherry-pick 8e65978cec11a62b0404d88db43adb35f3258e7d c97c758b15ba49bb848e0644089432569145ade3

# oneplus-msm8996/oneplus3
cd ~/android/lineage/lineage-15.1/kernel/oneplus/msm8996
git fetch https://github.com/franciscofranco/one_plus_3T
git cherry-pick 8e65978cec11a62b0404d88db43adb35f3258e7d c97c758b15ba49bb848e0644089432569145ade3

# moto-msm8974/victara not applicable :: no bootloader check on safetynet

# Low-RAM on Moto G4
cd ~/android/lineage/lineage-15.1/device/motorola/athene/
# edit system.prop ; adding the following
    # Low memory device
    ro.config.low_ram=true

    # Force high-end graphics in low ram mode
    persist.sys.force_highendgfx=trues

## Extras
# add google, fdroid, and other pre-builts to build process
cd ~/android/lineage/lineage-15.1/vendor/lineage/config/
cat commons-additions.mk >> common.mk

# Change icon-mask back to square
# revert: https://github.com/LineageOS/android_vendor_lineage/commit/d12ab12c6142337fc79a76af50fc3d62bc337626
cd ~/android/lineage/lineage-15.1/vendor/lineage/overlay/common/frameworks/base/core/res/res/values/
sed -r 's/<string name="config_icon_mask" translatable="false">"M50 0A50 50,0,1,1,50 100A50 50,0,1,1,50 0"</string>//' config.xml

# Add support for unofficial updates
cd ~/android/lineage/lineage-15.1/packages/apps/Updater/res/values/
sed -r 's/download.lineageos.org/ota.jwolfweb.com/' strings.xml

# add blue bootanimation
cp ~/Downloads/bootanimation.tar ~/android/lineage/lineage-15.1/vendor/lineage/bootanimation

# revert 5252d606716c3f8d81617babc1293c122359a94d
cd ~/android/lineage/lineage-15.1/packages/apps/Updater
git revert 5252d606716c3f8d81617babc1293c122359a94d