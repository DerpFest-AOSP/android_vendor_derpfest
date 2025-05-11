# Increase DerpFest Version with each major release.
DERPFEST_VERSION := 16.0

DERPFEST_BUILD_DATE := $(shell date -u +%Y%m%d)

# Allow DERPFEST_BUILD_TYPE to be set from the environment, default to Community
DERPFEST_BUILD_TYPE ?= $(strip $(DERPFEST_BUILD_TYPE))
ifeq ($(DERPFEST_BUILD_TYPE),)
  DERPFEST_BUILD_TYPE := Community
endif

# Build variant
DERPFEST_BETA ?= true
ifeq ($(DERPFEST_BETA),false)
    DERPFEST_BUILD_VARIANT = Beta
else
    DERPFEST_BUILD_VARIANT = Stable
endif

# Internal version
LINEAGE_VERSION := DerpFest-v$(DERPFEST_VERSION)-$(shell date +%Y%m%d)-$(LINEAGE_BUILD)-$(DERPFEST_BUILD_TYPE)-$(DERPFEST_BUILD_VARIANT)

# Display version
LINEAGE_DISPLAY_VERSION := DerpFest-v$(DERPFEST_VERSION)-$(LINEAGE_BUILD)

# DerpFest version properties
PRODUCT_SYSTEM_PROPERTIES += \
    ro.derpfest.build.date=$(DERPFEST_BUILD_DATE) \
    ro.derpfest.build.version=$(LINEAGE_VERSION) \
    ro.derpfest.build.variant=$(DERPFEST_BUILD_VARIANT) \
    ro.derpfest.display.version=$(LINEAGE_DISPLAY_VERSION) \
    ro.derpfest.releasetype=$(DERPFEST_BUILD_TYPE) \
    ro.derpfest.version=$(DERPFEST_VERSION) \
    ro.derpfestlegal.url=https://derpfest.org/privacy
