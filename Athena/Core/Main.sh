#! /bin/bash

######################################
# Main.sh
# Utilité: Script principal d'Athena 
# Auteur: RootKitDev <RootKit.Dev@gmail.com>
# Mise à jour le: 23/01/2017
######################################

# Define PATH
HOME_PATH="/home/athena/Core"
LIB_PATH="$HOME_PATH/Libs.d"
COMMON_LIB="$LIB_PATH/Common"
DATA_LIB="$LIB_PATH/Data"
SQL_LIB="$LIB_PATH/SQL"
LOG_PATH="$HOME_PATH/Logs.d"

if [ $# -eq 0 ]
then
    usage
fi

while getopts ":t:vo:h" option
do
    case $option in
        v)
            exec 5> $LOG_PATH/Debug.log 2>&1
            BASH_XTRACEFD="5"
            set -x
            ;;
        t)
            if [ "$OPTARG" == "Data" ]
            then
                source $DATA_LIB/Data_Manager.sh
                Data_save
                Type=$OPTARG
            elif [ "$OPTARG" == "SQL" ]
            then
                source $SQL_LIB/Sql_Manager.sh
                SQL_save
                Type=$OPTARG
            else
                echo "L'argumet \"$OPTARG\" est incorrect"
                exit 1
            fi
            ;;
        o)
            echo "Liste des arguments à traiter : $OPTARG"
            ;;
        h)
            usage
            ;;
        :)
            echo "L'option \"-$OPTARG\" requiert un argument"
            exit 1
            ;;
        \?)
            echo "$OPTARG : option invalide"
            exit 1
            ;;
    esac
done

echo "" >> $LOG_PATH/Save.log
echo "Envoi des Logs du jour par mail" >> $LOG_PATH/Save.log

php $COMMON_LIB/Mail.php

echo "" >> $LOG_PATH/Save.log
echo "Fin du script $0 ($Type)" >> $LOG_PATH/Save.log
echo `date` >> $LOG_PATH/Save.log

exit 0