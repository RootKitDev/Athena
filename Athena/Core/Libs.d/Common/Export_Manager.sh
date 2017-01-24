#!/bin/bash

######################################
# Export_Manager.sh
# Utilité: Librairie de gestion du transfet de la Tarball vers des hotes pré-définis
# Auteur: RootKitDev <RootKit.Dev@gmail.com>
# Mise à jour le: 23/01/2017
######################################

Export_save(){

    Month=$(date +"%m")
    Day=$(date +"%d")
    
    while read line  
    do
        if [[ $line =~ "user" ]];
        then
            user=$(echo $line | cut -d'=' -f2)
        fi

        if [[ $line =~ "password" ]];
        then
            passwd=$(echo $line | cut -d'=' -f2)
        fi
    done < $FILE_PATH/User_Export.cnf

    REMOTE_HOST_TAB=( "backup.rootkit-lab.org" "home.data-infinity.fr" )
    
    Count_Host=$(mysql --defaults-extra-file=$FILE_PATH/User_SQL.cnf -D Athena -e "SELECT count(*) As '' FROM Partners")

    if [[ $Count_Host -ne ${#REMOTE_HOST_TAB[@]} ]]; then
        echo "une erreur non bloquante est survenu : " >> $LOG_PATH/Save$SUB_LOG.log
        echo "Le nombre Hôtes entre la base de données et le script est différent" >> $LOG_PATH/Save$SUB_LOG.log
        echo "BDD : "$Count_Host >> $LOG_PATH/Save$SUB_LOG.log
        echo "Script : "${#REMOTE_HOST_TAB[@]} >> $LOG_PATH/Save$SUB_LOG.log
    fi

    for (( i = 0; i < ${#REMOTE_HOST_TAB[@]}; i++ )); do
        REMOTE_HOST=${REMOTE_HOST_TAB[$i]}

        SCP_CMD="sshpass -p $passwd scp $EXPORT_PATH/$1 $user@$REMOTE_HOST:$REMOTE_EXPORT_PATH"

        VarChkSum=$(Check_Partners)

        if [[ $VarChkSum = 0 ]]; then
            echo ""  >> $LOG_PATH/Save$SUB_LOG.log
            echo "Transfert de la sauvegarde en cours vers \"$REMOTE_HOST\""  >> $LOG_PATH/Save$SUB_LOG.log
            Time=$({ time $($SCP_CMD); } 2>&1 | grep real | cut -d 'l' -f2 | cut -c2-)
            Time=$(Time_2_Transfer $Time)
            echo "Le transfert a duré $Time" >> $LOG_PATH/Save$SUB_LOG.log
            echo "Transfert terminé" >> $LOG_PATH/Save$SUB_LOG.log

            if [[ ! -f $EXPORT_CKSUM_PATH/"Demande_CkSum" ]]; then
                echo "" >> $LOG_PATH/Save$SUB_LOG.log
                echo "Création d'une demande de CkSum" >> $LOG_PATH/Save$SUB_LOG.log
                touch $EXPORT_CKSUM_PATH/"Demande_CkSum$SUB_LOG"
                echo "Demande de CkSum$SUB_LOG créée" >> $LOG_PATH/Save$SUB_LOG.log
            fi

            echo "" >> $LOG_PATH/Save$SUB_LOG.log
            echo "Envoie d'une demande de CkSum de la part de \"$REMOTE_HOST\"" >> $LOG_PATH/Save$SUB_LOG.log
            sshpass -p $passwd scp $EXPORT_CKSUM_PATH/"Demande_CkSum$SUB_LOG" $user@$REMOTE_HOST:"/home/athena"
            echo "Demande envoyée" >> $LOG_PATH/Save$SUB_LOG.log
            rm $EXPORT_CKSUM_PATH/"Demande_CkSum$SUB_LOG"

            echo "" >> $LOG_PATH/Save$SUB_LOG.log
            echo "En attente du Cksum de l'hôte \"$REMOTE_HOST\"" >> $LOG_PATH/Save$SUB_LOG.log 
            echo $(date) >> $LOG_PATH/Save$SUB_LOG.log
            echo "Reprise du script dans 3 min" >> $LOG_PATH/Save$SUB_LOG.log
            sleep 3m
            echo "" >> $LOG_PATH/Save$SUB_LOG.log
            echo $(date) >> $LOG_PATH/Save$SUB_LOG.log
            echo "Reprise du script" >> $LOG_PATH/Save$SUB_LOG.log

            echo "" >> $LOG_PATH/Save$SUB_LOG.log
            echo "Controle des CheckSums :" >> $LOG_PATH/Save$SUB_LOG.log
            
            Old=$(mysql --defaults-extra-file=$FILE_PATH/User_SQL.cnf -D Athena -e "SELECT DisplayState As '' FROM State INNER JOIN Save ON State.id = Save.state WHERE month='$Month' and day='$Day'")
            Old=${Old:1:${#Old}}

            if [[ "$(Ctrl_ChkSum "$2")" == 1 ]] && [[ $(($i + 1)) == ${#REMOTE_HOST_TAB[@]} ]] && ( [[ "$Old" == "OK" ]] || [[ "$Old" == "OK_SQL" ]]); then
                echo "" >> $LOG_PATH/Save$SUB_LOG.log
                echo "La sauvegarde a été exportées sur au moins un hôte distant" >> $LOG_PATH/Save$SUB_LOG.log
                if [[ -z $SUB_LOG ]]; then
                    State_Save "1"
                else
                    State_Save "6"
                fi
            fi

            if [[ $(($i + 1)) == ${#REMOTE_HOST_TAB[@]} ]]; then
                echo "" >> $LOG_PATH/Save$SUB_LOG.log
                echo "Suppression du fichier de sauvegarde local ($1)" >> $LOG_PATH/Save$SUB_LOG.log
                $(rm $EXPORT_PATH/*)
                echo "Fichier local ($1) supprimé" >> $LOG_PATH/Save$SUB_LOG.log
                echo "" >> $LOG_PATH/Save$SUB_LOG.log
                echo "Suppression des fichiers .cksum" >> $LOG_PATH/Save$SUB_LOG.log
                $(rm $EXPORT_CKSUM_PATH/*)
                echo "Fichiers .cksum supprimés" >> $LOG_PATH/Save$SUB_LOG.log
            else
                echo "" >> $LOG_PATH/Save$SUB_LOG.log
                echo "Suppression du fichiers .cksum de l'hote distant" >> $LOG_PATH/Save$SUB_LOG.log
                $(rm $EXPORT_CKSUM_PATH"/"*"_Remote.cksum")
                echo "Fichier .cksum supprimés" >> $LOG_PATH/Save$SUB_LOG.log
            fi
            
        fi
    done
}