# Google's Apps from opengapps/aosp_build
GAPPS_VARIANT := micro

PRODUCT_PACKAGES += \
    Drive \
    Maps \
    Music2 \
    Photos \
    PixelLauncher \
    PixelLauncherIcons \
    PlusOne \
    PrebuiltBugle \
    Wallet \
    YouTube

# Don't override Eleven, Email, or Gallery
GAPPS_BYPASS_PACKAGE_OVERRIDES := \
    Music2 \
    Photos \
    PrebuiltGmail

# Google Apps not provided by opengapps/aosp_build
PRODUCT_PACKAGES += \
    Fireball \
    Gearhead \
    Tachyon

# Moto Widgets
PRODUCT_PACKAGES += \
    CommandCenter \
    TimeWeather

# Amazon Apps
PRODUCT_PACKAGES += \
    Underground \
    Venezia 

# FDroid
PRODUCT_PACKAGES += \
    FDroid \
    FDroidPrivilegedExtension

# Extra [Nova (for Google Now), Swiftkey, Yahoo WeatherProvider]
PRODUCT_PACKAGES += \
    Nova \
    Swiftkey \
    YahooWeatherProvider

$(call inherit-product, vendor/opengapps/build/opengapps-packages.mk)