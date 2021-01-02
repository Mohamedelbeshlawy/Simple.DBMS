#!/bin/bash
#Script to display the records menu

binPath="../../../bin"                  #Path to scripts directory
tb=$1                                   #Passing the table name as argument
while true
do
     echo -e "\n+---------Records Menu----------+"
     echo      "|                               |"
     echo      "| 1. Insert Into Table.         |"
     echo      "| 2. Update Table.              |"
     echo      "| 3. Delete From Table.         |"
     echo      "| 4. Describe Table.            |"
     echo      "| 5. Show Records.              |"
     echo      "| 6. Back to Table Menu.        |"
     echo      "| 7. Exit.                      |"
     echo      "+-------------------------------+"
     echo -e "mydbms> Your choice: \c"
     read choice
   
     case $choice in
     1 )  ./$binPath/insert.sh $tb         ;;
     2 )  ./$binPath/update_tb.sh $tb      ;;
     3 )  ./$binPath/del_record.sh  $tb    ;;
     4 )  ./$binPath/desc_tb.sh $tb        ;;
     5 )  ./$binPath/selectAll.sh $tb      ;;
     6 )  exit                             ;;     
     7 )  exit 100                         ;;          
     * )  echo "Error: Invalid Option, insert a number from 1 to 6 and try again";
     esac
done 