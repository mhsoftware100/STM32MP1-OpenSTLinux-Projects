# OpenSTLinux MicroSD Card Deployment Script

This script facilitates the deployment of an OpenSTLinux image to a microSD card for the STM32MP1 platform.

## Usage

```
./deploy_to_sdcard.sh <workspace_directory_path> <microSD_card_device>
```
*  **<workspace_directory_path>:** Path to the directory where your Yocto Project workspace is located.
*  **<microSD_card_device>:** Full path to the microSD card device (e.g., /dev/sdX).

## Prerequisites

Before running the script, ensure that you have built the OpenSTLinux image using the provided build script and have a microSD card available.

## Steps

* 1. Go to Script Directory: Changes to the script directory to locate necessary files.

* 2. Check Script Existence: Verifies that the required script for creating a microSD card image exists.

* 3. Create Raw File: Generates a raw file for the microSD card based on the flash layout.

* 4. Check Raw File Existence: Ensures the raw file is successfully created before proceeding.

* 5. Unmount Partitions: Unmounts all partitions associated with the microSD card.

* 6. Prompt User: Prompts the user to insert the microSD card before continuing.

* 7. Deploy to microSD Card: Uses the dd command to populate the microSD card. The progress is displayed on the console.

## Important Note

Make sure to replace **<workspace_directory_path>** and **<microSD_card_device>** with the appropriate paths.