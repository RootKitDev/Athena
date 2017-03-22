# Athena

Independent backup system for Linux (tested on Debian GNU / Linux 8.5 (jessie))

---
### Languages Used
Athena uses 3 languages:
 - shell (33%) (Core)
 - PHP (60%) (HMI / DashBoard)
 - HTML (7%) (HMI / DashBoard)
 
---
### version
0.1.10b

Of course, Athena is open source with a [public filing] [save] on GitHub.

---
### Installation

---
#### Requirements
Athena needs the UNIX account (athena) if you enable the archive export (enable by default)

Athena also needs MySQL account:

 - 1 for the DUMP of the databases (SQL backup), for example Backup (non-exclusive) right: "show databases", "File", "Select", "Update"
 - 1 for updating the Athena database eg AthenaAdm (exclusive) right: "Insert", "Select", "Update"
 - 1 for HMI and Dashboard, eg AthenaReport (exclusive) right: "Select"

See example in the Files.d folder

---
#### Get the source:
To recover the source, type:
```sh
$ cd ~/
$ clone git https://github.com/RootKitDev/Athena.git / home / athena
```

---
### Install
```sh
$ cd /home/athena/Install.d
```
In this folder you find Cnf subfolder (work in procces) and two file:

 - athena.cron
 - Athena.sql

File cron is my crontab configuration for example

Sql file is useful for creating the database "Athena"

```sh
$ mysql < Athena.sql -u root -p
```



---
### Use

---
#### General operation
Athena currently runs on the backup server and the script is designed to run once a day.

Athena offers backups with the following frequencies
 - Monthly (complete: eg full system backup)
 - Hebdomadiare (complete: for example full backup of user data / application)
 - Weekend (monthly incremental: for example every Saturday)
 - SQL (complete BDD: for example every Sunday)
 - Daily (Incremental Hebdomadiare: the default action if no other backup has been triggered)

Athena integrates a "flag" system in ```sh /home/athena/Flags```, which allows the management of backups.
The flags are by default "ordered" in ```sh /home/athena/Flags/Block``` so that Athena does not interpret the flag by "mistake".

The list of pennants:
 - EX-000 ("Exceptional Backup": run a monthly backup in the default condition (every 1st of the month))
 - PS-000 ("No Backup": Unscheduled Backup)
 - PS-001 ("No Monthly / Exceptional Backup" logs logs in the "No Backup")
 - PS-002 ("No Hebdomadiare Backup" logs logs in the "No Backup")
 - PS-003 ("No Backup Week-end" logs logs to the "No Backup" folder)
 - PS-004 ("No Daily Backup" logs logs in the "No Backup")


The automatic use of this system requires crontab (or any other task scheduler)
Here is an example of a crontab rule

```sh
# Starting backup script data (Data_Save.sh) every day at 6 o'clock
00 6 * * * /home/athena/Main.sh -t Data >> /home/athena/Logs.d/Cron.log 2> & 1
```

The current system requires a receive host for exporting backups.

---
### Git bound
An HMI (Human Machine Interface) is being developed that displays backup logs, backup volume, ...
A web dashboard is also being developed, with arbitrary indicators

---
### Contribution

Do you want to contribute? Very good !

Send me your ideas and comments by e-mail: <rootkit.dev@gmail.com>.

---
### Licence

MIT

** Free software, Hell Yeah! **

---

[Save]: <https://github.com/RootKitDev/Athena>