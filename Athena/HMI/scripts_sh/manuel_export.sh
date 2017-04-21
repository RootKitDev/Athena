#! /bin/bash

######################################
# Manuel_Export.sh
# Utilité: 
# Auteur: RootKitDev <RootKit.Dev@gmail.com>
# Mise à jour le: 
######################################

# Define PATH

SUB_LOG=""

HOME_PATH="/home/athena/Core"
LIB_PATH="$HOME_PATH/Libs.d"
COMMON_LIB="$LIB_PATH/Common"
DATA_LIB="$LIB_PATH/Data"
SQL_LIB="$LIB_PATH/SQL"
LOG_PATH="$HOME_PATH/Logs.d"

# Load all the others .sh lib
source $COMMON_LIB/Directory_Manager.sh
source $COMMON_LIB/Save_Manager.sh
source $COMMON_LIB/Export_Manager.sh
source $COMMON_LIB/Partners_Manager.sh
source $COMMON_LIB/CheckSum_Manager.sh
source $COMMON_LIB/States_Manager.sh
source $COMMON_LIB/Variable_Manager.sh

State_Save "10"

# Writing in the early log
echo "" >> $LOG_PATH/Save.log
echo "-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-" >> $LOG_PATH/Save.log
echo `date` >> $LOG_PATH/Save.log
echo "" >> $LOG_PATH/Save.log

echo "Relance Manuel de l'export" >> $LOG_PATH/Save.log

REGEX_MONTH=$(date +%B)'\.'
REGEX_WE='_WeekEnd_'
REGEX_WEEK='Full_Backup_'$(date +%B)'_Week_'
REGEX_DAILY=$(date -d 'now' +"%Y_%m_")

if [[ $1 =~ $REGEX_MONTH ]];
then
	type="Mensuel"
elif [[ $1 =~ $REGEX_WE ]];
then
	type="Week-End"
elif [[ $1 =~ $REGEX_WEEK ]];
then
	type="Hebdomadaire"
elif [[ $1 =~ $REGEX_DAILY ]];
then
	type="Journaliere"
fi

Export_save $1 $type
