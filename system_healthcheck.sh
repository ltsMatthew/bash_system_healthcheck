#!/bin/bash

#===========================================================
#Title		: System Health Overview Script
#Author		: Matthew Adriaanzen
#Creation Date	: 2024-06-20
#Version	: 1.0
#Usage		: bash syshealthcheck.sh
#===========================================================

#DATE
Date=$(date | awk '{print $2, $3, $4, $5, $6}')

#UPTIME
Uptime=$(cat /proc/uptime | awk '{print int($1) /60 /60 /24}' | awk '{print int($1)}')

#SERVICES
ntp=$(systemctl status ntpd.service | grep "Active" | awk '{print $2}')
firewalld=$(systemctl status firewalld | grep "Active" | awk '{print $2}')
httpd=$(systemctl status httpd | grep "Active" | awk '{print $2}')

#CPU
#NOTE: Edit the "CPU_THRESHOLD" variable to the number you would like the
#      the Threshold to be, it should be based on the number of Cores your system has!

CPU_THRESHOLD=$(echo "1")
CPU_1_MIN=$(uptime | awk '{print int($10)}')
CPU_5_MIN=$(uptime | awk '{print int($11)}')
CPU_15_MIN=$(uptime | awk '{print int($12)}')

Cores=$(lscpu | grep "CPU(s):" | head -n 1 | awk '{print $2}')

#MEMORY
MBtotal=$(free -m | grep Mem | awk '{print $2}')
MBfree=$(free -m | grep Mem | awk '{print $4}')
Swaptotal=$(free -m | grep Swap | awk '{print $2}')
Swapfree=$(free -m | grep Swap | awk '{print $4}')

#DISK SPACE
Diskspace=$(df -h)
Usedspace=$(df -h / | awk 'NR==2 {print $5}' | sed 's/%//')

#NETWORK
#NOTE: Edit the "EXPECTED" interface variables to match that of your system!

INTERFACES=$(ip link)

EXPECTED_CURRENT_INTERFACES=$(echo "5")
CURRENT_INTERFACES=$(ip link | tail -n 2 | grep "state" | awk '{print int($1)}')

EXPECTED_UP_INTERFACES=$(echo "2")
CURRENT_UP_INTERFACES=$(ip link | grep "state UP" | wc -l)

EXPECTED_DOWN_INTERFACES=$(echo "2")
CURRENT_DOWN_INTERFACES=$(ip link | grep "state DOWN" | wc -l)

EXPECTED_UNKNOWN_INTERFACES=$(echo "1")
CURRENT_UNKNOWN_INTERFACES=$(ip link | grep "state UNKNOWN" | wc -l)

#COLOURS
BLUE=$(tput setaf 4)		#Blue Colour
RED=$(tput setaf 9)		#Red Colour
GREEN=$(tput setaf 10)		#Green Colour
YELLOW=$(tput setaf 11)		#Yellow Colour
MAGENTA=$(tput setaf 13)	#Magenta Colour
CYAN=$(tput setaf 14)		#Cyan Colour
CYANBOLD=$(tput bold 14)	#Cyan Bold Colour
WHITEBOLD=$(tput bold 15)	#White Bold Colour
RESET=$(tput sgr0)

###BODY###
echo "${CYAN}###########################${RESET}"
echo
echo "${YELLOW}Health Check for Today ${RESET}"
echo
echo "${CYAN}###########################${RESET}"
echo
echo "${WHITEBOLD}Initiating Health Check at ${CYAN}${Date}${RESET}"

echo
echo "${YELLOW}Starting OS Checks${RESET}"
echo "---------------------------"
echo
echo "${WHITEBOLD}Checking uptime Status...${RESET}"
echo "Current uptime = ${Uptime} days"
if [ "$Uptime" -eq 0 ]; then
	echo "${RED}System was Rebooted${RESET}"
else
	echo "${GREEN}No Reboot Detected${RESET}"
fi
echo
echo "${WHITEBOLD}Checking NTP Service...${RESET}"
if [ "$ntp" = active ]; then
	echo "Status = ${GREEN}Active${RESET}"
else
	echo "Status = ${RED}Inactive${RESET}"
fi
echo
echo "${WHITEBOLD}Checking firewalld Service...${RESET}"
if [ "$firewalld" = active ]; then
	echo "Status = ${GREEN}Active${RESET}"
else
	echo "Status = ${RED}Inactive${RESET}"
fi
echo
echo "${WHITEBOLD}Checking httpd Service...${RESET}"
if [ "$httpd" = active ]; then
	echo "Status = ${GREEN}Active${RESET}"
