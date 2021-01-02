#!/bin/bash
#Script to rename tables

not_exit=0                                                      #Flag to exit the infinite loop
errorFile="../../.errorLog"                                     #Path to error file
binPath="../../bin"                                             #Path to scripts directory            
metaPath="./MetaData"                                           #Path to metadata directory
dataPath="./Tables"                                             #Path to tables directory
source ./$binPath/validate_name.sh                              #This script is used as source file

while [ $not_exit -eq 0 ]
do
   tb_no=$(ls $dataPath 2>>$errorFile | wc -l)                  #Check if the database is empty or not
   if [[ $tb_no -ne 0 ]]
   then
        read -p "mydbms> Enter table name: " tabname
        if [[ -f $dataPath/$tabname".d" ]]
        then    
            read -p "mydbms> Enter new table name: " tabRename
            name=$tabRename  
            CHECK_NAME
            valid=$?
            until [ $valid -eq 0 ]                              #Loop until the name becomes valid
            do
               if [ $valid -eq 1 ]
               then
                   echo "Error: Invalid table name, check your input and try again."
               elif [ $valid -eq 2 ]
               then
                   echo "Error: No input given, check your input and try again."
               else        
                   echo "Error: No blanks are allowed, check your input and try again."
               fi
               read -p "mydbms> New table name: " name
               CHECK_NAME
               valid=$?
            done
            tabRename=$name
            if [[ -f $dataPath/$tabRename".d" ]]                #Check if the table name already exists or not
            then
                echo -e "Error: Table" $tabRename "already exists.\n"
                echo -e "Do you want to try again?[Y/n]: \c"
                if [ $($binPath/exit_loop.sh) -eq 0 ]
                then
                    not_exit=1
                fi
            else
                mv $dataPath/$tabname".d" $dataPath/$tabRename".d" 2>>$errorFile            #Rename the raw data file
                mv $metaPath/$tabname".m" $metaPath/$tabRename".m" 2>>$errorFile            #Rename the metadata file
                if [[ $? == 0 ]]
                then
   	                echo -e "Table renamed successfully.\n"
                    echo -e "Do you want to rename another table?[Y/n]: \c"
                    if [ $("./$binPath"/exit_loop.sh) -eq 0 ]
                    then
                        not_exit=1
                    fi
                else
                    echo -e "Error: Unable to rename" $tabname"."
                    echo "Returning back.."
                    not_exit=1
                fi
            fi
        else
            echo "Error:" $tabname "doesn't exist."             #Renaming of table failed & hence abort
            not_exit=1
        fi
   else
        echo -e "Empty set.\n"
        not_exit=1
   fi
done
