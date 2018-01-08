#!/usr/bin/env python
# -*- coding: utf-8 -*-

######################################
# Data_Manager.py
# Utilité: Librairie lié aux sauvegardes de type données
# Auteur: RootKitDev <RootKit.Dev@gmail.com>
# Mise à jour le: 17/08/2017
######################################

from datetime import datetime
import sys
import os
import subprocess
import time

import Directory_Manager as DM
from libs.common.Variable_Manager import *
from libs.common import Export_Manager as EM
from libs.common import State_Manager as SM
from libs.utility.BDD import *
from libs.utility import LogMod
from libs.utility import DateMod

def save():

	Ex = ""

	now = datetime.now()
	DoW = now.weekday()

	cursor.execute("""
		SELECT displayState
		FROM save s
		INNER JOIN state st
		WHERE s.state = st.id
		AND day = %s
		AND month = %s
	""",
	(DateMod.display(now.day), DateMod.display(now.month)))

	rows = cursor.fetchall()

	for row in rows:
		Old = row[0]

	LogMod.addDebug("State : " + Old)
	LogMod.addDebug("Day value : " + str(now.day))
	LogMod.addDebug("DoW (Day of Week) value : " + str(DoW))

	if "SQL" in Old:
		print 'Une sauvegarde SQL a déjà été effectuée'
		LogMod.addError('Une sauvegarde SQL a déjà été effectuée')
		sys.exit(1)

	SM.set_State(10)

	# Déplanifiée
	LogMod.addDebug("Flag DP : " + str(os.path.exists(FLAG_PATH + "/PS-000")))
	if os.path.exists(FLAG_PATH + "/PS-000"):
		LogMod.addInfo("Fanion \"PS-000\" a été posé,")
		LogMod.addInfo("La sauvegarde a été déplanifiée")
		SM.set_State(11)
	else:

			LogMod.addDebug("EX Flag : " + str(os.path.exists(FLAG_PATH + "/EX-000")))

			# Mensuel
			if ((now.day > 8 and now.day < 14) and DoW == 6) or os.path.exists(FLAG_PATH + "/EX-000"):
				LogMod.addDebug("Monthly Save : " + str(((now.day > 8 and now.day < 14) and DoW == 6)))
				LogMod.addDebug("Flag PS Monthly : " + str(os.path.exists(FLAG_PATH + "/PS-001")))
				if os.path.exists(FLAG_PATH + "/PS-001"):
					LogMod.addInfo('Fanion "Pas de Sauvegarde Mensuel" détecté')
					SM.set_State(5)
				else :

					if os.path.exists(FLAG_PATH + "/EX-000"):
						LogMod.addInfo("Sauvegarde Exceptionnel (sauvegarde Full) :")
						LogMod.addDebug("Move Ex Flag")
						subprocess.call(["mv", FLAG_PATH + "/EX-000", FLAG_PATH + "/block/"])
						LogMod.addDebug("EX Flag after move : " + str(os.path.exists(FLAG_PATH + "/EX-000")))
						Ex="Excep"
					else :
						LogMod.addInfo("Sauvegarde Mensuel (sauvegarde Full) :")

					LogMod.addInfo("Les Répertoires sauvegardés sont :")
					LogMod.addDebug("Size File value : " + str(os.path.getsize(SAVE_LIST_PATH + "/ListSaveMen")))
					if os.path.getsize(SAVE_LIST_PATH + "/ListSaveMen") == 0:
						LogMod.addInfo("Il n'y a pas de dossier a sauvegarder")
					else :
						with open(SAVE_LIST_PATH + "/ListSaveMen") as f:
							for line in f:
								DM.Get_Directory(line.rstrip())
							LogMod.addInfo("Eligibilité des dossiers terminée avec succes !")

						if Ex == "" :
							cursor.execute("UPDATE save SET type = 1 WHERE month = '%s' AND day = '%s'" % (DateMod.display(now.month), DateMod.display(now.day)))
						else :
							cursor.execute("UPDATE save SET type = 6 WHERE month = '%s' AND day = '%s'" % (DateMod.display(now.month), DateMod.display(now.day)))

						conn.commit()
						LogMod.addDebug("Launch Monthly Save")
						Create_Tarball("Mensuel", Ex)

			# Hebdomadaire
			elif DoW == 0 :
				LogMod.addDebug("Weekly Save : " + str(DoW == 0))
				LogMod.addDebug("Flag PS Weekly : " + str(os.path.exists(FLAG_PATH + "/PS-003")))
				if os.path.exists(FLAG_PATH + "/PS-002"):
					LogMod.addInfo('Fanion "Pas de Sauvegarde Hebdomadaire" détecté')
					SM.set_State(5)
				else :
					LogMod.addInfo('Sauvegarde Hebdomadaire (sauvegarde Full) :')

				LogMod.addInfo('Les Répertoires sauvegardés sont :')
				LogMod.addDebug("Size File value : " + str(os.path.getsize(SAVE_LIST_PATH + "/ListSaveHeb")))
				if os.path.getsize(SAVE_LIST_PATH + "/ListSaveHeb") == 0:
						LogMod.addInfo("Il n'y a pas de dossier a sauvegarder")
				else :
					with open(SAVE_LIST_PATH + "/ListSaveHeb") as f:
						for line in f:
							DM.Get_Directory(line.rstrip())

					LogMod.addInfo("Eligibilité des dossiers terminée avec succes !")
					cursor.execute("UPDATE save SET type = 3 WHERE month = '%s' AND day = '%s'" % (DateMod.display(now.month), DateMod.display(now.day)))
					conn.commit()
					LogMod.addDebug("Launch Weekly Save")
					Create_Tarball("Hebdomadaire")

			# Week-End
			elif DoW == 5 :
				LogMod.addDebug("Week-End Save : " + str(DoW == 5))
				LogMod.addDebug("Flag PS Week-End : " + str(os.path.exists(FLAG_PATH + "/PS-003")))
				if os.path.exists(FLAG_PATH + "/PS-003"):
					LogMod.addInfo('Fanion "Pas de Sauvegarde Hebdomadaire "Week-End"" détecté')
					SM.set_State(5)
				else :
					LogMod.addInfo('Sauvegarde Hebdomadaire "Week-End" (sauvegarde Incrementiel => Mensuel) :')

				LogMod.addInfo('Les Répertoires sauvegardés sont :')
				LogMod.addDebug("Size File > 0 ? : " + str(os.path.getsize(SAVE_LIST_PATH + "/ListSaveMen")))
				if os.path.getsize(SAVE_LIST_PATH + "/ListSaveMen") == 0:
						LogMod.addInfo("Il n'y a pas de dossier a sauvegarder")
				else :
					with open(SAVE_LIST_PATH + "/ListSaveMen") as f:
						for line in f:
							DM.Get_Directory(line.rstrip())

					LogMod.addInfo("Eligibilité des dossiers terminée avec succes !")
					cursor.execute("UPDATE save SET type = 2 WHERE month = '%s' AND day = '%s'" % (DateMod.display(now.month), DateMod.display(now.day)))
					conn.commit()
					LogMod.addDebug("Launch Week-End Save")
					Create_Tarball("Week-End")

			# Journaliere
			else : 
				LogMod.addDebug("Daily Save : True")
				if os.path.exists(FLAG_PATH + "/PS-004"):
					LogMod.addInfo('Fanion "Pas de Sauvegarde Journaliere détecté')
					SM.set_State(5)
				else :
					LogMod.addInfo('Sauvegarde Journaliere (sauvegarde Incrementiel => Hebdomadaire) :')

				LogMod.addInfo('Les Répertoires sauvegardés sont :')
				LogMod.addDebug("Size File value : " + str(os.path.getsize(SAVE_LIST_PATH + "/ListSaveHeb")))
				if os.path.getsize(SAVE_LIST_PATH + "/ListSaveHeb") == 0:
					LogMod.addInfo("Il n'y a pas de dossier a sauvegarder")
				else :
					with open(SAVE_LIST_PATH + "/ListSaveHeb") as f:
						for line in f:
							DM.Get_Directory(line.rstrip())

					LogMod.addInfo("Eligibilité des dossiers terminée avec succes !")
					cursor.execute("UPDATE save SET type = 4 WHERE month = '%s' AND day = '%s'" % (DateMod.display(now.month), DateMod.display(now.day)))
					conn.commit()
					LogMod.addDebug("Launch Daily Save")
					Create_Tarball("Journaliere")

