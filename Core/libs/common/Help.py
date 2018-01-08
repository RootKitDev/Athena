#!/usr/bin/python
# -*- coding: utf-8 -*-

######################################
# Help.py
# Utilité: Librairie d'aide
# Auteur: RootKitDev <RootKit.Dev@gmail.com>
# Mise à jour le: 16/08/2017
######################################

import os

def usage(file):
	print "athena [-h] [-v] [--check] [--test-svg] [-t Data|SQL] [-o specificfile.log] -- Athena : Program to save your system with different types of customizable backup"
	print "where:"
	print "\t-h\t\tshow this help text"
	print "\t-v\t\tset verbose mode"
	print "\t-t\t\tset the type of save  : Data or SQL"
	print "\t-o\t\tset the specific log file (other than the default in \$LOG_PATH)"
	print "\t-V\t\tshow Version"
	print "\t--check\t\tChecks the integrity of Athena"
	print "\t--test-svg\tPerforms a backup test"
