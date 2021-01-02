#!/bin/bash
#Script to create tables

export PS3="mydbms> "
not_exit=0                                                           #Flag to exit the infinite loop
binPath=../../bin                                                    #Path to scripts directory
errorFile="../../.errorLog"                                          #Path to error file
source ./$binPath/validate_name.sh                                   #This script is used as source file

while [ $not_exit -eq 0 ]                           
do
   read -p "mydbms> Table name: " tb
   name=$tb  
   CHECK_NAME                                                        #Function to validate names
   valid=$?
   until [ $valid -eq 0 ]                                            #Loop until the name becomes valid
   do
     if [ $valid -eq 1 ]
     then
        echo "Error: Invalid table name, check your input and try again."
     elif [ $valid -eq 2 ]
     then
        echo "Error: No input given, check your input and try again."
     else        
        echo "Error: No blanks are allowed, check your input and try again."
     fi
     read -p "mydbms> Table name: " name
     CHECK_NAME
     valid=$?
   done
   tb=$name
   if [ -f MetaData/$tb".m" ]                                        #Check if table name exists or not
   then
       echo "Table already exists."
       exit
   else
       read -p "mydbms> Fields number: " col_no
       until [ $("./$binPath/"number_valid.sh $col_no) -eq 0 ]       #Loop until the input becomes valid
       do
          if [ $("./$binPath/"number_valid.sh $col_no) -eq 1 ]
          then
               echo "Error: Table must have at least 2 fields. Please try again."
          elif [ $("./$binPath/"number_valid.sh $col_no) -eq 3 ]
          then
               echo "Error: No input given. Please try again."
          else
               echo "Error: Invalid field number. Please try again."
          fi
          read -p "mydbms> Fields number: " col_no
       done
       fs=":"
       metadata=""
       type=""
       key=""
       null=""
       tableFile="./Tables/$tb.d"
       metaFile="./MetaData/$tb.m"
       touch $tableFile 2>>$errorFile                                #Creating file for the raw data
       touch $metaFile 2>>$errorFile                                 #Creating file for the metadata
       for col in $(seq $col_no)
       do
        if [ $col -eq 1 ]
        then
            echo "note: primary key is assigned INT data type value by default."          
            echo -e "mydbms> Field" $col "(primary key) name: \c"
            read col_name
            type="INT"
            key="PRI"
            null="NO"
        else
            echo -e "\nmydbms> Field" $col "name: \c"
            read col_name
            key=""
        fi
        name=$col_name  
        CHECK_NAME
        valid=$?
        until [ $valid -eq 0 ]                                       #Loop until the field name becomes valid
        do
           if [ $valid -eq 1 ]
           then
               echo "Error: Invalid field name, check your input and try again."
           elif [ $valid -eq 2 ]
           then
               echo "Error: No input given, check your input and try again."
           else        
               echo "Error: No blanks are allowed, check your input and try again."
           fi
           read -p "mydbms> Field name: " name
           CHECK_NAME
           valid=$?
        done
        col_name=$name
        if [ $col -eq 1 ]
        then
            metadata+=$col_name$fs$type$fs$key$fs$null
            echo -e $metadata >> $metaFile
            metadata=""
            head=$col_name$fs
        else
            until [ -z $(awk -F: -v col="$col_name" '{if($1==col) print$1}' $metaFile) ]    #Loop until the field name becomes valid
            do
              read -p "Error: Duplicate field name. Please try again: " col_name
              name=$col_name  
              CHECK_NAME
              valid=$?
              until [ $valid -eq 0 ]                                     #Loop until the field name becomes valid
              do
                if [ $valid -eq 1 ]
                then
                    echo "Error: Invalid field name, check your input and try again."
                elif [ $valid -eq 2 ]
                then
                    echo "Error: No input given, check your input and try again."
                else        
                    echo "Error: No blanks are allowed, check your input and try again."
                fi
                read -p "mydbms> Field name: " name
                CHECK_NAME
                valid=$?
              done
              col_name=$name  
            done
            echo "mydbms> Data type:"
            select choice in "Integer." "String."
            do
               case $REPLY in 
               1 )   type="INT" ; break ;;
               2 )   type="STR" ; break ;;
               * )   echo "Error: Invalid choice. Please insert a choice number." ;;
               esac
            done
            echo "mydbms> Do you want your field to have null values option?"
            select choice in "Yes." "No."
            do
               case $REPLY in 
               1 )   null="YES" ; break ;;
               2 )   null="NO"  ; break ;;
               * )   echo "Error: Invalid choice. Please insert a choice number." ;;
               esac
            done
            metadata+=$col_name$fs$type$fs$key$fs$null
            echo -e $metadata >> $metaFile
            metadata=""
            if [ $col -eq $col_no ]
            then
                head+=$col_name
            else
                head+=$col_name$fs
            fi
         fi
       done
       echo $head >> $tableFile
       echo -e "Do you want to create another table?[Y/n]: \c"
       if [ $(./$binPath/exit_loop.sh) -eq 0 ]                      
       then
           not_exit=1                                                        #Exit the loop
       fi     
   fi
done