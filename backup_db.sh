#!/bin/bash

TIMESTAMP=$(date +"%Y-%m-%d_%H-%M-%S")
BACKUP_DIR="./db_backups"
FILENAME="postgres_backup_$TIMESTAMP.sql"

mkdir -p $BACKUP_DIR

docker exec postgres-db pg_dump -U postgres user_api_development > "$BACKUP_DIR/$FILENAME"

# Upload to Google Drive via rclone
rclone copy "$BACKUP_DIR" google_drive:/PostgresBackups --copy-links --progress

echo "Backup complete: $BACKUP_DIR/$FILENAME"