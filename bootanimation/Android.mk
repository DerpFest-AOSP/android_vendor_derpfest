LOCAL_PATH := $(call my-dir)

# DERP_BOOTANIMATION is normalized in config/common.mk: default, legacy, or
# none. "none" leaves these modules out of PRODUCT_PACKAGES. legacy installs
# the old zip under both the light and dark filenames.

ifeq ($(DERP_BOOTANIMATION),legacy)
bootanimation_light_source := $(LOCAL_PATH)/bootanimation_legacy.zip
bootanimation_dark_source := $(LOCAL_PATH)/bootanimation_legacy.zip
else
bootanimation_light_source := $(LOCAL_PATH)/bootanimation.zip
bootanimation_dark_source := $(LOCAL_PATH)/bootanimation-dark.zip
endif

bootanimation_width := $(if $(TARGET_SCREEN_WIDTH),$(TARGET_SCREEN_WIDTH),0)
bootanimation_height := $(if $(TARGET_SCREEN_HEIGHT),$(TARGET_SCREEN_HEIGHT),0)
ifneq ($(filter true,$(TARGET_BOOTANIMATION_HALF_RES)),)
ifneq ($(bootanimation_width),0)
bootanimation_width := $(shell expr $(bootanimation_width) / 2)
bootanimation_height := $(shell expr $(bootanimation_height) / 2)
endif
endif

bootanimation_light_generated := $(TARGET_OUT_INTERMEDIATES)/BOOTANIMATION/bootanimation-$(bootanimation_width)x$(bootanimation_height).zip
bootanimation_dark_generated := $(TARGET_OUT_INTERMEDIATES)/BOOTANIMATION/bootanimation-dark-$(bootanimation_width)x$(bootanimation_height).zip

# Recipes run after every Android.mk has been read, so LOCAL_PATH and the
# variables cleared below are gone by then. Bind them to each target now.
$(bootanimation_light_generated): PRIVATE_SCRIPT := $(LOCAL_PATH)/fit_desc.py
$(bootanimation_light_generated): PRIVATE_WIDTH := $(bootanimation_width)
$(bootanimation_light_generated): PRIVATE_HEIGHT := $(bootanimation_height)
$(bootanimation_light_generated): $(bootanimation_light_source) $(LOCAL_PATH)/fit_desc.py
	@echo "Fitting bootanimation to $(PRIVATE_WIDTH)x$(PRIVATE_HEIGHT)"
	@mkdir -p $(dir $@)
	$(hide) python3 $(PRIVATE_SCRIPT) $< $@ $(PRIVATE_WIDTH) $(PRIVATE_HEIGHT)

$(bootanimation_dark_generated): PRIVATE_SCRIPT := $(LOCAL_PATH)/fit_desc.py
$(bootanimation_dark_generated): PRIVATE_WIDTH := $(bootanimation_width)
$(bootanimation_dark_generated): PRIVATE_HEIGHT := $(bootanimation_height)
$(bootanimation_dark_generated): $(bootanimation_dark_source) $(LOCAL_PATH)/fit_desc.py
	@echo "Fitting dark bootanimation to $(PRIVATE_WIDTH)x$(PRIVATE_HEIGHT)"
	@mkdir -p $(dir $@)
	$(hide) python3 $(PRIVATE_SCRIPT) $< $@ $(PRIVATE_WIDTH) $(PRIVATE_HEIGHT)

# ETC modules install under etc/, which would put these in
# /product/etc/media/. Bootanimation only looks in /product/media/.
include $(CLEAR_VARS)
LOCAL_MODULE := derp_bootanimation
LOCAL_MODULE_CLASS := ETC
LOCAL_MODULE_TAGS := optional
LOCAL_MODULE_STEM := bootanimation.zip
LOCAL_MODULE_PATH := $(TARGET_OUT_PRODUCT)/media
LOCAL_PRODUCT_MODULE := true
include $(BUILD_SYSTEM)/base_rules.mk
$(LOCAL_BUILT_MODULE): $(bootanimation_light_generated)
	@mkdir -p $(dir $@)
	$(hide) cp $< $@

include $(CLEAR_VARS)
LOCAL_MODULE := derp_bootanimation_dark
LOCAL_MODULE_CLASS := ETC
LOCAL_MODULE_TAGS := optional
LOCAL_MODULE_STEM := bootanimation-dark.zip
LOCAL_MODULE_PATH := $(TARGET_OUT_PRODUCT)/media
LOCAL_PRODUCT_MODULE := true
include $(BUILD_SYSTEM)/base_rules.mk
$(LOCAL_BUILT_MODULE): $(bootanimation_dark_generated)
	@mkdir -p $(dir $@)
	$(hide) cp $< $@

bootanimation_light_source :=
bootanimation_dark_source :=
bootanimation_width :=
bootanimation_height :=
bootanimation_light_generated :=
bootanimation_dark_generated :=
