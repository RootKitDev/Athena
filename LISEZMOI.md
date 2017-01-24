# Athena

Système de sauvegarde indépendant pour Linux (testé sur Debian GNU / Linux 8.5 (jessie))

---
### Langues utilisées
Athena utilise 3 languages:
 - Shell (33%) (Core)
 - PHP (60%) (IHM / DashBoard)
 - HTML (7%) (IHM / DashBoard)
 
---
### version
0.1

Bien sûr, Athena est open source avec un [dépôt public] [save] sur GitHub.

---
### Installation

---
#### Exigences
Athena a besoin du compte UNIX (athena) si vous activez l'exportation de l'archive (activer par défaut)

Athena a également besoin de compte MySQL:

 - 1 pour le DUMP des bases de données (sauvegarde SQL), par exemple Backup (non exclusive) droit : "Show databases", "File", "Select", "Update", ""
 - 1 pour les mise à jour de la base de données Athena  par exemple AthenaAdm (exclusive) droit : "Insert", "Select", "Update"
 - 1 pour HMI et Dashboard, par exemple AthenaReport (exclusive) droit : "Select"

Voir exemple dans le dossier Files.d

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
$ cd /home/athena/Install.d
```
Dans ce dossier vous trouvez Cnf sous-dossier (travail dans procces) et deux fichier:

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
Athena fonctionne actuellement sur le serveur a sauvegarder et le script est conçu pour être exécuter une fois par jour.

Athena propose des sauvegardes avec les fréquences suivantes
 - Mensuel (complet: par exemple sauvegarde complète du système)
 - Hebdomadiare (complet: par exemple sauvegarde complète des données utilisateur / application)
 - Week-end (la mensuel incremental: par exemple tous les samedis)
 - SQL (BDD complets: par exemple tous les dimanches)
 - Quotidien (incrémental Hebdomadiare: l'action par défaut si aucune autre sauvegarde n'a été déclenchée)

Athena intègre un système de « fanion » dans ```sh /home/athena/Flags ```, qui permet la gestion des sauvegardes.
Les fanion sont par défaut « rangés » dans ```sh /home/athena/Flags/Block``` afin qu'Athena n'interprète pas les fanion par "erreur".

La liste des fanion:
 - EX-000 ("Exceptional Backup": exécuter une sauvegarde mensuelle dans la condition par défaut (tous les 1er du mois))
 - PS-000 ("No Backup": Sauvegarde dé-planifiée)
 - PS-001 ("No Monthly / Exceptional Backup" historise les journaux dans le "No Backup")
 - PS-002 ("No Hebdomadiare Backup" historise les journaux dans le "No Backup")
 - PS-003 («No Backup Week-end» historise les journaux dans le dossier «No Backup»)
 - PS-004 ("Pas de sauvegarde quotidienne" historise les journaux dans la "No Backup")


L'utilisation automatique de ce système nécessite crontab (ou tout autre planificateur de tâches)
Voici un exemple de règle crontab

```sh
# Démarrage des données du script de sauvegarde (Data_Save.sh) tous les jours à 6 heures
00 6 * * * /home/athena/Main.sh -t Données >> /home/athena/Logs.d/Cron.log 2>&1
```

Le système actuel requiert un hôte de réception pour l'export des sauvegardes.

---
### Git lié
Une IHM (Interface Homme Machine) est en cours d'élaboration affichant les journaux de sauvegarde, le volume de la sauvegarde, ...
Un tableau de bord Web est également est en cours d'élaboration, avec des indicateurs arbitraires

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