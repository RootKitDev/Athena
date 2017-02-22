#!/bin/bash

######################################
# Envoi_Flux_CkSum.sh
# Utilité: Renvoi le cksum de la sauvegarde au serveur "Maitre"
# Auteur: RootKitDev <RootKit.Dev@gmail.com>
# Mise à jour le: 22/02/2017
######################################

Save_User=""
REMOTE_HOST="Master.host"

EXPORT_CKSUM_PATH="/path/to/athena/Core/CkSum_Export"

HOME_PATH="/path/to/athena"
CKSUM_PATH="$HOME_PATH/Scripts/CkSum"
LOG_PATH="$HOME_PATH/Scripts/Logs.d"
SAVE_PATH="$HOME_PATH/MasterHost/Data"
DUMPS_PATH="$HOME_PATH/MasterHost/Dumps"

REGEX_MONTH=$(date +%B)'\.'
REGEX_WE='_WeekEnd_'
REGEX_WEEK='_Week_'$(date -d 'now' +"%U")'\.'
REGEX_DAILY=$(date -d 'now' +"%Y_%m_%d")

File_CkSum=$(ls -lt $SAVE_PATH/ | rev | cut -d' ' -f1 | rev | sed '1d' | (head -n1 && tail -n1))
DataBase_CkSum=$(ls -lt $DUMPS_PATH/ | rev | cut -d' ' -f1 | rev | sed '1d' | (head -n1 && tail -n1))
Base=$(ls  -lt $DUMPS_PATH/ | head -n2 | tail -n1 | rev | cut -d' ' -f1 | rev | cut -d '_' -f1)

if [[ -e $HOME_PATH/Demande_CkSum ]]
then
        echo "" >> $LOG_PATH/Save.log
        echo "-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-" >> $LOG_PATH/Save.log
        echo `date` >> $LOG_PATH/Save.log
        echo "" >> $LOG_PATH/Save.log

	if [[ $File_CkSum =~ $REGEX_MONTH ]];
	then
		echo "$(cksum $SAVE_PATH/$File_CkSum | cut -d' ' -f1,2)" > "$CKSUM_PATH/Mensuel_"$(date -d 'now' +%Y_%m_%d)"_Remote.cksum"
		echo -n "Cksum : " >> $LOG_PATH/Save.log
		echo "$(cksum $SAVE_PATH/$File_CkSum | cut -d' ' -f1,2)" >> $LOG_PATH/Save.log

#                               Use on of SCP_CMD 
#               1) if user/pwd export if set in $FILE_PATH/User_Export.cnf or on variable in this sh
#               2) if ssh key without passphrase is enable
#################################################################################################
#   1)  SCP_CMD="sshpass -p $passwd scp $CKSUM_PATH/Mensuel_"$(date -d 'now' +%Y_%m_%d)"_Remote.cksum $Save_User@$REMOTE_HOST:$EXPORT_CKSUM_PATH"
#   2)  SCP_CMD="scp $CKSUM_PATH/Mensuel_"$(date -d 'now' +%Y_%m_%d)"_Remote.cksum $Save_User@$REMOTE_HOST:$EXPORT_CKSUM_PATH"
##################################################################################################

		
	elif [[ $File_CkSum =~ $REGEX_WE ]];
	then
		echo "$(cksum $SAVE_PATH/$File_CkSum | cut -d' ' -f1,2)" > "$CKSUM_PATH/Week-End_"$(date -d 'now' +%Y_%m_%d)"_Remote.cksum"
                echo -n "Cksum : " >> $LOG_PATH/Save.log
                echo "$(cksum $SAVE_PATH/$File_CkSum | cut -d' ' -f1,2)" >> $LOG_PATH/Save.log

#                               Use on of SCP_CMD 
#               1) if user/pwd export if set in $FILE_PATH/User_Export.cnf or on variable in this sh
#               2) if ssh key without passphrase is enable
#################################################################################################
#   1)  SCP_CMD="sshpass -p $passwd scp $CKSUM_PATH/Week-End_"$(date -d 'now' +%Y_%m_%d)"_Remote.cksum $Save_User@$REMOTE_HOST:$EXPORT_CKSUM_PATH"
#   2)  SCP_CMD="scp $CKSUM_PATH/Week-End_"$(date -d 'now' +%Y_%m_%d)"_Remote.cksum $Save_User@$REMOTE_HOST:$EXPORT_CKSUM_PATH"
##################################################################################################

	elif [[ $File_CkSum =~ $REGEX_WEEK ]];
	then
		echo "$(cksum $SAVE_PATH/$File_CkSum | cut -d' ' -f1,2)" > "$CKSUM_PATH/Hebdomadaire_"$(date -d 'now' +%Y_%m_%d)"_Remote.cksum"
                echo -n "Cksum : " >> $LOG_PATH/Save.log
                echo "$(cksum $SAVE_PATH/$File_CkSum | cut -d' ' -f1,2)" >> $LOG_PATH/Save.log

