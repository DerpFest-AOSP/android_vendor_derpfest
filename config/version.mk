# Increase DerpFest Version with each major release.
DERPFEST_VERSION := 16.2

DERPFEST_BUILD_DATE := $(shell date -u +%Y%m%d)

# Allow DERPFEST_BUILD_TYPE to be set from the environment, default to Community
ifdef DERPFEST_BUILD_TYPE
  DERPFEST_BUILD_TYPE := $(strip $(DERPFEST_BUILD_TYPE))
else
  DERPFEST_BUILD_TYPE := Community
endif

# Build variant
DERPFEST_BETA ?= true
ifeq ($(DERPFEST_BETA),false)
    DERPFEST_BUILD_VARIANT = Beta
else
    DERPFEST_BUILD_VARIANT = Beta
endif

# Internal version
LINEAGE_VERSION := DerpFest-v$(DERPFEST_VERSION)-$(shell date +%Y%m%d)-$(LINEAGE_BUILD)-$(DERPFEST_BUILD_TYPE)-$(DERPFEST_BUILD_VARIANT)

# Display version
LINEAGE_DISPLAY_VERSION := DerpFest-v$(DERPFEST_VERSION)-$(LINEAGE_BUILD)

# DerpFest version properties
PRODUCT_PRODUCT_PROPERTIES += \
    ro.derpfest.version=$(DERPFEST_VERSION) \
    ro.derpfest.display.version=$(LINEAGE_DISPLAY_VERSION) \
    ro.derpfest.build.version=$(LINEAGE_VERSION) \
    ro.derpfest.build.variant=$(DERPFEST_BUILD_VARIANT) \
    ro.derpfest.releasetype=$(DERPFEST_BUILD_TYPE)
