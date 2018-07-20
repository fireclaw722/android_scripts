## LineageOMS & Cerulean ##
# F-Droid
PRODUCT_PACKAGES += \
    F-DroidPrivilegedExtension \
    FDroid

# Firefox & Substratum
PRODUCT_PACKAGES += \
    Fennec \
    Substratum

## Cerulean ##
# Republic Apps for Republic Wireless support
PRODUCT_PACKAGES += \
    Republic \
    RepublicAnywhere

# Moto Widgets
PRODUCT_PACKAGES += \
    CommandCenter \
    TimeWeather

## Microsoft
# MSN Services
PRODUCT_PACKAGES += \
    Bing \
    Cortana \
    MicrosoftNews

# Microsoft Office
PRODUCT_PACKAGES += \
    Excel \
    Onenote \
    Onedrive \
    Outlook \
    Powerpoint \
    Word

# Extra Microsoft Android Apps
PRODUCT_PACKAGES += \
    Edge \
    MicrosoftLauncher \
    Swiftkey

## Google via OpenGApps
GAPPS_VARIANT := pico
PRODUCT_PACKAGES += \
    Maps \
    Wallet

$(call inherit-product, vendor/opengapps/build/opengapps-packages.mk)
