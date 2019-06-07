## Basic Extras - LineageOMS/Unofficial builds
# F-Droid
PRODUCT_PACKAGES += \
    FDroidPrivilegedExtension \
    FDroid

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
    Signal

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