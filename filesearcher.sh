#!/bin/bash

# This script searches for files matching the given file extension in a disk partition and prints out the contents of 

DISK_NAME=$1
PARTITION_START=$2
FILE_EXTENSION=$3

if [[ "$1" = "" || "$2" = "" || "$3" = "" ]]; then
	echo syntax error: ./filesearcher.sh [DISKNAME] [PARTITION_START] [FILE_EXTENSION]
	exit 9
fi

# Recursively search through each directory
search() {
	fls -o $PARTITION_START $DISK_NAME $1 | while read -r line
	do
 		# Check for a match
		if [[ "$line" =~ "$FILE_EXTENSION" ]]; then
			icat -o $PARTITION_START $DISK_NAME $(awk -F'[ :]' '{print $2}' <<< "$line")
   		# Else search if a directory
		elif [[ "$line" =~ "d/d" ]]; then
			search $(awk -F'[ :]' '{print $2}' <<< $line)
		fi
			
	done
}

search
