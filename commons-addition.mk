## Basic Extras Unofficial builds
PRODUCT_PACKAGES += \
    Cloud \
    FDroid \
    F-DroidPrivilegedExtension \
    Notes

# MicroG GMS
PRODUCT_PACKAGES += \
    GmsCore \
    GsfProxy \
    Phonesky

# MindtheGapps GMS
$(call inherit-product, vendor/gapps/arm64/arm64-vendor.mk)

# OpenGapps GMS
GAPPS_VARIANT := pico

GAPPS_PRODUCT_PACKAGES += \
    DigitalWellbeing \
    Maps \
    Wallet

$(call inherit-product, vendor/opengapps/build/opengapps-packages.mk)
