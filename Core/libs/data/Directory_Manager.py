#!/usr/bin/env python
# -*- coding: utf-8 -*-

######################################
# Directory_Manager.py
# Utilité: Librairie de vérification l'éligibilité de l'argument (seul les dossiers sont autorisés)
# Auteur: RootKitDev <RootKit.Dev@gmail.com>
# Mise à jour le: 16/08/2017
######################################

import os
import sys

from libs.utility import LogMod
from libs.common import State_Manager as SM

def Error(Code, element):

	if Code == 0 :
		LogMod.addInfo("'" + element + "' -> Ok pour Sauvegarde")
	elif Code == 1 :
		LogMod.addCritical("Code d'erreur 1 :")
		LogMod.addCritical("\t '" + element +"' n'existe pas")
		LogMod.addCritical("Arret d'Athena\n")
		SM.set_State(2)
		sys.exit(1)

	elif Code == 2 :
		LogMod.addCritical("Code d'erreur 1 :")
		LogMod.addCritical("\t '" + element +"' n'est pas un dossier")
		LogMod.addCritical("Arret d'Athena\n")
		SM.set_State(2)
		sys.exit(2)

	else :
		LogMod.addCritical("Code d'erreur inconnu : '" + Code +"'")
		LogMod.addCritical("Arret d'Athena\n")
		sys.exit(3)

def Get_Directory(element):

	if not os.path.exists(element):
		Error(1, element)
	elif os.path.isfile(element) or os.path.islink(element):
		Error(2, element)
	else :
		Error(0,element)
