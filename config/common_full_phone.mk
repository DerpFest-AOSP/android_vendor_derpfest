# Inherit mobile full common Lineage stuff
$(call inherit-product, vendor/lineage/config/common_mobile_full.mk)

# Enable support of one-handed mode
PRODUCT_PRODUCT_PROPERTIES += \
    ro.support_one_handed_mode?=true

# UDFPS Animation effects
PRODUCT_PACKAGES += \
    UdfpsAnimations

# UDFPS Icons
PRODUCT_PACKAGES += \
    UdfpsIcons

$(call inherit-product, vendor/lineage/config/telephony.mk)
