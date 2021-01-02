#!/bin/bash
#Script to check if the passed argument is null or not

input=$1                #Passing argument to be tested
if [[ $input = "" ]]
then
    echo 0              #null
else
    echo 1              #not null
fi
