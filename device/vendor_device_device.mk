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
    Aptoide \
    CommandCenter \
    FDroid \
    FDroidPrivilegedExtension \
    mShop \
    Nova \
    Substratum \
    Swiftkey \
    TimeWeather \
    UnifiedNlp \
    Venezia \
    YahooWeatherProvider \
    YalpStore

$(call inherit-product, vendor/opengapps/build/opengapps-packages.mk)