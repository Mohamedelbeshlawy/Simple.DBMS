#!/bin/bash
#Script to delete records from tables

not_exit=0                                          #Flag to exit the infinite loop
errorFile="../../../.errorLog"                      #Path to error file
binPath="../../../bin"                              #Path to scripts directory
metaPath="../MetaData"                              #Path to metadata directory
tb=$1                                               #Passing the table name as argument
export PS3="mydbms> "                               #Set the prompt of the database

while [ $not_exit -eq 0 ]
do
  col_no=$(cat $tb".d" 2>>$errorFile | wc -l)       
  if [[ $col_no -eq 1 ]]                            #check if the table is empty or not
  then
      echo -e "Empty set.\n"                    
      not_exit=1                                    #Exit the loop
  else
      echo "mydbms> Do you want to delete: "
      select choice in "Whole rows." "Specific row(s)."
      do
        case $REPLY in 
        1 )
            sed -i '2,$d' ./$tb".d" 2>>$errorFile   #Delete lines starting from the second line as the first line contains the field names
            echo "Table deleted successfully."
            exit 
            break ;;
        2 )
            read -p "mydbms> Enter condition column name: " conditionCol                        
            searchCol=$(awk -v data="$conditionCol" 'BEGIN{FS=":"}{for(i=1;i<=NF;i++){if(i==1){if($i==data) print NR}}}' $metaPath/$tb".m" 2>>$errorFile)    
            if [[ $searchCol == "" ]]               #Check if the column exists or not
            then
                echo "mydbms> Column not found."
            else
                read -p "mydbms> Enter condition data: " conditionData
                searchData=$(awk -v data="$conditionData" 'BEGIN{FS=":"}{if($'$searchCol'==data) print $'$searchCol'}' $tb".d"  2>>$errorFile)
                if [[ $searchData == "" ]]          #Check if the data exists or not
                then
                    echo "Data not found."
                else
                    NR=$(awk -v data="$conditionData" 'BEGIN{FS=":"}{if($'$searchCol'==data) print NR}' ./$tb".d"  2>>$errorFile)  #The records that will be updated
                    for nNR in $NR
                    do
                      if [[ $nNR != '1' ]]         #The first record contains the field names
                      then 
                          sed -i "$nNR s/$conditionData/'*del*'/" $tb".d" 2>>$errorFile         #Replace every cell that matches the pattern with known symbol because if we delete each line here, the sed shifts the deleted rows 
                          echo "Row deleted successfully."                                      
                      fi    
                    done
                    sed -i '/'*del*'/d' $tb".d" 2>>$errorFile                                   #Delete all the records that contains the known symbol
                fi
            fi
            echo -e "Do you want to delete another record?[Y/n]: \c"
            if [ $("./$binPath"/exit_loop.sh) -eq 0 ]
            then
                not_exit=1                          #Exit the loop
            fi
            break ;;
        * )  
            echo "Error: Invalid Option" ;;
        esac 
      done
  fi
done