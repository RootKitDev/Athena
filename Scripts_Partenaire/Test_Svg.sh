#!/bin/bash

######################################
# Test_Svg.sh
# Utilité: test de sauvegarde de sauvegarde avec serveur "Maitre"
# Auteur: RootKitDev <RootKit.Dev@gmail.com>
# Mise à jour le: 22/02/2017
######################################


Save_User="athena"
REMOTE_HOST="Master.host"

EXPORT_PATH="$HOME_PATH/MasterHost//CkSum_Export"

HOME_PATH="/home/athena"
SAVE_PATH="$HOME_PATH/folder/Data"

if [[ -e $SAVE_PATH/test_svg.tar.gz ]]
then

	tar -zxf $SAVE_PATH/test_svg.tar.gz -C $SAVE_PATH/ > /dev/null 2>&1
	mv $SAVE_PATH/file_test_svg $SAVE_PATH/remote_file_test_svg
	scp $SAVE_PATH/remote_file_test_svg $Save_User@$REMOTE_HOST:$EXPORT_PATH > /dev/null 2>&1
	ssh $Save_User@$REMOTE_HOST "chmod 777 $EXPORT_PATH/*" > /dev/null 2>&1
	rm $SAVE_PATH/*test_svg*
fi

