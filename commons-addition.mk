## Basic Extras LineageOMS/Unofficial builds
# F-Droid
PRODUCT_PACKAGES += \
    FDroidPrivilegedExtension \
    FDroid

## Personal Builds
# Firefox
PRODUCT_PACKAGES += \
    Klar

# Weather app
PRODUCT_PACKAGES += \
    Weather

# Nextcloud sync Apps
PRODUCT_PACKAGES += \
    DavDroid \
    Nextcloud \
    NextcloudNotes

# MicroG GMS
PRODUCT_PACKAGES += \
    DroidGuard \
    GmsCore \
    GsfProxy \
    MozillaNlp \
    NominatimNlp \
    Phonesky

# GMS --for reference--
GAPPS_VARIANT := pico

GAPPS_PRODUCT_PACKAGES += \
    Maps \
    Wallet

$(call inherit-product, vendor/opengapps/build/opengapps-packages.mk)
