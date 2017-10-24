# Google's Apps
GAPPS_VARIANT := pico

PRODUCT_PACKAGES += \
    Books \
    CalendarGooglePrebuilt \
    Chrome \
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
    Chrome \
    PrebuiltDeskClockGoogle

GAPPS_BYPASS_PACKAGE_OVERRIDES := \
    Music2 \
    Photos

# Extra Apps
PRODUCT_PACKAGES += \
    Amazon \
    CommandCenter \
    FDroid \
    FDroidPrivilegedExtension \
    GalleryOnePlus \
    Lawnchair \
    OpenWeatherMapWeatherProvider \
    Substratum \
    TimeWeather \
    YahooWeatherProvider \
    WeatherOnePlus

# Moto G4-only extra apps
PRODUCT_PACKAGES += \
    MotoCamera

# OnePlus 3(T)-only extra apps
PRODUCT_PACKAGES += \
    CameraOnePlus

$(call inherit-product, vendor/opengapps/build/opengapps-packages.mk)