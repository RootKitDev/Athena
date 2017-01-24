#! /bin/bash

Check_Data(){
    if [[ $line =~ "Activate" ]];
    then
        ActivData=$(echo $line | cut -d'=' -f2)
    fi

    if [[ $line =~ "[Type]" ]];
    then
        while !([[ $line =~ "[/Type]" ]]) && read line  
        do
            if [[ $line =~ "Daily" ]];
            then
                ActivDaily=$(echo $line | cut -d'=' -f2)
            fi
                    
            if [[ $line =~ "Weekly" ]];
            then
                ActivWeekly=$(echo $line | cut -d'=' -f2)
            fi
                    
            if [[ $line =~ "Monthly" ]];
            then
                ActivMonthly=$(echo $line | cut -d'=' -f2)
            fi
                    
            if [[ $line =~ "WeekEnd" ]];
            then
                ActivWeekEnd=$(echo $line | cut -d'=' -f2)
            fi
        done

    fi 

    
}

Conf_Data(){
    if ! $ActivData ;
    then
        echo "Les sauvegardes Data ne sont pas activées"
    elif $ActivData ;
    then
        echo "Les sauvegardes Data sont activée"
        echo "Merci définir la/les type de sauvegardes souhaité"
        echo "(q pour terminer)"
        echo "Journaliere : (Incrémentiel)"
        echo $ActivDaily
        echo "Hebdomadaire : (Full)"
        echo $ActivWeekly
        echo "Mensuel : (Full)"
        echo $ActivMonthly
        echo "Week-End : (Incrémentiel)"
        echo $ActivWeekEnd
        
        while !([[ $Freq = "J" ]] || [[ $Freq = "H" ]] || [[ $Freq = "M" ]] || [[ $Freq = "W" ]] || [[ $Freq = "q" ]])
        do
            echo -n "Quelle fréquence souhaitez-vous activer ? (J/H/M/W) "
            read Freq
            
            case $Freq in
                "J")
                    sed -i ':1 ; N ; $!b1 ; s/Daily=false/Daily=true/1' ./Files.d/Config.conf
                    echo "Sauvegarde Journaliere activée"
                    ActivDaily=true
                ;;
                
                "H")
                    sed -i ':1 ; N ; $!b1 ; s/Weekly=false/Weekly=true/1' ./Files.d/Config.conf
                    echo "Sauvegarde Hebdomadaire activée"
                    ActivWeekly=true
                ;;
                
                "M")
                    sed -i ':1 ; N ; $!b1 ; s/Monthly=false/Monthly=true/1' ./Files.d/Config.conf
                    echo "Sauvegarde Mensuel activée"
                    ActivMonthly=true
                ;;
                
                "W")
                    sed -i ':1 ; N ; $!b1 ; s/WeekEnd=false/WeekEnd=true/1' ./Files.d/Config.conf
                    echo "Sauvegarde Week-End activée"
                    WeekEnd=true
                ;;
            esac
        done
        
        clear
        
        echo "Etat actuel des sauvegardes :"
        echo "Journaliere : (Incrémentiel)"
        echo $ActivDaily
        echo "Hebdomadaire : (Full)"
        echo $ActivWeekly
        echo "Mensuel : (Full)"
        echo $ActivMonthly
        echo "Week-End : (Incrémentiel)"
        echo $ActivWeekEnd
        
        Conf_Date
        
    fi
}

Conf_Date(){
    
    echo "Configuration des dates "

    if [[ $line =~ "[Frequency]" ]];
    then
        while !([[ $line =~ "[/Frequency]" ]]) && read line  
        do
            if [[ $line =~ "Weekly" ]];
            then
                DateWeekly=$(echo $line | cut -d'=' -f2)
            fi
                    
            if [[ $line =~ "Monthly" ]];
            then
                DateMonthly=$(echo $line | cut -d'=' -f2)
            fi
                    
            if [[ $line =~ "WeekEnd" ]];
            then
                DateWeekEnd=$(echo $line | cut -d'=' -f2)
            fi
        done
    fi
    
    echo "Quel jour de la semaine ? (Lun - Dim, * = tous)"
    read dow
    
    case $dow in
        "Lun")
        
        ;;
        "Mar")
        
        ;;
        "Mer")
        
        ;;
        "Jeu")
        
        ;;
        "Ven")
        
        ;;
        "Sam")
        
        ;;
        "Dim")
        
        ;;
        "*")
        
        ;;
    esac
    
    echo "Quel mois ? (01 - 12, * = tous)"
    read moy
    
    echo "Quel jour du mois ? (01 - 31, * = tous)"
    read dom
    
    if [[ $moy = "*" ]]; then
        moy="tout les mois"
    fi

    if [[ $dom = "*" ]]; then
        dom="tout les jours du mois"
    fi    
    echo $dow" "$moy" "$dom
}