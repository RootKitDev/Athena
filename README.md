# Athena

Independent backup system for Linux (tested on Debian GNU / Linux 8.5 (jessie))
now in V1
---
### Languages used
Athena uses:
 - Shell (Core: 41%)
 - Python (Core: 59%)

---
### version
1.0.0

Of course, Athena is open source with a public repository [save] on GitHub.

---
### Installation

---
#### Requirements
Athena needs UNIX account (athena) if you enable archive export (enable by default)

Athena also needs MySQL account:

 - 1 for the database DUMP (SQL backup), for example Backup. Right: "Show databases", "File", "Select", "Update", ""
 - 1 for updates to the Athena database eg AthenaUser. Right: "Insert", "Select", "Update"

See example in Core / libs / utility / BDD.py

---
#### Get the source:
To recover the source, type:
```sh
$ cd ~ /
$ clone git https://github.com/RootKitDev/Athena.git / home / athena
```

---
### Install
```sh
$ cd / home / athena / install /
```
In this folder you find two files:

 - athena.cron
 - Athena.sql

Cron file is my crontab configuration for example

Sql file is useful for creating the database "Athena"

```sh
$ mysql <Athena.sql -u root -p
```

---
### Use

---
#### General operation
Athena is currently running on the server to back up and the script is designed to run once a day.

Athena offers backups with the following frequencies
 - Monthly (complete: for example full backup of the system)
 - Weekly (complete: for example full backup of user / application data)
 - Weekend (incremental of the monthly: for example every Saturday)
 - SQL (complete BDD: for example every Sunday)
 - Daily (incrementalWeekly: the default action if no other backup has been triggered)

Athena incorporates a "pennant" system in ```sh / home / athena / flags```, which allows the management of backups.
The pennants are, by default, "stored" in ```sh / home / athena / flags / block``` so that Athena does not interpret them as "error".

The list of pennants:
 - EX-000 ("Exceptional Backup": run a monthly backup in the default condition (every 1st of the month))
 - PS-000 ("No Backup": Deprecated backup)
 - PS-001 ("No Monthly / Exceptional Backup")
 - PS-002 ("No Hebdomadiare Backup")
 - PS-003 ("No Backup Weekend")
 - PS-004 ("No daily backup")


Automatic use of this system requires crontab (or any other task scheduler)
Here is an example of a crontab rule

```sh
# Launch backup script every day 6h
00 6 * * 1-6 / bin / athena -t Data >> /home/athena/Core/logs/Cron.log 2> & 1
00 6 * * 0 / bin / athena -t SQL >> /home/athena/Core/logs/Cron.log 2> & 1
```

The current system requires a receiving host to export backups.

---
### Git bound
An HMI (Human Machine Interface) is being developed displaying the backup logs, the volume of the backup, ...

---
### Contribution

Do you want to contribute? Very good !

Send me your ideas and comments by email: <rootkit.dev@gmail.com>.

---
### Licence

MIT

** Free software, Hell Yeah! **

---

[save]: <https://github.com/RootKitDev/Athena>