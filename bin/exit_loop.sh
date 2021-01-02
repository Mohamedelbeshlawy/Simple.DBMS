#!/bin/bash
#Script used to let the user choose to continue or exit

read answer
until [[ $answer =~ ^[yYnN]$ ]]                     #Loop until the input becomes valid
do
   read -p "Error: Invalid answer. Please try again: " answer
done
if [[ $answer =~ ^[nN]$ ]]                          #Check if the answer is no
then 
    echo 0    #exit loop
else 
    echo 1    #don't exit
fi
