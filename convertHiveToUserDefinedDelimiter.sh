#!/bin/bash
#######################################################################################
# This script will join multiple part files from hadoop together (hive table), convert
# HIVE delimiters (\001) to a user defined delimiter, remove the first column from the
# dataset, replace the null characters (\N) with an empty string, sort the data, and 
# finally write to a user defined file
#######################################################################################
FILE_NAMES=""
DELIM=""
OUTPUT_FILE=""

while getopts "d:f:o:" opt;
do
    case "$opt" in
	    d)
		   DELIM="$OPTARG"
		   ;;
		f)
		   FILE_NAMES="$OPTARG"
		   ;;
		o)
		   OUTPUT_FILE="$OPTARG"
		   ;;
	esac
done

cat ${FILE_NAMES} | tr "\001" "${DELIM}" awk -F${DELIM} '{print $2"${DELIM}"$3"${DELIM}"$4"${DELIM}"$5"${DELIM}"$3"${DELIM}"$7"${DELIM}"$8"${DELIM}"$9"${DELIM}"$10"${DELIM}"$11"${DELIM}"$12"${DELIM}"} | sed -e 's/|\\N/|/g' | sort > ${OUTPUT_FILE}