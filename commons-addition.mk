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

# Weather app
PRODUCT_PACKAGES += \
    Weather

# Better Messaging Apps
PRODUCT_PACKAGES += \
    QKSMS \
    Signal

# MicroG Services
PRODUCT_PACKAGES += \
    DroidGuard \
    GmsCore \
    GsfProxy \
    MozillaNlp \
    NominatimNlp \
    Phonesky

# Nextcloud sync Apps
PRODUCT_PACKAGES += \
    DavDroid \
    Nextcloud \
    NextcloudNotes

# GMS --for reference--
GAPPS_VARIANT := pico

GAPPS_PRODUCT_PACKAGES += \
    Maps \
    Wallet

$(call inherit-product, vendor/opengapps/build/opengapps-packages.mk)