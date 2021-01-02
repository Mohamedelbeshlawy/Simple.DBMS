#!/bin/bash
#Script to show the records of tables

errorFile="../../../.errorLog"                              #Path to error file
tb=$1                                                       #Passing the table name as argument
dataFile=$tb".d"                                            
record_no=$(wc -l <$dataFile 2>>$errorFile)
if [ $record_no -eq 1 ]
then
    echo -e "Empty set.\n"
else
    echo ""
    characters=$(column -s: -t $dataFile | head -1 | wc -c)
    for (( i = 1 ; i <= $characters ; i++ ))
    do
       line+="-"
    done
    column -s: -t $dataFile >> .temp 2>>$errorFile
    sed -i 2s/^/$line"\n"/ .temp 2>>$errorFile
    cat .temp 2>>$errorFile
    let record_no--
    echo -e "\n"$record_no "row(s) in set."
    rm .temp 2>>$errorFile
fi