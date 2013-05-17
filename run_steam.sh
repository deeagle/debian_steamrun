#!/bin/bash

#
# Starts steam on Linux (install and start, Debian GNU Linux).
#
# Martin Kock <code@deeagle.de>
#

set +x 

# Var
#+--------------------
STEAMLIBS=${HOME}/Steamlibc/
TRUE=0;
FALSE=1;
LOCAL_FILE_DIR=${HOME}/Downloads/steam/


# Bash-Colors
#+--------------------
BC_NORMAL=`tput setaf 7`	# black
BC_GOOD=`tput setaf 2`		# green
BC_ERR=`tput setaf 1`		# red
BC_UNK=`tput setaf 4`		# blue
BC_LINE=`tput setaf 3`		# yellow
BC_CHK=`tput setaf 3`		# yellow

function myecho()
{
	#$1 -- kind of message
	#	MSG
	#	ERR
	#	CHK
	#	UNK
	#$2 -- message

	if [ $1 ]; then
		if [ "$2" ]; then
			if [ $1 = MSG ]; then
				echo -e "[${BC_GOOD}MSG${BC_NORMAL}] $2."
			elif [ $1 = ERR ]; then
				echo -e "[${BC_ERR}ERR${BC_NORMAL}] $2."
				#exit 1
			elif [ $1 = LINE ]; then
				echo -e "[${BC_UNK}+++${BC_NORMAL}] $2."
			elif [ $1 = UNK ]; then
				echo -e "[${BC_UNK}UNK${BC_NORMAL}] $2."
			elif [ $1 = CHK ]; then
				echo -e "[${BC_CHK}CHK${BC_NORMAL}] $2."
			else
				echo -e "[BUG] $2."
				exit 1
			fi
		elif [ $1 = LINE ]; then
			echo -e "[${BC_UNK}+++${BC_NORMAL}] ${BC_LINE}-------------------------------------------------------${BC_NORMAL}."
		fi
	fi
} #//myecho()


function are_steamlibs_installed {
	myecho CHK "Check if Steamlibs are installed";
	if [ -d "${STEAMLIBS}" ]; then
		CMD=`ls ${STEAMLIBS} | wc -l`;
		if [ ${CMD} -gt 0 ]; then
			#PSEUDOTEST I KNOW
			return $TRUE;
		fi
	fi
	
	return $FALSE;
} #//are_steamlibs_installed89

function install_steamlibs {
	myecho MSG "Try install of steamlibs (needs root-access)"
	mkdir -p ${STEAMLIBS}
	cd /tmp/
	myecho MSG "Download/Install libc6 from ubuntu"
	wget http://security.ubuntu.com/ubuntu/pool/main/e/eglibc/libc6_2.15-0ubuntu10.2_i386.deb
	dpkg -x libc6_2.15-0ubuntu10.2_i386.deb /tmp/libc/
	mv /tmp/libc/lib/i386-linux-gnu/* ${STEAMLIBS}
	myecho MSG "Download/Install jockey-common from ubuntu"
	wget http://mirror.ovh.net/ubuntu//pool/main/j/jockey/jockey-common_0.9.7-0ubuntu7_all.deb
	myecho MSG "Download/Install python-xkit from ubuntu"
	wget http://mirror.ovh.net/ubuntu//pool/main/x/x-kit/python-xkit_0.4.2.3build1_all.deb
	sudo dpkg -i jockey-common_0.9.7-0ubuntu7_all.deb python-xkit_0.4.2.3build1_all.deb
	sudo apt-get install libjpeg8 libcurl3-gnutls libtheora0 libpulse0 libpixman-1-0 libcairo2 libgtk2.0-0 libpango1.0-0
	sudo apt-get install libgdk-pixbuf2.0-0
}

function is_steam_installed {
	myecho CHK "Check if Steam is installed"
	CMD=`dpkg -s steam-launcher | grep 'install ok unpack' | wc -l`;
	if [ $CMD -gt 0 ]; then
		return $TRUE;
	fi

	return $FALSE;
} #//is_steam_installed

function install_steam {
	myecho MSG "Try to install Steam for Linux (need root access)"

	# steam-files dir
	if [ ! -f "${LOCAL_FILE_DIR}/steam.deb" ]; then
		#does dir exist?
		if [ ! -e "${LOCAL_FILE_DIR}" ]; then
			myecho MSG "Create new directory ${LOCAL_FILE_DIR}"
			mkdir ${LOCAL_FILE_DIR}
		fi

		myecho MSG "Download Ubuntu-Steam-Package"
		cd ${LOCAL_FILE_DIR}
		wget http://media.steampowered.com/client/installer/steam.deb
	fi

	#and install
	sudo dpkg -i "${LOCAL_FILE_DIR}steam.deb"
} #//install_steam

function start_steam {
	myecho MSG "Starting Steam!"
   	myecho MSG "Have some fun!"
	export STEAMLIBS=${HOME}/Steamlibc/
	export LD_LIBRARY_PATH=${STEAMLIBS}
	export LC_ALL=C
	/usr/bin/steam
} #//start_steam 

##########
# MAIN
#########

myecho MSG "Try to start steam for debian"

# Are steamlibs installed?
are_steamlibs_installed

# yes
if [ $? -eq $TRUE ]; then
	myecho MSG "Steamlibs seams installed"
else # No
	myecho ERR "Steamlibs are not installed"
	install_steamlibs
fi

# Libs are installed.
# Is steam-package installed?
is_steam_installed

# yes
if [ $? -eq $TRUE ]; then
	myecho MSG "Steam seams installed"
else # no
	# wirft nen Fehler?
	#myecho ERR "Steam are not installed"
	install_steam
fi

# start steam
start_steam


exit 0;
