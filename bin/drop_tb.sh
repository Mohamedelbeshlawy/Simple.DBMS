#!/bin/bash
#Script to drop tables

not_exit=0                                                       #Flag to exit the infinite loop
binPath="../../bin"                                              #Path to scripts directory
errorFile="../../.errorLog"                                      #Path to error file
dataPath="./Tables"                                              #Path to tables directory
metaPath="./MetaData"                                            #Path to metadata directory

while [ $not_exit -eq 0 ]
do
   tb_no=$(ls $dataPath 2>>$errorFile | wc -l)
   if [[ $tb_no -ne 0 ]]                                         #Check if the table is empty or not
   then
        read -p "mydbms> Table name: " tabname
        rm $dataPath/$tabname".d" 2>>$errorFile                  #Remove raw data file      
        rm $metaPath/$tabname".m" 2>>$errorFile                  #Remove metadata file   
        if [[ $? == 0 ]]
        then
            echo -e "Table dropped successfully.\n"
            echo -e "Do you want to drop another table?[Y/n]: \c"
            if [ $($binPath/exit_loop.sh) -eq 0 ]
            then
                not_exit=1
            fi
        else
            echo -e "Error:" $tabname "doesn't exist."            #Removal of table failed & hence abort
            echo -e "Do you want to try again?[Y/n]: \c"
            if [ $($binPath/exit_loop.sh) -eq 0 ]
            then
                not_exit=1                                        
            fi
        fi
    else
        echo -e "Empty set.\n"
        not_exit=1                                                #Exit the loop
   fi
done