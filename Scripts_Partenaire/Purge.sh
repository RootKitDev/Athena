#!/bin/bash

HOME_PATH="/path/to/athena"
LOG_PATH="$HOME_PATH/Scripts/Logs.d"

PURGE_PATH="$HOME_PATH/MasterHost/*"
PURGE_PATH_CKSUM="$HOME_PATH/Scripts/Cksum/"

REGEX_WE=*'_WeekEnd_'*
REGEX_WEEK='Full_Backup_'*'_Week_'[0-9][0-9]'.tar.gz'
REGEX_DAILY="Incremental_Backup_"*"_Week_"[0-9][0-9]"_"[0-9][0-9][0-9][0-9]"_"[0-9][0-9]"_"[0-9][0-9]"_"[0-9][0-9]"H"[0-9][0-9]".tar.gz"

echo "=========================================" >> $LOG_PATH/Purge.log
echo $(date) >> $LOG_PATH/Purge.log
echo "-----------------------------------------" >> $LOG_PATH/Purge.log
echo "Purge des sauvegardes Journaliere de plus de 14 jours" >> $LOG_PATH/Purge.log
echo "" >> $LOG_PATH/Purge.log
if [[ $(find $PURGE_PATH -name $REGEX_DAILY -ctime +14 -print | cut -d'/' -f6) == "" ]];
then
    echo "Aucune Sauvegardes supprimées"  >> $LOG_PATH/Purge.log
else
    find $PURGE_PATH -name $REGEX_DAILY -ctime +14 -print | cut -d'/' -f6 >> $LOG_PATH/Purge.log
    find $PURGE_PATH -name $REGEX_DAILY -ctime +14 -delete
    find $PURGE_PATH_CKSUM -ctime +14 -delete
    echo "Sauvegardes supprimées"  >> $LOG_PATH/Purge.log
fi
echo "" >> $LOG_PATH/Purge.log



echo "-----------------------------------------" >> $LOG_PATH/Purge.log
echo "Purge des sauvegardes Week-End de plus de 21 jours" >> $LOG_PATH/Purge.log
echo "" >> $LOG_PATH/Purge.log
if [[ $(find $PURGE_PATH -name $REGEX_WE -ctime +21 -print | cut -d'/' -f6) == "" ]];
then
    echo "Aucune Sauvegardes supprimées"  >> $LOG_PATH/Purge.log
else
    find $PURGE_PATH -name $REGEX_WE -ctime +21 -print | cut -d'/' -f6 >> $LOG_PATH/Purge.log
    find $PURGE_PATH -name $REGEX_WE -ctime +21 -delete
    find $PURGE_PATH_CKSUM -ctime +21 -delete
    echo "Sauvegardes supprimées"  >> $LOG_PATH/Purge.log
fi
echo "" >> $LOG_PATH/Purge.log



echo "-----------------------------------------" >> $LOG_PATH/Purge.log
echo "Purge des sauvegardes Hebdomadaire de plus de 21 jours" >> $LOG_PATH/Purge.log
echo "" >> $LOG_PATH/Purge.log
if [[ $(find $PURGE_PATH -name $REGEX_WEEK -ctime +21 -print | cut -d'/' -f6) == "" ]];
then
    echo "Aucune Sauvegardes supprimées"  >> $LOG_PATH/Purge.log
else
    find $PURGE_PATH -name $REGEX_WEEK -ctime +21 -print | cut -d'/' -f6 >> $LOG_PATH/Purge.log
    find $PURGE_PATH -name $REGEX_WEEK -ctime +21 -delete
    find $PURGE_PATH_CKSUM -ctime +21 -delete
    echo "Sauvegardes supprimées"  >> $LOG_PATH/Purge.log
fi
echo "" >> $LOG_PATH/Purge.log



echo "-----------------------------------------" >> $LOG_PATH/Purge.log
echo "Purge des sauvegardes de plus de 33 jours (tous type)" >> $LOG_PATH/Purge.log
echo "" >> $LOG_PATH/Purge.log
if [[ $(find $PURGE_PATH  -ctime +33 -print | cut -d'/' -f6 ) == "" ]];
then
    echo "Aucune Sauvegardes supprimées"  >> $LOG_PATH/Purge.log
else
    find $PURGE_PATH -ctime +33 -print | cut -d'/' -f6 >> $LOG_PATH/Purge.log
    find $PURGE_PATH -ctime +33 -delete
    find $PURGE_PATH_CKSUM -ctime +33 -delete
    echo "Sauvegardes supprimées"  >> $LOG_PATH/Purge.log
fi
echo "" >> $LOG_PATH/Purge.log
