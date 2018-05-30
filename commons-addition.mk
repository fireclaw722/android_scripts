# Google's Apps
GAPPS_VARIANT := nano

# opengapps/aosp_build
PRODUCT_PACKAGES += \
    Books \
    Drive \
    Maps \
    Music2 \
    Newsstand \
    Photos \
    PlayGames \
    Videos \
    Wallet \
    YouTube

# other google apps
PRODUCT_PACKAGES += \
    Fireball \
    Gearhead \
    Tachyon

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

# Microsoft Office packages
PRODUCT_PACKAGES += \
    Excel \
    Outlook \
    Powerpoint \
    Word

# Extra [Firefox, Nova (for Google Now), Swiftkey]
PRODUCT_PACKAGES += \
    Fennec \
    Nova \
    Swiftkey

$(call inherit-product, vendor/opengapps/build/opengapps-packages.mk)