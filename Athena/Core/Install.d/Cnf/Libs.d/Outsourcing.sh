#! /bin/bash

Check_Outsource(){
    if [[ $line =~ "Activate" ]];
    then
        ActivOut=$(echo $line | cut -d'=' -f2)
    fi
            
    if [[ $line =~ "Partern" ]] ;
    then
        if $ActivOut ;
        then
            Partern=$(echo $line | cut -d'=' -f2)

        fi
    fi
}

Conf_Outsource(){
    if ! $ActivOut ;
    then
    
        while [[ $repExt != "n" ]] && [[ $repExt != "N" ]] && [[ $repExt != "y" ]] && [[ $repExt != "Y" ]]
        do
            echo "L'externalisation des sauvegardes est désactivée"
            echo -n "Voulez-vous activer l'externalisation des sauvegardes ? [Y/n]"
            read repExt
            if [[ -z $repExt ]]; then
                repExt="y"
            fi
            
            if [[ $repExt = "y" ]] || [[ $repExt = "Y" ]]; then
                sed -i ':1 ; N ; $!b1 ; s/Activate=false/Activate=true/1' ./Files.d/Config.conf
                sed -i 's/Partern=false/Partern=true/' ./Files.d/Config.conf
                sed -i ':1 ; N ; $!b1 ; s/Activate=false/Activate=true/2' ./Files.d/Config.conf 
                sed -i ':1 ; N ; $!b1 ; s/Activate=false/Activate=true/3' ./Files.d/Config.conf 

            fi
            
        done
        
        echo "L'externalisation des sauvegardes est désormais activée"
        
    elif $ActivOut ;
    then
        echo "L'externalisation des sauvegardes est activée"
    fi

#### Partern ####

    if ! $Partern ;
    then
        echo "Les Partenaires ne sont pas définis"
    
    elif $Partern ;
    then
        ParternFile=$(find / -name Partenaires | grep "V0.1.0_Athena" | head -n1)
        existPartern=$(cat $ParternFile)
        if [[ -z $existPartern ]]; then
            echo "Les Partenaires ne sont pas définis"
            echo "Merci d'en définir au moins un (1) pour le bon fonctionnement du systeme"
            echo "q pour terminé la saisie des partenaires"
            echo "Format : \"hote:IP\""
            while [[ $ParternTarget != "q" ]]; do
                echo -n "> "
                read ParternTarget
                
                if [[ $ParternTarget != "q" ]]; then
                    ParternHost=$(echo $ParternTarget | cut -d':' -f1)
                    ParternIP=$(echo $ParternTarget | cut -d':' -f2)
                
                    while !([[ $ParternIP =~ ^[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}$ ]])
                    do
                        echo "la partie \"IP\" est incorrect"
                        echo "Merci de saisir une IP "
                        echo -n "> "
                        read ParternIP
                    done
                    echo "Hoste Partenaire correct"
                    ParternTarget=$ParternHost":"$ParternIP
                    echo $ParternTarget >> $ParternFile
                fi
            done
            
            echo -e "Les Partenaires sont :\n"
            cat $ParternFile
            echo ""
    
        else
        
            echo -e "Les Partenaires sont définis\n"
            cat $ParternFile
            echo ""
        fi
    
    fi
}