def Create_Tarball(Type, Ex=""):

	now = datetime.now()

	LogMod.addDebug("Creation d'une Tarball de type : " + Type)
	if Type == "Mensuel":
		if Ex == "":
			LogMod.addDebug("Month/Ex tarball name : Full_Backup_" + now.strftime("%B") + ".tar.gz")
			tar_Name = "Full_Backup_" + now.strftime("%B") + ".tar.gz"

		else:
			LogMod.addDebug("Month/Ex tarball name : Full_Backup_" + Ex + "_" + now.strftime("%B") + ".tar.gz")
			tar_Name = "Full_Backup_" + Ex + "_" + now.strftime("%B") + ".tar.gz"
		target = "Men"
		listed_Incremental = "Backup_" + now.strftime("%B") + ".list"

	elif Type == "Hebdomadaire":
		LogMod.addDebug("Weekly Tarball name : Full_Backup_" + now.strftime("%B") + "_Week_" + str(now.isocalendar()[1]) + ".tar.gz")
		tar_Name = "Full_Backup_"+ now.strftime("%B") + "_Week_" + str(now.isocalendar()[1]) + ".tar.gz"
		listed_Incremental = "Backup_" + now.strftime("%B") + "_Week_" + str(now.isocalendar()[1]) + ".list"
		target = "Heb"

	elif Type == "Week-End":
		LogMod.addDebug("Week-End Tarball name : Incremental_Backup_"+ now.strftime("%B") + "_WeekEnd_" + str(now.isocalendar()[1]) + ".tar.gz")
		tar_Name = "Incremental_Backup_" + now.strftime("%B") + "_WeekEnd_" + str(now.isocalendar()[1]) + ".tar.gz"
		listed_Incremental = "Backup_" + now.strftime("%B") + ".list"
		target = "Men"

	elif Type == "Journaliere":
		LogMod.addDebug("Daily Tarball name : Incremental_Backup_"+ now.strftime("%B") + "_Week_" + str(now.isocalendar()[1]) + "_" + now.strftime("%Y_%m_%d_%HH%M") + ".tar.gz")
		tar_Name = "Incremental_Backup_" + now.strftime("%B") + "_Week_" + str(now.isocalendar()[1]) + "_" + now.strftime("%Y_%m_%d_%HH%M") + ".tar.gz"
		listed_Incremental = "Backup_" + now.strftime("%B") + "_Week_" + str(now.isocalendar()[1]) + ".list"
		target = "Heb"

	EXCLUDE = "--exclude='"
	INCLUDE = ""

	LogMod.addInfo("Les répertoire suivants ont été exclus :")
	with open(EXCLUDE_LIST_PATH + "/ListExclude%s" % target) as f:
		lines = f.readlines()
		try:
			last = lines[-1]
		except IndexError:
			LogMod.addDebug("Liste d'exclusion vide")
		for line in lines:
			if line is last:
				EXCLUDE = EXCLUDE + line.rstrip() + "'"
			else:
				EXCLUDE = EXCLUDE + line.rstrip() + "' --exclude='"

			LogMod.addInfo("\t " + line.rstrip())

	EXCLUDE = EXCLUDE.split(" ")

	LogMod.addDebug(EXCLUDE)

	with open(SAVE_LIST_PATH + "/ListSave%s" % target) as f:
		for line in f:
			INCLUDE = INCLUDE + " " + line.rstrip()

	INCLUDE = INCLUDE.split(" ")
	INCLUDE = " ".join(INCLUDE[1:])
	INCLUDE = INCLUDE.split(" ")

	LogMod.addDebug(INCLUDE)

	TAR_CMD = [HOME_PATH + "/libs/common/shell_Scripts/custom_TAR.sh", EXPORT_PATH + "/" + tar_Name, "--listed-incremental=" + LISTED_INCREMENTAL_PATH + "/" + listed_Incremental]
	TAR_CMD.extend(EXCLUDE)
	TAR_CMD.extend(INCLUDE)

	LogMod.addDebug("TAR_CMD = " + str(TAR_CMD))
	time1 = time.time()
	subprocess.call(TAR_CMD)
	time2 = time.time()
	#time=$(Time_2_Save time)
	LogMod.addInfo("La sauvegarde a durée %d secondes" %(time2 - time1))
	LogMod.addInfo("Sauvegarde terminée")

	#	Size "$EXPORT_PATH/$EXPORT_NAME"

	LogMod.addInfo("Le CheckSum de " + tar_Name + " à sa création est : ")

	ckSum = subprocess.Popen(["cksum", EXPORT_PATH + "/" + tar_Name], stdout=subprocess.PIPE)
	cut = subprocess.Popen(["cut", "-d", ' ', "-f1,2"], stdin=ckSum.stdout, stdout=subprocess.PIPE)
	ckSum.stdout.close()  # Allow p1 to receive a SIGPIPE if p2 exits.
	output,err = cut.communicate()

	LogMod.addInfo(output[:-1])
	file = open(CKSUM_PATH + "/" + Type + "_" + str(now.year) + "_" + str(DateMod.display(now.month)) + "_" + str(DateMod.display(now.day)) + "_Local.cksum","w") 
	file.write(output) 
	file.close() 

	EM.export(tar_Name, Type)

