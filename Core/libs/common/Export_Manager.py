#!/usr/bin/env python
# -*- coding: utf-8 -*-

######################################
# Export_Manager.py
# Utilité: Librairie lié aux sauvegardes de type données
# Auteur: RootKitDev <RootKit.Dev@gmail.com>
# Mise à jour le: 17/08/2017
######################################

from datetime import datetime
import sys
import os
import subprocess
import time

from libs.common.Variable_Manager import *
from libs.common import Partner_Manager as PM
from libs.common import CheckSum_Manager as CM
from libs.common import State_Manager as SM
from libs.utility.BDD import *
from libs.utility import LogMod
from libs.utility import DateMod

def export(tar_Name, Type):

	now = datetime.now()
	DoW = now.weekday()
	now = datetime.now()
	year = str(now.year)
	month = str(DateMod.display(now.month))
	day = str(DateMod.display(now.day))

	cursor.execute("""
		SELECT host
		FROM partner
	""")
	i = 0
	hosts = cursor.fetchall()

	#DEBUG
	cursor.execute("""
		SELECT count(*)
		FROM partner
	""")
	ResCount = cursor.fetchall()



	results = len(ResCount) 
	if results > 0:
		#DEBUG
		for row in ResCount:
			nbHosts = row[0]
	else:
		#DEBUG
		LogMod.addDebug(1)

	results = len(hosts) 
	if results > 0:
			#DEBUG
		for host in hosts:
			i += 1
			host = str(host)
			host = host[3:]
			host = host[:-3]

			SCP_CMD = ["scp", "-i", "/home/athena/.ssh/id_rsa", EXPORT_PATH + "/" + tar_Name, "athena@" + host + ":" + REMOTE_EXPORT_PATH]
			SCP_CMD_CKSUM = ["scp", "-i", "/home/athena/.ssh/id_rsa", CKSUM_PATH + "/Demande_CkSum", "athena@" + host + ":/home/athena"]
			LogMod.addDebug("Hote : " + host)
			LogMod.addDebug("SCP_CMD : " + str(SCP_CMD))

			if PM.Check_Partner(host):
				LogMod.addInfo("Transfert de la sauvegarde en cours vers " + host)
				time1 = time.time()
				subprocess.call(SCP_CMD)
				time2 = time.time()
				LogMod.addInfo("Le transfere a duré %d secondes" %(time2 - time1))
			else:
				sys.exit(42)

			if not os.path.exists(CKSUM_PATH + "/Demande_CkSum"):
				LogMod.addInfo("Création d'une demande de CkSum")
				f = open(CKSUM_PATH + "/Demande_CkSum", "w")
				f.close()

			LogMod.addInfo("Envoie de la demande de CkSum vers "+ str(host))
			subprocess.call(SCP_CMD_CKSUM)

			LogMod.addInfo("En attente du Cksum de l'hôte "+ str(host))
			LogMod.addInfo("Reprise d'Athéna a réception du fichier réponse")

			while not os.path.exists(CKSUM_PATH + "/" + Type + "_" + year + "_" + month + "_" + day + "_Remote.cksum"):
				time.sleep(1)

			LogMod.addDebug("Fichier Remote récupéré")

			#DEBUG
			cursor.execute("""
				SELECT displayState
				FROM save s
				INNER JOIN state st
				WHERE s.state = st.id
				AND day = %s
				AND month = %s
			""",
			(DateMod.display(now.day), DateMod.display(now.month)))
			State = cursor.fetchall()

			results = len(State) 
			if results > 0:
				#DEBUG
				for row in State:
					Old = row[0]
			else:
				#DEBUG
				LogMod.addDebug(1)

			LogMod.addInfo("Reprise d'Athéna")
			LogMod.addInfo("Controle des CheckSums : ")

			if (CM.Ctrl_ChkSum(Type, tar_Name) and nbHosts == i) and "OK" in Old:
				LogMod.addInfo("La sauvegarde a été exportées sur au moins un hôte distant")
				SM.set_State(1)
				LogMod.addInfo("Suppression du fichier de sauvegarde local (" + tar_Name + ")")
				os.remove(EXPORT_PATH + "/" + tar_Name)
				LogMod.addInfo("Fichier local (" + tar_Name + ") supprimé")
				LogMod.addInfo("Suppression des fichiers .cksum")
				RM_CKSUM_CMD = "rm " + CKSUM_PATH + "/*"
				Res = subprocess.check_output(RM_CKSUM_CMD, stdin=subprocess.PIPE, shell=True)
				LogMod.addInfo("Fichiers .cksum supprimés")
			else:
				LogMod.addInfo("Suppression des fichiers .cksum et tarball")
				RM_CKSUM_CMD = "rm " + CKSUM_PATH + "/*"
				Res = subprocess.check_output(RM_CKSUM_CMD, stdin=subprocess.PIPE, shell=True)
				LogMod.addInfo("Fichiers .cksum supprimés")
				RM_TAR_CMD = "rm " + EXPORT_PATH + "/*"
				Res = subprocess.check_output(RM_TAR_CMD, stdin=subprocess.PIPE, shell=True)
				LogMod.addInfo("Fichiers tarball supprimés")
	else:
		#DEBUG
		LogMod.addDebug(1)
