#!/bin/bash

# Color definitions
red=$(tput setaf 1)
grn=$(tput setaf 2)
bldgrn=$(tput bold; tput setaf 2)
txtbld=$(tput bold)
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

# Add this function after gradient_derpfest

gradient_reds() {
    local text="$1"
    local len=${#text}
    local result=""
    for ((i=0; i<len; i++)); do
        # Red (RGB: 200, 0, 0) to Orange (RGB: 255, 85, 0)
        local r=$((200 + (i * (255-200) / len)))
        local g=$((0 + (i * 85 / len)))
        local b=0
        result+="\033[38;2;${r};${g};${b}m${text:$i:1}"
    done
    echo -e "${result}${txtrst}"
}

# Get the directory where the script is located
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
# Get the Android root directory (two levels up from the script)
ANDROID_ROOT="$( cd "$SCRIPT_DIR/../../.." && pwd )"

# Change to Android root directory
cd "$ANDROID_ROOT"

# DerpFest ASCII Logo with gradient
echo -e "$(gradient_derpfest "
 @@@@@@@  @@@@@@@@ @@@@@@@  @@@@@@@  @@@@@@@@ @@@@@@@@  @@@@@@ @@@@@@@
 @@!  @@@ @@!      @@!  @@@ @@!  @@@ @@!      @@!      !@@       @@!  
 @!@  !@! @!!!:!   @!@!!@!  @!@@!@!  @!!!:!   @!!!:!    !@@!!    @!!  
 !!:  !!! !!:      !!: :!!  !!:      !!:      !!:          !:!   !!:  
 :: :  :  : :: :::  :   : :  :        :       : :: ::: ::.: :     :   
")"

# get current version
VERSION=$(grep "^DERPFEST_VERSION" "$SCRIPT_DIR/../config/version.mk" | sed 's/.*:= *//')

echo -e "$(gradient_derpfest "Building DerpFest $VERSION")"

# Source envsetup.sh to make lunch available
. build/envsetup.sh > /dev/null 2>&1

# Device codename from command line
if [ -z "$1" ]; then
    echo -e "$(gradient_reds 'Please specify a device codename (e.g. derpfest komodo)')"
    exit 1
else
    device="$1"
    shift
fi

# Get AOSP target release from file if available, otherwise prompt
if [ -f "$ANDROID_ROOT/vendor/lineage/vars/aosp_target_release" ]; then
    unset aosp_target_release
    . "$ANDROID_ROOT/vendor/lineage/vars/aosp_target_release" 2>/dev/null
    if [ -n "$aosp_target_release" ]; then
        release="$aosp_target_release"
    else
        release=$(grep -v '^#' "$ANDROID_ROOT/vendor/lineage/vars/aosp_target_release" | head -n1)
    fi
else
    read -p "Enter AOSP target release (e.g. bp1a) [bp1a]: " release
    release=${release:-bp1a}
fi

# Prompt for build variant
echo "Select build variant:"
echo "1) user (recommended for stable builds)"
echo "2) userdebug (for testing)"
echo "3) eng (for development)"
read -p "Enter choice [1]: " build_type
build_type=${build_type:-1}
case $build_type in
    1) variant="user" ;;
    2) variant="userdebug" ;;
    3) variant="eng" ;;
    *) variant="user" ;;
esac

# Ask for build variant
echo -e ""
echo -e ${txtbld}"Select build variant:"${txtrst}
echo -e "1) Beta (default)"
echo -e "2) Stable"
read -p "Enter choice [1]: " build_variant
build_variant=${build_variant:-1}

