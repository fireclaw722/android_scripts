# ARM64 MindtheGapps GMS
$(call inherit-product, vendor/gapps/arm64/arm64-vendor.mk)

# ARM MindtheGapps GMS
$(call inherit-product, vendor/gapps/arm/arm-vendor.mk)

# OpenGapps GMS
# replace in partner_gms.mk
GAPPS_VARIANT := pico
$(call inherit-product, vendor/opengapps/build/opengapps-packages.mk)

# include on Pixel devices
# in their device.mk or device-common.mk
GAPPS_PRODUCT_PACKAGES += \
    GoogleCamera

# Graphene extras and replacements
# Bromite
PRODUCT_PACKAGES += \
    Bromite \
    BromiteWebView

# Aurora
PRODUCT_PACKAGES += \
    AuroraDroid \
    AuroraServices \
    AuroraStore

# GMSCompat
PRODUCT_PACKAGES += \
    GmsCompat

# Repainter integration
PRODUCT_PACKAGES += \
    RepainterServicePriv

# Graphene Replacements
PRODUCT_PACKAGES += \
    Etar \
    QKSMS \
    Vinyl

# Pixel Active Edge (Graphene)
PRODUCT_PACKAGES += \
    ElmyraService