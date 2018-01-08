#!/usr/bin/env python
# -*- coding: utf-8 -*-

######################################
# LogMod.py
# Utilité: 
# Auteur: RootKitDev <RootKit.Dev@gmail.com>
# Mise à jour le: 17/08/2017
######################################

from pathlib import Path
import sys
import logging
from logging import FileHandler

from libs.common.Variable_Manager import *
import DateMod

logger = logging.getLogger()
logger.setLevel(logging.DEBUG)

formatter = logging.Formatter('%(asctime)s :: %(levelname)s :: %(message)s', "%d/%m/%Y %H:%M:%S")

def setLogger(lvl="INFO", file=LOG_PATH + "/Save.log"):
	if lvl == "INFO":
		logFile = FileHandler(file,"a")
		logFile.setLevel(logging.getLevelName(lvl))
		logFile.setFormatter(formatter)
		logger.addHandler(logFile)

	if lvl == "DEBUG":
		logDebug = FileHandler(file,"a")
		logDebug.setLevel(logging.getLevelName(lvl))
		logDebug.setFormatter(formatter)
		logger.addHandler(logDebug)

	addDebug(lvl +  ' Mode Enable')

def beginLog():
	addInfo("-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_")
	addInfo("Début de l'execution d'Athena")

def addDebug(log):
	logger.debug(log)

def addInfo(log):
	logger.info(log)

def addWarning(log):
	logger.warning(log)

def addError(log):
	logger.error(log)

def addCritical(log):
	logger.critical(log)

def endLog(Type):
	logger.info("Fin du script Athena (" + Type + ")\n")
