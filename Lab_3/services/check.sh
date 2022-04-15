#!/bin/bash

###checks if the given ID does exists in the table
## returns 0 in success
## returns 1 ID not exists
function checkInvoice {
    local INVID=${1}
    local FLAG
    FLAG=$(mysql -u "${USR}" -p"${PASSWORD}"  -sNe "SELECT EXISTS (SELECT '*' FROM ${DATABASE}.${TABLE_ONE} where invID = ${INVID})")
    echo "${FLAG}"
}
