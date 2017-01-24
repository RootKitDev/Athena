#! /bin/bash


source ./Libs.d/Outsourcing.sh
source ./Libs.d/Data.sh
source ./Libs.d/SQL.sh

while read line  
do  
    if [[ $line =~ "[Outsourcing]" ]];
    then
        while !([[ $line =~ "[/Outsourcing]" ]]) && read line  
        do
            Check_Outsource
        done

    fi
done < ./Files.d/Config.conf    

Conf_Outsource


while read line  
do  
    if [[ $line =~ "[SQL]" ]];
    then
        while !([[ $line =~ "[/SQL]" ]]) && read line  
        do
            Check_SQL
        done
    fi
    
done < ./Files.d/Config.conf

Conf_SQL


while read line  
do  
    if [[ $line =~ "[Data]" ]];
    then
        while !([[ $line =~ "[/Data]" ]]) && read line  
        do
            Check_Data
        done
    fi
done < ./Files.d/Config.conf

Conf_Data
