## Basic Extras - LineageOMS/Unofficial builds
# F-Droid
PRODUCT_PACKAGES += \
    FDroidPrivilegedExtension \
    FDroid

# Substratum
PRODUCT_PACKAGES += \
    Substratum

## Personal builds
# Firefox
PRODUCT_PACKAGES += \
    Firefox \
    Klar

# Weather app
PRODUCT_PACKAGES += \
    Weather

# Better Messaging Apps
PRODUCT_PACKAGES += \
    QKSMS


## GMS or MicroG
# MicroG
PRODUCT_PACKAGES += \
    DroidGuard \
    FakeStore \
    GmsCore \
    GsfProxy \
    MozillaNlp \
    NominatimNlp \
    YalpStore

# GMS
GAPPS_VARIANT := pico

GAPPS_PRODUCT_PACKAGES += \
    Maps \
    Wallet

$(call inherit-product, vendor/opengapps/build/opengapps-packages.mk)