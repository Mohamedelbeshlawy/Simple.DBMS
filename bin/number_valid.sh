#!/bin/bash
#Script to validate the number passed

number=$1                   #Passing argument to be tested
if [ -z $number ]
then
    echo 3
elif [[ $number =~ ^[2-9]+[0-9]*$ ]]
then
    echo 0
elif [ $number -ge 0 ]
then
    echo 1
else
    echo 2   
fi
