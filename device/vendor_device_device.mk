# Google's Apps
GAPPS_VARIANT := pico

PRODUCT_PACKAGES += \
    CalendarGooglePrebuilt \
    Drive \
    GoogleTTS \
    Maps \
    Music2 \
    PrebuiltDeskClockGoogle \
    PrebuiltKeep \
    Velvet \
    Wallet

GAPPS_PACKAGE_OVERRIDES := \
    PrebuiltDeskClockGoogle

GAPPS_BYPASS_PACKAGE_OVERRIDES := \
    Music2

# Extra Apps
PRODUCT_PACKAGES += \
    Amazon \
    CommandCenter \
    FDroid \
    FDroidPrivilegedExtension \
    Lawnchair \
    Lawnfeed \
    OpenWeatherMapWeatherProvider \
    Substratum \
    TimeWeather \
    YahooWeatherProvider

$(call inherit-product, vendor/opengapps/build/opengapps-packages.mk)