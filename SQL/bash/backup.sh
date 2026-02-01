#!/bin/bash

DB_HOST="localhost"
DB_USER="root"
DB_NAME="SchoolDB"
BACKUP_DIR="./backups"
TIMESTAMP=$(date +"%Y%m%d_%H%M%S")
BACKUP_FILE="$BACKUP_DIR/${DB_NAME}_backup_$TIMESTAMP.sql"

mkdir -p "$BACKUP_DIR"

echo "Starting backup for database: $DB_NAME"

mysqldump -h "$DB_HOST" -u "$DB_USER" -p "$DB_NAME" > "$BACKUP_FILE"
if [ $? -ne 0 ]; then
  echo "Backup failed"
  exit 1
fi

echo "Backup created: $BACKUP_FILE"

echo "Recreating database: $DB_NAME"

mysql -h "$DB_HOST" -u "$DB_USER" -p <<EOF
DROP DATABASE IF EXISTS $DB_NAME;
CREATE DATABASE $DB_NAME
  CHARACTER SET utf8mb4
  COLLATE utf8mb4_unicode_ci;
EOF

if [ $? -ne 0 ]; then
  echo "Database recreate failed"
  exit 1
fi

echo "Database recreated"

echo "Restoring data from backup"

mysql -h "$DB_HOST" -u "$DB_USER" -p "$DB_NAME" < "$BACKUP_FILE"
if [ $? -ne 0 ]; then
  echo "Restore failed"
  exit 1
fi

echo "Restore completed successfully"

echo "Verifying tables:"
mysql -h "$DB_HOST" -u "$DB_USER" -p "$DB_NAME" -e "SHOW TABLES;"

echo "Backup & restore process finished"
