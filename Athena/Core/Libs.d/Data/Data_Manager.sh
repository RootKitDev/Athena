#!/bin/bash

######################################
# Data_Manager.sh
# Utilité: Librairie lié aux sauvegardes de type données
# Auteur: RootKitDev <RootKit.Dev@gmail.com>
# Mise à jour le: 07/02/2017
######################################


Data_save(){

SUB_LOG=""

# Load all the others .sh lib
source $COMMON_LIB/Directory_Manager.sh
source $COMMON_LIB/Save_Manager.sh
source $COMMON_LIB/Export_Manager.sh
source $COMMON_LIB/Partners_Manager.sh
source $COMMON_LIB/CheckSum_Manager.sh
source $COMMON_LIB/States_Manager.sh
source $COMMON_LIB/Variable_Manager.sh

Old=$(mysql --defaults-extra-file=$FILE_PATH/User_SQL.cnf -D Athena -e "SELECT DisplayState As '' FROM State INNER JOIN Save ON State.id = Save.state WHERE month='$Month' and day='$Day'")
Old=${Old:1:${#Old}}
    
if [[ $Old  =~ "SQL" ]]; then
	exit 0
fi

State_Save "10"

# Writing in the early log
echo "" >> $LOG_PATH/Save.log
echo "-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-" >> $LOG_PATH/Save.log
echo `date` >> $LOG_PATH/Save.log
echo "" >> $LOG_PATH/Save.log

# Determining date
Day=$(date +"%d")
DoW=$(date +"%u")
Month=$(date +"%m")
Go_Save_WE="1507"

if [[ -f $FLAG_PATH/PS-000 ]];
then
	echo ""  >> $LOG_PATH/Save.log
	echo "Fanion \"PS-000\" a été posé," >> $LOG_PATH/Save.log
	echo "La sauvegarde a été déplanifiée" >> $LOG_PATH/Save.log
	State_Save "11"
else
	if ([[ $Day -ge 8 ]] && [[ $DoW -eq 7 ]]) || [[ -f $FLAG_PATH/EX-000 ]];
	then
	    if [ ! -f $FLAG_PATH/PS-001 ] ;
	    then
	    	# Writing Log File
	    	if [ -f $FLAG_PATH/EX-000 ];
	    	then
	    		echo 'Sauvegarde Exceptionnel (sauvegarde Full) :' >> $LOG_PATH/Save.log
	    		cmd="mv $FLAG_PATH/EX-000 $FLAG_PATH/Block/"
	    		Ex="Excep"
	    		eval $(echo $cmd)
	    	else
	    		echo 'Sauvegarde Mensuel (sauvegarde Full) :' >> $LOG_PATH/Save.log
	    	fi
	
	    	echo 'Les Répertoires sauvegardés sont :' >> $LOG_PATH/Save.log
	
	    	if [[ -z "$(cat $SAVE_LIST_PATH/ListSaveMen)" ]]; then
	    		echo -e "Il n'y a pas de dossier a sauvegarder" >> $LOG_PATH/Save.log
	    	else
	    		# Check if directory exist
	    		for elem in $(cat $SAVE_LIST_PATH/ListSaveMen)
	    		do
	    			Get_Directory $elem
	    		done
	
	    		echo ""  >> $LOG_PATH/Save.log
	    		echo "Eligibilité des dossiers terminée avec succes !" >> $LOG_PATH/Save.log
	
	    		# Launch monthly Data Save 
	    		mysql --defaults-extra-file=$FILE_PATH/User_SQL.cnf -D Athena -e "UPDATE Save SET type=1 WHERE month=$Month and day=$Day"
	    		Create_Tarball "Mensuel"
	    	fi
	    else
	    	echo 'Fanion "Pas de Sauvegarde Mensuel" détecté' >> $LOG_PATH/Save.log
	    	State_Save "5"
	    fi
	elif [[ "$DoW" = "1" ]];
	then 
		if [ ! -f $FLAG_PATH/PS-002 ];
		then
			# Writing Log File
			echo 'Sauvegarde Hebdomadaire (sauvegarde Full) :' >> $LOG_PATH/Save.log
			echo "" 
			echo 'Les Répertoires sauvegardés sont :' >> $LOG_PATH/Save.log
			if [[ -z "$(cat $SAVE_LIST_PATH/ListSaveHeb)" ]]; then
				echo "Il n'y a pas de dossier(s) a sauvegardé(s)" >> $LOG_PATH/Save.log
			else
				# Check if directory exist
				for elem in $(cat $SAVE_LIST_PATH/ListSaveHeb)
				do
	       			Get_Directory $elem
				done
				echo ""  >> $LOG_PATH/Save.log
				echo "Eligibilité des dossiers terminée avec succes !" >> $LOG_PATH/Save.log

				# Launch weekly Data Save 
				mysql --defaults-extra-file=$FILE_PATH/User_SQL.cnf -D Athena -e "UPDATE Save SET type=3 WHERE month=$Month and day=$Day"
				Create_Tarball "Hebdomadaire"
			fi
		else
			echo 'Fanion "Pas de Sauvegarde Hebdomadaire" détecté' >> $LOG_PATH/Save.log
			State_Save "5"
		fi
	elif [[ "$DoW" = "6" ]] && [[ "$(date +%H%M)" -gt $Go_Save_WE ]];
	then 
		if [ ! -f $FLAG_PATH/PS-003 ];
		then
			# Writing Log File
			echo 'Sauvegarde Hebdomadaire "Week-End" (sauvegarde Incrementiel => Mensuel) :' >> $LOG_PATH/Save.log
			echo 'Les Répertoires sauvegardés sont :' >> $LOG_PATH/Save.log

			if [[ -z "$(cat $SAVE_LIST_PATH/ListSaveMen)" ]]; then
				echo "Il n'y a pas de dossier(s) a sauvegardé(s)" >> $LOG_PATH/Save.log
			else
				# Check if directory exist
				for elem in $(cat $SAVE_LIST_PATH/ListSaveMen)
				do
	       			Get_Directory $elem
				done
	
				echo "" >> $LOG_PATH/Save.log
				echo "Eligibilité des dossiers terminée avec succes !"  >> $LOG_PATH/Save.log
	
				# Launch weekly-end Data Save 
				mysql --defaults-extra-file=$FILE_PATH/User_SQL.cnf -D Athena -e "UPDATE Save SET type=3 WHERE month=$Month and day=$Day"
				Create_Tarball "Week-End"
			fi
		else
			echo 'Fanion "Pas de Sauvegarde Hebdomadaire "Week-End"" détecté'  >> $LOG_PATH/Save.log
			State_Save "5"
		fi
	elif [ ! -f $FLAG_PATH/PS-004 ];
	then
		# Writing Log File
		echo 'Sauvegarde Journaliere (sauvegarde Incrementiel => Hebdomadaire) :' >> $LOG_PATH/Save.log
		echo 'Les Répertoires sauvegardés sont :' >> $LOG_PATH/Save.log

		if [[ -z "$(cat $SAVE_LIST_PATH/ListSaveHeb)" ]]; then
			echo "Il n'y a pas de dossier(s) a sauvegardé(s)" >> $LOG_PATH/Save.log
		else
			# Check if directory exist
			for elem in $(cat $SAVE_LIST_PATH/ListSaveHeb)
			do
				Get_Directory $elem
			done
			echo "" >> $LOG_PATH/Save.log
			echo "Eligibilité des dossiers terminée avec succes !" >> $LOG_PATH/Save.log
	
			# Launch daily Data Save 
			mysql --defaults-extra-file=$FILE_PATH/User_SQL.cnf -D Athena -e "UPDATE Save SET type=2 WHERE month=$Month and day=$Day"
			Create_Tarball "Journaliere"
		fi
	else
		echo 'Fanion "Pas de Sauvegarde Journaliere" détecté' >> $LOG_PATH/Save.log
		State_Save "5"
	fi
fi
}

Create_Tarball(){

	DateSave=$(date +%Y_%m_%d_%HH%M)

    case "$1" in
        "Journaliere")
       		EXPORT_NAME="Incremental_Backup_$(date +%B)_Week_$(date +%U)_$DateSave.tar.gz"
            Listed_Incremental="Backup_$(date +%B)_Week_$(date +%U).list"
            TARGET="Heb"
            ;;
        "Hebdomadaire")
       		EXPORT_NAME="Full_Backup_$(date +%B)_Week_$(date +%U).tar.gz"
            Listed_Incremental="Backup_$(date +%B)_Week_$(date +%U).list"
            TARGET="Heb"
            ;;
        "Week-End" )
       		EXPORT_NAME="Incremental_Backup_$(date +%B)_WeekEnd_$(date +%U).tar.gz"
            Listed_Incremental="Backup_$(date +%B).list"
            TARGET="Men"
            ;;
        "Mensuel")
        	if [[ -n $Ex ]]; then
        		EXPORT_NAME="Full_Backup_"$Ex"_$(date +%B).tar.gz"
        	else
        		EXPORT_NAME="Full_Backup_$(date +%B).tar.gz"
        	fi
            Listed_Incremental="Backup_$(date +%B).list"
            TARGET="Men"
            ;;
    esac

    EXCLUDE_LIST=$(cat $EXCLUDE_LIST_PATH/ListExclude$TARGET)
	EXCLUDE=$(echo $EXCLUDE_LIST | sed "i--exclude='" | tr -d '\n' | sed "s/\ \//' --exclude='\//g")

    if [[ $EXCLUDE == "--exclude='" ]]; then
        TAR_CMD="tar -czf $EXPORT_PATH/$EXPORT_NAME --listed-incremental=$LISTED_INCREMENTAL_PATH/$Listed_Incremental $(echo -e "$(cat $SAVE_LIST_PATH/ListSave$TARGET)\n")"
    else
        TAR_CMD="tar -czf $EXPORT_PATH/$EXPORT_NAME --listed-incremental=$LISTED_INCREMENTAL_PATH/$Listed_Incremental $EXCLUDE' $(echo -e "$(cat $SAVE_LIST_PATH/ListSave$TARGET)\n")"

        echo "Les répertoire suivants ont été exclus :" >> $LOG_PATH/Save.log
        echo -e "$(cat $EXCLUDE_LIST_PATH/ListExclude$TARGET)\n" >> $LOG_PATH/Save.log
    fi

    echo "Sauvegarde en cours" >> $LOG_PATH/Save.log
    Time=$({ time $(eval $(echo $TAR_CMD));  } 2>&1 | grep real | cut -d 'l' -f2 | cut -c2-)
    Time=$(Time_2_Save $Time)
    echo "La sauvegarde a duree $Time" >> $LOG_PATH/Save.log
    echo "Sauvegarde terminé" >> $LOG_PATH/Save.log

    Size "$EXPORT_PATH/$EXPORT_NAME"

    echo "" >> $LOG_PATH/Save.log
    echo -n "Le CheckSum de \"$EXPORT_NAME\" a sa création est : " >> $LOG_PATH/Save.log
    echo "$(cksum $EXPORT_PATH/$EXPORT_NAME | cut -d' ' -f1,2)" >> $LOG_PATH/Save.log
    echo "$(cksum $EXPORT_PATH/$EXPORT_NAME | cut -d' ' -f1,2)" > $EXPORT_CKSUM_PATH"/"$1"_"$(date +%Y_%m_%d)"_Local".cksum

    Export_save "$EXPORT_NAME" "$1"
}