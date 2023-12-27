#!/bin/bash

# Usage: ./deploy_to_sdcard.sh <workspace_directory_path> <microSD_card_device>

# Check if the correct number of arguments is provided
if [ "$#" -ne 2 ]; then
    echo "Usage: $0 <workspace_directory_path> <microSD_card_device>"
    exit 1
fi

# Assign input parameter to the WORKSPACE_DIR variable
WORKSPACE_DIR=$1

# Assign input parameter to a variable
FULL_DEVICE_PATH=$2

MICROSD_DEVICE=$(basename "$FULL_DEVICE_PATH")

# Assuming this script is in the build_and_deploy_sdcard directory
#SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
#WORKSPACE_DIR="$SCRIPT_DIR/../openstlinux_kirkstone"
DISTRO="openstlinuxweston"
MACHINE="stm32mp1"

echo "Step 1: Go to script directory ..."
RAW_SCRIPT_PATH="build-${DISTRO}-${MACHINE}/tmp-glibc/deploy/images/${MACHINE}/scripts"
cd "$WORKSPACE_DIR/$RAW_SCRIPT_PATH"

# Check if the script exists before running it
CREATE_SCRIPT="./create_sdcard_from_flashlayout.sh"
if [ ! -f "$CREATE_SCRIPT" ]; then
    echo "Error: $CREATE_SCRIPT not found. Please check your build configuration."
    exit 1
fi

echo "Step 2: Creating raw file for microSD card..."
"$CREATE_SCRIPT" "../flashlayout_st-image-weston/optee/FlashLayout_sdcard_${MACHINE}57f-dk2-optee.tsv"

echo "Step 3: Check if the raw file exists"
RAW_FILE="../FlashLayout_sdcard_stm32mp157f-dk2-optee.raw"
if [ ! -f "$RAW_FILE" ]; then
    echo "Error: $RAW_FILE not found. Please build the OpenSTLinux image first."
    exit 1
fi

echo "Step 4: Umounting all partitions associated with the microSD card..."
# Umount all partitions associated with the microSD card
umount $(lsblk --list | grep "$MICROSD_DEVICE" | grep part | awk '{ print $7 }' | tr '\n' ' ')

# Prompt user to insert the microSD card
read -p "Insert the microSD card and press Enter to start the deployment..."

echo "Step 5: Populating microSD card with dd command..."
dd if="$RAW_FILE" of="$FULL_DEVICE_PATH" bs=8M conv=fdatasync status=progress | tee /dev/tty

# Final message
echo "MicroSD card deployment completed successfully!"
