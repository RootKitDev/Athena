#! /bin/bash

######################################
# restauration.sh
# Utilité: Demande le transfert des tarballs nécessaire pour la restauration
# Auteur: RootKitDev <RootKit.Dev@gmail.com>
# Mise à jour le: 07/04/2017
######################################

if [[ -f "/$2" ]]; then
	tar -C / -zxvf /var/www/html/Outils/IHM/file/resto/tarball/$1 $2 --overwrite
else
	tar -C / -zxvf /var/www/html/Outils/IHM/file/resto/tarball/$1 $2
fi