# Clean option selection loop
while true; do
    echo -e ""
    echo -e ${txtbld}"Select clean option:"${txtrst}
    echo -e "1) make clean"
    echo -e "2) make dirty"
    echo -e "3) make magic"
    echo -e "4) make kernelclean"
    echo -e "5) make appclean"
    echo -e "6) make imgclean"
    echo -e "7) make systemclean"
    echo -e "8) make recoveryclean"
    echo -e "9) make rootclean"
    echo -e "10) make official"
    echo -e "11) make community"
    echo -e "0) Continue with build"
    read -p "Enter choice [0]: " opt_clean
    opt_clean=$(echo $opt_clean | tr -cd '0-9')
    opt_clean=${opt_clean:-0}

    case $opt_clean in
        1)
            make clean >/dev/null
            echo -e ""
            echo -e "$(gradient_derpfest "Got rid of the garbage")"
            echo -e ""
            break
            ;;
        2)
            make dirty >/dev/null
            echo -e ""
            echo -e "$(gradient_derpfest "Changelogs, build.prop and zips removed yet still full of crap")"
            echo -e ""
            break
            ;;
        3)
            echo -e ""
            echo -e "$(gradient_reds "Muhahaha")"
            echo -e ""
            continue
            ;;
        4)
            make kernelclean >/dev/null
            echo -e ""
            echo -e "$(gradient_derpfest "All kernel components have been removed")"
            echo -e ""
            break
            ;;
        5)
            make appclean >/dev/null
            echo -e ""
            echo -e "$(gradient_derpfest "All apps have been removed")"
            echo -e ""
            break
            ;;
        6)
            make imgclean >/dev/null
            echo -e ""
            echo -e "$(gradient_derpfest "All imgs have been removed")"
            echo -e ""
            break
            ;;
        7)
            make systemclean >/dev/null
            echo -e ""
            echo -e "$(gradient_derpfest "All system components have been removed")"
            echo -e ""
            break
            ;;
        8)
            make recoveryclean >/dev/null
            echo -e ""
            echo -e "$(gradient_derpfest "All recovery components have been removed")"
            echo -e ""
            break
            ;;
        9)
            make rootclean >/dev/null
            echo -e ""
            echo -e "$(gradient_derpfest "Root components have been removed")"
            echo -e ""
            break
            ;;
        10)
            echo -e $(gradient_reds "Moving previously created official zips to Official folder")
            mkdir Official 2> /dev/null
            mv $OUTDIR/target/product/*/*official*.zip Official 2> /dev/null
            mv $OUTDIR/target/product/*/*official*.zip.md5sum Official 2> /dev/null
            export DERPFEST_BUILD_TYPE=Official
            echo -e ""
            echo -e $(gradient_reds "You better be on the team if you're using this flag fucker")
            echo -e ""
            break
            ;;
        11)
            echo -e $(gradient_reds "Moving previously created community zips to Community folder")
            mkdir Community 2> /dev/null
            mv $OUTDIR/target/product/*/*community*.zip Community 2> /dev/null
            mv $OUTDIR/target/product/*/*community*.zip.md5sum Community 2> /dev/null
            export DERPFEST_BUILD_TYPE=Community
            echo -e ""
            echo -e $(gradient_reds "Building Community version #StayDerped")
            echo -e ""
            break
            ;;
        0)
            break
            ;;
        *)
            break
            ;;
    esac

done

# Ask for number of jobs
read -p "Number of parallel jobs [$CPUS]: " jobs
jobs=${jobs:-$CPUS}

# Ask for create_log
echo -e ""
echo -e ${txtbld}"Do you want to create build logs?"${txtrst}
echo -e "1) Yes"
echo -e "2) No"
read -p "Enter choice [1]: " create_log
create_log=$(echo $create_log | tr -cd '0-9')
create_log=${create_log:-1}

# Ask for sync_before
echo -e ""
echo -e ${txtbld}"Do you want to sync before building?"${txtrst}
echo -e "1) Yes"
echo -e "2) No"
read -p "Enter choice [1]: " sync_before
sync_before=$(echo $sync_before | tr -cd '0-9')
sync_before=${sync_before:-1}

