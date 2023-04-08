# Audio
$(call inherit-product, vendor/lineage/config/audio.mk)

# Fonts
include vendor/fontage/config.mk

# Additional props
PRODUCT_SYSTEM_DEFAULT_PROPERTIES += \
    drm.service.enabled=true \
    media.mediadrmservice.enable=true \
    persist.sys.disable_rescue=true

# Disable touch video heatmap to reduce latency, motion jitter, and CPU usage
# on supported devices with Deep Press input classifier HALs and models
PRODUCT_PRODUCT_PROPERTIES += \
    ro.input.video_enabled=false

# Blur
ifndef TARGET_NOT_USES_BLUR
    USES_BLUR=1
endif

ifeq ($(TARGET_NOT_USES_BLUR),true)
    USES_BLUR=0
else
    USES_BLUR=1
endif

PRODUCT_PRODUCT_PROPERTIES += \
    ro.sf.blurs_are_expensive=$(USES_BLUR) \
    ro.surface_flinger.supports_background_blur=$(USES_BLUR) \
    persist.sysui.disableBlur=$(shell echo $$((1 - $(USES_BLUR))))

PRODUCT_PRODUCT_PROPERTIES += \
     ro.launcher.blur.appLaunch=0

# Disable async MTE on system_server
PRODUCT_SYSTEM_EXT_PROPERTIES += \
    arm64.memtag.process.system_server=off

# Enable dex2oat64 to do dexopt
PRODUCT_SYSTEM_EXT_PROPERTIES += \
    dalvik.vm.dex2oat64.enabled=true

# StorageManager configuration
PRODUCT_PRODUCT_PROPERTIES += \
    ro.storage_manager.show_opt_in=false

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

# GMS
WITH_GMS := true
$(call inherit-product-if-exists, vendor/google/gms/config.mk)
$(call inherit-product-if-exists, vendor/google/pixel/config.mk)
