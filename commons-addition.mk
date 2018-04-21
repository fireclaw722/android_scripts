# Google's Apps
GAPPS_VARIANT := nano

PRODUCT_PACKAGES += \
    Chrome \
    Drive \
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

# Extra [Firefox, Nova (for Google Now), Signal, Swiftkey, Amazon App Store]
PRODUCT_PACKAGES += \
    Fennec \
    Nova \
    Signal \
    Swiftkey \
    Venezia

$(call inherit-product, vendor/opengapps/build/opengapps-packages.mk)