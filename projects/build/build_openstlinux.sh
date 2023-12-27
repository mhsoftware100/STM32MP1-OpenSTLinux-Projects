#!/bin/bash

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
WORKSPACE_DIR="$SCRIPT_DIR/openstlinux_kirkstone"
MANIFEST_URL="https://github.com/STMicroelectronics/oe-manifest.git"
BRANCH="kirkstone"
DISTRO="openstlinux-weston"
MACHINE="stm32mp1"

# Check if the workspace directory exists
if [ ! -d "$WORKSPACE_DIR" ]; then
    echo "Creating working directory: $WORKSPACE_DIR"
    mkdir "$WORKSPACE_DIR"
fi

# Step 2: Get OpenSTLinux Distribution with Repo
cd "$WORKSPACE_DIR"
if [ ! -d ".repo" ]; then
    echo "Initializing repo for the first time..."
    repo init -u "$MANIFEST_URL" -b "$BRANCH"
fi

# Always sync OpenSTLinux Distribution with Repo
echo "Syncing repo..."
repo sync

# Step 3: Initialize Distribution Package Environment
echo "Initializing environment variables..."
DISTRO="$DISTRO" MACHINE="$MACHINE" source ./layers/meta-st/scripts/envsetup.sh

# Step 4: Build OpenSTLinux Image
echo "Building OpenSTLinux image..."
bitbake st-image-weston

# Final message
echo "OpenSTLinux build process completed successfully!"
