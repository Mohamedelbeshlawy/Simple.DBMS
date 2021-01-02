#!/bin/bash
#Script to drop databases

not_exit=0                                                   #Flag to exit the infinite loop
while [ $not_exit -eq 0 ]
do
   read -p "mydbms> Database name: " db
   rm -r ../Databases/$db 2>>../.errorLog                    #Remove the directory with it's subdirectories
   if [[ $? == 0 ]]
   then
       echo -e "Database dropped successfully.\n"
       echo -e "Do you want to drop another database?[Y/n]: \c"
       if [ $(./exit_loop.sh) -eq 0 ]
       then
           not_exit=1                                       #Exit the loop
       fi
   else
       echo -e "Error:" $db "doesn't exist."                #Removal of database failed & hence abort
       not_exit=1                                           
   fi
done