#!/bin/bash

function displayMenu {
    local OPTION=0
    while [ ${OPTION} -ne 4 ]
    do
        echo -e "1.show all\n2.display one\n3.insert invoice\n4.delete invoice\n5.quit" 
        read -r OPTION
        case ${OPTION} in 
            1)
                showAll
                ;;
            2)
                displayOne
                ;;
            3)
                insert
                ;;
            4) 
                delete
                ;;
            5) 
                exit 0
                ;;
            *)
                echo -e "invalid option\n"
        esac
    done
    
}
