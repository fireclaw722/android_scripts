# FOSS Extras
PRODUCT_PACKAGES += \
    AuroraServices

# ARM64 MindtheGapps GMS
$(call inherit-product, vendor/gapps/arm64/arm64-vendor.mk)

# ARM MindtheGapps GMS
$(call inherit-product, vendor/gapps/arm/arm-vendor.mk)

# OpenGapps GMS
# replace in partner_gms.mk
ifdef WITH_GMS
    ifeq ($(WITH_GMS),true)
        GAPPS_VARIANT := pico
        $(call inherit-product, vendor/opengapps/build/opengapps-packages.mk)
    else
        PRODUCT_PACKAGES += \
            MGmsCore \
            MGsfProxy \
            FakeStore \
            privapp-permissions-com.google.android.gms.xml \
            privapp-permissions-com.android.vending.xml
    endif
else
    PRODUCT_PACKAGES += \
            MGmsCore \
            MGsfProxy \
            FakeStore \
            privapp-permissions-com.google.android.gms.xml \
            privapp-permissions-com.android.vending.xml
endif


# include on Pixel devices
# in their device.mk or device-common.mk
ifeq ($(WITH_GMS),true)
    GAPPS_PRODUCT_PACKAGES += \
        GoogleCamera
endif

