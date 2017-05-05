#!/bin/bash

######################################
# Help.sh
# Utilité: Librairie d'aide
# Auteur: RootKitDev <RootKit.Dev@gmail.com>
# Mise à jour le: 05/05/2017
######################################


usage(){
	echo "$(basename "$0") [-h] [-v] [--check] [--test-svg] [-t Data|SQL] [-o specificfile.log] -- Athena : Program to save your system with different types of customizable backup"

	echo "where:"
	echo -e "\t-h\t\tshow this help text"
	echo -e "\t-v\t\tset verbose mode"
	echo -e "\t-t\t\tset the type of save  : Data or SQL"
	echo -e "\t-o\t\tset the specific log file (other than the default in \$LOG_PATH)"
	echo -e "\t-V\t\tshow Version"
	echo -e "\t--check\t\tChecks the integrity of Athena"
	echo -e "\t--test-svg\tPerforms a backup test"
}
