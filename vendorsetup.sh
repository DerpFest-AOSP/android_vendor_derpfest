#!/bin/bash

# Color variables
YELLOW='\033[1;33m'
RESET='\033[0m'

# Check if the welcome message has already been shown
if [ -z "${WELCOME_SHOWN}" ]; then

    # Welcome message
    echo -e "Welcome to ${YELLOW}DerpFest!${RESET}"

    echo -e "\nHere are some things before you get started!\n"

    # Build flags information
    echo -e "\nBuild Flags Configuration:\n"
    echo -e "Core Build Flags:"
    echo -e "  - TARGET_BUILD_VARIANT - Build variant (eng/userdebug/user)"
    echo -e "  - WITH_ADB_INSECURE - Disable ADB authentication"
    
    echo -e "\nFeature Flags:"
    echo -e "  - TARGET_INCLUDE_ACCORD (default: true) - Include Accord app"
    echo -e "  - TARGET_FACE_UNLOCK_SUPPORTED (default: TARGET_SUPPORTS_64_BIT_APPS) - Enable Face Unlock"
    echo -e "  - TARGET_SUPPORTS_QUICK_TAP (default: true) - Quick Tap gesture support"
    echo -e "  - TARGET_DISABLE_EPPE - Disable EPPE enforcement"
    echo -e "  - TARGET_EXCLUDE_BACKUPTOOL - Exclude backup tool"
    
    echo -e "\nDon't forget to join https://t.me/DerpFestAOSP! Enjoy! :D"

    export WELCOME_SHOWN=true

else
    echo -e "Welcome to ${YELLOW}DerpFest!${RESET}"
    echo -e "Environment ready."
fi
