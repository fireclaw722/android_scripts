# MicroG GMS, F-Droid, Aurora
$(call inherit-product, packages/apps/prebuilt/microg.mk)

# ARM64 MindtheGapps GMS
$(call inherit-product, vendor/gapps/arm64/arm64-vendor.mk)

# ARM MindtheGapps GMS
$(call inherit-product, vendor/gapps/arm/arm-vendor.mk)

# OpenGapps GMS
GAPPS_VARIANT := pico

GAPPS_PRODUCT_PACKAGES += \
    DigitalWellbeing \
    Maps \
    PrebuiltBugle \
    Wallet

# include on Pixel devices
GAPPS_PRODUCT_PACKAGES += \
    GoogleCamera

$(call inherit-product, vendor/opengapps/build/opengapps-packages.mk)
