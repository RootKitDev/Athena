#! /bin/bash

######################################
# Send_Resto.sh
# Utilité: Renvoi les tarballs de la sauvegarde demandé au serveur "Maitre"
# Auteur: RootKitDev <RootKit.Dev@gmail.com>
# Mise à jour le: 22/02/2017
######################################

Save_User=""
REMOTE_HOST="Master.host"

HOME_PATH="/path/to/athena"
EXPORT_PATH="$HOME_PATH/IHM/Export"
RESTO_PATH="$HOME_PATH/MasterHost/Resto"
SAVE_PATH="$HOME_PATH/MasterHost/Data"

if [[ -e $RESTO_PATH/demande_Resto ]]; then
    Day=$(cat $RESTO_PATH/demande_Resto | cut -d'-' -f3)
    res=${Day:0:1}
    if [[ $res -eq 0 ]]; then
        Day=${Day:1:1}
    fi

    TargetMonth=$(cat $RESTO_PATH/demande_Resto | cut -d'-' -f2)
    Year=$(cat $RESTO_PATH/demande_Resto | cut -d'-' -f1)

    Now=$(date +%d)
    res=${Now:0:1}
    if [[ $res -eq 0 ]]; then
        Now=${Now:1:1}
    fi

    Target=$(($Now - $Day))
    res=${Target:0:1}
    if [[ $res -eq 0 ]]; then
        Target=${Target:1:1}
    fi

    DoW=$(date -d '-'$Target' days' +%u)

    DoM=$(date -d '-'$Target' days' +%d)
    res=${DoM:0:1}
    if [[ $res -eq 0 ]]; then
        DoM=${DoM:1:1}
    fi

    case $TargetMonth in
        "01")
            Month="January"
        ;;
        "02")
            Month="February"
        ;;
        "03")
            Month="March"
        ;;
        "04")
            Month="April"
        ;;
        "05")
            Month="May"
        ;;
        "06")
            Month="June"
        ;;
        "07")
            Month="July"
        ;;
        "08")
            Month="August"
        ;;
        "09")
            Month="September"
        ;;
        "10")
            Month="October"
        ;;
        "11")
            Month="November"
        ;;
        "12")
            Month="December"
        ;;
    esac

    if (([[ $DoM -ge 8 ]] && [[ $DoM -le 14 ]]) && [[ $DoW -eq 7 ]]); then
        Tar="Full_Backup_"$Month".tar.gz"
        CMD="ls -lt $SAVE_PATH | grep $Tar | rev | cut -d' ' -f1 | rev"
        Files=$(eval $CMD)
        if [[ -n $Files ]]; then
            echo $Files > $RESTO_PATH/Reponse_Resto_RootKit
        fi

    elif [[ $DoW -eq 1 ]]; then
        Tar="Full_Backup_"$Month"_Week_"$(date -d '-'$Target' days' +%U)".tar.gz"
        CMD="ls -lt $SAVE_PATH | grep $Tar | rev | cut -d' ' -f1 | rev"
        Files=$(eval $CMD)
        if [[ -n $Files ]]; then
            echo $Files > $RESTO_PATH/Reponse_Resto_RootKit
        fi
    else
        i=0
        Date=$(($Target + $i))

        DoWDate=0

        while [[ $DoWDate -ne 1 ]]
        do
            DoWDate=$(date -d '-'$Date' days' +%u)
            res=${DoWDate:0:1}

            if [[ $res -eq 0 ]]; then
                DoWDate=${DoWDate:1:1}
            fi

            if [[ $DoWDate -eq 1 ]]; then
                Tar="Full_Backup_"$Month"_Week_"$(date -d '-'$Date' days' +%U)".tar.gz"
                CMD="ls -lt $SAVE_PATH | grep $Tar | rev | cut -d' ' -f1 | rev"
                Files=$(eval $CMD)
            else
                Tar="Incremental_Backup_"$Month"_Week_"$(date -d '-'$Date' days' +%U)"_"$Year"_"$TargetMonth"_"$(date -d '-'$Date' days' +%d)"_06H00.tar.gz"
                CMD="ls -lt $SAVE_PATH | grep $Tar | rev | cut -d' ' -f1 | rev"
                Files=$(eval $CMD)
            fi

            if [[ -n $Files ]]; then
                echo $Files >> $RESTO_PATH/Reponse_Resto_RootKit
            fi

            if [[ $DoWDate -eq 1 ]]; then
                break
            fi
            i=$(($i + 1))
            Date=$(($Target + $i))
            res=${Date:0:1}

            if [[ $res -eq 0 ]]; then
                Date=${Date:1:1}
            fi

        done
    fi

#                               Use on of SCP_CMD 
#               1) if user/pwd export if set in $FILE_PATH/User_Export.cnf or on variable in this sh
#               2) if ssh key without passphrase is enable
#################################################################################################
#   1)  SCP_CMD="sshpass -p $passwd scp $RESTO_PATH/Reponse_Resto $Save_User@$REMOTE_HOST:$EXPORT_PATH"
#   2)  SCP_CMD="scp $RESTO_PATH/Reponse_Resto $Save_User@$REMOTE_HOST:$EXPORT_PATH"
##################################################################################################

    $($SCP_CMD)

#               1) if user/pwd export if set in $FILE_PATH/User_Export.cnf or on variable in this sh
#               2) if ssh key without passphrase is enable
#################################################################################################
#   1)  sshpass -p $passwd ssh $Save_User@$REMOTE_HOST "chmod 777 $EXPORT_PATH/Reponse_Resto"
#   2)  ssh $Save_User@$REMOTE_HOST "chmod 777 $EXPORT_PATH/Reponse_Resto"
##################################################################################################

    rm $RESTO_PATH/*

    while [ ! -f $RESTO_PATH/Reponse_Resto ]; do
            sleep 1s
    done

    if [[ -z $(cat $RESTO_PATH/Reponse_Resto) ]]; then
        exit 0
    else

        while read line  
        do
#                               Use on of SCP_CMD 
#               1) if user/pwd export if set in $FILE_PATH/User_Export.cnf or on variable in this sh
#               2) if ssh key without passphrase is enable
#################################################################################################
#   1)  SCP_CMD="sshpass -p $passwd scp $SAVE_PATH/$line $Save_User@$REMOTE_HOST:$EXPORT_PATH/Tarball"
#   2)  SCP_CMD="scp $SAVE_PATH/$line $Save_User@$REMOTE_HOST:$EXPORT_PATH/Tarball"
##################################################################################################
            $($SCP_CMD)
        done < $RESTO_PATH/Reponse_Resto
    fi

#               1) if user/pwd export if set in $FILE_PATH/User_Export.cnf or on variable in this sh
#               2) if ssh key without passphrase is enable
#################################################################################################
#   1)  sshpass -p $SSHPASS ssh $Save_User@$REMOTE_HOST "chmod 777 $EXPORT_PATH/Tarball/*"
#   2)  ssh $Save_User@$REMOTE_HOST "chmod 777 $EXPORT_PATH/Tarball/*"
##################################################################################################

    rm $RESTO_PATH/*

fi