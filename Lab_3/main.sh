#!/bin/bash

### this script manages CRUD on the database
## exit codes
#   exit 0 success
#   exit 1 exit from crud
#   exit 2 x file missing
#   exit 3 x file is not readable
#   exit 4 config file data bad

## check for the files

[ ! -f "./configs/config.cfg" ] && echo 'config file does not exist, exit 2' && exit 2
[ ! -r "./configs/config.cfg" ] && echo 'config file is not readable, exit 3' && exit 3
# set the config var
CONFIG="./configs/config.cfg"

# ignore not used, they are passed to the source files
DATABASE=$(cut <${CONFIG} -d"=" -f 2 | sed -n 1p)
USR=$(cut <${CONFIG} -d"=" -f 2 | sed -n 2p)
PASSWORD=$(cut <${CONFIG} -d"=" -f 2 | sed -n 3p)
TABLE_ONE=$(cut <${CONFIG} -d"=" -f 2 | sed -n 4p)
TABLE_TWO=$(cut <${CONFIG} -d"=" -f 2 | sed -n 5p)

# check if the data files recieved correctly
[ -z "${DATABASE}" ] && echo 'database was not recieved, exit 4' && exit 4
[ -z "${USR}" ] || [ "${USR}" != "<db username>" ] && echo 'usr name was not recieved, exit 4' && exit 4
[ -z "${PASSWORD}" ] || [ "${PASSWORD}" != "<db password>" ] && echo 'password was not recieved, exit 4' && exit 4
[ -z "${TABLE_ONE}" ] && echo 'table name was not recieved, exit 4' && exit 4
[ -z "${TABLE_TWO}" ] && echo 'table two was not recieved, exit 4' && exit 4
return 0

# crud operations file
[ ! -f "./services/crud.sh" ] && echo 'crud file does not exist, exit 2' && exit 2
[ ! -r "./services/crud.sh" ] && echo 'crud file is not readable, exit 3' && exit 3
# source if exists
# shellcheck source=/dev/null
source ./services/crud.sh

# check file
[ ! -f "./services/check.sh" ] && echo "check file does not exist " && exit 2
[ ! -r "./services/check.sh" ] && echo "check file is not readable " && exit 3
# shellcheck source=/dev/null
source "./services/check.sh"

# menu file
[ ! -f "./menu.sh" ] && echo "menu file config file does not exist, exit 2" && exit 2
[ ! -r "./menu.sh" ] && echo "menu file config file is not readable, exit 3" && exit 3
# shellcheck source=/dev/null
source ./menu.sh

displayMenu

exit 0
