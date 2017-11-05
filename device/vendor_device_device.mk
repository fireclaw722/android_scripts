# Google's Apps
GAPPS_VARIANT := pico

PRODUCT_PACKAGES += \
    CalendarGooglePrebuilt \
    Drive \
    GoogleTTS \
    Maps \
    Music2 \
	PrebuiltBugle \
    PrebuiltKeep \
    Velvet \
    Wallet

GAPPS_FORCE_MMS_OVERRIDES := true

GAPPS_BYPASS_PACKAGE_OVERRIDES := \
    Music2

# Technically Google Apps, but not provided by OpenGapps
PRODUCT_PACKAGES += \
    Fireball \
    Gearhead \
    Tachyon

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
    Swiftkey \
    TimeWeather \
    YahooWeatherProvider

$(call inherit-product, vendor/opengapps/build/opengapps-packages.mk)