# Fonts
include vendor/fontage/config.mk

# Overlays
include vendor/overlay/overlays.mk

# Certification
$(call inherit-product, vendor/certification/config.mk)

# DRM Service
PRODUCT_PRODUCT_PROPERTIES += \
    drm.service.enabled=true \
    media.mediadrmservice.enable=true

# Disable RescueParty due to high risk of data loss
PRODUCT_PRODUCT_PROPERTIES += \
    persist.sys.disable_rescue=true

# Disable touch video heatmap to reduce latency, motion jitter, and CPU usage
# on supported devices with Deep Press input classifier HALs and models
PRODUCT_PRODUCT_PROPERTIES += \
    ro.input.video_enabled=false

# Blur
ifneq ($(TARGET_SUPPORTS_BLUR),false)
PRODUCT_PRODUCT_PROPERTIES += ro.surface_flinger.supports_background_blur=1
endif

# Disable async MTE on system_server
PRODUCT_SYSTEM_EXT_PROPERTIES += \
    arm64.memtag.process.system_server=off

# Enable dex2oat64 to do dexopt
PRODUCT_SYSTEM_EXT_PROPERTIES += \
    dalvik.vm.dex2oat64.enabled=true

# StorageManager configuration
PRODUCT_PRODUCT_PROPERTIES += \
    ro.storage_manager.show_opt_in=false

# Extra packages
PRODUCT_PACKAGES += \
    Accord \
    BatteryStatsViewer \
    DerpWalls \
    GameSpace \
    LMOSystemUIClock \
    Prospect \
    Ripple

# ColumbusService
ifneq ($(TARGET_SUPPORTS_QUICK_TAP),false)
PRODUCT_PACKAGES += \
    ColumbusService
endif

# Face Unlock
TARGET_FACE_UNLOCK_SUPPORTED ?= $(TARGET_SUPPORTS_64_BIT_APPS)
ifeq ($(TARGET_FACE_UNLOCK_SUPPORTED),true)
    PRODUCT_PACKAGES += \
        ParanoidSense
    PRODUCT_SYSTEM_EXT_PROPERTIES += \
        ro.face.sense_service=true
    PRODUCT_COPY_FILES += \
        frameworks/native/data/etc/android.hardware.biometrics.face.xml:$(TARGET_COPY_OUT_SYSTEM_EXT)/etc/permissions/android.hardware.biometrics.face.xml
else
    PRODUCT_PACKAGES += \
        SettingsGoogleFutureFaceEnroll
endif

# Don't dexpreopt prebuilts. (For GMS).
DONT_DEXPREOPT_PREBUILTS := true

# Include GMS by default
WITH_GMS := true
$(call inherit-product, vendor/gms/products/gms.mk)

# Signing
ifneq (eng,$(TARGET_BUILD_VARIANT))
ifneq (,$(wildcard vendor/lineage/signing/keys/releasekey.pk8))
PRODUCT_DEFAULT_DEV_CERTIFICATE := vendor/lineage/signing/keys/releasekey
PRODUCT_MAINLINE_BLUETOOTH_SEPOLICY_DEV_CERTIFICATES := $(dir $(PRODUCT_DEFAULT_DEV_CERTIFICATE))
PRODUCT_DEFAULT_PROPERTY_OVERRIDES += ro.oem_unlock_supported=1
endif
ifneq (,$(wildcard vendor/lineage/signing/keys/otakey.x509.pem))
PRODUCT_OTA_PUBLIC_KEYS := vendor/lineage/signing/keys/otakey.x509.pem
endif
endif
