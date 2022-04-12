#!/bin/bash

# script to install apache in a remote host
## exit codes
#   0: success
#   1: connection failed
#   2: file not found
#   3: file read failed
#   4: bad data sent

DATAFILE='./data/VMconnection'

## check for files

[  ! -f ${DATAFILE} ] && echo 'file does not exist, exit 2' && exit 2
[  ! -r ${DATAFILE} ] && echo 'file is not readable, exit 3' && exit 3

## get the data from the file
USER=$(< ${DATAFILE} cut -d":" -f 2 | sed -n 1p)
PASS=$(< ${DATAFILE} cut -d":" -f 2 | sed -n 2p)
IP=$(< ${DATAFILE} cut -d":" -f 2 | sed -n 3p)

# check if the data files recieved correctly
[ -z "${USER}" ] || [ "${USER}" == "<guest user name>" ] && echo 'file data bad, exit 4' ; exit 4
[ -z "${PASS}" ] || [ "${PASS}" == "<guest password>" ] &&  echo 'file data bad, exit 4' ; exit 4
[ -z "${IP}" ] || [ "${IP}" == "<guestIP>" ] && echo 'bad data sent in the file' ; exit 4

# install and enable apache2
printf "installing apache ... \n"
ssh "${USER}"@"${IP}" "echo ${PASS} | sudo -S apt install apache2"
printf "apache installed \nenabling\n"
ssh "${USER}"@"${IP}" "echo ${PASS} | sudo -S service apache2 start"
printf "\n Done, Bye"

exit 0