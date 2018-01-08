#!/usr/bin/env python
# -*- coding: utf-8 -*-

######################################
# BDD.py
# Utilité: 
# Auteur: RootKitDev <RootKit.Dev@gmail.com>
# Mise à jour le: 17/08/2017
######################################

import sys
import mysql.connector

from libs.common.Variable_Manager import *

file = open(CONF_PATH + "/Type", "r") 
Type = file.read() 

if Type == "SQL":
	conn = mysql.connector.connect(host="localhost",user="Backup",password="B@ckupP@ssw0rD")
else:
	conn = mysql.connector.connect(host="localhost",user="AthenaUser",password="@then@UserP@ssw0rD", database="Athena")
cursor = conn.cursor()
