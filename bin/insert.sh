#!/bin/bash
#Script to insert data into tables

not_exit=0                                                            #Flag to exit the infinite loop
errorFile="../../../.errorLog"                                        #Path to error file
binPath="../../../bin"                                                #Path to scripts directory
metaPath="../MetaData"                                                #Path to metadata directory
tb=$1                                                                 #Passing the table name as argument
source $binPath/check_data.sh                                         #This script is used as source file

while [ $not_exit -eq 0 ]
do        
  colNo=`cat $metaPath/$tb".m" | wc -l`                               #Or colNo=`awk -F: 'END {print NR}' $metaPath/$tb".m"`
  for (( col = 1 ; col <= $colNo ; col++ ))
  do
    field=$(awk -F: '{if(NR=='$col') print $1}' $metaPath/$tb".m")
    type=$(awk  -F: '{if(NR=='$col') print $2}' $metaPath/$tb".m")
    null=$(awk  -F: '{if(NR=='$col') print $4}' $metaPath/$tb".m")
    if [ $col -eq 1 ]                                                 #Primary key column
    then
         echo -e "mydbms>" $field"(PRIMARY KEY): \c"
         read data
         VALIDATE_PK                                                  #Function to make sure of the primary key constraints
         echo -e $data":\c" >> $tb".d" 2>>$errorFile 
    else
         echo -e "mydbms>" $field": \c"
         read data
         VALIDATE_FIELDS                                              #Function to make sure of fields constraints
         if [ $col -eq $colNo ]
         then
              echo $data >> $tb".d" 2>>$errorFile
         else
              echo -e $data":\c" >> $tb".d" 2>>$errorFile  
         fi
    fi 
  done
  echo "Row added successfully."
  echo -e "Do you want to insert another record?[Y/n]: \c"
  if [ $("./$binPath"/exit_loop.sh) -eq 0 ]
  then
       not_exit=1                                                     #Exit the loop
  fi    
done
