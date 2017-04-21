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
source $DATA_LIB/Data_Manager.sh

State_Save "10"

# Writing in the early log
echo "" >> $LOG_PATH/Save.log
echo "-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-" >> $LOG_PATH/Save.log
echo `date` >> $LOG_PATH/Save.log
echo "" >> $LOG_PATH/Save.log

echo "Relance Manuel de la sauvegarde" >> $LOG_PATH/Save.log


case $2 in
	"01")
		month="Jan"
	;;
	"02")
		month="Feb"
	;;
	"03")
		month="Mar"
	;;
	"04")
		month="Apr"
	;;
	"05")
		month="May"
	;;
	"06")
		month="Jun"
	;;
	"07")
		month="Jul"
	;;
	"08")
		month="Aug"
	;;
	"09")
		month="Sep"
	;;
	"10")
		month="Oct"
	;;
	"11")
		month="Nov"
	;;
	"12")
		month="Dec"
	;;
esac

day=$1
res=${day:0:1}
 if [[ $res -eq 0 ]]; then
	day=${day:1:1}
fi

CMD="cat /home/athena/Core/Logs.d/Save.log | grep \"$month $day\" -A 3 | head -n3 | tail -n1  | cut -d' ' -f2"
type=$(eval $CMD)

if [[ -z $type ]]; then
	CMD="cat /home/athena/Core/Logs.d/Save.log | grep \"$day $month\" -A 3 | head -n3 | tail -n1  | cut -d' ' -f2"
	type=$(eval $CMD)
fi

if [[ $type == "Mensuel" ]] || [[ $type == "Week-End" ]]; then
	List=$SAVE_LIST_PATH/ListSaveMen
	Ex=$EXCLUDE_LIST_PATH/ListExcludeMen
elif [[ $type == "Hebdomadaire" ]] || [[ $type == "Journaliere" ]]; then
	List=$SAVE_LIST_PATH/ListSaveHeb
	Ex=$EXCLUDE_LIST_PATH/ListExcludeHeb
fi

sed 's/\s\+/\n/g' $List > $List"tmp" && mv $List"tmp" $List
sed 's/\s\+/\n/g' $Ex > $Ex"tmp" && mv $Ex"tmp" $Ex

echo "" >> $LOG_PATH/Save.log
echo 'Les Répertoires sauvegardés sont :' >> $LOG_PATH/Save.log
if [[ -z "$(cat $List)" ]]; then
	echo "Il n'y a pas de dossier(s) a sauvegardé(s)" >> $LOG_PATH/Save.log
else
	# Check if directory exist
	for elem in $(cat $List)
	do
		Get_Directory $elem
	done
	echo ""  >> $LOG_PATH/Save.log
	echo "Eligibilité des dossiers terminée avec succes !" >> $LOG_PATH/Save.log
fi

Create_Tarball "$type"