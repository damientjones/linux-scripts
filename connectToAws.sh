#!/bin/bash
if [ -z $1 ]
then
    echo "Error: hostname argument was not provided"
	echo "Exiting ..."
	exit
fi

HOSTNAME=$1                                          #This is the Master public DNS from the Amazon EMR console
PEMFILE=$2                                           #This should be hard coded
echo "Connecting to $HOSTNAME"

ssh -i ~/${PEMFILE} hadoop@${HOSTNAME}