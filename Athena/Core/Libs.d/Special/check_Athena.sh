#!/bin/bash

HOME_PATH="$HOME_PATH"
LIB_PATH="$HOME_PATH/Libs.d"
COMMON_LIB="$LIB_PATH/Common"
DATA_LIB="$LIB_PATH/Data"

BOLD="\e[1m"
RED='\033[0;31m'
NC='\033[0m'
GREEN='\033[0;32m'
UNDER='\e[4m'
ORANGE='\033[0;33m'

echo -e "${BOLD}${UNDER}Initialisation de la vérification d'Athena : ${NC}"
echo ""
echo -e "${UNDER}Test de connexion BDD${NC}"
echo ""
echo -e "${UNDER}User : Athena${NC}"

mysql --defaults-extra-file=$HOME_PATH/Files.d/User_SQL.cnf -Bse "exit"  > /dev/null 2>&1
res=$(echo $?)

if [[ $res == 0 ]]; then
	echo -e "${GREEN}test ... OK${NC}"
else
	echo -e "${RED}test ... KO${NC}"
fi

echo ""
echo -e "${UNDER}User : Backup${NC}"
mysql --defaults-extra-file=$HOME_PATH/Files.d/Dumps_User_SQL.cnf -Bse "exit" > /dev/null 2>&1
res=$(echo $?)
if [[ $res == 0 ]]; then
	echo -e "${GREEN}test ... OK${NC}"
else
	echo -e "${RED}test ... KO${NC}"
fi

echo ""

echo -e "${UNDER}Test de présence des bases d'environnements : ${NC}"

databases=$(echo 'show databases' | mysql --defaults-extra-file=$HOME_PATHFiles.d/Dumps_User_SQL.cnf | grep Athena)

if [[ -n $databases ]]; then
	PROD=$(echo 'show databases' | mysql --defaults-extra-file=$HOME_PATH/Files.d/Dumps_User_SQL.cnf | grep Athena | head -n 1)
	PREPROD=$(echo 'show databases' | mysql --defaults-extra-file=$HOME_PATH/Files.d/Dumps_User_SQL.cnf | grep PREPROD)
	DEV=$(echo 'show databases' | mysql --defaults-extra-file=$HOME_PATH/Files.d/Dumps_User_SQL.cnf | grep DEV)

	if [[ -n $PROD ]]; then
		echo -e "${GREEN}La base de PROD : \"$PROD\" ... OK${NC}"
	else
		echo -e "${RED}La base de PROD : \"Athena\" est nécessaire${NC}"
		Error=true
	fi

	if [[ -n $PREPROD ]]; then
		echo -e "${GREEN}La base de PREPROD : \"$PREPROD\" ... OK${NC}"
	else
		echo -e "${ORANGE}La base de PREPROD : \"AthenaPREPROD\" ... Non disponible${NC}"
	fi

	if [[ -n $DEV ]]; then
		echo -e "${GREEN}La base de DEV : \"$DEV\" ... OK${NC}"
	else
		echo -e "${ORANGE}La base de DEV : \"AthenaDEV\" ... Non disponible${NC}"
	fi

else
	echo -e "${RED}Aucune bases n'est pas disponible !! ${NC}"
	echo -e "${RED}La base de PROD : \"Athena\" est nécessaire${NC}"
fi


echo ""
echo -e "${UNDER}Test de connexion vers les hotes partenaires : ${NC}"
while read line  
do
	if [[ $line =~ "user" ]];
	then
		user=$(echo $line | cut -d'=' -f2)
	fi
done < $HOME_PATH/Files.d/User_Export.cnf

Hosts=$(mysql --defaults-extra-file=$HOME_PATH/Files.d/User_SQL.cnf -D Athena -e "SELECT host As '' FROM Partners")
for host in ${Hosts[@]}
do
	ssh $user@$host 'exit' > /dev/null 2>&1
	res=$(echo $?)
	if [[ $res == 0 ]]; then
		echo -e "${GREEN}$host ... OK${NC}"
		HostsTest=true
	else
		echo -e "${RED}$host ... KO${NC}"
	fi
done

if [[ $HostsTest ]]; then
	echo "Au moins un hote est disponible :"
	echo -e "${GREEN}test ... OK${NC}"
else
	echo "Aucun un hote n'est disponible :"
	echo -e "${RED}test ... KO${NC}"
	Error=true
fi

if [[ $Error ]]; then
	echo "Des erreurs bloquantes ont été détectées merci de les corrigées et de relancer ce script."
else
	echo "Aucunes erreurs n'a été détectées"
	echo -n "Voulez-vous lancer un test de sauvegarde ? "
	read rep
	
	if [[ "$rep" == "oui" ]]; then
		source $DATA_LIB/Data_Manager.sh
		Test_Svg
	fi

fi