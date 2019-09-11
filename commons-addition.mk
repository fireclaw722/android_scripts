## Basic Extras LineageOMS/Unofficial builds
# F-Droid
PRODUCT_PACKAGES += \
    FDroidPrivilegedExtension \
    FDroid
## Personal Builds
# Firefox
PRODUCT_PACKAGES += \
    Klar

# Weather app and provider
PRODUCT_PACKAGES += \
    Weather

# MicroG GMS
PRODUCT_PACKAGES += \
    DroidGuard \
    GmsCore \
    GsfProxy \
    MozillaNlp \
    MozillaNlp \
    Phonesky

# GMS
GAPPS_VARIANT := pico

GAPPS_PRODUCT_PACKAGES += \
    DigitalWellbeing \
    Maps \
    Wallet

$(call inherit-product, vendor/opengapps/build/opengapps-packages.mk)
