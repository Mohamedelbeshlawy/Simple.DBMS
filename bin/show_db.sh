#!/bin/bash
#Script to show databases

db_no=$(ls ../Databases 2>>../.errorLog | wc -l)      #number of available databases
dbs=$(ls ../Databases 2>>../.errorLog)                #names of the databases
 
if [ $db_no -ne 0 ]
then
    n=1
    echo -e "\n+-----------------------------+"
    echo      "|      D A T A B A S E S      |"
    echo      "+-----------------------------+"  
    for db in $dbs
    do
      echo -e "| "$n". "$db".\c"
      for i in $(seq 1 $((24 - ${#db})))	#calculating the number of spaces required for each db name to draw the table correctly
      do
        echo -e " \c"
      done
      echo "|"
      ((n++))
    done
    echo      "+-----------------------------+"  
    echo -e $db_no "row(s) in set.\n"   
else
    echo -e "Empty set."
fi