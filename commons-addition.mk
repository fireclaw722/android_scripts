## LineageOMS & Cerulean ##
# F-Droid
PRODUCT_PACKAGES += \
    F-DroidPrivilegedExtension \
    FDroid

## Cerulean ##
# Extras [Firefox, Moto Widgets, Nova]
PRODUCT_PACKAGES += \
    CommandCenter \
    Fennec \
    Nova \
    TimeWeather

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

# Don't override Eleven, Gallery, or Email
GAPPS_BYPASS_PACKAGE_OVERRIDES := \
    Chrome \
    Music2

$(call inherit-product, vendor/opengapps/build/opengapps-packages.mk)
