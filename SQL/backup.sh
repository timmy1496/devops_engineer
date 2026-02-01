#!/usr/bin/env bash

mysqldump -u root -p --databases SchoolDB > SchoolDB_backup.sql
mysql -u root -p -e "DROP DATABASE IF EXISTS SchoolDB_Restore; CREATE DATABASE SchoolDB_Restore CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;"
sed 's/`SchoolDB`/`SchoolDB_Restore`/g' SchoolDB_backup.sql | mysql -u root -p
