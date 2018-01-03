# Google's Apps from OpenGapps/aosp_build
GAPPS_VARIANT := stock

# Remove apps that aren't good for non-Nexus/non-Pixel phones
GAPPS_EXCLUDED_PACKAGES := \
    GoogleCamera \
    GoogleDialer

# Don't override Eleven, Email, or Gallery
GAPPS_BYPASS_PACKAGE_OVERRIDES := \
    Music2 \
    Photos \
    PrebuiltGmail

# Extra Apps
PRODUCT_PACKAGES += \
    CommandCenter \
    FDroid \
    FDroidPrivilegedExtension \
    Fireball \
    Gearhead \
    Nova \
    Substratum \
    Swiftkey \
    Tachyon \
    TimeWeather \
    Underground \
    Venezia \
    YahooWeatherProvider

$(call inherit-product, vendor/opengapps/build/opengapps-packages.mk)