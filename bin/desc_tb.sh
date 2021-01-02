#!/bin/bash
#Script to describe tables

errorFile="../../../.errorLog"                                  #Path to error file
tb=$1                                                           #Passing the table name as argument           
metaFile="../MetaData/"$tb".m"                                  #Path to metafile                  
field_no=$(wc -l <$metaFile 2>>$errorFile)                      #number of fields in metadata file
echo ""
version=$(cat /etc/os-release | head -1 | grep Ubuntu)          #Linux distribution of the system
if [ $? -eq 0 ]                                                 #Ubuntu
then
    head="Field:Type:Key:Null\n"                                #Metadata header
    sed -i 1s/^/$head/ $metaFile                                #Add the header to the metadata file
    characters=$(column -s: -t -n $metaFile | head -1 | wc -c)  #Number of characters required to draw the line
    for (( i = 1 ; i <= $characters ; i++ ))
    do
       line+="-"
    done
    column -s: -t -n $metaFile >> .temp 2>>$errorFile           #Create a hidden temporary file which contains the formated table
    sed -i '1d' $metaFile                                       #Delete the header of the metafile
else                                                            #Other 
    characters=$(column -s: -t --table-columns Field,Type,Key,Null $metaFile | head -1 | wc -c)          
    for (( i = 1 ; i <= $characters ; i++ ))
    do
       line+="-"
    done
    column -s: -t --table-columns Field,Type,Key,Null $metaFile >> .temp 2>>$errorFile
fi
sed -i 2s/^/$line"\n"/ .temp 2>>$errorFile                      #Draw line under the head
cat .temp 2>>$errorFile                                         #Read the temporary file
echo -e "\n"$field_no "row(s) in set."                          #Display the number of records
rm .temp 2>>$errorFile                                          #Remove the temporary file