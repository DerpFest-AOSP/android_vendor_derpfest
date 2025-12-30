#!/bin/bash

# Color reset
txtrst=$(tput sgr0)

# Gradient colors (DerpFest purple/pink theme)
gradient_derpfest() {
    local text="$1"
    local len=${#text}
    local result=""
    for ((i=0; i<len; i++)); do
        # Purple (RGB: 147, 112, 219) to Pink (RGB: 255, 105, 180)
        local r=$((147 + (i * (255-147) / len)))
        local g=$((112 + (i * (105-112) / len)))
        local b=$((219 + (i * (180-219) / len)))
        result+="\033[38;2;${r};${g};${b}m${text:$i:1}"
    done
    echo -e "${result}${txtrst}"
}

# Check if the welcome message has already been shown
if [ -z "${WELCOME_SHOWN}" ]; then

    # Welcome message
    echo -e "$(gradient_derpfest "Welcome to DerpFest!")"

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
    echo -e "$(gradient_derpfest "Welcome to DerpFest!")"
    echo -e "Environment ready."
fi
