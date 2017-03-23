#!/bin/bash

######################################
# Help.sh
# Utilité: Librairie d'aide
# Auteur: RootKitDev <RootKit.Dev@gmail.com>
# Mise à jour le: 23/01/2017
######################################


usage(){
	echo "$(basename "$0") [-h] [-v] [-t Data|SQL] [-o specificfile.log] -- Athena : Program to save your system with different types of customizable backup"

	echo "where:"
	echo -e "\t-h  show this help text"
	echo -e "\t-v  set verbose mode"
	echo -e "\t-t  set the type of save  : Data or SQL"
	echo -e "\t-o  set the specific log file (other than the default in \$LOG_PATH)"
}
