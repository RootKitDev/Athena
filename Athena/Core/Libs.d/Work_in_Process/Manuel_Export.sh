#! /bin/bash

######################################
# Manuel_Export.sh
# Utilité: 
# Auteur: RootKitDev <RootKit.Dev@gmail.com>
# Mise à jour le: 
######################################

# Define PATH

SUB_LOG=""

HOME_PATH="/home/rootkit/Dev_Zone/Athena_Project/V0.1.0_Athena"
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

Export_save "$1" "$2"