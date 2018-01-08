#!/usr/bin/python
# -*- coding: utf-8 -*-

######################################
# State_Manager.py
# Utilité: Librairie de gestion des états
# Auteur: RootKitDev <RootKit.Dev@gmail.com>
# Mise à jour le: 17/08/2017
######################################

from datetime import datetime

from libs.common.Variable_Manager import *
from libs.utility.BDD import *
from libs.utility import LogMod
from libs.utility import DateMod

def set_State(State):

	now = datetime.now()

	cursor.execute("""
		use Athena
	""")

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
	resState = cursor.fetchall()

	results = len(resState) 
	if results > 0:
		#DEBUG
		for row in resState:
			Old = row[0]

	fristSetState = [10,5,11]

	if State in fristSetState:
		cursor.execute("UPDATE save SET state = %d WHERE month = '%s' AND day = '%s'" % (State ,DateMod.display(now.month), DateMod.display(now.day)))
	elif State < 5:
		if "OK" not in Old:
			cursor.execute("UPDATE save SET state = %d WHERE month = '%s' AND day = '%s'" % (State ,DateMod.display(now.month), DateMod.display(now.day)))
	else:
		LogMod.addWarning("Argument " + str(State) + " non supporté")

	conn.commit()