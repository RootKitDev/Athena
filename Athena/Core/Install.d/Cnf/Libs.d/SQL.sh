#! /bin/bash

Check_SQL(){
    if [[ $line =~ "Activate" ]];
    then
        ActivSQL=$(echo $line | cut -d'=' -f2)
    fi
}

Conf_SQL(){
    if ! $ActivSQL ;
    then
        echo "Les sauvegardes SQL ne sont pas activées"
    elif $ActivSQL ;
    then
        echo "Les sauvegardes SQL sont activée"
    fi
}