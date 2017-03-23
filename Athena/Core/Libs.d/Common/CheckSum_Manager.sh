#!/bin/bash

######################################
# CheckSum_Manager.sh
# Utilité: Librairie de controle des Checksums (local et remote)
# Auteur: RootKitDev <RootKit.Dev@gmail.com>
# Mise à jour le: 23/01/2017
######################################

Ctrl_ChkSum(){

	if [[ -e $EXPORT_CKSUM_PATH"/"$1"_"$(date +%Y_%m_%d)"_Local.cksum" ]]; then
		Local=$(cat $EXPORT_CKSUM_PATH"/"$1"_"$(date +%Y_%m_%d)"_Local.cksum")
	fi

	if [[ -e $EXPORT_CKSUM_PATH"/"$1"_"$(date  +%Y_%m_%d)"_Remote.cksum" ]]; then
		Remote=$(cat $EXPORT_CKSUM_PATH"/"$1"_"$(date +%Y_%m_%d)"_Remote.cksum")
	fi

	if [[ -n $SUB_LOG ]]; then
		EXPORT_NAME=$1
	fi

	echo "" >> $LOG_PATH/Save$SUB_LOG.log
	echo "Controle des CheckSums en cours pour \"$EXPORT_NAME\"" >> $LOG_PATH/Save$SUB_LOG.log

	if [[ "$Local" = "$Remote" ]]; then
		echo "Les CheckSums de la sauvegarde $1 du $(date +%d/%m/%Y) en Local et sur \"$REMOTE_HOST\" sont identitiques :" >> $LOG_PATH/Save$SUB_LOG.log
		echo "Local  : $Local" >> $LOG_PATH/Save$SUB_LOG.log
		echo "Remote : $Remote" >> $LOG_PATH/Save$SUB_LOG.log

		if [[ -z $SUB_LOG ]]; then
			State_Save "1"
		else
			State_Save "6"
		fi
		echo 0
	else
		echo "Les CheckSums de la sauvegarde $1 du $(date +%d/%m/%Y) en Local et sur \"$REMOTE_HOST\" sont différents :" >> $LOG_PATH/Save$SUB_LOG.log
		echo "Local : $Local" >> $LOG_PATH/Save$SUB_LOG.log
		echo "Remote : $Remote" >> $LOG_PATH/Save$SUB_LOG.log

		if [[ -z $SUB_LOG ]]; then
			State_Save "4"
		else
			State_Save "9"
		fi
		echo 1
	fi
}