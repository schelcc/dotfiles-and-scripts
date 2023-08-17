#!/bin/bash

BACKUP_PATH=/mnt/remarkable-backup/

rsync -a remarkable-wired:/home/root/.local/share/remarkable/xochitl/* $BACKUP_PATH &
notify-send "remarkable tablet synced"
