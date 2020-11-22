# MicroG GMS, F-Droid, Aurora
$(call inherit-product, packages/apps/prebuilt/microg.mk)

# ARM64 MindtheGapps GMS
$(call inherit-product, vendor/gapps/arm64/arm64-vendor.mk)

# ARM MindtheGapps GMS
$(call inherit-product, vendor/gapps/arm/arm-vendor.mk)

# OpenGapps GMS
# replace in partner_gms.mk
ifeq ($(WITH_GMS),true)
    GAPPS_VARIANT := pico
    $(call inherit-product, vendor/opengapps/build/opengapps-packages.mk)
endif

# include on Pixel devices
# in their device.mk or device-common.mk
ifeq ($(WITH_GMS),true)
    GAPPS_PRODUCT_PACKAGES += \
        GoogleCamera
endif

# FOSS Extras
PRODUCT_PACKAGES += \
    AuroraServices