#!/bin/bash
#Functions to validate names
#This script is used as a source file
# shopt command is used to toggle the values of settings controlling optional shell behavior
# -s option is used to enable (set) the optname
# extglob enables the extended pattern matching features
shopt -s extglob   
# LC_COLLATE controls the sorting order of the characters in range expressions
# C enables the traditional interpretation of ranges in bracket expressions
export LC_COLLATE=C  

function CHECK_SPACES
#Function that loop over every character of string name and find if it has blank or not
#it returns a flag  0:Blank found   1:No blank found
{
    found=1                        #no spaces found
    for (( character = 1 ; character <= ${#name} ; character++ ))
    do
        case ${name:$character:1} in
        " " )
             found=0                #spaces found
             break
             ;;
        esac     
    done
    return $found
}

function CHECK_NAME
{
   CHECK_SPACES 
   if [ $? -eq 0 ]
   then
       valid=3              #spaces found
   elif [ -z $name ]
   then
       valid=2              #name is empty
   elif [[ ! $name =~ ^[_]{0,1}[a-zA-Z]+[a-zA-Z0-9_]*[a-zA-Z0-9]*$ ]]
   then
       valid=1              #name is not valid
   else
       valid=0              #name is valid
   fi
   return $valid
}