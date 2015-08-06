#!/bin/bash
###################################################################################################
# The following are requirements of this script, please change as needed:
# 1) This file must be a directory above the HQL and data files for the HIVE table
# 2) Inputs are the subfolder where the data and HQL file are for the table
# 3) The hql file and the data file have the same name (HQL file is appended with .hql)
# 4) Assumes that the HQL file points to the correct folder in HDFS
#    a) uppercase folder name and lowercase file name)
###################################################################################################
#Check if input isn't empty
if [ -z $1 -o -z $2 ]; then
   echo "The input is null, please specify a file name and folder name"
   exit
fi

BOLD=`tput bold`
NORMAL=`tput sgr0`
DIRECTORY_NAME="${1,,}"                  #Make directory name lowercase
FILE_NAME="${1^^}"                       #Make filename uppercase
HQL_FILE=$FILE_NAME.hql                  #Name of hql create table file
HADOOP_FILE=$DIRECTORY_NAME/$FILE_NAME   #File name and path in HDFS
FOLDER=$2                                #Folder HQL file and source data is in

#check if source file and hql file exist

if [ -f ~/${FOLDER}/${FILE_NAME} ] || [ -f ~/${FOLDER}/${HQL_FILE} ]; then
        #Check if file already exists in hadoop
		hadoop -fs -test -e ${HADOOP_FILE}
		#Use the return value from the above command to verify the file exists, if so delete it
		if [ $?=0 ]; then
		       echo $'\n'${BOLD}"Removing hadoop folder ${DIRECTORY_NAME}"${NORMAL}
			   hadoop fs -rm -r ${DIRECTORY_NAME}
        fi
		#Create directory, move file, and create table in hive
		echo $'\n'${BOLD}"Creating hadoop directory ${DIRECTORY_NAME}"${NORMAL}
		hadoop fs -mkdir ${DIRECTORY_NAME}
		echo $'\n'${BOLD}"Moving the data file ${FILE_NAME} to the hadoop directory ${DIRECTORY_NAME}"${NORMAL}
		hadoop fs -put ~/${FOLDER}/${FILE_NAME} ${DIRECTORY_NAME}
		echo $'\n'${BOLD}"Creating HIVE table for the file ${HQL_FILE}"${NORMAL}
		hive -f ~/${FOLDER}/${HQL_FILE}
		echo $'\n'${BOLD}"HIVE table creation complete"${NORMAL}
		exit
else
        echo $'\n'${BOLD}"The input file ${FILE_NAME} doesn't exist"${NORMAL}
		exit
fi
