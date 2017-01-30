#!/bin/bash

######################################
# Sql_Manager.sh
# Utilité: Librairie lié aux sauvegardes de type SQL
# Auteur: RootKitDev <RootKit.Dev@gmail.com>
# Mise à jour le: 30/01/2017
######################################


SQL_save(){
    
    SUB_LOG="_SQL"
    
    source $COMMON_LIB/Save_Manager.sh    
    source $COMMON_LIB/Export_Manager.sh
    source $COMMON_LIB/Partners_Manager.sh
    source $COMMON_LIB/CheckSum_Manager.sh
    source $COMMON_LIB/States_Manager.sh
    source $COMMON_LIB/Variable_Manager.sh
    
    # Writing in the early log
    
    echo "" >> $LOG_PATH/Save.log
    echo "-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-" >> $LOG_PATH/Save.log
    echo `date` >> $LOG_PATH/Save.log
    echo "Sauvegarde SQL" >> $LOG_PATH/Save.log
    echo "" >> $LOG_PATH/Save.log
    echo "Cf Save_SQL.log" >> $LOG_PATH/Save.log
    
    echo "" >> $LOG_PATH/Save_SQL.log
    echo "-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-" >> $LOG_PATH/Save_SQL.log
    echo `date` >> $LOG_PATH/Save_SQL.log
        
    if [[ -f $FLAG_PATH/PS-000 ]];
    then
    	echo ""  >> $LOG_PATH/Save.log
    	echo "Fanion \"PS-000\" a été posé," >> $LOG_PATH/Save_SQL.log
    	echo "La sauvegarde a été déplanifiée" >> $LOG_PATH/Save_SQL.log
    	State_Save "11"
    else
        
        Day=$(date +"%d")
        Month=$(date +"%m")
    
        DateSave=$(date +%Y_%m_%d_%HH%M)
    
        mysql --defaults-extra-file=$FILE_PATH/User_SQL.cnf -D Athena -e "UPDATE Save SET type=3 WHERE month=$Month and day=$Day"
        State_Save "10"
    
        databases=$(echo 'show databases' | mysql --defaults-extra-file=$FILE_PATH/Dumps_User_SQL.cnf | grep -v -E '(information_schema|performance_schema|Database)')
    
        for database in ${databases[@]}
        do
            echo "dump : $database" >> $LOG_PATH/Save_SQL.log
            echo "Dump en cours" >> $LOG_PATH/Save_SQL.log
    
            SQL_DUMP_CMD="mysqldump --defaults-extra-file=$FILE_PATH/User_SQL.cnf '$database' > $EXPORT_PATH/${database}_dump.sql"
            TAR_CMD="tar -czf $EXPORT_PATH/${database}_export_$DateSave.tar.gz -C $EXPORT_PATH/ ."
    
            Time=$({ time $(eval $(echo $SQL_DUMP_CMD));
            $($TAR_CMD);
            $(rm "$EXPORT_PATH/"$database"_dump.sql");} 2>&1 | grep real | cut -d 'l' -f2 | cut -c2-)
    
            Time=$(Time_2_Save $Time)
            echo "Le Dump de la base $database a dure $Time" >> $LOG_PATH/Save_SQL.log
    
            File_Name="$(ls $EXPORT_PATH | grep $database)"
    
            if [[ -f $EXPORT_PATH/$File_Name ]];
            then
                echo "Dump fini avec succes" >> $LOG_PATH/Save_SQL.log
                echo -n "Le fichier $File_Name disponible, a cet emplacement "$EXPORT_PATH >> $LOG_PATH/Save_SQL.log
    
                echo "" >> $LOG_PATH/Save_SQL.log
                echo -n "Le CheckSum de \"$database\" a sa création est : " >> $LOG_PATH/Save_SQL.log
                echo "$(cksum $EXPORT_PATH/$File_Name | cut -d' ' -f1,2)" >> $LOG_PATH/Save_SQL.log
                echo "$(cksum $EXPORT_PATH/$File_Name | cut -d' ' -f1,2)" > $EXPORT_CKSUM_PATH"/"$database"_"$(date +%Y_%m_%d)"_Local".cksum
                Export_save $File_Name $database
    
            else
                echo "Des erreurs ont été detectees :" >> $LOG_PATH/Save_SQL.log
                echo "Le fichier $File_Name introuvable !" >> $LOG_PATH/Save_SQL.log
                echo "" >> $LOG_PATH/Save_SQL.log
                State_Save "7"
            fi
        done
    fi
}