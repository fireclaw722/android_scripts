# Google's Apps
GAPPS_VARIANT := nano

PRODUCT_PACKAGES += \
    Books \
    Drive \
    Maps \
    Music2 \
    Photos \
    PlayGames \
    PrebuiltGmail \
    PrebuiltKeep \
    Tachyon \
    Videos \
    Wallet

# Don't override Eleven, Gallery, or Email
GAPPS_BYPASS_PACKAGE_OVERRIDES := \
    Music2 \
    Photos \
    PrebuiltGmail

# Moto Widgets
PRODUCT_PACKAGES += \
    CommandCenter \
    TimeWeather

# FDroid
PRODUCT_PACKAGES += \
    FDroid \
    FDroidPrivilegedExtension

# Extra [Firefox, Nova (for Google Now), Swiftkey]
PRODUCT_PACKAGES += \
    Fennec \
    Nova \
    Swiftkey

$(call inherit-product, vendor/opengapps/build/opengapps-packages.mk)