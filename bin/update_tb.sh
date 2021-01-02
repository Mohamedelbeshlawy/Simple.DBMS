#!/bin/bash
#Script to update records of tables

not_exit=0                                          #Flag to exit the infinite loop
errorFile="../../../.errorLog"                      #Path to error file
binPath="../../../bin"                              #Path to scripts directory
metaPath="../MetaData"                              #Path to metadata directory
tb=$1                                               #Passing the table name as argument
export PS3="mydbms> "                               #Set the prompt of the database
source $binPath/check_data.sh                       #This script is used as source file

while [ $not_exit -eq 0 ]
do
   echo "mydbms> Do you want to update: "
   select choice in "Whole rows." "Specific row(s)."
   do
    case $REPLY in
    1 )
       read -p "mydbms> Enter updated column name: " setCol                                     #The Updated Column
       searchCell=$(awk -F: '{if($1=="'$setCol'") print NR}' $metaPath/$tb".m" 2>>$errorFile) 
       if [[ $searchCell == "" ]]                                                               #Check if the column exists or not
       then
           echo "Column not found."
       else
           field=$(awk -F: '{if(NR=='$searchCell') print $1}' $metaPath/$tb".m")
           type=$(awk  -F: '{if(NR=='$searchCell') print $2}' $metaPath/$tb".m")
           null=$(awk  -F: '{if(NR=='$searchCell') print $4}' $metaPath/$tb".m")
           if [ $searchCell -ne 1 ]                                                             #As the primary key must be unique
           then
               echo -e "mydbms> Enter updated "$field" data: \c"            
               read data
               VALIDATE_FIELDS                                                                  #Function to validate the data before updating the table
               NR=$(awk -F: '{if(NR>1) {print NR}}' $tb".d" 2>>$errorFile)                      #Number of records to be updated
               for nNR in $NR
               do  
                 if [[ $nNR != '1' ]]                                                           #As the first row contains the field names
                 then
                     oldData=$(awk -v data="$searchCell" 'BEGIN{FS=":"}{if(NR=='$nNR'){for(i=1;i<=NF;i++){if(i==data) print $i}}}' $tb".d" 2>>$errorFile)
                     sed -i ''$nNR's/'$oldData'/'$data'/g' $tb".d" 2>>$errorFile
                 fi
              done
              echo "All rows updated successfully."
           else
               echo -e "Error: Column" $field "(Primary Key) must be unique"
           fi    
       fi
       echo -e "Do you want to update another record?[Y/n]: \c"
       if [ $("./$binPath"/exit_loop.sh) -eq 0 ]
       then
           not_exit=1                           #Exit the loop
       fi  
       break ;;
    2 )
       read -p "mydbms> Enter condition column name: " conditionCol
       searchCol=$(awk -F: '{if($1=="'$conditionCol'") print NR}' $metaPath/$tb".m" 2>>$errorFile)
       if [[ $searchCol == "" ]]
       then
           echo "Column not found."
       else
           read -p "mydbms> Enter condition data: " conditionData
           searchData=$(awk -v data="$conditionData" 'BEGIN{FS=":"}{if($'$searchCol'==data) print $'$searchCol'}' $tb".d"  2>>$errorFile)   
           if [[ $searchData == "" ]]           #Check if the data exists or not
           then
               echo "Data not found."
           else
               read -p "mydbms> Enter updated column name: " setCol
               searchCell=$(awk -F: '{if($1=="'$setCol'") print NR}' $metaPath/$tb".m" 2>>$errorFile)
               if [[ $searchCell == "" ]]
               then
                   echo "Column not found."
               else
                   field=$(awk -F: '{if(NR=='$searchCell') print $1}' $metaPath/$tb".m")
                   type=$(awk  -F: '{if(NR=='$searchCell') print $2}' $metaPath/$tb".m")
                   null=$(awk  -F: '{if(NR=='$searchCell') print $4}' $metaPath/$tb".m")
                   if [ $searchCell -eq 1 ]
                   then
                       echo -e "mydbms> Enter updated "$field" data (PRIMARY KEY): \c"
                       read data
                       VALIDATE_PK                                  
                       NR=$(awk -v data="$conditionData" 'BEGIN{FS=":"}{if($'$searchCol'==data) print NR}' $tb".d" 2>>$errorFile)  
                       for nNR in $NR
                       do  
                          if [[ $nNR != '1' ]]
                          then
                              oldData=$(awk -v data="$searchCell" 'BEGIN{FS=":"}{if(NR=='$nNR'){for(i=1;i<=NF;i++){if(i==data) print $i}}}' $tb".d" 2>>$errorFile)
                              sed -i "$nNR s/$oldData/$data/g" ./$tb".d" 2>>$errorFile
                              echo "Row updated successfully."
                              break
                          fi
                        done
                   else
                       echo -e "mydbms> Enter updated "$field" data: \c"
                       read data
                       VALIDATE_FIELDS                              
                       NR=$(awk -v data="$conditionData" 'BEGIN{FS=":"}{if($'$searchCol'==data) print NR}' $tb".d" 2>>$errorFile)
                       for nNR in $NR
                       do  
                         if [[ $nNR != '1' ]]
                         then
                             oldData=$(awk -v data="$searchCell" 'BEGIN{FS=":"}{if(NR=='$nNR'){for(i=1;i<=NF;i++){if(i==data) print $i}}}' $tb".d" 2>>$errorFile)
                             sed -i "$nNR s/$oldData/$data/g" $tb".d" 2>>$errorFile
                             echo "Row updated successfully."
                         fi
                       done
                   fi    
               fi       
           fi
       fi
       echo -e "Do you want to update another record?[Y/n]: \c"
       if [ $("./$binPath"/exit_loop.sh) -eq 0 ]
       then
           not_exit=1
       fi  
       break ;;
    * )  
       echo "Error: Invalid Option" ;;   
    esac
  done 
done
          