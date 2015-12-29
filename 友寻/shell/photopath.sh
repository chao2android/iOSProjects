#!/bin/sh

path='/var/ProjectD/photo'
for((i = 0; i< 100; i++)) 
do
   len=`expr length $i`;
   if [ $len -eq 1 ] 
   then
       p="0"$i 
   else    
       p=$i;
   fi  
   for((j = 0; j< 100; j++))
   do  
    len1=`expr length $j`;
    if [ $len1 -eq 1 ] 
    then
         c=$p"/0"$j
    else
    
        c=$p"/"$j;
    fi  
        #echo $path'/'$c
        mkdir -p $path'/'$c;
   done
done