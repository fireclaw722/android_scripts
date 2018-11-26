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
    Substratum

# Weather app and provider
PRODUCT_PACKAGES += \
    Weather \
    YahooProvider

# Lawnchair over Trebuchet
PRODUCT_PACKAGES += \
    Lawnchair

# Launcher from e.foundation
PRODUCT_PACKAGES += \
    BlissIconPack \
    BlissLauncher

# GMS
GAPPS_VARIANT := pico

GAPPS_PRODUCT_PACKAGES += \
    Maps \
    Wallet

$(call inherit-product, vendor/opengapps/build/opengapps-packages.mk)