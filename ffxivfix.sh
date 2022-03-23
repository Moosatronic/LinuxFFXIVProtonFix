#!/usr/bin/env bash
read -p "This is a script that will attempt to install xivlauncher into Steam. Please note that using this script is at your own peril. Press ENTER to continue"
while true; do
	read -p "Are you a non-steam FFXIV account owner who would like to launch XIVLauncher from the FFXIV Free Trial? [y/n]" yn
	case $yn in
        [Yy]* )FFXIVSTEAMID=312060; break;;
        [Nn]* )FFXIVSTEAMID=39210; break;;
        * ) echo "Please answer yes or no.";;
	esac
done

##
# Check for alternate Steam Library folders.
if [ -f ~/.steam/steam/steamapps/libraryfolders.vdf ]; then
  steamDirs=($(cat ~/.steam/steam/steamapps/libraryfolders.vdf | grep "path" | awk '{ print $2  }' | sed s/\"//g))
fi
# Add the default steam library to check.
steamDirs=("${steamDirs[@]}" "$HOME/.steam/steam")

##
# Check for what we want in there.
for checkDir in "${steamDirs[@]}"; do
    if [ -d "${checkDir}/compatibilitytools.d" ]; then
    # sets a variable STEAMPROTONLOCATION to Steam's directory's for non-valve proton installs (i.e. not in the "common" folder")
       STEAMPROTONLOCATION="${checkDir}/compatibilitytools.d"
    fi
    if [ -d "${checkDir}/steamapps/common/Proton 5.0" ]; then
       proton5="${checkDir}/steamapps/common/Proton 5.0"
    fi
    ##
    # Still iterate to make sure we find the above if they exist, even if we find the right prefix below.
    if [ -z "$STEAMLIBRARY" ]; then
        if [ -d "${checkDir}/steamapps/compatdata/$FFXIVSTEAMID/pfx" ]; then
            printf "Located FFXIV install at: ${checkDir}\n"
            read -p "Is this correct? [y/n]" yn
                case $yn in
                    [Yy]* ) STEAMLIBRARY="${checkDir}/steamapps"
                            FFXIVPREFIXLOCATION="${checkDir}/compatdata/$FFXIVSTEAMID"; break;;
                    [Nn]* ) printf "\n";;
                    * ) echo "Please answer yes or no.";;
            esac
        fi
    fi
done

##
# If $STEAMLIBRARY is empty, no usable XIV installs were found / accepted.  Exit.
if [ -z "$STEAMLIBRARY" ]; then printf "No installation candidate found, exiting.\n"; exit; fi

# What is the location of your steam FFXIV install?
if [ -z "$proton5" ]
    then
        read -p "Proton 5.0 is required to continue but not installed in your steam library, would you like to install it? [y/n]" yn
            case $yn in
	        [Yy]* ) xdg-open "steam://install/1245040" & > /dev/null 2>&1; sleep 1;
                        read -p "Please install to the default Steam library and press ENTER to continue once complete.";;
		[Nn]* ) read -p "Proton 5.0 is required to continue, exiting."; exit 1;;
	    esac
fi
echo "$STEAMPROTONLOCATION"
if [ -d "$STEAMPROTONLOCATION/Proton-6.21-GE-2" ] ; then
	echo "Proton-6.21-GE-2 is already installed in your Steam Compatibility Tools folder"
else
	while true; do
    	read -p "Proton-6.21-GE-2 is not installed, would you like to install it? [y/n]" yn
    	case $yn in
        	[Yy]* ) cd $STEAMPROTONLOCATION && curl -L https://github.com/GloriousEggroll/proton-ge-custom/releases/download/6.21-GE-2/Proton-6.21-GE-2.tar.gz | tar xz ; break;;
        	[Nn]* ) exit;;
        	* ) echo "Please answer yes or no.";;
    		esac
	done
fi

read -p "installing Centzilius's ProtonFix to Proton-6.21-GE-2, press ENTER to continue"
cp 39210.py "$STEAMPROTONLOCATION"/Proton-6.21-GE-2/protonfixes/gamefixes/39210.py
# Also replace the gamefixes script for the free trial.
cp "$STEAMPROTONLOCATION"/Proton-6.21-GE-2/protonfixes/gamefixes/{39210,312060}.py
read -p "running wine-tricks update to ensure you have the latest winetricks, press ENTER to continue"
cd "$STEAMPROTONLOCATION"/Proton-6.21-GE-2/protonfixes
./winetricks --self-update


