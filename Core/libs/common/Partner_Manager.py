#!/usr/bin/env python
# -*- coding: utf-8 -*-

######################################
# Partner_Manager.py
# Utilité: Librairie lié aux sauvegardes de type données
# Auteur: RootKitDev <RootKit.Dev@gmail.com>
# Mise à jour le: 17/08/2017
######################################

from datetime import datetime
import sys
import subprocess

from libs.common.Variable_Manager import *
from libs.utility.BDD import *
from libs.common import State_Manager as SM
from libs.utility import LogMod
from libs.utility import DateMod

def Check_Partner(backupHost):
	#DEBUG


	now = datetime.now()

	cursor.execute("""
		SELECT ip As ''
		FROM partner
		WHERE host = "%s"
	""",
	(backupHost))

	rows = cursor.fetchall()

	results = len(rows) 
	if results > 0:
		#DEBUG
		for row in rows:
			IP = row[0]
	else:
		IP = ""

	if not IP:
		#DEBUG
		IP_CMD = "nslookup " + backupHost + " | tail -2 | head -n 1 | cut -d' ' -f2"
		IP = str(subprocess.check_output(IP_CMD, stdin=subprocess.PIPE, shell=True))
		IP = IP[:-1]

	#DEBUG
	Res_CMD = "traceroute " + backupHost + " 22 | grep " + IP + " | sed '1d'"
	Res = subprocess.check_output(Res_CMD, stdin=subprocess.PIPE, shell=True)
	Res = Res[:-1]


	if not Res:
		#DEBUG
		Res_CMD = "traceroute " + backupHost + " 22 -I | grep " + IP + " | sed '1d'"
		Res = subprocess.check_output(Res_CMD, stdin=subprocess.PIPE, shell=True)
		Res = Res[:-1]

	#DEBUG
	if not Res:
		LogMod.addWarning("L'hôte " + backupHost + " est injoignable")
		cursor.execute("""
			SELECT count(*)
			FROM partner
		""")
		rows = cursor.fetchall()

		results = len(rows) 
		if results > 0:
			#DEBUG
			for row in rows:
				nbHosts = row[0]

		if nbHosts > 1:
			#DEBUG
			LogMod.addWarning("Transfert annulé")
		else:
			LogMod.addError("Transfert annulé")
			#SM.set_State(4)
			return False
	else:
		#DEBUG
		LogMod.addInfo("L'hôte " + backupHost + " est joignable")
		return True