else
	echo "Status = ${RED}Inactive${RESET}"
fi
#===========================================================
echo
echo "${WHITEBOLD}Checking CPU Load Status...${RESET}"
echo "Load Average (1min) = ${CPU_1_MIN}"
if [ "$CPU_1_MIN" -lt "$CPU_THRESHOLD" ]; then
	echo "Status = ${GREEN}OK${RESET}"
else
	echo "Status = ${RED}NOT OK${RESET}"
fi
echo "Load Average (5min) = ${CPU_5_MIN}"
if [ "$CPU_5_MIN" -lt "$CPU_THRESHOLD" ]; then
	echo "Status = ${GREEN}OK${RESET}"
else
	echo "Status = ${RED}NOT OK${RESET}"
fi
echo "Load Average (15min) = ${CPU_15_MIN}"
if [ "$CPU_15_MIN" -lt "$CPU_THRESHOLD" ]; then
	echo "Status = ${GREEN}OK${RESET}"
else
	echo "Status = ${RED}NOT OK${RESET}"
fi
echo "CPU Load 1min  (Load:${CPU_1_MIN} / Cores:${Cores})"
echo "CPU Load 5min  (Load:${CPU_5_MIN} / Cores:${Cores})"
echo "CPU Load 15min (Load:${CPU_15_MIN} / Cores:${Cores})"

#===========================================================
echo
echo "${WHITEBOLD}Checking Memory Status...${RESET}"
echo "Memory Total MB = ${MBtotal}"
echo "Memory Free MB = ${MBfree}"
if [ "$MBfree" -lt 500 ]; then
	echo "Status = ${RED}NOT OK${RESET}"
else
	echo "Status = ${GREEN}OK${RESET}"
fi
echo
echo "${WHITEBOLD}Checking Swap Status...${RESET}"
echo "Swap Total MB = ${Swaptotal}"
echo "Swap Free MB = ${Swapfree}"
if [ "$Swapfree" -lt 500 ]; then
	echo "Status = ${RED}NOT OK${RESET}"
else
	echo "Status = ${GREEN}OK${RESET}"
fi
#===========================================================
echo
echo "${WHITEBOLD}Checking Disk Space...${RESET}"
echo "${Diskspace}"
if [ "$Usedspace" -lt 80 ]; then
	echo "Status = ${GREEN}OK${RESET}"
else
	echo "Status = ${RED}NOT OK${RESET}"
fi
#===========================================================
echo
echo "${WHITEBOLD}Displaying Network Interfaces...${RESET}"
echo "${INTERFACES}"
echo
echo "Expected Interface Count = ${EXPECTED_CURRENT_INTERFACES}"
echo "Current Interface Count = ${CURRENT_INTERFACES}"
echo
echo "Expected UP Interface Count = ${EXPECTED_UP_INTERFACES}"
echo "Current UP Interface Count = ${CURRENT_UP_INTERFACES}"
echo
echo "Expected DOWN Interface Count = ${EXPECTED_DOWN_INTERFACES}"
echo "Current DOWN Interface Count = ${CURRENT_DOWN_INTERFACES}"
echo
echo "Expected UNKNOWN Interface Count = ${EXPECTED_UNKNOWN_INTERFACES}"
echo "Current UNKNOWN Interface Count = ${CURRENT_UNKNOWN_INTERFACES}"
echo
if [ "$CURRENT_INTERFACES" -eq "$EXPECTED_CURRENT_INTERFACES" ]; then
	echo "Interface Count Status = ${GREEN}OK${RESET}"
else
	echo "Interface Count Status = ${RED}NOT OK${RESET}"
fi
if [ "$CURRENT_UP_INTERFACES" -eq "$EXPECTED_UP_INTERFACES" ]; then
	echo "Up Interfaces Status = ${GREEN}OK${RESET}"
else
	echo "Up Interfaces Status = ${RED}NOT OK${RESET}"
fi
if [ "$CURRENT_DOWN_INTERFACES" -eq "$EXPECTED_DOWN_INTERFACES" ]; then
	echo "DOWN Interfaces Status = ${GREEN}OK${RESET}"
else
	echo "DOWN Interfaces Status = ${RED}NOT OK${RESET}"
fi
if [ "$CURRENT_UNKNOWN_INTERFACES" -eq "$EXPECTED_UNKNOWN_INTERFACES" ]; then
	echo "UNKNOWN Interfaces Status = ${GREEN}OK${RESET}"
else
	echo "UNKNOWN Interfaces Status = ${RED}NOT OK${RESET}"
fi
echo
#===========================================================
###END###
