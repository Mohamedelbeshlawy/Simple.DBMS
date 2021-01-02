#!/bin/bash

echo "   +------------------------------------------------------------------+"
echo "   |                   Welcome to mydbms v1.0.0                       |"
echo "   |                                                                  |"
echo "   |  Brought to you by Shehab El-Deen Alalkamy & Mohamed Elbeshlawy  |"
echo "   |                                                                  |"
echo "   |                  Copyright(c) ITI Intake 41                      |"
echo "   +------------------------------------------------------------------+"
while true
do
     echo -e "\n+----------Main Menu----------+"
     echo      "|                             |"
     echo      "| 1. Select Database.         |"
     echo      "| 2. Create Database.         |"
     echo      "| 3. Drop Database.           |"
     echo      "| 4. Show Databases.          |"
     echo      "| 5. Exit                     |"
     echo      "+-----------------------------+"
     echo -e "mydbms> Your choice: \c"
     read choice
   
     case $choice in
     1 ) 
          cd bin                           #changing directory to the bin directory to execute files on demand
          ./select_db.sh
          if [ $? -eq 100 ]                #If user chooses to exit from other menus
          then
              echo -e "\nSee you soon."
              exit
          fi
          cd ..  ;;
     2 )  cd bin ;  ./create_db.sh ;      cd .. ;;
     3 )  cd bin ;  ./drop_db.sh   ;      cd .. ;;
     4 )  cd bin ;  ./show_db.sh   ;      cd .. ;;
     5 )  echo -e "\nSee you soon.";       exit ;;
     "")  echo "Error: No input, insert a number from 1 to 5 and try again."       ;;
     * )  echo "Error: Invalid Option, insert a number from 1 to 5 and try again." ;;
     esac
done