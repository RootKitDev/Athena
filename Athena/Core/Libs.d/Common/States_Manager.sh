#!/bin/bash

######################################
# Save_Manager.sh
# Utilité: Librairie de gestion des états
# Auteur: RootKitDev <RootKit.Dev@gmail.com>
# Mise à jour le: 23/03/2017
######################################

State_Save(){

	# Determining of useful variables
	Month=$(date +"%m")
	Day=$(date +"%d")

	# Read SQL
	Old=$(mysql --defaults-extra-file=$FILE_PATH/User_SQL.cnf -D Athena -e "SELECT DisplayState As '' FROM State INNER JOIN Save ON State.id = Save.state WHERE month='$Month' and day='$Day'")
	Old=${Old:1:${#Old}}

	if [[ -z $SUB_LOG ]]; then

		if [ $1 -eq 10 ] || [ $1 -eq 5 ] || [ $1 -eq 11 ]; then
			mysql --defaults-extra-file=$FILE_PATH/User_SQL.cnf -D Athena -e "UPDATE Save SET state=$1 WHERE month='$Month' and day='$Day'"
		elif [ $1 -lt 5 ]; then
			if [ $Old != "OK" ]; then
				# Write SQL
				mysql --defaults-extra-file=$FILE_PATH/User_SQL.cnf -D Athena -e "UPDATE Save SET state=$1 WHERE month='$Month' and day='$Day'"
			fi
		else
			echo "Argument \"$1\" non supporté" >> $LOG_PATH/Save$SUB_LOG.log
		fi
	else

		if [ $1 -eq 10 ] || [ $1 -eq 5 ] || [ $1 -eq 11 ]; then
			mysql --defaults-extra-file=$FILE_PATH/User_SQL.cnf -D Athena -e "UPDATE Save SET state=$1 WHERE month='$Month' and day='$Day'"
		elif [ $1 -gt 5 ]; then
			if [ $Old != "SQL_OK" ]; then
				# Write SQL
				mysql --defaults-extra-file=$FILE_PATH/User_SQL.cnf -D Athena -e "UPDATE Save SET state=$1 WHERE month='$Month' and day='$Day'"
			fi
		else
			echo "Argument \"$1\" non supporté" >> $LOG_PATH/Save$SUB_LOG.log
		fi

	fi
}