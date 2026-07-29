# Inherit mobile mini common Lineage stuff
$(call inherit-product, vendor/lineage/config/common_mobile_mini.mk)

# Define tablet-specific variables
TARGET_IS_TABLET := true

# Inherit tablet common Lineage stuff
$(call inherit-product, vendor/lineage/config/tablet.mk)

$(call inherit-product, vendor/lineage/config/telephony.mk)
