#!/bin/bash

# Usage: ./setup_and_build.sh <openstlinux_directory>

# Check if the correct number of arguments is provided
if [ "$#" -ne 1 ]; then
    echo "Usage: $0 <openstlinux_directory>"
    exit 1
fi

# Get the absolute path of the myblinkled directory
BLINKLED_FILES=$(readlink -f "$(dirname "${0}")/myblinkled")
DISTRO="openstlinux-weston" 
MACHINE="stm32mp1"
LAYER_NAME="meta-my-examples"
OPENSTLINUX_DIR="$1"
LAYER_DIR="$OPENSTLINUX_DIR/layers/meta-st/$LAYER_NAME"

cd $OPENSTLINUX_DIR

# Step 1: Go to the OpenSTLinux directory and initialize environment variables
echo "Step 1: Going to OpenSTLinux directory and initializing environment variables..."

source ./layers/meta-st/scripts/envsetup.sh "build-openstlinuxweston-${MACHINE}"

# Step 2: Create and add the "meta-my-examples" layer
echo "Step 2: Creating and adding layer '$LAYER_NAME'..."
if [ ! -d "$LAYER_DIR" ]; then
    bitbake-layers create-layer "$LAYER_DIR"
    bitbake-layers add-layer "$LAYER_DIR"
else
    echo "Layer '$LAYER_NAME' already exists. Skipping..."
fi


# Step 3: Copy the "myblinkled" folder to the "recipes-example" directory
COPY_DESTINATION="$LAYER_DIR/recipes-example"
echo "Step 3: Copying 'myblinkled' to '$COPY_DESTINATION' if it doesn't exist..."
if [ ! -d "${COPY_DESTINATION}/myblinkled" ]; then
    mkdir -p "$COPY_DESTINATION"
    cp -r "${BLINKLED_FILES}" "$COPY_DESTINATION/"
else
    echo "Destination directory '$COPY_DESTINATION' already exists. Skipping..."
fi


# Step 4: Check if 'IMAGE_INSTALL:append = "myblinkled"' already exists in conf/local.conf
echo "Step 4: Checking if 'IMAGE_INSTALL:append = \"myblinkled\"' already exists in 'conf/local.conf'..."
if ! grep -q 'IMAGE_INSTALL:append = " myblinkled"' conf/local.conf; then
    echo "Step 4: Appending 'IMAGE_INSTALL:append = \" myblinkled\"' to 'conf/local.conf'..."
    echo 'IMAGE_INSTALL:append = " myblinkled"' >> conf/local.conf
else
    echo "'IMAGE_INSTALL:append = \"myblinkled\"' already exists in 'conf/local.conf'. Skipping..."
fi


# Step 5: Build the image with the "st-image-weston" recipe
echo "Step 5: Building the image with 'bitbake st-image-weston'..."
bitbake st-image-weston

# Step 6: Print message for successful build
echo "Package successfully built! Use deploy command to write to SD card."
