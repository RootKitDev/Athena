#!/usr/bin/python
# -*- coding: utf-8 -*-

######################################
# Main.py
# Utilité: Script principal d'Athena 
# Auteur: RootKitDev <RootKit.dev@gmail.com>
# Mise à jour le: 
######################################

import getopt
import sys

from libs.common import Help
from libs.utility import LogMod
from libs.common.Variable_Manager import *

def main():
	global Type

	Type = ""

	LogMod.setLogger()

	try:
		opts, args = getopt.getopt(sys.argv[1:], "vho:t:V", ["check", "test-svg"])
	except getopt.GetoptError as err:
		print(err)
		Help.usage(__file__)
		sys.exit(10)

	if not opts:
		Help.usage(__file__)
		sys.exit(10)

	for o, a in opts:
		if o == "-v":
			LogMod.setLogger("DEBUG", LOG_PATH + "/Debug.log")

		elif o == "-V":
			file = open(CONF_PATH + "/Version", "r") 
			print "Athena version : " + file.read() 

		elif o == "-t":
			if a in ['Data', 'SQL']:
				Type = a
				LogMod.beginLog()
				file = open(CONF_PATH + "/Type", "w") 
				file.write(a)
				file.close()

				if a == "Data":
					from libs.data import Data_Manager as Data
					Data.save()

				elif a == "SQL":
					from libs.SQL import Sql_Manager as SQL
					SQL.save()

			else:
				print "type '" + a + "' non supporter"
				sys.exit(11)

		elif o == "-h":
			Help.usage(__file__)
			sys.exit(10)

		elif o == "-o":
			output = a
			print "out"

		elif o == "--test-svg":
			from libs.data import Data_Manager as Data
			Data.Test_Svg()

		elif o == "--check":
			from libs.special import check_Athena

		else:
			assert False, "unhandled option"

if __name__ == "__main__":
	main()
	LogMod.endLog(Type)
