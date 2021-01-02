#!/bin/bash
#Script to create databases

source validate_name.sh                                         #This script is used as source file
errorFile="../.errorLog"                                        #Path for the error file

if [ ! -d ../Databases ]                                        #Checking if there is not a Databases directory
then
     mkdir ../Databases 2>>$errorFile                           #Submit error messages to hidden errorLog file 
fi
not_exit=0                                                      #Flag to exit the infinite loop
while [ $not_exit -eq 0 ]
do
   read -p "mydbms> Database name: " db
   name=$db  
   CHECK_NAME
   valid=$?
   until [ $valid -eq 0 ]                                       #Loop until the name becomes valid
   do
      if [ $valid -eq 1 ]
      then
           echo "Error: Invalid database name, check your input and try again."
      elif [ $valid -eq 2 ]
      then
           echo "Error: No input given, check your input and try again."
      else        
           echo "Error: No blanks are allowed, check your input and try again."
      fi
      read -p "mydbms> Database name: " name
      CHECK_NAME
      valid=$?
   done
   db=$name
   if [ -d ../Databases/$db ]                                   #Condition to check for previous existence
   then
       echo $db "already exists."
       exit
   else
       mkdir ../Databases/"$db" 2>>$errorFile 
       if [[ $? == 0 ]]                                         #Check the previous command status 0: OK  any no: Failed
       then
           echo "Database created."
           mkdir ../Databases/"$db"/MetaData 2>>$errorFile      #Creating Directory for the metadata
           mkdir ../Databases/"$db"/Tables 2>>$errorFile        #Creating Directory for the raw data
      
           echo -e "Do you want to create another database?[Y/n]: \c"
           if [ $(./exit_loop.sh) -eq 0 ]
           then
               not_exit=1                                       #Exit the loop
           fi     
       else
           echo "Error:" $db "can't be created."                #Creation of directory failed & hence abort
           not_exit=1
       fi
   fi
done