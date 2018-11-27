## Basic Extras
# F-Droid
PRODUCT_PACKAGES += \
    FDroidPrivilegedExtension \
    FDroid

# Firefox
PRODUCT_PACKAGES += \
    Firefox \
    Klar

# Substratum
PRODUCT_PACKAGES += \
    Substratum \
    SubstratumService

PRODUCT_SYSTEM_SERVER_APPS += \
    SubstratumService

# Weather app and provider
PRODUCT_PACKAGES += \
    Weather \
    YahooProvider

# Launcher from e.foundation
PRODUCT_PACKAGES += \
    BlissIconPack \
    BlissLauncher

# Lawnchair
#PRODUCT_PACKAGES += \
#   Lawnchair

# GMS
GAPPS_VARIANT := pico

GAPPS_PRODUCT_PACKAGES += \
    Maps \
    Wallet

$(call inherit-product, vendor/opengapps/build/opengapps-packages.mk)