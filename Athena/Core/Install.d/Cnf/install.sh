#! /bin/bash

######################################
# install.sh
# Utilité: ce script sert a installer SaveSystem grace a un fichier config.cfg,
# défini les variable "*PATH" (Log, flag, ..., sauf LIB_PATH)
# Auteur: RootKitDev <RootKit.Dev@gmail.com>
# Mise à jour le: 02/09/2016
######################################

if [[ $EUID -ne 0 ]]; then
   echo "merci d'utilisé la commande \"sudo\" pour lancé ce script" 
else

    UserName=$(logname)
    Intall=$(dpkg -l | grep nginx | head -n1)
    
    # Verbose mode
    for param in $@
    do
            if [ $param = "-v" ]
            then
        		set -vx            
            fi
    done

    echo "Installation du systeme de sauvegarde sur $(hostname)"
    
    HOME_PATH="$(pwd)"

    rep=""
    
    while [[ $rep != "n" ]] && [[ $rep != "N" ]] && [[ $rep != "y" ]] && [[ $rep != "Y" ]]
    do
        echo "HOME_PATH définis le dossier racine de SaveSystem,"
        echo "HOME_PATH vaux actuellement : \"$HOME_PATH\""
        echo -n "Est-ce correct ? (Y/n) : "
        read rep
        if [[ -z $rep ]]; then
            rep="Y"
        fi
    done
    
    if [[ $rep = "n" ]] || [[ $rep = "N" ]]; then
        HOME_PATH=""
        while [[ ! ( $HOME_PATH =~ \/?["a"-"z"] ) ]] && [[ $HOME_PATH != "." ]]
        do
            echo -n "Quelle est la racine de SaveSystem ? : "
            read HOME_PATH
            
        done
        
        res=${HOME_PATH:0:1}
        
        if [[ $res = "/" ]]; then
            HOME_PATH=$HOME_PATH
        elif [[ $res = "." ]]; then
            HOME_PATH=$(pwd)
        else
            HOME_PATH="$(pwd)/$HOME_PATH"
        fi

        if [[ ! -e $HOME_PATH ]]; then
            echo "\"$HOME_PATH\" n'existe pas"
        fi 
    fi

    declare -A VarSaveSystem=( [LOG_PATH]="\$HOME_PATH/Logs.d"
                                [FLAG_PATH]="\$HOME_PATH/Flags"
                                [EXPORT_CKSUM_PATH]="\$HOME_PATH/CkSum_Export"
                                [LISTED_INCREMENTAL_PATH]="\$HOME_PATH/Lists.d"
                                [SAVE_LIST_PATH]="\$HOME_PATH/ListSave.d"
                                [EXCLUDE_LIST_PATH]="\$HOME_PATH/ExcludeSave.d"
                                [SAVE_STATE_PATH]="\$HOME_PATH/Etats" )

    declare -A VarSaveSystem2=( [EXPORT_PATH]="\$HOME_PATH/Data_Export"
                                [EXPORT_PATH_SQL]="\$HOME_PATH/Dumps_Export"
                                [REMOTE_EXPORT_PATH]="/home/save/azrod/Data"
                                [REMOTE_EXPORT_PATH_SQL]="/home/save/azrod/Dumps" )

    echo ""
    
    echo "Merci de de valider les chemins suivant, basé sur HOME_PATH"

    for key in "${!VarSaveSystem[@]}"
    do
        rep=""
        while [[ $rep != "n" ]] && [[ $rep != "N" ]] && [[ $rep != "y" ]] && [[ $rep != "Y" ]]
        do
            echo "\"$key\" => \"${VarSaveSystem[$key]}\""
            echo -n "Est-ce correct ? (Y/n) : "
            read rep
            if [[ -z $rep ]]; then
                rep="Y"
                echo ""
            fi
        done

        if [[ $rep = "n" ]] || [[ $rep = "N" ]]; then
            dir=""
            while [[ ! ( $dir =~ \/?["a"-"z"] ) ]]
            do
                echo -n "Quelle est le chemin pour \"$key\" ? : "
                read dir
            done
            
            res=${dir:0:1}
            
            if [[ $res != "/" ]]; then
                dir="$(pwd)/$dir"
            fi
            
            if [[ ! -e $dir ]]; then
                echo "\"$dir\" n'existe pas"
                echo "Interuption du script d'installation"
                exit 1
            else
                VarSaveSystem[$key]="$dir"
                echo "\"$key\" mis a jour"
                echo ""
            fi 
        fi
        
    done
    
    echo "Les variables suivante change selon la sauvegarde (Data ou SQL)"
        
    
    rep=""
    EXPORT_PATH="\$HOME_PATH/Data_Export"
    while [[ $rep != "n" ]] && [[ $rep != "N" ]] && [[ $rep != "y" ]] && [[ $rep != "Y" ]]
    do
        echo "\"EXPORT_PATH (Data) \" => $EXPORT_PATH"
        echo -n "Est-ce correct ? (Y/n) : "
        read rep
        if [[ -z $rep ]]; then
            rep="Y"
            echo ""
        fi
    done

    if [[ $rep = "n" ]] || [[ $rep = "N" ]]; then
        dir=""
        while [[ ! ( $dir =~ \/?["a"-"z"] ) ]]
        do
            echo -n "Quelle est le chemin pour \"$key\" ? : "
            read dir
        done
        
        res=${dir:0:1}
        
        if [[ $res != "/" ]]; then
            dir="$(pwd)/$dir"
        fi
        
        if [[ ! -e $dir ]]; then
            echo "\"$dir\" n'existe pas"
            echo "Interuption du script d'installation"
            exit 1
        else
            VarSaveSystem2[$key]="$dir"
            echo "\"$key\" mis a jour"
            echo ""
        fi 
    fi
    
    echo "\$HOME_PATH=\"$HOME_PATH\"" >> "$HOME_PATH/Lib.d/Var.sh"
    echo "" >> "$HOME_PATH/Lib.d/Var.sh"
    for key in "${!VarSaveSystem[@]}"
    do
        
        echo "$key=\"${VarSaveSystem[$key]}\"" >> "$HOME_PATH/Lib.d/Var.sh"
    done
    
    chown $UserName:$UserName $HOME_PATH 
    
    echo "export HOME_PATH=\"$HOME_PATH\"" >> /etc/apache2/envvars
        if [[ -z $Intall ]]; then
        Intall=$(dpkg -l | grep apache | head -n1)
        if [[ -n $Intall ]]; then
            Appli="apache2"
            for key in "${!VarSaveSystem[@]}"
            do
                echo "export $key=\"${VarSaveSystem[$key]}\"" >> /etc/apache2/envvars
            done
        fi
    else
        Appli="nginx"
        for key in "${!VarSaveSystem[@]}"
        do
            echo "env $key=\"${VarSaveSystem[$key]}\"" >> /etc/nginx/nginx.conf
        done
    fi
    
    echo "Redémarrage du service web : $Appli"
    eval $(service $Appli restart)
    
    #rm install.sh"
    
    echo '
if [[ -z $SUB_LOG ]]; then
    EXPORT_PATH="$HOME_PATH/Data_Export"
    REMOTE_EXPORT_PATH="/remote/path/to/export/Data"
else
    EXPORT_PATH="$HOME_PATH/Dumps_Export"
    REMOTE_EXPORT_PATH="/remote/path/to/export/Dumps"
fi' >> "$HOME_PATH/Lib.d/Var.sh"
    
fi
