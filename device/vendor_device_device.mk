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

# Google's Apps
GAPPS_VARIANT := pico

PRODUCT_PACKAGES += \
    CalendarGooglePrebuilt \
    GoogleDialer \
    Maps \
    Music2 \
    Photos \
    Turbo \
    Velvet \
    Wallet

GAPPS_FORCE_DIALER_OVERRIDES := true

GAPPS_BYPASS_PACKAGE_OVERRIDES := \
    Music2 \
    Photos

$(call inherit-product, vendor/opengapps/build/opengapps-packages.mk)