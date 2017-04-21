#! /bin/bash

######################################
# Ask_Backup.sh
# Utilité: Demande le transfert des tarballs nécessaire pour la restauration
# Auteur: RootKitDev <RootKit.Dev@gmail.com>
# Mise à jour le: 07/04/2017
######################################

IHM_PATH="/var/www/html/Outils/IHM"
CORE_PATH="/home/athena/Core"
EXPORT_PATH="$IHM_PATH/file/resto"
FILE_PATH="$CORE_PATH/Files.d"
REMOTE_PATH="/home/athena/Trinixium/Resto/"
RSA="/home/athena/.ssh/id_rsa"

echo $1 > $EXPORT_PATH/demande_Resto

Day=$(cat $EXPORT_PATH/demande_Resto | cut -d'-' -f3)
res=${Day:0:1}
 if [[ $res -eq 0 ]]; then
	Day=${Day:1:1}
fi

Month=$(cat $EXPORT_PATH/demande_Resto | cut -d'-' -f2)
Year=$(cat $EXPORT_PATH/demande_Resto | cut -d'-' -f1)

Now=$(date +%d)
res=${Now:0:1}
if [[ $res -eq 0 ]]; then
	Now=${Now:1:1}
fi

Target=$(($Now - $Day))
res=${Target:0:1}
if [[ $res -eq 0 ]]; then
	Target=${Target:1:1}
fi

if [[ $Day -lt 9 ]]; then
	Day="0$Day"
fi

DoM=$(date -d $Year'-'$Month'-'$Day +%d)
DoW=$(date -d $Year'-'$Month'-'$Day +%u)


## Rétention
# Hebdo
if (([[ $DoM -ge 8 ]] && [[ $DoM -le 14 ]]) && [[ $DoW -eq 7 ]]); then
	if [[ $Target -gt 21 ]]; then
		echo "La sauvegarde choisi n'est plus disponible"
	fi
# Journa
elif [[ $DoW -gt 1 ]] && [[ $DoW -lt 6 ]]; then
	if [[ $Target -gt 14 ]]; then
		echo "La sauvegarde choisi n'est plus disponible"
	fi
# All
else
	if [[ $Target -gt 33 ]]; then
		echo "La sauvegarde choisi n'est plus disponible"
	fi
fi

# User Access
while read line  
do
	if [[ $line =~ "user" ]];
	then
		user=$(echo $line | cut -d'=' -f2)
	fi
done < $EXPORT_PATH/Files.d/User_Export.cnf

SCP_CMD="scp -i /home/athena/.ssh/id_rsa $EXPORT_PATH/demande_Resto athena@$host1:/home/athena/Trinixium/Resto/"
$($SCP_CMD)

SCP_CMD="scp -i /home/athena/.ssh/id_rsa $EXPORT_PATH/demande_Resto athena@$host2:/home/athena/Trinixium/Resto/"
#$($SCP_CMD)

if [[ $DoW -eq 1 ]]; then
	Tar="Full_Backup_"$(date -d $Year'-'$Month'-'$Day +%B)"_Week_"$(date -d $Year'-'$Month'-'$Day +%U)".tar.gz"
elif (([[ $DoM -ge 8 ]] && [[ $DoM -le 14 ]]) && [[ $DoW -eq 7 ]]); then
	Tar="Full_Backup_"$(date -d $Year'-'$Month'-'$Day +%B)".tar.gz"
else
	Tar="Incremental_Backup_"$(date -d $Year'-'$Month'-'$Day +%B)"_Week_"$(date -d $Year'-'$Month'-'$Day +%U)"_"$Year"_"$Month"_"$Day"_06H00.tar.gz"
fi

echo $Tar > $EXPORT_PATH/Theory_Resto 

while [ ! -f $EXPORT_PATH/Reponse_Resto_RootKit ] && [ ! -f $EXPORT_PATH/Reponse_Resto_Wolfy ]; do
	sleep 1s
done

Theory=$(cat $EXPORT_PATH/Theory_Resto)
File=$(ls -ltr $EXPORT_PATH | grep Reponse | rev | cut -d' ' -f1 | rev | head -n1)
Res=$(cat $EXPORT_PATH/$File)

NbSave=$(cat $EXPORT_PATH/Theory_Resto | grep -c Backup)

if [[ "$Theory" == "$Res" ]]; then

	if [[ "$File" =~ "$Namehost1" ]]; then
		SCP_CMD="scp -i /home/athena/.ssh/id_rsa $EXPORT_PATH/$File athena@$host1:/home/athena/Trinixium/Resto/"
		$($SCP_CMD)

		echo "" > $EXPORT_PATH/Reponse_Resto_Wolfy
		SCP_CMD="cp -i /home/athena/.ssh/id_rsa $EXPORT_PATH/Reponse_Resto_Wolfy athena@$host2:/home/athena/Trinixium/Resto/"
		$($SCP_CMD)
		Time=$(($NbSave * 20))
	elif [[ "$File" =~ "$Namehost2" ]]; then
		SCP_CMD="scp -i /home/athena/.ssh/id_rsa $EXPORT_PATH/$File athena@$host2:/home/athena/Trinixium/Resto/"
		$($SCP_CMD)

		echo "" > $EXPORT_PATH/Reponse_Resto_RootKit
		SCP_CMD="scp -i /home/athena/.ssh/id_rsa $EXPORT_PATH/Reponse_Resto_RootKit athena@$host1:/home/athena/Trinixium/Resto/"
		$($SCP_CMD)
		Time=$(($NbSave * 45))
	fi

	rm $EXPORT_PATH/*Resto*
else
	echo "KO" > $EXPORT_PATH/Log
	exit 0
fi

sleep $Time

File=$(ls -ltr "$EXPORT_PATH/tarball" | grep Backup | rev | cut -d' ' -f1 | rev | head -n1)
tar tf $EXPORT_PATH/tarball/$File > "$EXPORT_PATH/content_save.txt"
chown www-data "$EXPORT_PATH/content_save.txt"
chown www-data "$EXPORT_PATH/tarball/" -R