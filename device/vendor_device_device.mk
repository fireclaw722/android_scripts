# Google's Apps
GAPPS_VARIANT := pico

PRODUCT_PACKAGES += \
    Books \
    CalendarGooglePrebuilt \
    Drive \
    GCS \
    GoogleTTS \
    Maps \
    Music2 \
    Photos \
    PlayGames \
    PrebuiltDeskClockGoogle \
    PrebuiltKeep \
    PrebuiltNewsWeather \
    Velvet \
    Wallet \
    Youtube

GAPPS_PACKAGE_OVERRIDES := \
    PrebuiltDeskClockGoogle

GAPPS_BYPASS_PACKAGE_OVERRIDES := \
    Music2 \
    Photos

# Extra Apps
PRODUCT_PACKAGES += \
    Amazon \
    FDroid \
    FDroidPrivilegedExtension \
    Lawnchair \
    MotoCamera \
    OnePlusCamera \
    OnePlusGallery \
    Substratum \
    TimeWeather \
    YahooWeatherProvider

$(call inherit-product, vendor/opengapps/build/opengapps-packages.mk)