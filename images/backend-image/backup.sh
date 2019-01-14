#!/bin/bash

source /home/packer/common-functions.sh

sudo su - postgres -c "pg_dump $DATABASE_URL --no-owner -F p --column-inserts > /var/lib/postgresql/backup/db-backup-`date +\"%Y\"`-`date +\"%m\"`-`date +\"%d\"`.sql"
sudo gsutil cp \/var\/lib\/postgresql\/backup\/db-backup-*.sql gs://mrm-sandbox-backup/
sudo rm -r /var/lib/postgresql/backup/db-*
