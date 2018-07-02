# Extra [Firefox, Moto Widgets, F-Droid]

PRODUCT_PACKAGES += \
    CommandCenter \
    F-DroidPrivilegedExtension \
    FDroid \
    Fennec \
    TimeWeather

## Cerulean
# Microsoft Office packages
PRODUCT_PACKAGES += \
    Excel \
    Outlook \
    Powerpoint \
    Word

# Google stuff
GAPPS_VARIANT := nano
PRODUCT_PACKAGES += \
    Books \
    Chromme \
    Maps \
    Music2 \
    Newsstand \
    Videos \
    Wallet

$(call inherit-product, vendor/opengapps/build/opengapps-packages.mk)
