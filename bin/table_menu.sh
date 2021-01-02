#!/bin/bash
#Script to display table menu

binPath="../../bin"                          #Path to scripts directory

while true
do
     echo -e "\n+---------Table Menu----------+"
     echo      "|                             |"
     echo      "| 1. Select Table.            |"
     echo      "| 2. Create Table.            |"
     echo      "| 3. Drop Table.              |"
     echo      "| 4. Rename Table.            |"
     echo      "| 5. Show Tables.             |"
     echo      "| 6. Back to Main Menu.       |"
     echo      "| 7. Exit.                    |"
     echo      "+-----------------------------+"
     echo -e "mydbms> Your choice: \c"
     read choice
   
     case $choice in
     1 )  
          ./$binPath/select_tb.sh  
           if [ $? -eq 100 ]                 #If user chooses to exit from record menu
           then
              exit 100
           fi 
           ;;
     2 )  ./$binPath/create_tb.sh       ;;
     3 )  ./$binPath/drop_tb.sh         ;;
     4 )  ./$binPath/rename_tb.sh       ;;
     5 )  ./$binPath/show_tbs.sh        ;;
     6 )  exit                          ;;
     7 )  exit 100                      ;;
     "")  echo "Error: No input, insert a number from 1 to 7 and try again."       ;;
     * )  echo "Error: Invalid Option, insert a number from 1 to 7 and try again"  ;;
     esac
done