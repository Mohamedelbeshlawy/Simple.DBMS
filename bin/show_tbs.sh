#!/bin/bash
#Script to show all tables in a database

path="MetaData/"                                  
tb_no=$(ls $path 2>>../../.errorLog | wc -l)   
tbs=$(ls $path 2>>../../.errorLog)        
 
if [ $tb_no -ne 0 ]
then
     n=1         
     echo -e "\n+-----------------------------+"
     echo      "|         T A B L E S         |"
     echo      "+-----------------------------+"  
     for tb in $tbs
     do
       echo -e "| "$n". "${tb::-2}".\c"
       for i in $(seq 1 $((26 - ${#tb})))	    #calculating the number of spaces required for each db name to draw the table correctly
       do
          echo -e " \c"
       done
       echo "|"
       ((n++))
     done
     echo      "+-----------------------------+"  
     echo -e $tb_no "row(s) in set.\n"   
else
    echo -e "Empty set.\n"
fi
