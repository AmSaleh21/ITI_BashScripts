#!/bin/bash

USR="private"
DATABASE="BashLabOne"
T1="Invoices"
T2="Invoices_details"

< invoice-data.txt awk -v USR=${USR} -v DATABASE=${DATABASE} -v T1=${T1} -f "Invoice.awk" |mysql -u ${USR}
< product-data.txt awk -v USR=${USR} -v DATABASE=${DATABASE} -v T2=${T2} -f "product.awk" |mysql -u ${USR}


exit 0
