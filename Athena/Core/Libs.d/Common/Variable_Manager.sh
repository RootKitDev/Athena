#!/bin/bash

######################################
# Variable_Manager.sh
# Utilité: Librairie de gestion des variables "d'environnements" d'Athena 
# Auteur: RootKitDev <RootKit.Dev@gmail.com>
# Mise à jour le: 23/01/2017
######################################

FLAG_PATH="$HOME_PATH/Flags"
LISTED_INCREMENTAL_PATH="$HOME_PATH/Lists.d"
EXPORT_CKSUM_PATH="$HOME_PATH/CkSum_Export"
SAVE_LIST_PATH="$HOME_PATH/ListSave.d"
EXCLUDE_LIST_PATH="$HOME_PATH/ExcludeSave.d"
FILE_PATH="$HOME_PATH/Files.d"

if [[ -z $SUB_LOG ]]; then
    EXPORT_PATH="$HOME_PATH/Data_Export"
    REMOTE_EXPORT_PATH="/home/user/remote/folder/Data"
else
    EXPORT_PATH="$HOME_PATH/Dumps_Export"
    REMOTE_EXPORT_PATH="/home/user/remote/folder/Dumps"
fi