def Test_Svg():

	print ("Test de sauvegarde en cours")
	LogMod.addInfo("Test de sauvegarde en cours")

	#	echo "Test de sauvegarde" > ./file_test_svg
	#	echo "Si vous lisez ces lignes une fois le \"test-svg\" fini" >> ./file_test_svg
	#	echo "c'est que le test c'est fini correctement" >> ./file_test_svg
	
	#	tar -czf $EXPORT_CKSUM_PATH/test_svg.tar.gz ./file_test_svg -C $EXPORT_CKSUM_PATH/ . > /dev/null 2>&1
	#	rm ./file_test_svg
	#	REMOTE_HOST_TAB=$(mysql --defaults-extra-file=/home/athena/Core/Files.d/User_SQL.cnf -D Athena -e "SELECT host As '' FROM Partners")
	#	for REMOTE_HOST in ${REMOTE_HOST_TAB[@]}
	#	do
	#		scp $EXPORT_CKSUM_PATH/test_svg.tar.gz $user@$REMOTE_HOST:$REMOTE_EXPORT_PATH  > /dev/null 2>&1
	#		res=1
	#		while [ $res -ne 0 ]; do
	#			sleep 1s
	#			ls $EXPORT_CKSUM_PATH"/remote_file_test_svg" > /dev/null 2>&1
	#			res=$(echo $?)
	#		done
	#	done
	
	#	if [[ -f $EXPORT_CKSUM_PATH"/remote_file_test_svg" ]]; then
	#		echo "Le test de sauvegarde c'est terminé avec succès voici le contenu du fichier :"
	#		cat $EXPORT_CKSUM_PATH"/remote_file_test_svg"
	#	fi
	#	sleep 2s
	#	rm $EXPORT_CKSUM_PATH/*