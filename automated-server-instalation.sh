#!/bin/bash
# Server Automated Instalation
# Version 2.1.5
# Last Modification: 14-10-2019
# Author: Octávio Filipe Pereira
# Copyright 2020 MagicBrain, Lda, OFPG, Lda
#
# Licence: This program is license under GNU/GPL v3
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.
#

export DEBIAN_FRONTEND=noninteractive

HOSTNAME=`which hostname`;

cat << "EOF"
            `.-:::::.`
          `-/+///+++++:`
         `:+/////++++++/`           ``````   `.:////:.
         .o//////+++++++- ``.-::///+++oooo++++sssssyyyo-
         .+//////+++++++///+++++oooooooooosssssssssyyyys/`
         `-+/////+++++++++++++++oooooooooosssssssssyyyyys-
          `-//++/+++++++++++++++oooooooooosssssssssyyyyys-
            `.-/+++++++++++++++ooo+++++++ooosssssssyyyyy/`
            `-/+/+++++++++++++/-...```````../osssssyyyo-`
           `:////+++++++++/-.`               `-:/++/:.`
          ./+////++++++/-`
        `-+//////++++/-`
        -+///////+++:`                                         `-:::.`
       .+////////+/-                                        `/syhddddhs-
      `/////////+/-              .:/ossso+:.`              -shhhddddddmdo`
      -+/////////-            `:shddhhhhhhhhs/`           `ohhhhddddddmmm:
     `+////////+:`           .shdhhyyyssyyyhhhs-          .ohhhhddddddmmm+
     .o////////+-           .ydhhysso+++oosyyhdy-         `+yhhhddddddmmd-
     :+/////////-           ohhhyso+/:::/+osyhhds          .+yhhddddddmh:
    `://////////-          `sdhhys+/:-.-:/+osyhdy`          `ohhddddddd:
     :+/////////-           +hdhyso+/:::/+osyhhdo           `ohhddddddd-
     .o////////+:           .sdhhysso+++oosyhhhs.           .shhddddddh.
     `+////////+/.           .ohdhhyyysyyyyhhho.            /yhhdddddms`
      -+////////+:`            -oyhhhhhhhhhyo-`            :yhhhdddddd:
      `//////////+:`             `.:/+o++:-`              -shhhhdddddo`
       .+////////++/.                                   `:shhhhhddddh.
   ``..-/+///////+++/-`                                .+yhhhhhhdddh-
 `-//////////////+++++/-`                           `./syyhhhhhhddy-
`////////////////++++++++:.`                      .-+syyyyhhhhhhhs-
:////////////////+++++++++++:-.`             `.-:+syyyyyyyhhhhhy+`
//////////////+++++++++++++++++++/:-------:/+oossssyyyyyyyhhhyo-
.+////////////:-/+++++++++++++++oooooooooosssssssssyyyyyyyhhho:.`
 -///////////:` `.:/++++++++++++oooooooooosssssssssyyyyyyyhhhhhhs-`
  `.::///::-`      `-:/+++++++++oooooooooosssssssssyyyyyyyhhhhhhdh/`
       ``             `.-:/+++++oooooooooosssssssso+oyyyyyhhhhhhddy.
                           `.-:://+++oooo+++//::.`` :yyyyyhhhhhhddy.
                                   ```````          .+yyyyhhhhhhdd/`
                                                     ./syyhhhhhhs-
                                                       `-/+o++/.
EOF
echo
echo

###################################################
## Check if this program is running with root user
###################################################
if [[ $EUID -ne 0 ]]; then
	echo -e "\e[38;5;82mThis program must be run as root.\e[0m"
	echo
	echo
	exit 1
fi

##########################################
## Start Fase 1, Automated Instalation
##########################################
if [ ! -f /var/log/automated-osi.log ]; then
	echo -e "\e[38;5;82mWelcome to Automated Server Configuration\e[0m"
	echo
	echo -e "\e[38;5;82mThis will run all the procedures to install and configure Linux Debian based Server.\e[0m"
	echo
	echo
	read -p "You are in Fase 1 of Automated Server Instalation :: Do you wish to continue? (y/n)" INSTALATION;
	echo
	if [ "$INSTALATION" == "n" ]; then
		exit 0;
	fi

	## Creating LOG File
	touch /var/log/automated-osi.log

	## OS CHECK FOR LINUX ONLY
	OSTYPE=$(lsb_release -si)
	echo -e "\e[38;5;82mDetected Operating System:\e[0m" $(lsb_release -si) $(lsb_release -sr) $(uname -m)
	sleep 2;
	echo
	read -p "This program only work in Debian-Based Distributions :: Do you wish to continue? (y/n)" CONTINUEINSTALATION;
	echo
	if [ "$CONTINUEINSTALATION" == "n" ]; then
		exit 0;
	fi

	## Updating Hostname
	echo -e "\e[38;5;82mWhat hostname do you want for this server?\e[0m"
	read userInput
	if [[ -n "$userInput" ]]; then
		definedhostname=$userInput
	fi
	echo
	echo -e "\e[38;5;82mUpdating your Hostname, please wait...\e[0m"
	echo
	rm -rf /etc/hostname
	touch /etc/hostname
	hostname $definedhostname
	echo $definedhostname > /etc/hostname
	sleep 2;

	## Updating Locales
	## You can change or define more locales bellow
	echo -e "\e[38;5;82mUpdating LOCALES, please wait...\e[0m"
	echo
	locale-gen en_US en_US.UTF-8 hu_HU hu_HU.UTF-8 pt_PT pt_PT.UTF-8
	dpkg-reconfigure locales
	sleep 2;

	## Setting Timezone
	echo -e "\e[38;5;82mWhat timezone do you want to setup for this server?\e[0m"
	read timezoneInput
	if [[ -n "$timezoneInput" ]]; then
		definedtimezone=$timezoneInput
	fi
	echo
	echo -e "\e[38;5;82mUpdate Server Timezone, please wait...\e[0m"
	echo
	timedatectl set-timezone $definedtimezone
	sleep 2;

	## Installing Additional Server Packages
	echo -e "\e[38;5;82mUpdating from Server from Oficial Sources, please wait...\e[0m"
	echo
	apt-get update 2>&1 | tee /var/log/automated-osi.log
	echo -e "\e[38;5;82mInstalling Fail2Ban, VIM and APTITUDE additional packages, please wait...\e[0m"
	echo
	apt-get -y --assume-yes install aptitude vim fail2ban 2>&1 | tee /var/log/automated-osi.log

	## Upgrade the System
	echo -e "\e[38;5;82mUpgrading Server from Oficial Sources, please wait...\e[0m"
	echo
	aptitude -y --assume-yes upgrade 2>&1 | tee /var/log/automated-osi.log
	sleep 5;

	echo -e "\e[38;5;82mAll packages are upgrade. The server will reboot in 5 seconds...\e[0m"
	echo
  sleep 5;
	shutdown -r now

else
	##########################################
	## Start Fase 2, of MagicBrain Instalation
	##########################################
	echo -e "\e[38;5;82mWelcome to Automated Server Configuration\e[0m"
	echo
	echo
	read -p "You are in Fase 2 of Automated Server Instalation :: Do you wish to continue? (y/n)" INSTALATION;
	echo
	if [ "$INSTALATION" == "n" ]; then
		exit 0;
	fi

	## Showing Hostname provided in Fase 1 procedure
	echo -e "\e[38;5;82mYour Server Hostname is:\e[0m" `$HOSTNAME`
	sleep 2;
	echo

	## Define Main IP Address
	OUTPUT="$(ip addr | grep 'state UP' -A2 | tail -n1 | awk '{print $2}' | cut -f1  -d'/')"
	echo -e "\e[38;5;82mYour Main IP Address is:\e[0m" ${OUTPUT}
	echo
	read -p "Is the Main IP detected correct? (y/n)" CONDITION_IP;
	echo
	if [ "$CONDITION_IP" == "n" ]; then
		echo -e "\e[38;5;82mDefine your Main IP Address:\e[0m"
		read userIP
		if [[ -n "$userIP" ]]; then
			defineIP=$userIP
		fi
	else
		defineIP=${OUTPUT}
	fi

	## Configure hosts file
	echo
	read -p "Your server have IPv6 configured? (y/n)" CONDITION_SERVER_TYPE;
	echo
	if [ "$CONDITION_SERVER_TYPE" == "y" ]; then
		echo -e "\e[38;5;82mReconfiguring HOSTS file, please wait\e[0m"
		mv /etc/hosts /etc/hosts.original
		touch /etc/hosts
		echo "127.0.0.1    `$HOSTNAME`	localhost" >> /etc/hosts
		echo "$defineIP    `$HOSTNAME`	localhost localhost.localdomain" >> /etc/hosts
		echo "# The following lines are desirable for IPv6 capable hosts" >> /etc/hosts
		echo "::1     ip6-localhost ip6-loopback" >> /etc/hosts
		echo "fe00::0 ip6-localnet" >> /etc/hosts
		echo "ff00::0 ip6-mcastprefix" >> /etc/hosts
		echo "ff02::1 ip6-allnodes" >> /etc/hosts
		echo "ff02::2 ip6-allrouters" >> /etc/hosts
	else
		echo -e "\e[38;5;82mReconfiguring HOSTS file, please wait...\e[0m"
		mv /etc/hosts /etc/hosts.original
		touch /etc/hosts
		echo "127.0.0.1    `$HOSTNAME`	localhost" >> /etc/hosts
		echo "$defineIP    `$HOSTNAME`	localhost localhost.localdomain" >> /etc/hosts
	fi

	## Configure hosts file
	echo -e "\e[38;5;82mReconfiguring RESOLVCONF file, please wait...\e[0m"
	cp /etc/resolv.conf /etc/resolv.conf.original
	echo "nameserver 127.0.0.1" >> /etc/resolv.conf
	echo

	## Start Install Webmin/Virtualmin
	read -p "Do you install Webmin/Virtualmin Control Panel? (y/n)" CONDITION;
	echo
	if [ "$CONDITION" == "y" ]; then
		wget http://software.virtualmin.com/gpl/scripts/install.sh

		sed -i '1321 i return' /root/install.sh

		echo -e "\e[38;5;82mLet's wait 2 seconds to start Webmin/Virtualmin Control Panel instalation...\e[0m"
		sleep 2;

		chmod 755 /root/install.sh

		source /root/install.sh

		echo
		echo -e "\e[38;5;82Server `$HOSTNAME` instalation finished, with Webmin and Virtualmin installed!\e[0m"
	else
		echo -e "\e[38;5;82Server `$HOSTNAME` instalation finished, without Webmin and Virtualmin!\e[0m"
	fi
fi

exit 0;
