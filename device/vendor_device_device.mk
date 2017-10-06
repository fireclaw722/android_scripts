# Google's Apps
GAPPS_VARIANT := pico

PRODUCT_PACKAGES += \
    CalendarGooglePrebuilt \
    GoogleDialer \
    Maps \
    Photos \
    Wallet

GAPPS_FORCE_DIALER_OVERRIDES := true

$(call inherit-product, vendor/opengapps/build/opengapps-packages.mk)