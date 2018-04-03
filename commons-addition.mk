# Google's Apps from opengapps/aosp_build
GAPPS_VARIANT := nano

PRODUCT_PACKAGES += \
    Drive \
    Fireball \
    Maps \
    Photos \
    Tachyon \
    Wallet

# Don't override Eleven or Gallery
GAPPS_BYPASS_PACKAGE_OVERRIDES := \
    Photos

# Moto Widgets
PRODUCT_PACKAGES += \
    CommandCenter \
    TimeWeather

# FDroid
PRODUCT_PACKAGES += \
    FDroid \
    FDroidPrivilegedExtension

# Extra [Nova (for Google Now), Swiftkey, Amazon Underground, Yahoo WeatherProvider]
PRODUCT_PACKAGES += \
    Fennec \
    Nova \
    Swiftkey \
    Venezia

$(call inherit-product, vendor/opengapps/build/opengapps-packages.mk)