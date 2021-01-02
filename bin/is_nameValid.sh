#!/bin/bash
#Script to validate the name of the passed argument

#D E F I N I T I O N S
# shopt command is used to toggle the values of settings controlling optional shell behavior
# -s option is used to enable (set) the optname
# extglob enables the extended pattern matching features
shopt -s extglob   
# LC_COLLATE controls the sorting order of the characters in range expressions
# C enables the traditional interpretation of ranges in bracket expressions
export LC_COLLATE=C

name=$1                   #Passing argument to be tested
if [[ ! $name =~ ^[a-zA-Z]+[a-zA-Z0-9_]*[a-zA-Z0-9]*$ ]]
then
    echo 1                #valid
else
    echo 0                #not valid
fi