# OLD PREFIX
# Checks if a FFXIV prefix already exists, asks if you want to delete your old prefix, and does so.
read -p "Checking if prefix for Final Fantasy XIV exists. Press Enter to Continue."
if [ -d "$FFXIVPREFIXLOCATION" ]; then
	while true; do
    	read -p "A FFXIV prefix already exists at $FFXIVPREFIXLOCATION, would you like to delete your old prefix? PLEASE NOTE: this will delete any existing FFXIV and XIVLauncher config files, and XIVLauncher files you installed in your steam install of FFXIV backup all files at $FFXIVPREFIXLOCATION [y/n]?" yn
    	case $yn in
        	[Yy]* ) printf "Backing up character data from '$FFXIVPREFIXLOCATION/pfx/drive_c/users/steamuser/My Documents/My Games/FINAL FANTASY XIV - A Realm Reborn/'...\n";
			rsync -aq "$FFXIVPREFIXLOCATION/pfx/drive_c/users/steamuser/My Documents/My Games/FINAL FANTASY XIV - A Realm Reborn" "./"
			printf "Backup complete, restoration must currently be done manually! Your backup is located at \n"
		        rm -rf $FFXIVPREFIXLOCATION; break;;
        	[Nn]* ) read -p "You must delete your prefix to continue, this script will now close"; exit ;;
        	* ) echo "Please answer yes or no.";;
    	esac
	done
else
	read -p "Great! The script detected that you do not have an old prefix in your steam library, press ENTER to continue"
fi

## CREATE PREFIX ##
# Checks if you have created a new prefix before continuing
read -p "please create a new prefix by right clicking on Final Fantasy XIV in your steam library, clicking on compatibility, and ensuring  the use of Proton 6.3-8. Start the game and close it after a few seconds. Upon completion, press ENTER."
if [ -d "$STEAMLIBRARY/compatdata/$FFXIVSTEAMID" ] ; then
	echo "Prefix Detected"
	if grep -q "6.3-3" "$FFXIVPREFIXLOCATION/version"; then
  		read -p "Proton 6.3-8 is detected as the current proton used for FFXIV, a new prefix was likely created. Press ENTER to Continue"
	else echo "ERROR: Proton 6.3-8 is not detected as the current proton version in your prefix, please check if $FFXIVPREFIXLOCATION/version file says "6.3-3", if yes then the script incorrectly detected you don't have Proton 6.3-8 set. Press Enter to Exit."
	fi
else
	read -p "ERROR: A prefix has not been created. Press Enter to Exit"
fi

read -p "please switch FFXIV's proton version to Proton-6.21-GE-2. Upon completion, press ENTER."
if [ -d "$STEAMLIBRARY/compatdata/$FFXIVSTEAMID" ] ; then
	echo "Prefix Detected"
	if grep -q "6.21-GE-1" "$FFXIVPREFIXLOCATION/version"; then
  		read -p "Proton 6.21-GE-1 is the current proton used for FFXIV, please ensure that you have entered \" XL_WINEONLINUX=True DSSENH=n %command%\" as the launch option for Final Fantasy XIV. Press ENTER to continue"
		read -p "When you start the game from steam, if installed correctly it will take some time before the xivlauncher starts as xivlauncher's dependencies are being installed to your prefix. It is reccomennded to start steam in a terminal to see your progress.\
		After completion you may see an error message, press no and xivlauncher should launch. If you run into errors please check https://github.com/Moosatronic/LinuxFFXIVProtonFix, xivlauncher's FAQ at https://goatcorp.github.io/faq/xl_troubleshooting.html, and xivlauncher's discord.\
		Press ENTER to Exit." 
	else echo "ERROR: Proton 6.21-GE-1 is not the current proton version in your prefix, please ensure that you have switched your current proton version to Proton 6.21-GE-1. Press Enter to Exit."
	fi
else
	read -p "ERROR: A prefix has not been created. Press Enter to Exit"
fi
