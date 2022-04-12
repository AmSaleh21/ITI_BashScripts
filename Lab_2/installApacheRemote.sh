#!/bin/bash

# script to install apache in a remote host
## exit codes
#   0: success
#   1: connection failed
#   2: file not found
#   3: file read failed
#   4: data bad

DATAFILE='./data/VMconnection'

## check for files

[  ! -f ${DATAFILE} ] && echo 'file does not exist, exit 2' && exit 2
[  ! -r ${DATAFILE} ] && echo 'file is not readable, exit 3' && exit 3

## get the data from the file
USER=$(< ${DATAFILE} cut -d":" -f 2 | sed -n 1p)
PASS=$(< ${DATAFILE} cut -d":" -f 2 | sed -n 2p)

# check if the data files recieved correctly
[ -z "${USER}" ] && echo 'file data bad, exit 4' && exit 4
[ -z "${PASS}" ] && echo 'file data bad, exit 4' && exit 4

# install and enable apache2
printf "installing apache ... \n"
ssh "${USER}"@192.168.9.129 "echo ${PASS} | sudo -S apt install apache2"
printf "apache installed \nenabling\n"
ssh "${USER}"@192.168.9.129 "echo ${PASS} | sudo -S service apache2 start"
printf "\n Done, Bye"

exit 0