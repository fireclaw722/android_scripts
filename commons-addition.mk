## Basic Extras LineageOMS/Unofficial builds
# F-Droid
PRODUCT_PACKAGES += \
    FDroidPrivilegedExtension \
    FDroid

# Substratum
PRODUCT_PACKAGES += \
    Substratum \
    SubstratumService

PRODUCT_SYSTEM_SERVER_APPS += \
    SubstratumService

## Personal Builds
# Firefox
PRODUCT_PACKAGES += \
    Firefox \
    Klar

# Weather app and provider
PRODUCT_PACKAGES += \
    Weather \
    YahooProvider

# Better Messaging Apps
PRODUCT_PACKAGES += \
    QKSMS

# GMS
GAPPS_VARIANT := pico

GAPPS_PRODUCT_PACKAGES += \
    Maps \
    Wallet

$(call inherit-product, vendor/opengapps/build/opengapps-packages.mk)