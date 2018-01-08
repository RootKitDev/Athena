#!/usr/bin/python
# -*- coding: utf-8 -*-


######################################
# Variable_Manager.py
# Utilité: Librairie de gestion des variables "d'environnements" d'Athena 
# Auteur: RootKitDev <RootKit.Dev@gmail.com>
# Mise à jour le: 16/08/2017
######################################

global HOME_PATH
global CONF_PATH
global LIB_PATH
global COMMON_LIB
global DATA_LIB
global SQL_LIB
global LOG_PATH
global SPECIAL_LIB
global FLAG_PATH
global LISTED_INCREMENTAL_PATH
global SAVE_LIST_PATH
global EXCLUDE_LIST_PATH
global FILE_PATH
global EXPORT_PATH

HOME_PATH = "/home/athena/Core"
CONF_PATH = HOME_PATH + "/conf"

file = open(CONF_PATH + "/Type", "r") 
Type = file.read() 

if Type == "SQL":
	REMOTE_EXPORT_PATH="/home/athena/RootKit-lab.org/Dev/Dumps"
else:
	REMOTE_EXPORT_PATH="/home/athena/RootKit-lab.org/Dev/Data"

LIB_PATH = HOME_PATH + "/libs"
COMMON_LIB = LIB_PATH + "/common"
DATA_LIB = LIB_PATH + "/data"
SQL_LIB = LIB_PATH + "/SQL"
LOG_PATH = HOME_PATH + "/logs"
SPECIAL_LIB = LIB_PATH + "/special"
FLAG_PATH = HOME_PATH + "/flags"
CKSUM_PATH = HOME_PATH + "/ckSum"
LISTED_INCREMENTAL_PATH = HOME_PATH + "/lists"
SAVE_LIST_PATH = HOME_PATH + "/listSave"
EXCLUDE_LIST_PATH = HOME_PATH + "/excludeSave"
FILE_PATH = HOME_PATH + "/files"
EXPORT_PATH = HOME_PATH +"/dataExport"