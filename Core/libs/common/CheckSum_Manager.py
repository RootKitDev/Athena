#!/usr/bin/env python
# -*- coding: utf-8 -*-

######################################
# CheckSum_Manager.py
# Utilité: Librairie lié aux sauvegardes de type données
# Auteur: RootKitDev <RootKit.Dev@gmail.com>
# Mise à jour le: 16/08/2017
######################################

from datetime import datetime
import os

from libs.common.Variable_Manager import *
from libs.common import State_Manager as SM
from libs.utility import LogMod
from libs.utility import DateMod

def Ctrl_ChkSum(Type, tar_Name):

	now = datetime.now()
	year = str(now.year)
	month = str(DateMod.display(now.month))
	day = str(DateMod.display(now.day))
	today = day + "/" + month + "/" + year

	localChkSumFile = CKSUM_PATH + "/" + Type + "_" + year + "_" + month + "_" + day + "_Local.cksum"
	remoteChkSumFile = CKSUM_PATH + "/" + Type + "_" + year + "_" + month + "_" + day + "_Remote.cksum"

	if os.path.exists(localChkSumFile):
		with open(localChkSumFile, "r") as file:
			local = file.read()
			local = local[:-1]
			LogMod.addDebug(local)
		file.close()
	else:
		local = ""

	if os.path.exists(remoteChkSumFile):
		with open(remoteChkSumFile, "r") as file:
			remote = file.read()
			remote = remote[:-1]
			LogMod.addDebug(remote)
		file.close()
	else:
		remote = None

	#if [[ -n $SUB_LOG ]]; then
	#	EXPORT_NAME=$1
	#fi

	LogMod.addInfo("Controle des CheckSums en cours pour " + tar_Name)

	if local == remote:
		LogMod.addInfo("Les CheckSums de la sauvegarde " + tar_Name + " du " + today + " sont identitiques :")
		LogMod.addInfo("Local  : " + str(local))
		LogMod.addInfo("Remote : " + str(remote))
		SM.set_State(1)
		return True
	else:
		LogMod.addInfo("Les CheckSums de la sauvegarde " + tar_Name + " du " + today + " sont différents :")
		LogMod.addInfo("Local  : " + str(local))
		LogMod.addInfo("Remote : " + str(remote))
		SM.set_State(4)
		return False