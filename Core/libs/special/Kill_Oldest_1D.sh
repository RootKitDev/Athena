#!/bin/bash

######################################
# Kill_Oldest_1D.sh
# Utilité: Kill des process plus vieux de 24h
# Auteur: RootKitDev <RootKit.Dev@gmail.com>
# Mise à jour le: 23/01/2017
######################################

Process=false

ps -e -o etime,pid,command | grep Main.py | grep -v -E '(grep|killathena|logs)' | awk '{print $1" "$2" "$3}' | while read Age Pid 
do
	if [[ $(echo $Age | grep -c '-') -gt 0 ]];then
		Process=true
		echo "Un processus Athena a une durée de vie supérieur à 24h"
		echo "arrete du process ..."
		kill -9 $Pid
		echo "processus arreté"
	else
		echo "Aucun processus Athena n'a une durée de vie supérieur à 24h"
	fi
done

ps -e -o etime,pid,command | grep athena | grep -v -E '(grep|killathena)' | awk '{print $1" "$2" "$3}' | while read Age Pid 
do
	if [[ $(echo $Age | grep -c '-') -gt 0 ]];then
		Process=true
		echo "Un processus Athena a une durée de vie supérieur à 24h"
		echo "arrete du process ..."
		kill -9 $Pid
		echo "processus arreté"
	else
		echo "Aucun processus Athena n'a une durée de vie supérieur à 24h"
	fi
done

if ! $Process; then

	echo "Aucun processus Athena ne tourne !"
fi