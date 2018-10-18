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
