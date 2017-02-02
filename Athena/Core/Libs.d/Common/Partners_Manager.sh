#!/bin/bash

######################################
# Partners_Manager.sh
# Utilité: Librairie de vérification de la disponibilité des Partenaires
# Auteur: RootKitDev <RootKit.Dev@gmail.com>
# Mise à jour le: 02/02/2017
######################################

Check_Partners(){

    IP=$(mysql --defaults-extra-file=$FILE_PATH/User_SQL.cnf -D Athena -e "SELECT ip As '' FROM Partners WHERE host='$REMOTE_HOST'")
    if [[ -z  "$IP" ]]; then
        IP=$(nslookup $REMOTE_HOST| grep Address | tail -1 | cut -d' ' -f2)
    fi
    Res=$(traceroute $REMOTE_HOST | grep $IP | sed '1d')

    if [[ -z "$Res" ]]; then
        Res=$(traceroute $REMOTE_HOST -I | grep $IP | sed '1d')
    fi

    echo "" >> $LOG_PATH/Save$SUB_LOG.log

    if [[ -z "$Res" ]]; then
        echo "L'hôte $REMOTE_HOST est injoignable" >> $LOG_PATH/Save$SUB_LOG.log
        echo "Transfert annulé" >> $LOG_PATH/Save$SUB_LOG.log
        State_Save 2
        echo 1
    else
        echo "L'hôte $REMOTE_HOST est joignable" >> $LOG_PATH/Save$SUB_LOG.log
        echo "Lancement du transfert vers $REMOTE_HOST" >> $LOG_PATH/Save$SUB_LOG.log
        echo 0
    fi
}