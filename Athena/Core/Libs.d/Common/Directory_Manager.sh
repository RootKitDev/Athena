#!/bin/bash

######################################
# Directory_Manager.sh
# Utilité: Librairie de vérification l'éligibilité de l'argument (seul les dossiers sont autorisés)
# Auteur: RootKitDev <RootKit.Dev@gmail.com>
# Mise à jour le: 23/01/2017
######################################

Error(){
        case "$1" in
                0)  echo "'$element' -> Ok pour Sauvegarde" >> $LOG_PATH/Save.log;;
                1)  echo "Code d'erreur 1 :"  >> $LOG_PATH/Save.log
                        echo -e "\t '$element' n'existe pas" >> $LOG_PATH/Save.log
                        State_Save 2
                        exit 1;;
                2)  echo "Code d'erreur 2 :"  >> $LOG_PATH/Save.log
                        echo -e "\t '$element' n'est pas un dossier" >> $LOG_PATH/Save.log
                        State_Save 2
                        exit 2;;
        esac
}

Get_Directory(){
        element=$1
        if [ ! -e $1 ];
        then
                Error 1
        elif [ -f $1 ];
        then
                Error 2
        else
                Error 0
        fi
}