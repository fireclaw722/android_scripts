## Basic Extras
# F-Droid
PRODUCT_PACKAGES += \
    FDroidPrivilegedExtension \
    FDroid

# Firefox
PRODUCT_PACKAGES += \
    Fennec \
    Klar

# Substratum
PRODUCT_PACKAGES += \
    Substratum \
    SubstratumService

PRODUCT_SYSTEM_SERVER_APPS += \
    SubstratumService

# MicroG's NLP with Mozilla and Nominatim backends
PRODUCT_PACKAGES += \
    UnifiedNlp \
    MozillaNlp \
    NominatimNlp

# Weather app
PRODUCT_PACKAGES += \
    Weather

# Citrus AOSP/CAF ROM's built-in theme
PRODUCT_PACKAGES += \
    Margarita

##### Google Mobile Services #####
GAPPS_VARIANT := pico

GAPPS_PRODUCT_PACKAGES += \
    Maps \
    PrebuiltBugle

$(call inherit-product, vendor/opengapps/build/opengapps-packages.mk)

##### Microsoft Apps #####
PRODUCT_PACKAGES += \
    Bing \
    Cortana \
    Edge \
    MicrosoftLauncher \
    MicrosoftNews \
    OfficeExcel \
    OfficeOnenote \
    OfficeOutlook \
    OfficePowerpoint \
    OfficeWord \
    Skydrive \
    Swiftkey
