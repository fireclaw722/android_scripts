# Google's Apps from opengapps/aosp_build
GAPPS_VARIANT := nano

PRODUCT_PACKAGES += \
    Drive \
    Maps \
    Photos \
    Wallet

# Don't override Eleven or Gallery
GAPPS_BYPASS_PACKAGE_OVERRIDES := \
    Photos

# Google Apps not provided by opengapps/aosp_build
PRODUCT_PACKAGES += \
    Fireball \
    Gearhead \
    Tachyon

# Moto Widgets
PRODUCT_PACKAGES += \
    CommandCenter \
    TimeWeather

# FDroid
PRODUCT_PACKAGES += \
    FDroid \
    FDroidPrivilegedExtension

# Extra [Nova (for Google Now), Swiftkey, Amazon Underground, Yahoo WeatherProvider]
PRODUCT_PACKAGES += \
    Fennec \
    Nova \
    Swiftkey \
    Underground \
    Venezia \
    YahooWeatherProvider

$(call inherit-product, vendor/google/build/opengapps-packages.mk)