#!/bin/bash
#Functions to validate the data before insertion into tables
#check_data.sh is used as source file

function VALIDATE_FIELDS
{
   if [ $type = "INT" ] && [ $null = "YES" ]
   then
      if [ $(./$binPath/is_null.sh $data) -eq 0 ]                                         #check if the input is null
	then
    	data=NULL
	else
    	until [ $(./$binPath/is_int.sh $data) -eq 0 ]                                       #check if the input is integer
     	do
         echo -e "Error: Column" $field " must be integer. Please try again: \c"
         read data
         if [ $(./$binPath/is_null.sh $data) -eq 0 ]                                      
	      then
            data=NULL
            echo "Data saved as a NULL."
            break
         fi
     	done
	fi
   elif [ $type = "INT" ] && [ $null = "NO" ]
   then 
      until [ $(./$binPath/is_null.sh $data) -eq 1 ]
      do
         echo -e "Error: Column" $field " can not be NULL. Please try again: \c"
         read data
      done
      until [ $(./$binPath/is_int.sh $data) -eq 0 ]
      do
         echo -e "Error: Column" $field " must be integer. Please try again: \c"
         read data
         until [ $(./$binPath/is_null.sh $data) -eq 1 ]
  	      do
            echo -e "Error: Column" $field " can not be NULL. Please try again: \c"
            read data
         done
      done
   elif [ $type = "STR" ] && [ $null = "YES" ]
   then
      if [ $(./$binPath/is_null.sh $data) -eq 0 ]
      then
         data=NULL
         echo "Data saved as a NULL."
      else
         until [ $(./$binPath/is_str.sh $data) -eq 0 ]                                       #check if the input is string
         do
            echo -e "Error: Column" $field " must be string. Please try again: \c"
            read data
            if [ $(./$binPath/is_null.sh $data) -eq 0 ]
	         then
            	data=NULL
               echo "Data saved as a NULL."
               break
            fi
         done
      fi
   else
      until [ $(./$binPath/is_null.sh $data) -eq 1 ]
      do
         echo -e "Error: Column" $field " can not be NULL. Please try again: \c"
         read data
      done
      until [ $(./$binPath/is_str.sh $data) -eq 0 ]
      do
         echo -e "Error: Column" $field " must be string. Please try again: \c"
         read data
         until [ $(./$binPath/is_null.sh $data) -eq 1 ]
  	      do
            echo -e "Error: Column" $field " can not be NULL. Please try again: \c"
            read data
         done
      done
   fi
}

function VALIDATE_PK
{
   until [ $(./$binPath/is_null.sh $data) -eq 1 ]
   do
      echo -e "Error: Column" $field "(Primary Key) can not be NULL. Please try again: \c"
      read data
   done
   until [ $(./$binPath/is_int.sh $data) -eq 0 ]
   do
      echo -e "Error: Column" $field "(Primary Key) must be integer. Please try again: \c"
      read data
      until [ $(./$binPath/is_null.sh $data) -eq 1 ]
      do
         echo -e "Error: Column" $field "(Primary Key) can not be NULL. Please try again: \c"
         read data
      done
   done
   until [ -z $(awk -F: -v pk="$data" '{if($1==pk) print$1}' $tb".d") ]                         #Loop until the input becomes valid
   do
      echo -e "Error: Column" $field "(Primary Key) must be unique. Please try again: \c"
      read data
      until [ $(./$binPath/is_int.sh $data) -eq 0 ]
      do
         echo -e "Error: Column" $field "(Primary Key) must be integer. Please try again: \c"
         read data
         until [ $(./$binPath/is_null.sh $data) -eq 1 ]
         do
            echo -e "Error: Column" $field "(Primary Key) can not be NULL. Please try again: \c"
            read data
         done
      done 
   done
}
