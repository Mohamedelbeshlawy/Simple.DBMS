#!/bin/bash

not_exit=0                                             #Flag to exit the infinite loop
while [ $not_exit -eq 0 ]
do
  echo -e "mydbms> Database: \c"
  read db 
  until [ $(./is_null.sh $db) -eq 1 ]                  #Loop untl the input is not null
  do
      echo -e "Error: No input given, check your input and try again: \c"
      read db
  done
  cd ../Databases/$db 2>>../.errorLog                  #Change directory to the input database name
  if [[ $? == 0 ]]
  then
      echo $db "selected."
      ./../../bin/table_menu.sh                        #Run table_menu.sh script 
      if [ $? -eq 100 ]                                #Check the value of the exit command in table_menu.sh script
      then
          exit 100                                     #Exit to mydbms.sh with value 100 
      fi
      not_exit=1
  else
      echo "Error:" $db "doesn't exist." 
      echo -e "Do you want to try again?[Y/n]: \c"
      if [ $(./exit_loop.sh) -eq 0 ]
      then
           not_exit=1
      fi     
  fi
done