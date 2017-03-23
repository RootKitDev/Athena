#!/bin/bash

######################################
# Save_Manager.sh
# Utilité: Librairie lié de la sauvegarde : taille non compressée, gestion des temps (convertion, ...)
# Auteur: RootKitDev <RootKit.Dev@gmail.com>
# Mise à jour le: 23/01/2017
######################################

Size(){
	Month=$(date +"%m")
	Day=$(date +"%d")

	size=$(tar -tzvf $1 | gawk ' BEGIN {sum=0} //{sum+=$3} END{print sum} ')
	unit="o"

	mysql --defaults-extra-file=$FILE_PATH/User_SQL.cnf -D Athena -e "UPDATE Save SET size=$size WHERE month=$Month and day=$Day"

	while [[ $size -gt 1024 ]];
	do
		size=$(($size / 1024))

		case $unit in
			"o")
				unit="Ko"
			;;
			"Ko")
				unit="Mo"
			;;
			"Mo")
				unit="Go"
			;;
			"Go")
				unit="To"
			;;
			"To")
				unit="Po"
			;;
			"Po")
				unit="Eo"
			;;
			"Eo")
				unit="Zo"
			;;
			"Zo")
				unit="Yo"
			;;
		esac
	done

	echo ""  >> $LOG_PATH/Save.log
	echo "-------------Calcul de Volumetrie-------------" >> $LOG_PATH/Save.log
	echo "$size$unit ont été sauvegardés"  >> $LOG_PATH/Save.log
}

Time_Convert(){
	Time=$(echo $1 | cut -d'.' -f1)
	Heu=$(echo $Time | cut -d"h" -f1)
	Min=$(echo $Time | cut -d"m" -f1)
	Sec=$(echo $Time | cut -d"m" -f2)

	REGEX='^([0-9]+):([0-9]+):([0-9]+)$'

	if [[ $Time =~ $REGEX ]]; then
		Heu=$(echo $Time | cut -d":" -f1)
		Min=$(echo $Time | cut -d":" -f2)
		Sec=$(echo $Time | cut -d":" -f3)
	fi

	if [ -z $Heu ] || [ $Time = $Heu ];
	then
		Heu=00
	elif [ $Heu -lt 10 ];
	then
		Heu="0$Heu"
	fi

	if [ -z $Min ];
	then
		Min=00
	elif [ $Min -lt 10 ];
	then
		Min="0$Min"
	fi

	if [ -z $Sec ];
	then
		Sec=00
	elif [ $Sec -lt 10 ];
	then
		Sec="0$Sec"
	fi

	Time=$Heu":"$Min":"$Sec

	echo $Time
}

Time_2_Save(){

	Time="$(Time_Convert $1)"

	# Determining of useful variables
	Month=$(date +"%m")
	Day=$(date +"%d")

	mysql --defaults-extra-file=$FILE_PATH/User_SQL.cnf -D Athena -e "UPDATE Save SET time_2_save$SUB_LOG='$Time' WHERE month=$Month and day=$Day"

	echo $Time
}

Time_2_Transfer(){

	Time="$(Time_Convert $1)"
	# Determining of useful variables
	Month=$(date +"%m")
	Day=$(date +"%d")
	# Read SQL
	Old=$(mysql --defaults-extra-file=$FILE_PATH/User_SQL.cnf -D Athena -e "SELECT time_2_transfer_AVG$SUB_LOG As '' FROM Save WHERE month=$Month and day=$Day")

	if [ -z $Old ] || [ $Old == "NULL" ];
	then
		mysql --defaults-extra-file=$FILE_PATH/User_SQL.cnf -D Athena -e "UPDATE Save SET time_2_transfer_AVG$SUB_LOG='$Time' WHERE month=$Month and day=$Day"
	else

		TimeAVG="$(Add_Time $Time $Old)"

		TimeAVG="$(AVG_Time $TimeAVG)"

		TimeAVG="$(Time_Convert $TimeAVG)"

		mysql --defaults-extra-file=$FILE_PATH/User_SQL.cnf -D Athena -e "UPDATE Save SET time_2_transfer_AVG$SUB_LOGmk='$TimeAVG' WHERE month=$Month and day=$Day"
	fi

	echo $Time
}

Add_Time(){

	Heu_Time=$(echo $1 | cut -d":" -f1)
	Min_Time=$(echo $1 | cut -d":" -f2)
	Sec_Time=$(echo $1 | cut -d":" -f3)

	Heu_Old=$(echo $2 | cut -d":" -f1)
	Min_Old=$(echo $2 | cut -d":" -f2)
	Sec_Old=$(echo $2 | cut -d":" -f3)

	Heu=$(($Heu_Old + $Heu_Time))
	Min=$(($Min_Old + $Min_Time))
	Sec=$(($Sec_Old + $Sec_Time))

	MinRet=0
	if [ $Sec -ge 60 ];
	then
		while [[ $Sec -ge 60 ]]
		do
			Sec=$(($Sec - 60))
			MinRet=$(($MinRet + 1))
		done
	fi

	Min=$(($Min+$MinRet))
	HeuRet=0
	if [ $Min -ge 60 ];
	then
		while [[ $Min -ge 60 ]]
		do
			Min=$(($Min - 60))
			HeuRet=$(($HeuRet + 1))
		done
	fi

	Heu=$(($Heu+$HeuRet))
	Time=$Heu":"$Min":"$Sec

	echo $Time
}

AVG_Time(){

	Heu=$(echo $1 | cut -d":" -f1)
	Min=$(echo $1 | cut -d":" -f2)
	Sec=$(echo $1 | cut -d":" -f3)

	MinRet=0
	if [ $Sec -eq 0 ] && [ $Min -gt 0 ];
	then
		Sec=60
		MinRet=$(($MinRet + 1))
	fi
	Sec=$(($Sec/${#REMOTE_HOST_TAB[@]}))

	Min=$(($Min-$MinRet))
	HeuRet=0
	if [ $Min -eq 0 ] && [ $Heu -gt 0 ];
	then
		Min=60
		HeuRet=$(($HeuRet + 1))
	fi

	Min=$(($Min/${#REMOTE_HOST_TAB[@]}))
	
	if [ $Heu -gt 0 ];
	then
		Heu=$(($Heu-$HeuRet))
		Heu=$(($Heu/${#REMOTE_HOST_TAB[@]}))
	fi

	Time=$Heu":"$Min":"$Sec

	echo $Time
}