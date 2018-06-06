# Moto Widgets
PRODUCT_PACKAGES += \
    CommandCenter \
    TimeWeather

# FDroid
PRODUCT_PACKAGES += \
    FDroid \
    F-DroidPrivilegedExtension

# Extra [Firefox, Google Now Plugins (for non-Stock Launchers)]
PRODUCT_PACKAGES += \
    ActionGoogle \
    Fennec \
    NovaGoogle \
    UnifiedNlp

$(call inherit-product, vendor/opengapps/build/opengapps-packages.mk)