#!/usr/bin/env python
# -*- coding: utf-8 -*-

######################################
# Sql_Manager.sh
# Utilité: Librairie lié aux sauvegardes de type SQL
# Auteur: RootKitDev <RootKit.Dev@gmail.com>
# Mise à jour le: 30/01/2017
######################################

from datetime import datetime
import sys
import os
import subprocess
import time

from libs.common.Variable_Manager import *
from libs.common import Export_Manager as EM
from libs.common import State_Manager as SM
from libs.utility.BDD import *
from libs.utility import LogMod
from libs.utility import DateMod


def save():

	# Déplanifiée
	LogMod.addDebug("Flag DP : " + str(os.path.exists(FLAG_PATH + "/PS-000")))
	if os.path.exists(FLAG_PATH + "/PS-000"):
		LogMod.addInfo("Fanion \"PS-000\" a été posé,")
		LogMod.addInfo("La sauvegarde a été déplanifiée")
		SM.set_State(11)
	else:

			if os.path.exists(FLAG_PATH + "/PS-005"):
				LogMod.addInfo('Fanion "Pas de Sauvegarde SQL" détecté')
				SM.set_State(5)
			else :

				cursor.execute("""
					SHOW DATABASES
				""")
				allDB = cursor.fetchall()

				cursor.execute("""
					SHOW DATABASES LIKE '%schema'
				""")
				notSaveDB = cursor.fetchall()

				for DB in allDB:
					if DB not in notSaveDB:
						DB = str(DB)
						DB = DB[3:]
						DB = DB[:-3]
						LogMod.addInfo("Dump de la Base : " + DB)
						LogMod.addInfo("Dump en cours")

						dumpcmd = "mysqldump --defaults-extra-file=" + CONF_PATH + "/Dumps_User_SQL.cnf " + DB + " > " + EXPORT_PATH + "/" + DB + "_dump.sql"
						deb = time.time()
						os.system(dumpcmd)
						end = time.time()

						Create_SQL_Tarball(deb, DB)

def Create_SQL_Tarball(deb, DB):

	now = datetime.now()
	DoW = now.weekday()
	tar_name = DB + "_export_" + now.strftime("%Y_%m_%d_%HH%M") + ".tar.gz"
	
	TAR_CMD = ["libs/common/shell_Scripts/custom_TAR.sh", EXPORT_PATH + "/" + tar_name, "-C " + EXPORT_PATH +"/ ."]
	RM_DUMP_CMD = "rm " + EXPORT_PATH + "/" + DB + "_dump.sql"

	LogMod.addDebug("TAR_CMD = " + str(TAR_CMD))
	LogMod.addDebug("RM_DUMP_CMD = " + str(RM_DUMP_CMD))

	subprocess.call(TAR_CMD)
	Res = subprocess.check_output(RM_DUMP_CMD, stdin=subprocess.PIPE, shell=True)
	end = time.time()
	#time=$(Time_2_Save time)
	LogMod.addInfo("Le Dump de la base " + DB + " a durée %d secondes" %(end - deb))
	LogMod.addInfo("Sauvegarde terminée")

	if not os.path.exists(EXPORT_PATH + "/" + tar_name):
		LogMod.addWarning("Une erreur a été detectée :")
		LogMod.addCritical("Le fichier "+ tar_name + " introuvable !")
		SM.set_State(7)
		sys.exit(42)

	print "export"
	#EM.export(tar_Name, DB)
