# Google's Apps
GAPPS_VARIANT := pico

PRODUCT_PACKAGES += \
    CalendarGooglePrebuilt \
    Drive \
    GoogleTTS \
    Maps \
    Music2 \
    PrebuiltKeep \
    Velvet \
    Wallet

GAPPS_BYPASS_PACKAGE_OVERRIDES := \
    Music2

# Technically Google Apps, but not provided by OpenGapps
PRODUCT_PACKAGES += \
    Fireball \
    Gearhead \
    Tachyon

# Extra Apps
PRODUCT_PACKAGES += \
    CommandCenter \
    FDroid \
    FDroidPrivilegedExtension \
    Nova \
    Substratum \
    Swiftkey \
    TimeWeather \
    Underground \
    YahooWeatherProvider

$(call inherit-product, vendor/opengapps/build/opengapps-packages.mk)