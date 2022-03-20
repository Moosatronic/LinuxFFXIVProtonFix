# FFXIV Bash Script to install Centzilius's FFXIV Proton Fix CURRENTLY WIP
A script designed to install XIVLauncher and run it on Steam on linux. 

This script also has support for non-steam account holders who want to launch XIVLauncher from the FFXIV Free Trial page on Steam

# NOTE: This script deletes your FFXIV prefix, please ensure you have backed up your config files before allowing the script to delete your prefix

# Instructions


Commands:

- git clone https://github.com/Moosatronic/LinuxFFXIVProtonFix.git
- cd LinuxFFXIVProtonFix
- chmod +x ffxivfix.sh
- ./ffxivfix.sh

# What does this script do?

It installs Cent's game fix at https://gist.github.com/Centzilius/57892e5d1aaea51b3f389e6f1d587c97 as well as all of its dependencies to either FFXIV or FFXIV's free trial on Steam so that you can run XIVLauncher from Steam. This fix is necessary for Steam FFXIV account players to play FFXIV on Linux.

# Dependencies

- Git
- Curl
- Steam
- Proton 5

# What this script downloads

- Proton-6.21-GE-2
- Cent's FFXIV protonfix 

# TO DO

- have script check for compatibilitytools.d
- remote Proton 5 download
- improve documentation