# CCACHE setup
if [ -z "${CCACHE_EXEC}" ]; then
    if command -v ccache &>/dev/null; then
        export USE_CCACHE=1
        export CCACHE_EXEC=$(command -v ccache)
        [ -z "${CCACHE_DIR}" ] && export CCACHE_DIR="$HOME/.ccache"
        echo -e "$(gradient_derpfest "ccache directory found, CCACHE_DIR set to: $CCACHE_DIR")"
        # Check if CCACHE_MAXSIZE is set, otherwise prompt
        if [ -z "$CCACHE_MAXSIZE" ]; then
            read -p "$(gradient_derpfest "Set CCACHE_MAXSIZE (e.g. 40G) [Enter for default 40G]: ")" ccache_size
            CCACHE_MAXSIZE="${ccache_size:-40G}"
            echo -e "$(gradient_derpfest "CCACHE_MAXSIZE set to $CCACHE_MAXSIZE")"
        else
            echo -e "$(gradient_derpfest "CCACHE_MAXSIZE already set to $CCACHE_MAXSIZE")"
        fi
        DIRECT_MODE="${DIRECT_MODE:-false}"
        $CCACHE_EXEC -o compression=true -o direct_mode="${DIRECT_MODE}" -M "${CCACHE_MAXSIZE}" \
            && echo -e "$(gradient_derpfest "ccache enabled, CCACHE_EXEC set to: $CCACHE_EXEC, CCACHE_MAXSIZE set to: $CCACHE_MAXSIZE, direct_mode set to: $DIRECT_MODE")" \
            || echo -e "$(gradient_reds "Warning: Could not set cache size limit. Please check ccache configuration.")"
        CURRENT_CCACHE_SIZE=$(du -sh "$CCACHE_DIR" 2>/dev/null | cut -f1)
        if [ -n "$CURRENT_CCACHE_SIZE" ]; then
            echo -e "$(gradient_derpfest "Current ccache size is: $CURRENT_CCACHE_SIZE")"
        else
            echo -e "$(gradient_reds "No cached files in ccache.")"
        fi
    else
        echo -e "$(gradient_reds "Error: ccache not found. Please install ccache.")"
    fi
fi

# setup environment
echo -e "$(gradient_derpfest "Getting ready")"
. build/envsetup.sh

# lunch device
echo -e ""
echo -e "$(gradient_derpfest "Getting your device")"
lunch "lineage_${device}-${release}-${variant}"

# sync with latest sources
if [[ "$sync_before" =~ ^[Yy]$ ]]; then
    echo -e ""
    echo -e "$(gradient_derpfest "Getting the latest shit")"
    repo sync -j"$jobs"
    echo -e ""
fi

rm -f $OUTDIR/target/product/$device/obj/KERNEL_OBJ/.version

# get time of startup
t1=$(date +%s)

# Remove system folder (this will create a new build.prop with updated build time and date)
rm -f $OUTDIR/target/product/$device/system/build.prop
rm -f $OUTDIR/target/product/$device/system/app/*.odex
rm -f $OUTDIR/target/product/$device/system/framework/*.odex

# Prepare build command
build_cmd="make -j${jobs} derp"

# Show build type message
if [ "$DERPFEST_BUILD_TYPE" = "Official" ]; then
    echo -e ""
    echo -e "$(gradient_derpfest "Building Official version")"
    echo -e ""
elif [ "$DERPFEST_BUILD_TYPE" = "Community" ]; then
    echo -e ""
    echo -e "$(gradient_derpfest "Building Community version")"
    echo -e ""
fi

# Add variant flags
if [ "$build_variant" = "2" ]; then
    build_cmd="$build_cmd DERPFEST_BETA=true"
    echo -e ""
    echo -e "$(gradient_derpfest "Beta flavor #StayDerped")"
    echo -e ""
else
    build_cmd="$build_cmd DERPFEST_BETA=false"
    echo -e ""
    echo -e "$(gradient_derpfest "Stable flavor #StayDerped")"
    echo -e ""
fi

# Handle build logging
if [[ "$create_log" =~ ^[Yy]$ ]]; then
    echo -e ""
    echo -e "$(gradient_derpfest "Creating build-logs directory if one hasn't been created already")"
    echo -e ""
    mkdir -p build-logs
    echo -e ""
    echo -e "$(gradient_derpfest "Your build will be logged in build-logs")"
    echo -e ""
    build_cmd="$build_cmd 2>&1 | tee build-logs/derpfest_${device}-$(date +%Y%m%d).txt"
fi

# Start the build
echo -e ""
echo -e "$(gradient_derpfest "Off like a prom dress")"
echo -e ""
eval $build_cmd

# finished? get elapsed time
t2=$(date +%s)

tmin=$(( (t2-t1)/60 ))
tsec=$(( (t2-t1)%60 ))

echo -e "$(gradient_derpfest "Total time elapsed: $tmin minutes $tsec seconds")"
