# Google's Apps
GAPPS_VARIANT := pico

PRODUCT_PACKAGES += \
    CalendarGooglePrebuilt \
    GoogleDialer \
    Maps \
    Music2 \
    Photos \
    Wallet

GAPPS_FORCE_DIALER_OVERRIDES := true

GAPPS_BYPASS_PACKAGE_OVERRIDES := Music2

$(call inherit-product, vendor/opengapps/build/opengapps-packages.mk)