# Google's Apps
GAPPS_VARIANT := nano

# opengapps/aosp_build
PRODUCT_PACKAGES += \
    Maps \
    Music2 \
    Newsstand \
    PlayGames \
    Videos \
    Wallet

# Don't override Eleven, Gallery, or Email
GAPPS_BYPASS_PACKAGE_OVERRIDES := \
    Music2

# Moto Widgets
PRODUCT_PACKAGES += \
    CommandCenter \
    TimeWeather

# FDroid
PRODUCT_PACKAGES += \
    FDroid \
    F-DroidPrivilegedExtension

# Extra [Firefox, Nova (for Google Now)]
PRODUCT_PACKAGES += \
    Fennec \
    Nova

$(call inherit-product, vendor/opengapps/build/opengapps-packages.mk)