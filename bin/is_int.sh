#!/bin/bash
#Script to check if the passed argument is integer or not

input=$1            #Passing argument to be tested
if [[ $input =~ ^[-]{0,1}[0-9][0-9]*$ ]]
then
    echo 0          #int
else
    echo 1          #not int   
fi
