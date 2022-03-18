#!/bin/bash
read -p "This is a script that will attempt to install xivlauncher into Steam. Please note that using this script is at your own peril. Press ENTER to continue"
while true; do
    read -p "Is your steam install and FFXIV install both located at the default location at $HOME/.steam/steam? [y/n]" yn
    case $yn in
        [Yy]* )STEAMLOCATION="$HOME/.steam/steam" &&\
STEAMLIBRARY="$HOME/.steam/steam/steamapps" &&\
STEAMPROTONLOCATION="$STEAMLOCATION/compatibilitytools.d" &&\
FFXIVSTEAMID=39210 &&\ 
FFXIVPREFIXLOCATION="$STEAMLIBRARY/compatdata/$FFXIVSTEAMID"; break;;
        [Nn]* ) read -p "this script will now exit. Press Enter to Exit" && exit;;
        * ) echo "Please answer yes or no.";;
    esac
done

# What is the location of your steam FFXIV install?
if [ -d "$STEAMLIBRARY/common/Proton 5.0" ]
	then
		echo " Proton 5.0 is installed in your steam library, good"
	else
		read -p " Proton 5.0 is not installed in your steam library, please install it in Steam before continuing. Press ENTER to continue if you have done so."
fi
echo "$STEAMPROTONLOCATION"
if [ -d "$STEAMLOCATION/compatibilitytools.d/Proton-6.21-GE-2" ] ; then
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
cd $STEAMPROTONLOCATION/Proton-6.21-GE-2/protonfixes/gamefixes/ && { curl -O https://gist.githubusercontent.com/Centzilius/57892e5d1aaea51b3f389e6f1d587c97/raw/d9941cf64dff28dcbfe1855113e2a10f162bbbd0/39210.py; cd -; }


# OLD PREFIX
# Checks if a FFXIV prefix already exists, asks if you want to delete your old prefix, and does so.
read -p "Checking if prefix for Final Fantasy XIV already exists. Press Enter to Continue."
if [ -d "$FFXIVPREFIXLOCATION" ]; then
	while true; do
    	read -p "A FFXIV prefix already exists at $FFXIVPREFIXLOCATION, would you like to delete your old prefix before continuing?" yn
    	case $yn in
        	[Yy]* ) rm -rf $FFXIVPREFIXLOCATION; break;;
        	[Nn]* ) read -p "You must delete your prefix to continue, this script will now close";;
        	* ) echo "Please answer yes or no.";;
    	esac
	done
else
	read -p "Great! You do not have an old prefix in your steam library, press ENTER to continue"
fi
		 
## CREATE PREFIX ##
# Checks if you have created a new prefix before continuing
read -p "please create a new prefix by right clicking on Final Fantasy XIV in your steam library, clicking on compatibility, and ensuring  the use of Proton 6.3-8. Start the game and close it after a few seconds. Upon completion, press ENTER."
if [ -d "$STEAMLIBRARY/compatdata/39210" ] ; then
	echo "Prefix Detected" 
	if grep -q "6.3-3" "$FFXIVPREFIXLOCATION/version"; then
  		read -p "Proton 6.3-8 is detected as the current proton used for FFXIV, a new prefix was likely created. Press ENTER to Continue" 
	else echo "ERROR: Proton 6.3-3 is not the current proton version in your prefix, please restart this script and ensure that you have properly followed the instructions. Press Enter to Exit."
	fi
else
	read -p "ERROR: A prefix has not been created. Press Enter to Exit" 
fi

read -p "please switch FFXIV's proton version to Proton-6.21-GE-2. Upon completion, press ENTER."
if [ -d "$STEAMLIBRARY/compatdata/39210" ] ; then
	echo "Prefix Detected" 
	if grep -q "6.21-GE-1" "$FFXIVPREFIXLOCATION/version"; then
  		read -p "Proton 6.21-GE-1 is the current proton used for FFXIV, please ensure that you have entered \" XL_WINEONLINUX=True DSSENH=n %command%\" as the launch option for Final Fantasy XIV, after having done so, upon launching the game you may get an error message. Press no and xivlauncher should launch, if it does not launch, and you are done, CONGRATULATIONS and enjoy Final Fantasy XIV. If the game does not launch then most likely a new prefix was not created or some other error occurred during installation. Press Enter to exit" 
	else echo "ERROR: Proton 6.21-GE-1 is not the current proton version in your prefix, please ensure that you have switched your current proton version to Proton 6.21-GE-1. Press Enter to Exit."
	fi
else
	read -p "ERROR: A prefix has not been created. Press Enter to Exit" 
fi