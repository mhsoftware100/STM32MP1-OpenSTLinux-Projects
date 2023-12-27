# OpenSTLinux Build Script

This script automates the process of building an OpenSTLinux image for the STM32MP1 platform using the Yocto Project and OpenEmbedded build system.
Prerequisites

Before running this script, ensure that you have the following prerequisites installed:

* [Git](https://git-scm.com/)
* [Repo](https://gerrit.googlesource.com/git-repo)
* [Yocto Project](https://www.yoctoproject.org/)
    
    
## Usage

```
./build_openstlinux.sh
```

## Script Overview

### Create Workspace Directory:
* Checks if the workspace directory exists.
* Creates the directory if not found.

### Initialize Repo and Sync:
* Initializes the Yocto Project manifest repository using Repo.
* Syncs the OpenSTLinux distribution with the local workspace.

### Initialize Environment Variables:
*  Sets up environment variables for the OpenSTLinux distribution and target machine.

### Build OpenSTLinux Image:
* Initiates the build process using the Yocto Project and BitBake.
* Builds the st-image-weston image for the specified STM32MP1 platform.

### Final Message:
* Displays a completion message if the build process is successful.

## Customize the Script

### Workspace Directory:
* Modify the WORKSPACE_DIR variable to set a custom workspace directory.

### Distribution and Machine:
* Customize the DISTRO and MACHINE variables for different OpenSTLinux configurations.
