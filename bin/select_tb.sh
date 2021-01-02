#!/bin/bash
#Script to select tables

dataPath="./Tables"                             #Path for Tables directory
binPath="../../../bin"                          #Path for scripts directory
not_exit=0                                      #Flag to exit the infinite loop
errorFile="../../.errorLog"                     #Path to error file

while [ $not_exit -eq 0 ]
do
  echo -e "mydbms> Table: \c"
  read tbname 
  cd $dataPath 2>>$errorFile
  if [[ $? == 0 ]]
  then
       until [ $(./$binPath/is_null.sh $tbname) -eq 1 ]                 #Check if the input is null
       do
          read -p "Error: No input. Please try again: " tbname
       done
       if [[ -f ./$tbname".d" ]]                                        #Check if the table exists or not
       then
	    echo $tbname "selected."
	    ./$binPath/record_menu.sh $tbname
        if [ $? -eq 100 ]
        then
            exit 100
        fi
	    exit
       else
	    echo "Error:" $tbname "doesn't exist." 
            echo -e "Do you want to try again?[Y/n]: \c"
            if [ $(./$binPath/exit_loop.sh) -eq 0 ]
            then
                not_exit=1
            fi
            cd ..     
        fi  
  else
      echo "Error: Missing files."                                      #Selection of table failed & hence abort
      echo "Returning back.." 
      not_exit=1 
  fi
done
