#!/bin/bash

# Ask for the backup file to restore
echo "Please enter the backup file name (e.g. postgres_backup_2025-04-15_19-45-00.tar.gz):"
read BACKUP_FILE

BACKUP_DIR="./db_backups"

# Extract if it's a .tar.gz
if [[ $BACKUP_FILE == *.tar.gz ]]; then
  echo "Extracting $BACKUP_FILE..."
  tar -xzf "$BACKUP_DIR/$BACKUP_FILE" -C "$BACKUP_DIR"
  SQL_FILE=$(tar -tzf "$BACKUP_DIR/$BACKUP_FILE" | grep .sql)
else
  SQL_FILE="$BACKUP_FILE"
fi

# Confirm file exists
if [ ! -f "$BACKUP_DIR/$SQL_FILE" ]; then
  echo "SQL file not found: $SQL_FILE"
  exit 1
fi

# Restore the dump into the Docker container
echo "Restoring database from $SQL_FILE..."
docker exec -i postgres-db psql -U postgres -d user_api_development < "$BACKUP_DIR/$SQL_FILE"

echo "Database restore complete."