#!/bin/bash
###
# run crud operations on the invoices Database
# start function must be run first and check the return codes
# continue if start returned 0
###
## return codes
#   1 no arguments in the awk function (scrapped)
#   2 check.sh not found
#   3 check.sh not readable

######### SCRAPPED ####################
function database() {
    local USR=$1
    local DATABASE=$2
    local TABLE=$3
    local AWKFILE=$4
    #local PASS=$4
    [ $# -eq 0 ] && echo "No arguments supplied exit 1 " && return 1
    if [ -n "$5" ]; then
        #create table
        awk -v USR="${USR}" -v DATABASE="${DATABASE}" -v TABLE_ONE="${TABLE}" -f "${AWKFILE}" | mysql -u "${USR}"
    else
        #insert into the table
        local InsertData=$5
        awk <"${InsertData}" -v USR="${USR}" -v DATABASE="${DATABASE}" -v TABLE_ONE="${TABLE}" -f "${AWKFILE}" | mysql -u "${USR}"
    fi
}
######### END SCRAPPED ####################


### CRUD OPERATIONS
##   CREATE
# function to create the database and tables if not exists
function create() {
    # create database if not exits
    mysql -u "${USR}" -p"${PASSWORD}" -e "CREATE DATABASE IF NOT EXISTS ${DATABASE}"

    #creat tables if not exists
    mysql -u "${USR}" -p"${PASSWORD}" -e "CREATE TABLE IF NOT EXISTS ${DATABASE}.${TABLE_ONE}(invID int PRIMARY KEY,custname varchar(100), invdate date, invtotal float )"
    mysql -u "${USR}" -p"${PASSWORD}" -e "CREATE TABLE IF NOT EXISTS ${DATABASE}.${TABLE_TWO}(seq int PRIMARY KEY AUTO_INCREMENT,invID int REFERENCES ${DATABASE}.${TABLE_ONE}(invID), itemname varchar(50), unitprice int, quantity int)"
}

# function to insert into database
function insert() {

    # flag to insert multiple items
    local FLAG="y"
    local INVID
    local DATE
    read -rp "please enter the invoice id: " INVID
    [ "$(checkInvoice "${INVID}")" != 0 ] && echo "invalid invoice exit 2" && exit 2
    local CUSTNAME
    read -rp "please enter the customer name: " CUSTNAME
    local INVTOTAL
    read -rp "please enter the invoice total: " INVTOTAL
    DATE=$(date +%Y-%m-%d)
    mysql -u "${USR}" -p"${PASSWORD}" -e "INSERT INTO ${DATABASE}.${TABLE_ONE}(invID,custName,invDate,invTotal) VALUES(${INVID},\"${CUSTNAME}\","\""${DATE}""\",${INVTOTAL})"
    echo -e "invoice master inserted successfully\n"
    while [ ${FLAG} = "Y" ] || [ ${FLAG} = 'y' ] || [ ${FLAG} = 'YES' ] || [ ${FLAG} = 'yes' ]; do
        local ITEMNAME
        read -rp "please enter the item name:" ITEMNAME
        local UPRICE
        read -rp "please enter the unti price:" UPRICE
        local QUANTITY
        read -rp "please enter the item quantity: " QUANTITY
        mysql -u "${USR}" -p"${PASSWORD}" -e "INSERT INTO ${DATABASE}.${TABLE_TWO}(invID,itemname,unitprice,quantity) VALUES(${INVID},\"${ITEMNAME}\",${UPRICE},${QUANTITY})"
        read -rp "Do you want to insert another item? Y/N " FLAG
    done

}

## READ
# function to show all tables contents for testing
function showAll() {
    echo "--- select all from Invoice Master ---"
    mysql -u "${USR}" -p"${PASSWORD}" -e "(SELECT * FROM ${DATABASE}.${TABLE_ONE})"
    ##
    echo "--- select all from Invoice details ---"
    mysql -u "${USR}" -p"${PASSWORD}" -e "SELECT * FROM ${DATABASE}.${TABLE_TWO}"
}

# Display one invoice
function displayOne() {

    local INVID
    read -rp "please enter the invoice id to display: " INVID
    [ "$(checkInvoice "\"${INVID}\"")" != 1 ] && return 1
    echo "--- Invoice Master ---"
    mysql -u "${USR}" -p"${PASSWORD}" -e "SELECT * FROM ${DATABASE}.${TABLE_ONE} WHERE invID = ${INVID}"
    echo "--- Invoice details ---"
    mysql -u "${USR}" -p"${PASSWORD}" -e "SELECT * FROM ${DATABASE}.${TABLE_TWO} WHERE invID = ${INVID}"

}

## DELETE
# delete an invoice from the database
function delete() {
    local INVID
    read -rp "please enter the invoice id to delete:" INVID
    [ "$(checkInvoice "${INVID}")" != 1 ] && return 1
    mysql -u "${USR}" -p"${PASSWORD}" -e "DELETE FROM ${DATABASE}.${TABLE_TWO} WHERE invID = ${INVID}"
    mysql -u "${USR}" -p"${PASSWORD}" -e "DELETE FROM ${DATABASE}.${TABLE_ONE} WHERE invID = ${INVID}"
}
