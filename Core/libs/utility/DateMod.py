#!/usr/bin/env python
# -*- coding: utf-8 -*-

######################################
# DateMod.py
# Utilité: 
# Auteur: RootKitDev <RootKit.Dev@gmail.com>
# Mise à jour le: 17/08/2017
######################################

from datetime import datetime

def datenow():
	now = datetime.now()
	date = ""
	if now.day < 10:
		date = "0" + str(now.day) + "/"
	else:
		date = str(now.day) + "/"

	if now.month < 10:
		date += "0" + str(now.month) + "/" + str(now.year) + " "
	else:
		date += str(now.month) + "/" + str(now.year) + " "

	if now.hour < 10:
		date += "0" + str(now.hour) + "h"
	else:
		date += str(now.hour) + "h"

	if now.minute < 10:
		date += "0" + str(now.minute)
	else:
		date += str(now.minute)

	return date

def display(number):
	if number < 10:
		number = "0" + str(number)
	return number