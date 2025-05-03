# Copyright (C) 2017 Unlegacy-Android
# Copyright (C) 2017,2020 The LineageOS Project
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

# -----------------------------------------------------------------
# DerpFest OTA update package

LINEAGE_TARGET_PACKAGE := $(PRODUCT_OUT)/$(LINEAGE_VERSION).zip

SHA256 := prebuilts/build-tools/path/$(HOST_PREBUILT_TAG)/sha256sum

$(LINEAGE_TARGET_PACKAGE): $(INTERNAL_OTA_PACKAGE_TARGET)
	$(hide) mv -f $(INTERNAL_OTA_PACKAGE_TARGET) $(LINEAGE_TARGET_PACKAGE)
	$(hide) $(SHA256) $(LINEAGE_TARGET_PACKAGE) | sed "s|$(PRODUCT_OUT)/||" > $(LINEAGE_TARGET_PACKAGE).sha256sum
	$(hide) ./vendor/lineage/tools/generate_json_build_info.sh $(LINEAGE_TARGET_PACKAGE)
	$(hide) rm -rf $(call intermediates-dir-for,PACKAGING,target_files)
	@echo -e ""
	@echo -e "${cya}Building ${bldcya}DerpFest ${txtrst}";
	@echo -e ""
	@echo -e ${CL_CYN}"█████▄ ▓█████  ██▀███   ██▓███    █████▒▓█████   ██████ ▄▄▄█████▓ "
	@echo -e ${CL_CYN}"▒██▀ ██▌▓█   ▀ ▓██ ▒ ██▒▓██░  ██▒▓██   ▒ ▓█   ▀ ▒██    ▒ ▓  ██▒ ▓▒"
	@echo -e ${CL_CYN}"░██   █▌▒███   ▓██ ░▄█ ▒▓██░ ██▓▒▒████ ░ ▒███   ░ ▓██▄   ▒ ▓██░ ▒░"
	@echo -e ${CL_CYN}"░▓█▄   ▌▒▓█  ▄ ▒██▀▀█▄  ▒██▄█▓▒ ▒░▓█▒  ░ ▒▓█  ▄   ▒   ██▒░ ▓██▓ ░ "
	@echo -e ${CL_CYN}"░▒████▓ ░▒████▒░██▓ ▒██▒▒██▒ ░  ░░▒█░    ░▒████▒▒██████▒▒  ▒██▒ ░ "
	@echo -e ${CL_CYN}" ▒▒▓  ▒ ░░ ▒░ ░░ ▒▓ ░▒▓░▒▓▒░ ░  ░ ▒ ░    ░░ ▒░ ░▒ ▒▓▒ ▒ ░  ▒ ░░   "
	@echo -e ${CL_CYN}" ░ ▒  ▒  ░ ░  ░  ░▒ ░ ▒░░▒ ░      ░       ░ ░  ░░ ░▒  ░ ░    ░    "
	@echo -e ${CL_CYN}" ░ ░  ░    ░     ░░   ░ ░░        ░ ░       ░   ░  ░  ░    ░      "
	@echo -e ${CL_CYN}".................................................................."
	@echo -e ${CL_CYN}"........................DerpFest AOSP............................."
	@echo -e ${CL_CYN}".................... Based on Android 17 .........................."
	@echo -e ${CL_RST}".................................................................."
	@echo -e ${CL_YLW}"..................Its Done.........Getcha Some...................."
	@echo -e ${CL_YLW}"...................Steady Fucking Derped Shit....................."
	@echo -e ""
	@echo -e "zip: "$(LINEAGE_TARGET_PACKAGE)
	@echo -e "sha256: `cat $(LINEAGE_TARGET_PACKAGE).sha256sum | cut -d ' ' -f 1`"
	@echo -e "size:`ls -lah $(LINEAGE_TARGET_PACKAGE) | cut -d ' ' -f 5`"
	@echo -e "" >&2

.PHONY: derp
derp: $(LINEAGE_TARGET_PACKAGE) $(DEFAULT_GOAL)
