# Athena

Système de sauvegarde indépendant pour Linux (testé sur Debian GNU / Linux 8.5 (jessie))
maintenant en V1
---
### Langues utilisées
Athena utilise :
 - Shell (Core : 41%)
 - Python (Core : 59%)
 
---
### version
1.0.0

Bien sûr, Athena est open source avec un dépôt public [save] sur GitHub.

---
### Installation

---
#### Exigences
Athena a besoin du compte UNIX (athena) si vous activez l'exportation de l'archive (activer par défaut)

Athena a également besoin de compte MySQL:

 - 1 pour le DUMP des bases de données (sauvegarde SQL), par exemple Backup. Droit : "Show databases", "File", "Select", "Update", ""
 - 1 pour les mises à jour de la base de données Athena par exemple AthenaUser. Droit : "Insert", "Select", "Update"

Voir exemple dans Core/libs/utility/BDD.py

---
#### Obtenir la source:
Pour récupérer la source, tapez:
```sh
$ cd ~/
$ clone git https://github.com/RootKitDev/Athena.git /home/athena
```

---
### Installer
```sh
$ cd /home/athena/install/
```
Dans ce dossier vous trouvez deux fichiers:

 - athena.cron
 - Athena.sql

Fichier cron est ma configuration crontab pour exemple

Fichier Sql est utile pour créer la base de données "Athena"

```sh
$ mysql < Athena.sql -u root -p
```

---
### Utilisation

---
#### Fonctionnement général
Athena fonctionne actuellement sur le serveur à sauvegarder et le script est conçu pour être exécuté une fois par jour.

Athena propose des sauvegardes avec les fréquences suivantes
 - Mensuel (complet: par exemple sauvegarde complète du système)
 - Hebdomadaire (complet: par exemple sauvegarde complète des données utilisateurs / application)
 - Week-end (incrementale de la mensuelle : par exemple tous les samedis)
 - SQL (BDD complets: par exemple tous les dimanches)
 - Quotidien (incrementaleHebdomadaire: l'action par défaut si aucune autre sauvegarde n'a été déclenchée)

Athena intègre un système de « fanion » dans ```sh /home/athena/flags ```, qui permet la gestion des sauvegardes.
Les fanion sont, par défaut, « rangés » dans ```sh /home/athena/flags/block``` afin qu'Athena ne les interprète pas par "erreur".

La liste des fanion :
 - EX-000 ("Exceptional Backup": exécuter une sauvegarde mensuelle dans la condition par défaut (tous les 1er du mois))
 - PS-000 ("No Backup": Sauvegarde dé-planifiée)
 - PS-001 ("No Monthly / Exceptional Backup")
 - PS-002 ("No Hebdomadiare Backup")
 - PS-003 («No Backup Week-end»)
 - PS-004 ("Pas de sauvegarde quotidienne")


L'utilisation automatique de ce système nécessite crontab (ou tout autre planificateur de tâches)
Voici un exemple de règle crontab

```sh
# Lancement du script de sauvegarde tous les jour 6h
00 6 * * 1-6 /bin/athena -t Data >> /home/athena/Core/logs/Cron.log 2>&1
00 6 * * 0 /bin/athena -t SQL >> /home/athena/Core/logs/Cron.log 2>&1
```

Le système actuel requiert un hôte de réception pour l'export des sauvegardes.

---
### Git lié
Une IHM (Interface Homme Machine) est en cours d'élaboration affichant les journaux de sauvegarde, le volume de la sauvegarde, ...

---
### Contribution

Voulez-vous contribuer? Très bien !

Envoyez-moi vos idées et commentaires par mail: <rootkit.dev@gmail.com>.

---
### Licence

MIT

** Logiciel libre, Hell Yeah! **

---

[save]: <https://github.com/RootKitDev/Athena>