#                               Use on of SCP_CMD 
#               1) if user/pwd export if set in $FILE_PATH/User_Export.cnf or on variable in this sh
#               2) if ssh key without passphrase is enable
#################################################################################################
#   1)  SCP_CMD="sshpass -p $passwd scp $CKSUM_PATH/Hebdomadaire_"$(date -d 'now' +%Y_%m_%d)"_Remote.cksum $Save_User@$REMOTE_HOST:$EXPORT_CKSUM_PATH"
#   2)  SCP_CMD="scp $CKSUM_PATH/Hebdomadaire_"$(date -d 'now' +%Y_%m_%d)"_Remote.cksum $Save_User@$REMOTE_HOST:$EXPORT_CKSUM_PATH"
##################################################################################################

	elif [[ $File_CkSum =~ $REGEX_DAILY ]];
	then
		echo "$(cksum $SAVE_PATH/$File_CkSum | cut -d' ' -f1,2)" > "$CKSUM_PATH/Journaliere_"$(date -d 'now' +%Y_%m_%d)"_Remote.cksum"
                echo -n "Cksum : " >> $LOG_PATH/Save.log
                echo "$(cksum $SAVE_PATH/$File_CkSum | cut -d' ' -f1,2)" >> $LOG_PATH/Save.log

#                               Use on of SCP_CMD 
#               1) if user/pwd export if set in $FILE_PATH/User_Export.cnf or on variable in this sh
#               2) if ssh key without passphrase is enable
#################################################################################################
#   1)  SCP_CMD="sshpass -p $passwd scp $CKSUM_PATH/Journaliere_"$(date -d 'now' +%Y_%m_%d)"_Remote.cksum $Save_User@$REMOTE_HOST:$EXPORT_CKSUM_PATH"
#   2)  SCP_CMD="scp $CKSUM_PATH/Journaliere_"$(date -d 'now' +%Y_%m_%d)"_Remote.cksum $Save_User@$REMOTE_HOST:$EXPORT_CKSUM_PATH"
##################################################################################################

	fi

	echo -n "envoi du cksum de " >> $LOG_PATH/Save.log
	echo $File_CkSum >> $LOG_PATH/Save.log
	eval $(echo $SCP_CMD)
	echo "Suppresion du fichier de Demande" >> $LOG_PATH/Save.log
	rm $HOME_PATH/Demande_CkSum

elif [[ -e $HOME_PATH/Demande_CkSum_SQL ]]
then
	echo "" >> $LOG_PATH/Save_SQL.log
        echo "-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-" >> $LOG_PATH/Save_SQL.log
        echo `date` >> $LOG_PATH/Save_SQL.log
        echo "CkSum SQL" >> $LOG_PATH/Save_SQL.log
	echo "" >> $LOG_PATH/Save_SQL.log

	echo "$(cksum $DUMPS_PATH/$DataBase_CkSum | cut -d' ' -f1,2)" > $CKSUM_PATH/$Base"_"$(date -d 'now' +%Y_%m_%d)"_Remote.cksum"
        echo -n "Cksum : " >> $LOG_PATH/Save_SQL.log
        echo "$(cksum $DUMPS_PATH/$DataBase_CkSum | cut -d' ' -f1,2)" >> $LOG_PATH/Save_SQL.log

#                               Use on of SCP_CMD 
#               1) if user/pwd export if set in $FILE_PATH/User_Export.cnf or on variable in this sh
#               2) if ssh key without passphrase is enable
#################################################################################################
#   1)  SCP_CMD="sshpass -p $passwd scp "$CKSUM_PATH"/"$Base"_"$(date -d 'now' +%Y_%m_%d)"_Remote.cksum $Save_User@$REMOTE_HOST:$EXPORT_CKSUM_PATH"
#   2)  SCP_CMD="scp "$CKSUM_PATH"/"$Base"_"$(date -d 'now' +%Y_%m_%d)"_Remote.cksum $Save_User@$REMOTE_HOST:$EXPORT_CKSUM_PATH"
##################################################################################################

        echo -n "envoi du cksum de " >> $LOG_PATH/Save_SQL.log
        echo $DataBase_CkSum >> $LOG_PATH/Save_SQL.log
        eval $(echo $SCP_CMD)
        echo "Suppresion du fichier de Demande" >> $LOG_PATH/Save_SQL.log

        rm $HOME_PATH/Demande_CkSum_SQL
	rm $CKSUM_PATH"/"$Base"_"$(date -d 'now' +%Y_%m_%d)"_Remote.cksum"
fi

