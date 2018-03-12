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

## Extras
# add fdroid, and other pre-builts to build process
cd ~/android/lineage/lineage-15.1/vendor/lineage/config/
cat commons-additions.mk >> common.mk

# Add support for updater
cd ~/android/lineage/lineage-15.1/packages/apps/Updater/res/values/
sed -r 's/download.lineageos.org/ota.jwolfweb.com/' strings.xml